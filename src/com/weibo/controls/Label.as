package com.weibo.controls 
{
	import com.weibo.core.UIComponent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Qi Donghui
	 */
	public class Label extends UIComponent 
	{		
		protected var _text:String;
		
		protected var _tf:TextField;
		
		protected var _format:TextFormat;
		
		public function Label(text:String = "", format:TextFormat = null) 
		{
			this._text = text;
			this._format = format;
			super();
		}		
		
		///////////////////////////////////
		// 共有函数
		///////////////////////////////////
		public function setTextFormat(format:TextFormat):void
		{
			_format = format;
			_tf.defaultTextFormat = _format;
			_tf.setTextFormat(_format);
		}
		
		///////////////////////////////////
		// 重写父类函数
		///////////////////////////////////
		override protected function create():void
		{
			_tf = new TextField();
			_tf.selectable = false;
			_tf.mouseEnabled = false;
			_tf.autoSize = TextFieldAutoSize.LEFT;
			_tf.text = _text;
			if (_format != null) setTextFormat(_format);
		}
		
		override protected function layout():void
		{
			addChild(_tf);
		}
		
		override public function get width():Number
		{
			if (_tf != null) return _tf.textWidth;
			else return super.width;
		}
		
	}

}