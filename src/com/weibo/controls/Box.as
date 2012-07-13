package com.weibo.controls
{
	import com.weibo.core.UIComponent;
	import com.weibo.core.ValidateType;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * 容器模型基类
	 * 子对象自由排列
	 * @author yaofei
	 */	
	public class Box extends UIComponent
	{
		protected var _border:Object = false;
		protected var _padding:Object = false;
		
		protected var _borderContainer:Sprite;
		protected var _paddingContainer:Sprite;
		protected var _content:Sprite;
		
		public function Box()
		{
			listenChildrenSize = true;
			super();
		}
		
//===============================
// 公开方法
		
		/*override public function get width():Number
		{
			return _content.width;
		}
		
		override public function get height():Number
		{
			return _content.height;
		}*/
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			super.addChild(child);
//			_content.addChild(child);
			invalidate(ValidateType.SIZE);
			return child;
		}
		
//===============================
// 内部方法
		
		override protected function create():void
		{
			if (_content == null)	_content = new Sprite();
			super.addChild(_content);
		}
		
		override protected function layout():void
		{
			_width = 0;
			_height = 0;
			for (var i:int = 0; i < numChildren; i++)
			{
				var d:DisplayObject = getChildAt(i);
				_width = Math.max(d.width, _width);
				_height = Math.max(d.height, _height);
			}
		}
		
		
		override protected function updateState():void
		{
			
		}
		
//===============================
// 事件侦听器
		
		
	}
}