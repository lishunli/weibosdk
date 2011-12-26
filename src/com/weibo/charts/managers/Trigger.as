package com.weibo.charts.managers
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import com.weibo.charts.utils.data.HashMap;

	/**
	 * 全局触发器，自发且可控的执行函数
	 * <p>可实现<code>Event.ENTER_FRAME</code>、<code>Event.TIMER</code>、<code>Event.RENDER</code>三种方式的触发并执行函数队列</p>
	 * @author Aaron Wei
	 * @langversion 3.0
	 * @playerversion Flash 9+
	 */
	public class Trigger
	{
		/**直接调用模式，视觉效果最流畅但消耗较大*/
		public static const DIRECT:String="direct";
		/**帧频触发模式*/
		public static const ENTER_FRAME:String="enterFrame";
		/**时钟触发模式*/
		public static const TIMER:String="timer";
		/**<code>Event.RENDER</code>触发模式*/
		public static const RENDER:String="render";
		public static var DEFAULT_TYPE:String="direct";
		/**对主场景舞台的引用*/
		public static var stage:Stage;
		/**
		 * 待执行的队列
		 * @private
		 */
		private static var _queue:HashMap=new HashMap();
		private static var _rendering:Boolean;
		/**
		 * <coed>EnterFrame</code>触发器
		 * @private
		 */
		private static var _frameTrigger:Sprite;
		/**
		 * <code>Timer</code>触发器
		 * @private
		 */
		private static var _timer:Timer;
		/**
		 * 触发器类型
		 * @example
		 * <br><code>TriggerManager.type=TriggerManager.ENTER_FRAME</code>帧频触发</br>
		 * <br><code>TriggerManager.type=TriggerManager.TIMER</code>时间触发</br>
		 * <br><code>TriggerManager.type=TriggerManager.MULTI</code>时间触发</br>
		 * @default <code>TriggerManager.ENTER_FRAME</code>
		 * @private
		 */
		private static var _type:String=Trigger.DEFAULT_TYPE;
		/**
		 * 用于强制刷新舞台显示列表而建的媒介
		 * @private
		 */
		private static var _updateTimer:Timer;

		private static var _runtimeCount:Number;

		/**
		 * 注册舞台实例
		 * @param s 舞台实例
		 * @return <code>Stage instants</code>
		 */
		public static function registerStage(s:Stage):Stage
		{
			stage=s;
			return stage;
		}

		/**
		 * 注销舞台实例
		 * @return <code>Stage instants</code>
		 */
		public static function logoutStage():Stage
		{
			var returnValue:Stage=stage;
			stage=null;
			return returnValue;
		}

		/**
		 * 设置时钟频率
		 * @param delay 时钟计时器的频率
		 */
		public static function setTimer(delay:int=20, repeat:int=1):void
		{
			if (!_timer)
			{
				_timer=new Timer(delay, repeat);
				_timer.addEventListener(TimerEvent.TIMER, execute);
			}
			else
			{
				_timer.delay=delay;
				_timer.repeatCount=repeat;
			}
		}

		/**
		 * 启动重绘管理器，根据管理器类型自动监听事件并触发响应
		 */
		public static function play():void
		{
			_runtimeCount=getTimer();
			if(_type==RepaintManager.DIRECT)
			{
				endTimer();
				endRender();
				endEnterFrame();
				execute();
			}
			else if (_type == Trigger.ENTER_FRAME)
			{
				endTimer();
				endRender();
				startEnterFrame();
			}
			else if (_type == Trigger.TIMER)
			{
				endEnterFrame();
				endRender();
				startTimer();
			}
			else if (_type == Trigger.RENDER)
			{
				endTimer();
				endEnterFrame();
				startRender();
			}
		}

		/**
		 * 暂停重绘管理器，注销一切事件监听
		 */
		public static function pause():void
		{
			endTimer();
			endEnterFrame();
			endRender();
		}

		/**
		 * 添加函数到执行队列
		 * @param fun 被添加的函数
		 * @return 被添加的函数
		 */
		public static function addToQueue(fun:Function, params:Array=null):void
		{
			params && _queue.put(fun, params) || _queue.put(fun, "null");
			play();
		}

		/**
		 * 从执行队列移除函数
		 * @param fun 被移除的函数
		 * @return 被移除的函数
		 */
		public static function removeFromQueue(fun:Function):void
		{
			_queue.remove(fun);
		}

		/**
		 * 以一定时间间隔强制刷新舞台
		 * @param delay 计时器事件间的延迟（以毫秒为单位）
		 * @param repeat 指定重复次数。 如果为 0，则计时器重复无限次数。 如果不为 0，则将运行计时器，运行次数为指定的次数，然后停止
		 */
		public static function forceUpdate(delay:int=20, repeat:int=1):void
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
			if (!_timer.running)
			{
				_updateTimer.reset();
				_updateTimer.start();
			}
		}

		/**
		 * 启动帧频触发器对<code>Event.ENTER_FRAME</code>的监听
		 * @private
		 */
		private static function startEnterFrame():void
		{
			if (!_frameTrigger)
			{
				_frameTrigger=new Sprite();
			}
			_frameTrigger.addEventListener(Event.ENTER_FRAME, execute);
		}

		/**
		 * 结束帧频触发器对<code>Event.ENTER_FRAME</code>的监听
		 * @private
		 */
		private static function endEnterFrame():void
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
		private static function startTimer():void
		{
			setTimer(_timer.delay, _timer.repeatCount);
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
		private static function endTimer():void
		{
			_timer && _timer.running && _timer.stop();
		}

		/**
		 * 启动监听舞台<code>invalidate</code>
		 * @private
		 */
		private static function startRender():void
		{
			stage && stage.addEventListener(Event.RENDER, execute);
			stage && stage.invalidate();
		}

		/**
		 * 注销监听舞台<code>invalidate</code>
		 * @private
		 */
		private static function endRender():void
		{
			stage && stage.hasEventListener(Event.RENDER) && stage.removeEventListener(Event.RENDER, execute);
		}

		/**
		 * 立即执行重绘
		 * @param e 触发执行重绘的事件类型
		 */
		public static function execute(e:*=null):void
		{
			_rendering=true;
			var functions:Array=_queue.keys(), params:Array=_queue.values(), len:int=_queue.size();
			_queue.clear(); //赋值完毕后立即清空待执行队列

			for (var i:int=0; i < len; i++)
			{
				var fun:Function=functions[i] as Function;
				var param:Array=params[i] as Array;
				fun && fun.apply(null, param);
			}
			(e is TimerEvent) && updateAfterEvent(e);
			_queue.size()||pause();//important!!!
			_rendering=false;
			_runtimeCount=getTimer() - _runtimeCount;
			//trace("Trigger", "excute=" + _runtimeCount);
		}

		/**
		 * 重绘管理器触发执行的事件类型
		 * <p>code<>Trigger.RENDERER,stage.validate()</code>触发</p>
		 * <p>code<>Trigger.TIMER,stage.validate()</code>触发</p>
		 * <p>code<>Trigger.ENTER_FRAME,stage.validate()</code>触发</p>
		 * @return <code>String</code>
		 */
		public static function get type():String
		{
			return _type;
		}

		/**
		 * 重绘管理器触发执行的事件类型
		 * <p>code<>Trigger.RENDERER,stage.validate()</code>触发</p>
		 * <p>code<>Trigger.TIMER,stage.validate()</code>触发</p>
		 * <p>code<>Trigger.ENTER_FRAME,stage.validate()</code>触发</p>
		 * @param 事件类型
		 */
		public static function set type(t:String):void
		{
			_type=t;
		}

		/**
		 * 强制更新舞台显示列表
		 * @private
		 */
		private static function updateAfterEvent(e:TimerEvent):void
		{
			e.updateAfterEvent();
		}
	}
}