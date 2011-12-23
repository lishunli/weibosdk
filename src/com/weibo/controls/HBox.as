package com.weibo.controls 
{
	import com.weibo.core.UIComponent;
	import com.weibo.managers.RepaintManager;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Qi Donghui
	 */
	public class HBox extends UIComponent 
	{
		protected var _spacing:Number = 5;
		
		private var _alignment:String = NONE;
		
		public static const TOP:String = "top";
		public static const BOTTOM:String = "bottom";
		public static const MIDDLE:String = "middle";
		public static const NONE:String = "none";		
		
		public function HBox() 
		{
			
		}
				
		override protected function layout():void
		{
			_width = 0;
			_height = 0;
			var xpos:Number = 0;
			for(var i:int = 0; i < numChildren; i++)
			{
				var child:DisplayObject = getChildAt(i);
				child.x = xpos;
				xpos += child.width;
				xpos += _spacing;
				_width += child.width;
				_height = Math.max(_height, child.height);
			}
			doAlignment();
			_width += _spacing * (numChildren - 1);
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		/**
		 * 垂直排版
		 */
		protected function doAlignment():void
		{
			if(_alignment != NONE)
			{
				for(var i:int = 0; i < numChildren; i++)
				{
					var child:DisplayObject = getChildAt(i);
					if(_alignment == TOP)
					{
						child.y = 0;
					}
					else if(_alignment == BOTTOM)
					{
						child.y = _height - child.height;
					}
					else if(_alignment == MIDDLE)
					{
						child.y = (_height - child.height) / 2;
					}
				}
			}
		}		
		
		/**
		 * 强制排版
		 * @param	child
		 * @return
		 */
		public override function addChild(child:DisplayObject):DisplayObject
		{
			super.addChild(child);	
			child.addEventListener(Event.RESIZE, onResize);
			this._validateTypeObject["size"] = true;
			RepaintManager.getInstance().addToRepaintQueue(this);			
			return child;
		}
		
		/**
		 * 强制排版
		 * @param	child
		 * @param	index
		 * @return
		 */
        override public function addChildAt(child:DisplayObject, index:int) : DisplayObject
        {
			super.addChild(child);
			child.addEventListener(Event.RESIZE, onResize);
			this._validateTypeObject["size"] = true;
			RepaintManager.getInstance().addToRepaintQueue(this);	
			return child;
		}
		
		/**
		 * 强制排版
		 * @param	child
		 * @return
		 */
        override public function removeChild(child:DisplayObject):DisplayObject
        {
            super.removeChild(child);
            child.removeEventListener(Event.RESIZE, onResize);
			this._validateTypeObject["size"] = true;
			RepaintManager.getInstance().addToRepaintQueue(this);	
            return child;
        }

		/**
		 * 强制排版
		 * @param	index
		 * @return
		 */
        override public function removeChildAt(index:int):DisplayObject
        {
            var child:DisplayObject = super.removeChildAt(index);
            child.removeEventListener(Event.RESIZE, onResize);
			this._validateTypeObject["size"] = true;
			RepaintManager.getInstance().addToRepaintQueue(this);	
            return child;
        }		
		
		/**
		 * 所有的子显示对象发出Event.RESIZE的时候重新排版
		 * @param	event
		 */
		protected function onResize(event:Event):void
		{
			this._validateTypeObject["size"] = true;
			RepaintManager.getInstance().addToRepaintQueue(this);		
		}
		
		/**
		 * 水平间隔
		 */
		public function get spacing():Number { return _spacing; }
		public function set spacing(value:Number):void 
		{
			_spacing = value;
			this._validateTypeObject["size"] = true;
			RepaintManager.getInstance().addToRepaintQueue(this);					
		}
		
		/**
		 * 垂直方向的对齐方式
		 */
		public function get alignment():String { return _alignment; }
		public function set alignment(value:String):void 
		{
			_alignment = value;
			this._validateTypeObject["size"] = true;
			RepaintManager.getInstance().addToRepaintQueue(this);					
		}
		
	}

}