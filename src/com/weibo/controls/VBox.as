package com.weibo.controls
{
	import com.weibo.core.UIComponent;
	import com.weibo.core.ValidateType;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * 这是一个容器
	 * 排列方式：子对象按竖直方向
	 * @author yaofei
	 */	
	public class VBox extends UIComponent
	{
		public static const LEFT:String = "left";
		public static const CENTER:String = "center";
		public static const RIGHT:String = "right";
		
		protected var _spacing:Number = 5;
		
		protected var _content:Sprite;
		
		
	//==================================
	// 构造函数
	//----------------------------------
		
		public function VBox()
		{
			listenChildrenSize = true;
			super();
		}
		
//==================================
// 公开方法
		
		public function get spacing():Number { return _spacing; }
		
		public function set spacing(value:Number):void
		{
			_spacing = value;
			invalidate(ValidateType.SIZE);
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			_content.addChild(child);
			invalidate(ValidateType.SIZE);
			return child;
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			_content.addChildAt(child, index);
			invalidate(ValidateType.SIZE);
			return child;
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			_content.removeChild(child);
			invalidate(ValidateType.SIZE);
			return child;
		}
		
		override public function removeChildAt(index:int):DisplayObject
		{
			throw new Error("VBox: 不支持removeChildAt方法!");
		}
		
		override public function get numChildren():int
		{
			return _content.numChildren;
		}
		
		/*override public function get width():Number
		{
			return _content.width;
		}
		
		override public function get height():Number
		{
			return _content.height;
		}*/
		
//==================================
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
		
		override protected function layout():void
		{
			_width = 0;
			var start:Number = 0;
			for (var i:int = 0; i < _content.numChildren; i++)
			{
				var d:DisplayObject = _content.getChildAt(i);
				_width = Math.max(d.width);
				d.y = start;
				start += d.height + _spacing;
			}
			_height = Math.max(0, start - _spacing);
		}
		
//==================================
// 事件侦听器
		
	}
}