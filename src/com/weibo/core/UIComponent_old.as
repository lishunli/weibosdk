package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class UIComponent extends Sprite
	{
		private var _validateTypeObject:Object = {};
		
//		protected var _tag:int = -1;
		
		protected var listenChildrenSize:Boolean;
		
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		
		//样式
		protected var _style:Object = {};
		
	//==========================================
	// 构造函数
	//------------------------------------------
		
		public function UIComponent()
		{
			super();
			
			//初始化
//			validate();
			create();
			addEvents();
			layout();
//			updateState();
			
//			invalidate(ValidateType.SIZE);
			invalidate(ValidateType.STATE);
			
			//是开始就渲染呢（尺寸问题）还是帧上渲染呢（设置尺寸不重复操作）
//			invalidate("all");
		}
		
		
	//==========================================
	// 私有方法
	//------------------------------------------
		
		private function validate():void
		{
			for (var type:Object in _validateTypeObject)
			{
				switch (type)
				{
					case ValidateType.ALL:
						break;
//					case ValidateType.STYLES:
//						break;
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
				layout(); //布局对象
				updateState(); //更新对象状态
				addEvents(); //给对象添加事件
			}
			//样式,是否需要？
			/*else if (_validateTypeObject[ValidateType.STYLES])
			{
				_validateTypeObject = {};
				removeEvents();
				destroy();
				create(); //创建对象
				layout(); //布局对象
				addEvents(); //给对象添加事件
			}*/
			else
			{
				//布局对象，包含还是并列updateState?
				if (_validateTypeObject[ValidateType.SIZE])
				{
//					delete _validateTypeObject[ValidateType.SIZE];
					_validateTypeObject = {};
					layout();
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
		
		/**
		 * 
		 * @param type
		 */		
		protected function invalidate(type:String = "state"):void
		{
			_validateTypeObject[type] = true;
			addEventListener(Event.ENTER_FRAME, invalidateOnFrame);
		}
		
		private function invalidateOnFrame(event:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, invalidateOnFrame);
			validate();
		}
		
	//==========================================
	// 子类需要覆写使用的方法
	//------------------------------------------
		
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
	//------------------------------------------
		
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
		 * 组件标识
		 */
		/*public function get tag():int { return _tag; }
		public function set tag(value:int):void
		{
			_tag = value;
		}*/
		
		
		/**
		 * 设置宽度，进入重新渲染流程
		 */
		override public function get width():Number { return _width; }
		override public function set width(w:Number):void
		{
			if (w == width) return;
			_width = w;
			invalidate("size");
			dispatchEvent(new Event(Event.RESIZE, true));
		}
		
		/**
		 * 设置高度，进入重新渲染流程
		 */
		override public function get height():Number { return _height; }
		override public function set height(h:Number):void
		{
			if (h == height) return;
			_height = h;
			invalidate("size");
			dispatchEvent(new Event(Event.RESIZE, true));
		}
		
		/**
		 * 设置宽度和高度，进入重新渲染流程
		 * @param w
		 * @param h
		 * 
		 */
		public function setSize(w:Number, h:Number):void
		{
			if (w == width && h == height) return;
			_width = w;
			_height = h;
			invalidate("size");
			dispatchEvent(new Event(Event.RESIZE, true));
		}
		
	}
}