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
		
		public function Label(text:String="")
		{
			super();
			_textfield.text = text;
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
			if (format) _format = format;
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
			invalidate();
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
			invalidate();
		}
		
		public function set textColor(value:uint):void
		{
			format.color = value;
			invalidate();
		}
		
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
			_textfield.defaultTextFormat = format;
			_textfield.setTextFormat(format);
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
	}
}