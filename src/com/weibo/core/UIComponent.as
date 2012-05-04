package com.weibo.core
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class UIComponent extends Sprite
	{
		
//::::::::::::::::::::::::::::::::::::::::::
// 渲染方式
		/*
		public static const ALL:String="all";
		public static const SIZE:String="size";
//		public static const STYLES:String="styles";
		public static const STATE:String="state";
//		public static const DATA:String="data";
//		public static const SCROLL:String="scroll";
//		public static const SELECTED:String="selected";
		*/
		
//==========================================
// 实例属性
		
		private var _validateTypeObject:Object = {};
		
		
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		
		//样式
		protected var _style:Object = {};
		
		//保留到渲染前再执行
//		protected var _haveResized:Boolean = false;
		
	//==========================================
	// 构造函数
	//------------------------------------------
		
		public function UIComponent()
		{
			super();
			
			//初始化
//			validate();//ENTER_FRAME时期
			create();
			addEvents();
			layout();//这里是直接调用，所以不能发送事件（应该在渲染前，有子对象后才会发送事件）
			updateState();
			
//			invalidate("all");//创建此对象避免调用
		}
		
		
//==========================================
// 私有方法
		/*
		private function validate():void
		{
			//打扫添加的不良信息，只保留有效值。
			for (var type:Object in _validateTypeObject)
			{
				switch (type)
				{
					case ValidateType.ALL:
						break;
					case ValidateType.STYLES:
						break;
					case ValidateType.SIZE:
						break;
					case ValidateType.STATE:
						break;
					default:
						delete _validateTypeObject[type];
						break;
				}
			}
			//重置全部内容
			if (_validateTypeObject[ValidateType.ALL])
			{
				_validateTypeObject = {};
				removeEvents();
				destroy();
				create(); //创建对象
				resized(); //布局对象
				updateState(); //更新对象状态
				addEvents(); //给对象添加事件
			}
			//样式,是否需要？比ALL方式只少了updateState！！
			else if (_validateTypeObject[ValidateType.STYLES])
			{
				_validateTypeObject = {};
				removeEvents();
				destroy();
				create(); //创建对象
				resized(); //布局对象
				addEvents(); //给对象添加事件
			}
			else
			{
				//布局对象，包含还是并列updateState?
				//SIZE先于STATE，SIZE里应该只设置和排列尺寸内容，具体处理显示层再在STATE里处理
				//这样保证父级渲染里能读到子级尺寸
				if (_validateTypeObject[ValidateType.SIZE])
				{
//					delete _validateTypeObject[ValidateType.SIZE];
					_validateTypeObject = {};
					resized();
					updateState();
				}
				//更新对象状态
				else if (_validateTypeObject[ValidateType.STATE])
				{
//					delete _validateTypeObject[ValidateType.STATE];
					_validateTypeObject = {};
					updateState();
				}
			}
		}
		*/
		
		/**
		 * 组件的属性或样式以哪种方式发生了改变。
		 * 注意这里隐藏着一个关于尺寸的重要的机制
		 * 如果设置容器的属性：容器先添加了Event.ENTER_FRAME，所以容器先于子对象执行validate。
		 * 如果设置子对象属性：则子对象执行validate，并发送尺寸事件，容器收到事件直接处理。
		 * 
		 * @param type
		 */		
		final protected function invalidate(type:String = ValidateType.STATE):void
		{
			_validateTypeObject[type] = true;
			addEventListener(Event.ENTER_FRAME, invalidateAtFrame);
		}
		
		private function invalidateAtFrame(event:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, invalidateAtFrame);
			
			var needRender:Boolean = false;
			//重置全部内容
			if (_validateTypeObject[ValidateType.ALL])
			{
				_validateTypeObject = {};//一定要立即重置，使ENTER_FRAME期间也可以设置invalidate
				needRender = true;
				removeEvents();
				destroy();
				create();//创建对象
				layout();//设置布局和尺寸
				addEvents();//给对象添加事件
				
				dispatchEvent(new Event(Event.RESIZE, true, false));
			}
			//布局对象，包含还是并列updateState?
			//SIZE先于STATE，SIZE里应该只设置和排列尺寸内容，具体处理显示层再在STATE里处理
			//这样保证父级渲染里能读到子级尺寸
			else if (_validateTypeObject[ValidateType.SIZE])
			{
				_validateTypeObject = {};//同上
				needRender = true;
				layout();
				
				//★各种容器尺寸：利用事件冒泡，容器整体侦听由内向外冒泡，减轻维护子类成本
				//发出事件的时机：ENTER_FRAME！
				dispatchEvent(new Event(Event.RESIZE, true, false));
			}
			else if (_validateTypeObject[ValidateType.STATE])
			{
				_validateTypeObject = {};//同上
				
				needRender = true;
			}
			else
			{
				_validateTypeObject = {};//同样有必要
			}
			
			//推迟到RENDER阶段
			//1.读到尺寸。2.容器和此对象同步渲染
			if (stage && needRender)
			{
				stage.addEventListener(Event.RENDER, invalidateAtRender);
				stage.invalidate();
			}
			/*else
			{
//				_haveResized = false;
			}*/
		}
		
		private function invalidateAtRender(event:Event):void
		{
			stage.removeEventListener(Event.RENDER, invalidateAtRender);
			/*if (_haveResized)
			{
				//发出事件后再处理，这会影响到容器？？
				layout();
				_haveResized = false;
			}*/
			
			updateState();
		}
		
		
