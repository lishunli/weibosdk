package com.weibo.managers
{
	import com.weibo.core.UIComponent;
	import com.weibo.util.data.HashSet;
	
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * 管理组件的渲染/重绘
	 * <p>如果需要重绘组件, 调用重绘方法, 自动注册到RenderManager</p>
	 * @langversion 3.0
	 * @playerversion Flash 9
	 */
	public class RepaintManager
	{
		/**直接调用模式重绘，视觉效果最流畅但消耗较大*/
		public static const DIRECT:String="direct";
		/**帧频模式重绘*/
		public static const ENTER_FRAME:String="enterFrame";
		/**时间模式重绘*/
		public static const TIMER:String="timer";
		/**renderer模式重绘*/
		public static const RENDERER:String="renderer";
		
		public static var DEFAULT_TYPE:String="enterFrame";
		
		/**对主场景舞台的引用*/
		public var stage:Stage;

		private static var _instance:RepaintManager;

		/**
		 * 触发器类型
		 * @example
		 * <br><code>TriggerManager.type=TriggerManager.ENTER_FRAME</code>帧频触发器</br>
		 * <br><code>TriggerManager.type=TriggerManager.TIMER</code>时间触发器</br>
		 * @default <code>TriggerManager.ENTER_FRAME</code>
		 * @private
		 */
		private static var _type:String=RepaintManager.DEFAULT_TYPE;
		private var _rendering:Boolean;
		/**
		 * <coed>EnterFrame</code>触发器
		 * @private
		 */
		private var _frameTrigger:Sprite;
		/**
		 * <code>Timer</code>触发器
		 * @private
		 */
		private var _timer:Timer;
		/**
		 * 用于强制刷新舞台显示列表而建的媒介
		 * @private
		 */
		private var _updateTimer:Timer;
		/**
		 * 待重绘的组件队列
		 * @private
		 */
		private var _repaintQueue:HashSet;

		/**
		 * 构造函数
		 * <p>管理组件的渲染/重绘</p>
		 * 单例
		 */
		public function RepaintManager()
		{
			if (_instance!=null)
			{
				throw new Error("Singleton can't be create more than once!");
				return
			}
			_repaintQueue=new HashSet();
			_rendering=false;
			play();
		}

		/**
		 * 获取重绘管理器的单例
		 * @return <code>RepaintManager Singleton</code>
		 */
		public static function getInstance():RepaintManager
		{
			if (_instance == null)
			{
				_instance=new RepaintManager();
			}
			return _instance;
		}

		/**
		 * 注册重绘管理器舞台实例
		 * @param s 舞台实例
		 * @return <code>Stage instants</code>
		 */
		public function registerStage(s:Stage):Stage
		{
			stage=s;
			return stage;
		}

		/**
		 * 注销重绘管理器舞台实例
		 * @return <code>Stage instants</code>
		 */
		public function logoutStage():Stage
		{
			var returnValue:Stage=stage;
			stage=null;
			return returnValue;
		}

		/**
		 * 设置时钟频率
		 * @param delay 时钟计时器的频率
		 */
		public function setTimer(delay:int=20):void
		{
			if (!_timer)
			{
				_timer=new Timer(delay, 1);
				_timer.addEventListener(TimerEvent.TIMER, execute);
			}
			else
			{
				_timer.delay=delay;
				_timer.repeatCount=1;
			}
		}

		/**
		 * 启动重绘管理器，根据管理器类型自动监听事件并触发响应
		 */
		public function play():void
		{
			if(_type==RepaintManager.DIRECT)
			{
				endTimer();
				endRender();
				endEnterFrame();
				execute();
			}
			else if (_type == RepaintManager.ENTER_FRAME)
			{
				endTimer();
				endRender();
				startEnterFrame();
			}
			else if (_type == RepaintManager.TIMER)
			{
				endEnterFrame();
				endRender();
				startTimer();
			}
			else if (_type == RepaintManager.RENDERER)
			{
				endTimer();
				endEnterFrame();
				startRender();
			}
		}

		/**
		 * 暂停重绘管理器，注销一切事件监听
		 */
		public function pause():void
		{
			endTimer();
			endEnterFrame();
			endRender();
		}

		/**
		 * 添加组件到重绘队列
		 * @param com 被添加的组件
		 * @return 被添加的组件
		 */
		public function addToRepaintQueue(com:UIComponent):UIComponent
		{
			var returnValue:UIComponent = _repaintQueue.add(com) as UIComponent;
			play();
			return returnValue;
		}
		
		public function contains(com:UIComponent):Boolean
		{
			return _repaintQueue.contains(com);
		}
		
		public function containsAll(arr:Array):Boolean
		{
			return _repaintQueue.containsAll(arr);
		}

		/**
		 * 从重绘队列移除组件
		 * @param com 被移除的组件
		 * @return 被移除的组件
		 */
		public function removeFromRepaintQueue(com:UIComponent):UIComponent
		{
			return (_repaintQueue.remove(com) as UIComponent);
		}

		/**
		 * 以一定时间间隔强制刷新舞台
		 * @param delay 计时器事件间的延迟（以毫秒为单位）
		 * @param repeat 指定重复次数。 如果为 0，则计时器重复无限次数。 如果不为 0，则将运行计时器，运行次数为指定的次数，然后停止
		 */
		public function forceUpdate(delay:int=20, repeat:int=1):void
		{
			if (!_updateTimer)
			{
				_updateTimer=new Timer(delay, repeat);
				_updateTimer.addEventListener(TimerEvent.TIMER, updateAfterEvent);
			}
			else
			{
				_updateTimer.delay=delay;
				_updateTimer.repeatCount=repeat;
			}
			if (!_updateTimer.running)
			{
				_updateTimer.reset();
				_updateTimer.start();
			}
		}

		/**
		 * 启动帧频触发器对<code>Event.ENTER_FRAME</code>的监听
		 * @private
		 */
		private function startEnterFrame():void
		{
			_frameTrigger=_frameTrigger||new Sprite();
			_frameTrigger.addEventListener(Event.ENTER_FRAME, execute);
		}

		/**
		 * 结束帧频触发器对<code>Event.ENTER_FRAME</code>的监听
		 * @private
		 */
		private function endEnterFrame():void
		{
			if (_frameTrigger && _frameTrigger.hasEventListener(Event.ENTER_FRAME))
			{
				_frameTrigger.removeEventListener(Event.ENTER_FRAME, execute);
			}
		}

		/**
		 * 启动时间触发器
		 * @private
		 */
		private function startTimer():void
		{
			if (!_timer)
			{
				_timer=new Timer(20, 1);
				_timer.addEventListener(TimerEvent.TIMER, execute);
			}

			if (!_timer.running)
			{
				_timer.reset();
				_timer.start();
			}
		}

		/**
		 * 停止时间触发器
		 * @private
		 */
		private function endTimer():void
		{
			_timer && _timer.running && _timer.stop();
		}

		/**
		 * 启动监听舞台<code>invalidate</code>
		 * @private
		 */
		private function startRender():void
		{
			stage && stage.addEventListener(Event.RENDER, execute);
			stage && stage.invalidate();
		}

		/**
		 * 注销监听舞台<code>invalidate</code>
		 * @private
		 */
		private function endRender():void
		{
			stage && stage.hasEventListener(Event.RENDER) && stage.removeEventListener(Event.RENDER, execute);
		}

		/**
		 * 立即执行重绘
		 * @param e 触发执行重绘的事件类型
		 */
		public function execute(e:*=null):void
		{
			_rendering=true;
			var queue:Array=_repaintQueue.toArray(), len:int=queue.length; //将待执行的函数赋值给队列
			_repaintQueue.clear(); //赋值完毕后立即清空待执行队列
			for (var i:int=0; i < len; i++)
			{
				var component:UIComponent=queue[i] as UIComponent;
				component && component.validate();
			}
			(e is TimerEvent) && updateAfterEvent(e);
			_repaintQueue.size()||pause();//important!!!
			_rendering=false;
			
			if(e&&(e is TimerEvent))
			{
				var t:Timer=((e as TimerEvent).currentTarget as Timer);
			}
		}

		/**
		 * 重绘管理器触发执行的事件类型
		 * <p>code<>RepaintManager.RENDERER,stage.validate()</code>触发</p>
		 * <p>code<>RepaintManager.TIMER,stage.validate()</code>触发</p>
		 * <p>code<>RepaintManager.ENTER_FRAME,stage.validate()</code>触发</p>
		 * @return <code>String</code>
		 */
		public function get type():String
		{
			return _type;
		}

		/**
		 * 重绘管理器触发执行的事件类型
		 * <p>code<>RepaintManager.RENDERER,stage.validate()</code>触发</p>
		 * <p>code<>RepaintManager.TIMER,stage.validate()</code>触发</p>
		 * <p>code<>RepaintManager.ENTER_FRAME,stage.validate()</code>触发</p>
		 * @param 事件类型
		 */
		public function set type(t:String):void
		{
			_type=t;
//			_type="direct";
		}

		/**
		 * 强制更新舞台显示列表
		 * @private
		 */
		private function updateAfterEvent(e:TimerEvent):void
		{
			e.updateAfterEvent();
		}
	}
}