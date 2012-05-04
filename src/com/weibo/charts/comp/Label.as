package com.weibo.charts.comp
{
	import com.weibo.core.UIComponent;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * 
	 * YaoFei
	 */
	public class Label extends UIComponent
	{
		private var _textfield:TextField;
		private var _format:TextFormat = new TextFormat("Arial", 12, 0x333333);
		
//==========================================
// 构造函数
//------------------------------------------
		
		public function Label(text:String="")
		{
			super();
			_textfield.text = text;
		}
		
//==========================================
// 公开方法
//------------------------------------------
		
		public function setLabel(value:String, useHTML:Boolean = false):void
		{
			if(useHTML) _textfield.htmlText = value;
			else _textfield.text = value;
			
//			invalidate();
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		public function set text(value:String):void
		{
			_textfield.text = (value == null) ? "" : value;
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		public function get text():String
		{
			return _textfield.text;
		}
		
		public function set format(format:TextFormat):void
		{
//			if (format == null)
			_format = format;
			invalidate();
		}

		public function get format():TextFormat
		{
			return _format;
		}
		
		public function set align(value:String):void
		{
			format.align = value;
			invalidate();
		}
		
		public function set font(value:String):void
		{
			format.font = value;
//			invalidate();
			_textfield.defaultTextFormat = format;
		}
		
		public function set size(value:Object):void
		{
			format.size = value;
			invalidate();
		}
		
		public function set bold(value:Object):void
		{
			format.bold = value;
			invalidate();
		}
		
		public function set letterSpacing(value:Object):void
		{
			format.letterSpacing = value;
			invalidate();
		}
		
		public function set underline(value:Object):void
		{
			format.underline = value;
			updateState();
//			invalidate();
		}
		
		public function set color(value:uint):void
		{
			format.color = value;
			invalidate();
		}
		
		override public function setSize(w:Number, h:Number):void
		{
			
		}
		
		override public function get width():Number
		{
			return _textfield.width;
		}
		override public function set width(w:Number):void
		{
			
		}
		
		override public function get height():Number
		{
			return _textfield.height;
		}
		override public function set height(h:Number):void
		{
			
		}
		
//==========================================
// 内部方法
//------------------------------------------
		
		override protected function create():void
		{
			_textfield = new TextField();
			_textfield.autoSize = TextFieldAutoSize.LEFT;
			_textfield.selectable = false;
//			_textfield.multiline = true;
			
			addChild(_textfield);
		}
		
		override protected function updateState():void
		{
			//颜色还是什么不能用?
//			_textfield.defaultTextFormat = format;
			_textfield.setTextFormat(format);
		}
	}
}