//==========================================
// 子类需要覆写使用的方法
		
		/**
		 * 需要被子类重写，完成创建元素的目的
		 */
		protected function create():void
		{
			
		}

		/**
		 * 需要被子类重写，完成销毁引用的目的
		 */		
		protected function destroy():void
		{
			
		}
		
		/**
		 * 需要被子类重写，完成添加事件侦听的目的
		 * 子类使用时要调用super.addEvents();尤其是容器
		 */	
		protected function addEvents():void
		{
			addEventListener(Event.RESIZE, resizeHandler);
		}

		/**
		 * 需要被子类重写，完成移除事件侦听的目的
		 * 子类使用时要调用super.removeEvents();尤其是容器
		 */		
		protected function removeEvents():void
		{
			removeEventListener(Event.RESIZE, resizeHandler);
		}
		
		/**
		 * 需要被子类重写，完成内容排版的目的
		 * 运行时期：一般都在ENTER_FRAME中
		 * 这里只计算尺寸，这样保证父级渲染里能读到子级尺寸
		 * 只有在必要时才计算尺寸，减少计算尺寸的开支。
		 */	
		protected function layout():void
		{
			
		}
		
		
		/**
		 * 需要被子类重写，完成状态更新的目的
		 */		
		protected function updateState():void
		{
			
		}
		
		
//==========================================
// 公开方法
		
		public function setStyle(style:String, value:Object):void
		{
			_style[style] = value;
//			invalidate(ValidateType.STYLES);
			invalidate();
		}
		
//		protected function get style():Object { return _style; }
		
		public function getStyle(style:String):Object
		{
			return _style[style];
		}
		
		public function clearStyle(style:String):void
		{
			delete _style[style];
//			invalidate(ValidateType.STYLES);
			invalidate();
		}
		
		/**
		 * 将组件移到指定的位置
		 * @param xpos x坐标
		 * @param ypos y坐标
		 */
		public function move(xpos:Number, ypos:Number):void
		{
			this.x = Math.round(xpos);
			this.y = Math.round(ypos);
		}
		
		/**
		 * 保证x位置为整数点
		 */
		override public function set x(value:Number):void
		{
			super.x = value;
		}
		
		/**
		 * 保证y位置为整数点
		 */
		override public function set y(value:Number):void
		{
			super.y = value;
		}
		
		
		/**
		 * 设置宽度，进入重新渲染流程
		 */
		override public function get width():Number { return _width; }
		override public function set width(w:Number):void
		{
			if (w == width) return;
			_width = w;
			invalidate(ValidateType.SIZE);
		}
		
		/**
		 * 设置高度，进入重新渲染流程
		 */
		override public function get height():Number { return _height; }
		override public function set height(h:Number):void
		{
			if (h == height) return;
			_height = h;
			invalidate(ValidateType.SIZE);
		}
		
		/**
		 * 设置宽度和高度，进入重新渲染流程
		 * @param w
		 * @param h
		 */
		public function setSize(w:Number, h:Number):void
		{
			if (w == width && h == height) return;
			_width = w;
			_height = h;
			invalidate(ValidateType.SIZE);
		}
		
//==========================================
// 事件侦听器
		
		/**
		 * 处理接收到的子对象的尺寸更新事件
		 * 发送事件的时机：ENTER_FRAME。
		 * 处理事件的时机：被推迟到了RENDER。
		 * 一次性处理多个事件，提高性能
		 */	
		protected function resizeHandler(event:Event):void
		{
			if (event.target == this) return;//排除自己发出的事件
			//直接启动RENDER
			if (stage)
			{
				stage.addEventListener(Event.RENDER, invalidateAtRender);
				stage.invalidate();
			}
		}
		
	}
}