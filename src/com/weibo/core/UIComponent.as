package com.weibo.core
{
	import com.weibo.events.UIComponentEvent;
	
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	
	/**
	 * 微型框架-基类
	 * 提高运行效率
	 * 以模板开发模式简化了开发
	 * 实现尺寸适应
	 * create
	 * destroy
	 * addEvents
	 * removeEvents
	 * layout
	 * updateState
	 * invalidate();根据参数更新相应模块
	 * ValidateType.ALL-->销毁所有模版内容并重新创建
	 * ValidateType.SIZE-->改变尺寸，影响布局
	 * ValidateType.STATE-->只改变状态
	 * 最近修改：yaofei
	 * @author sinaweibo
	 */	
	public class UIComponent extends Sprite
	{
		
//::::::::::::::::::::::::::::::::::::::::::
// 渲染方式
		/*
		public static const ALL:String="all";
		public static const SIZE:String="size";
		public static const STATE:String="state";
//		public static const DATA:String="data";
		*/
		
//==========================================
// 实例属性
		
		private var _validateTypeObject:Object = {};
		
		
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		
//		private var _autoSize:Boolean = true;
		
		//样式
		protected var _style:Object = {};
		
		//尺寸是否发生了变化
		protected var _haveResized:Boolean = false;
		//是否需要渲染
		protected var _needRender:Boolean = false;
		/**
		 * 子对象的尺寸变化是否影响容器
		 */		
		protected var listenChildrenSize:Boolean = false;
		
		
	//==========================================
	// 构造函数
	//------------------------------------------

		public function UIComponent()
		{
			super();
			this.visible = false;
			
			//初始化
			create();
			addEvents();
			
//			addEventListener(Event.RESIZE, resizeHandler);//监听子对象尺寸
			addEventListener("invalidate", invalidateListener);//兼容Player9
			
//			addEventListener(UIComponentEvent.LAYOUT, layoutHandler);//冒泡阶段，保证子对象-->父对象顺序
			addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			
			invalidate(ValidateType.SIZE);
		}
		
		
//==========================================
// 私有方法
		
		/**
		 * 组件的属性或样式的改变方式。
		 * @param type
		 */		
		final protected function invalidate(type:String = "state"):void
		{
			_validateTypeObject[type] = true;
			/*if (type == ValidateType.SIZE)
			{
				//启动父级对象改变尺寸
				dispatchEvent(new Event(Event.RESIZE, true));
			}
			addEventListener(Event.ENTER_FRAME, invalidateAtFrame);*/
			dispatchEvent(new DataEvent("invalidate", true, true, type));
		}
		
		private function invalidateAtFrame(event:Event):void
		{
			this.visible = true;
			removeEventListener(Event.ENTER_FRAME, invalidateAtFrame);
			
			_haveResized = false;
			_needRender = false;
			//重置全部内容
			if (_validateTypeObject[ValidateType.ALL])
			{
				_validateTypeObject = {};//一定要立即重置，使其可以立即重新设置invalidate
				_haveResized = true;
				_needRender = true;
				removeEvents();
				destroy();
				create();//创建对象
				addEvents();//给对象添加事件
				
			}
			//改变尺寸、布局对象
			else if (_validateTypeObject[ValidateType.SIZE])
			{
				_validateTypeObject = {};//同上
				_haveResized = true;
				_needRender = true;
				
			}
			//更新状态
			else if (_validateTypeObject[ValidateType.STATE])
			{
				_validateTypeObject = {};//同上
				_needRender = true;
			}
			else
			{
				_validateTypeObject = {};//同样有必要
			}
			
			//利用事件冒泡，容器整体侦听由内向外冒泡，减轻维护子类成本
			/*if (_haveResized)
			{
				dispatchEvent(new Event(UIComponentEvent.LAYOUT, true));
			}*/
			if (_haveResized){
				_needRender = true;
				layout();
			}
			
			//推迟到Render阶段
			if (stage && _needRender) stage.invalidate();
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
		 */	
		protected function addEvents():void
		{
			
		}

		/**
		 * 需要被子类重写，完成移除事件侦听的目的
		 */		
		protected function removeEvents():void
		{
			
		}
		
		/**
		 * 需要被子类重写，完成内容排版的目的
		 * 职责：设置宽高、布局子对象。
		 * //运行时期：FRAME_CONSTRUCTED
		 * 时机：此时能读到子对象尺寸；同时计算出自己的宽高。
		 * 注意：容器的子类考虑是否继承容器行为：super.layout();
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
			invalidate();
		}
		
		public function getStyle(style:String):Object
		{
			return _style[style];
		}
		
		public function clearStyle(style:String):void
		{
			delete _style[style];
			invalidate();
		}
		
		/**
		 * 将组件移到指定的位置
		 * @param xpos x坐标
		 * @param ypos y坐标
		 */
		public function move(xpos:Number, ypos:Number):void
		{
			this.x = xpos;
			this.y = ypos;
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
//			_autoSize = false;
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
//			_autoSize = false;
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
//			_autoSize = false;
			invalidate(ValidateType.SIZE);
		}
		
		/*public function get autoSize():Boolean
		{
			return _autoSize;
		}
		
		public function set autoSize(value:Boolean):void
		{
			_autoSize = value;
			invalidate(ValidateType.SIZE);
		}*/
		
//==========================================
// 事件侦听器
		
		private function addToStageHandler(event:Event):void
		{
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			addEventListener(Event.RENDER, invalidateAtRender);//添加渲染事件，利用冒泡
			
			if (_needRender) stage.invalidate();
		}
		
		private function removedFromStageHandler(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			removeEventListener(Event.RENDER, invalidateAtRender);
		}
		
		private function invalidateAtRender(event:Event):void
		{
			if (_needRender) updateState();
			//由于在Event.ADDED_TO_STAGE时添加了侦听，所以需要重置--避免外界因素触发
			_needRender = false;
			_haveResized = false;
		}
		
		/**
		 * 处理接收到的子对象的尺寸更新
		 * @param event
		private function resizeHandler(event:Event):void
		{
			if (event.target == this) return;//排除自身(避免死循环，且自身已添加)
			
			if (!listenChildrenSize) return;
			
			//同步：子对象发生了尺寸变化，因此父对象也需要启动同帧变化尺寸机制，但这时还未实现冒泡顺序
			invalidate(ValidateType.SIZE);
		}
		 */	
		private function invalidateListener(event:DataEvent):void
		{
			if (event.target != this && listenChildrenSize){
				//同步：子对象发生了尺寸变化，因此父对象也需要启动同帧变化尺寸机制，但这时还未实现冒泡顺序
				if (event.data == ValidateType.SIZE){
					_validateTypeObject[event.data] = true;
				}
			}
			
			removeEventListener(Event.ENTER_FRAME, invalidateAtFrame);
			addEventListener(Event.ENTER_FRAME, invalidateAtFrame);
		}
		
		
		/**
		 * 处理接收到的尺寸布局变化
		 * 由EnterFrame时期发送的事件
		 * 包括自身内的冒泡链，即：子对象-父对象（显示列表链）计算尺寸
		 * @param event
		private function layoutHandler(event:Event):void
		{
			if (!listenChildrenSize) return;
			
			removeEventListener(Event.FRAME_CONSTRUCTED, frameConstructedHandler);//保证顺序！务删！
			addEventListener(Event.FRAME_CONSTRUCTED, frameConstructedHandler);
		}
		
		private function frameConstructedHandler(event:Event):void{
			removeEventListener(Event.FRAME_CONSTRUCTED, frameConstructedHandler);
			layout();
			
			//由子对象发生的尺寸变化，触发updateState
			_haveResized = true;
			_needRender = true;
			if (stage)	stage.invalidate();
		}
		 */		
	}
}