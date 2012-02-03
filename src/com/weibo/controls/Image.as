package com.weibo.controls
{
	import com.weibo.core.UIComponent;
	
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
		private var _background:Shape;
		private var _content:Sprite;
		private var _loader:Loader;
		
		private var _showBack:Boolean = false;
		private var _border:Number = 1;
		private var _margin:Number = 2;
		private var _borderColor:uint = 0xcccccc;
		private var _backColor:uint = 0xffffff;
		private var _autoSize:Boolean = true;
		
	//======================================
	// 构造函数
	//--------------------------------------
		
		public function Image(showBack:Boolean = false, autoSize:Boolean = true)
		{
			_width = 0;
			_height = 0;
			super();
			_autoSize = autoSize;
			this.showBack = showBack;
			
			if(!autoSize) setSize(100, 100);
//			addEventListener(Component.DRAW, beforDraw);
		}
		
	//======================================
	// 公开方法
	//--------------------------------------
		
		public function get autoSize():Boolean
		{
			return _autoSize;
		}
		public function set autoSize(value:Boolean):void
		{
			_autoSize = value;
			invalidate();
		}
		
		public function set source(value:Object):void
		{
			removeContents();
			if (value is Class)
			{
				var object:DisplayObject = new value();
				if (object) _content.addChild(object);
			}
			else if (value is DisplayObject)
			{
				_content.addChild(value as DisplayObject);
			}
			else if (value is String)
			{
				_loader.load(new URLRequest(value as String));
				_content.addChild(_loader);
				addLoaderEvents();
			}
			invalidate();
		}
		
		public function get showBack():Boolean { return _showBack; }
		public function set showBack(value:Boolean):void
		{
			_showBack = value;
			invalidate();
		}
		
		public function get margin():Number { return _margin; }
		public function set margin(value:Number):void
		{
			_margin = value;
			invalidate();
		}
		
		public function get border():Number { return _border; }
		public function set border(value:Number):void
		{
			_border = value;
			invalidate();
		}
		
		
		override public function set width(w:Number):void
		{
			_autoSize = false;
			super.width = w;
		}
		
		override public function set height(h:Number):void
		{
			_autoSize = false;
			super.height = h;
		}
		
		override public function setSize(w:Number, h:Number):void
		{
			_autoSize = false;
			super.setSize(w, h);
		}
		
		
	//======================================
	// 内部方法
	//--------------------------------------
		
		override protected function create():void
		{
			if (_background == null)
			{
				_background = new Shape();
				addChild(_background);
			}
			
			if (_content == null)
			{
				_content = new Sprite();
				addChild(_content);
			}
			
			if (_loader == null)
			{
				_loader = new Loader();
			}
		}
		
		override protected function updateState():void
		{
			_background.graphics.clear();
			if (showBack)
			{
				if (!autoSize)
				{
					_content.width = width - border*2 - margin*2;
					_content.height = height - border*2 - margin*2;
				}
				else
				{
					_width = _content.width + border*2 + margin*2;
					_height = _content.height + border*2 + margin*2;
				}
				_background.graphics.beginFill(_borderColor);
				_background.graphics.drawRect(0, 0, width, height);
				_background.graphics.beginFill(_backColor);
				_background.graphics.drawRect(border, border, width - border*2, height - border*2);
				_content.x = border + margin;
				_content.y = border + margin;
			}
			else
			{
				if (!autoSize)
				{
					_content.width = width;
					_content.height = height;
				}
				else
				{
					_width = _content.width;
					_height = _content.height;
				}
				_content.x = 0;
				_content.y = 0;
			}
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		private function removeContents():void
		{
			while (_content.numChildren > 0) _content.removeChildAt(0);
			removeLoaderEvents();
		}
		
		private function addLoaderEvents():void
		{
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoad);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
		}
		
		private function removeLoaderEvents():void
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoad);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
		}
		
	//======================================
	// 事件侦听器
	//--------------------------------------
		
		/*override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
		this.buttonMode = true;
		super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
		this.buttonMode = false;
		super.removeEventListener(type, listener, useCapture);
		}*/
		
		/*protected function beforDraw(event:Event):void
		{
			if (showBack
			setSize(_content.width + (border+margin)*2, _content.height + (border+margin)*2);
		}*/
		
		protected function onLoad(event:Event):void
		{
			invalidate();
		}
		
		protected function onError(event:IOErrorEvent):void
		{
			
		}
	}
}