package com.weibo.controls
{
	import com.weibo.core.Container;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * 容器模型基类
	 * 子对象自由排列
	 * @author yaofei
	 */	
	public class Box extends Container
	{
		protected var _border:Object = false;
		protected var _padding:Object = false;
		
		protected var _borderContainer:Sprite;
		protected var _paddingContainer:Sprite;
		
		public function Box()
		{
			listenChildrenSize = true;
			super();
		}
		
//===============================
// 公开方法
		
		
//===============================
// 内部方法
		
		override protected function layout():void
		{
			if (autoSize){
				_width = 0;
				_height = 0;
				for (var i:int = 0; i < numChildren; i++)
				{
					var d:DisplayObject = getChildAt(i);
					_width = Math.max(d.width, _width);
					_height = Math.max(d.height, _height);
				}
			}
		}
		
		
		override protected function updateState():void
		{
			
		}
		
//===============================
// 事件侦听器
		
		
	}
}