package com.weibo.core
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	/**
	 * 
	 * 
	 * @author yaofei@staff.sina.com.cn
	 */	
	public class Container extends UIComponent
	{
		private var _autoSize:Boolean = true;
		
		protected var _content:Sprite;
		
		public function Container()
		{
			super();
		}
		
//===================================
// 公开方法
		
		public override function addChild(child:DisplayObject):DisplayObject
		{
			_content.addChild(child);
			invalidate(ValidateType.SIZE);
			return child;
		}
		
		public override function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			_content.addChildAt(child, index);
			invalidate(ValidateType.SIZE);
			return child;
		}
		
		public override function removeChild(child:DisplayObject):DisplayObject
		{
			_content.removeChild(child);
			invalidate(ValidateType.SIZE);
			return child;
		}
		
		public override function removeChildAt(index:int):DisplayObject
		{
            var child:DisplayObject = _content.removeChildAt(index);
			invalidate(ValidateType.SIZE);
			return child;
		}
		
		public override function get numChildren():int
		{
			return _content.numChildren;
		}
		
		/**
		 * 
		 * @param w
		 */		
		public override function set width(w:Number):void
		{
			_width = w;
			_autoSize = false;
			invalidate(ValidateType.SIZE);
		}
		
		/**
		 * 设置高度，进入重新渲染流程
		 * @param h
		 */		
		public override function set height(h:Number):void
		{
			_height = h;
			_autoSize = false;
			invalidate(ValidateType.SIZE);
		}
		
		/**
		 * 设置宽度和高度，进入重新渲染流程
		 * @param w
		 * @param h
		 */
		public override function setSize(w:Number, h:Number):void
		{
			_width = w;
			_height = h;
			_autoSize = false;
			invalidate(ValidateType.SIZE);
		}
		
		public function get autoSize():Boolean
		{
			return _autoSize;
		}
		
		public function set autoSize(value:Boolean):void
		{
			_autoSize = value;
			invalidate(ValidateType.SIZE);
		}
		
//===================================
// 内部方法
		
		override protected function create():void
		{
			_content = new Sprite();
			super.addChild(_content);
		}
		
		override protected function destroy():void
		{
			super.removeChild(_content);
			_content = null;
		}
		
//===================================
// 事件侦听器
	}
}