package com.weibo.controls
{
	import com.weibo.core.UIComponent;
	import com.weibo.core.ValidateType;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	/**
	 * Image通用组件
	 * 通过source设置图形
	 * 支持图片路径、类、实例
	 * @author yaofei
	 */	
	public class Image extends UIComponent
	{
//		private var _background:Shape;
		private var _content:Sprite;
		private var _loader:Loader;
		
		private var _source:Object;
		
		private var _autoSize:Boolean = true;
		
//		private var _showBack:Boolean = false;
//		private var _border:Number = 1;
//		private var _padding:Number = 2;
//		private var _borderColor:uint = 0xcccccc;
//		private var _backColor:uint = 0xffffff;
		
//======================================
// 构造函数
//--------------------------------------
		
		public function Image(source:Object = null)
		{
			super();
			this.source = source;
		}
		
//======================================
// 公开方法
		
		/**
		 * 图片的源：
		 * 显示类、显示对象、图片路径
		 * @param value
		 */		
		public function set source(value:Object):void
		{
			_source = value;
			
			removeContents();
			_content.scaleX = _content.scaleY = 1;
			
			if (value is Class)
			{
				var object:DisplayObject = new value();
				if (object) _content.addChild(object);
				
				invalidate(ValidateType.SIZE);
			}
			else if (value is DisplayObject)
			{
				_content.addChild(value as DisplayObject);
				
				invalidate(ValidateType.SIZE);
			}
			else if (value is String)
			{
				_loader.load(new URLRequest(value as String));
				_content.addChild(_loader);
				addLoaderEvents();
			}
//			invalidate();
			invalidate(ValidateType.SIZE);
		}
		
		
		
		override public function get width():Number
		{
			return autoSize ? _content.width : _width;
		}
		
		override public function get height():Number
		{
			return autoSize ? _content.height : _height;
		}
		
		public function get autoSize():Boolean{return _autoSize;}
		
		public function set autoSize(value:Boolean):void
		{
			_autoSize = value;
			invalidate(ValidateType.SIZE);
		}
		
		
//======================================
// 内部方法
		
		override protected function create():void
		{
			
			_content = new Sprite();
			addChild(_content);
			
			_loader = new Loader();
		}
		
		override protected function destroy():void
		{
			
			removeChild(_content);
			_content = null;
			
			if (contains(_loader)) removeChild(_loader);
			_loader = null;
		}
		
		override protected function layout():void
		{
			if (!autoSize)
			{
				_content.width = _width;
				_content.height = _height;
			}
		}
		
		private function removeContents():void
		{
			while (_content.numChildren > 0) _content.removeChildAt(0);
			removeLoaderEvents();
		}
		
		private function addLoaderEvents():void
		{
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageOnLoad);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
		}
		
		private function removeLoaderEvents():void
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imageOnLoad);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
		}
		
//======================================
// 事件侦听器
		
		protected function imageOnLoad(event:Event):void
		{
//			dispatchEvent(new Event(Event.RESIZE, true, false));//临时发送
			invalidate(ValidateType.SIZE);
//			invalidate();
		}
		
		protected function onError(event:IOErrorEvent):void
		{
			
		}
	}
}