package com.weibo.comp.weiboPublisher 
{
	import com.weibo.core.UIComponent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Qi Donghui
	 */
	public class Publisher extends UIComponent 
	{
		protected var _text:String;
		
		protected var _ba:ByteArray;
		
		/**
		 * 发布器核心最上层的容器，成功错误提示等等的内容
		 */
		private var _frontCont:Sprite;
		
		/**
		 * 发布器核心下层的容器
		 */
		private var _backCont:Sprite;
		
		/**
		 * 弹出面板的容器，每次只有唯一的显示对象
		 */
		private var _panelCont:Sprite;
		
		public function Publisher() 
		{
			
		}
		
		/**
		 * 添加功能按钮，到显示列表中
		 */
		public function addFunButton(obj:DisplayObject):void
		{
			
		}
		
		public function addFunPanel(obj:DisplayObject, globalX:Number, globalY:Number):void
		{
			
		}
		
		public function addUIToBack(obj:DisplayObject, globalX:Number, globalY:Number):void
		{
			var localPoint:Point = _frontCont.globalToLocal(new Point(globalX, globalY));
		}
		
		public function addUIToFront(obj:DisplayObject, globalX:Number, globalY:Number):void
		{
			
		}
		
		public function get text():String { return _text; }
		public function set text(value:String):void 
		{
			_text = value;
		}
		
		public function get ba():ByteArray { return _ba; }		
		public function set ba(value:ByteArray):void 
		{
			_ba = value;
		}
		
	}

}