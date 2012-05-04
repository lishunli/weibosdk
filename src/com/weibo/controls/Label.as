package com.weibo.controls 
{
	import com.weibo.core.UIComponent;
	import com.weibo.core.ValidateType;
	
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
			invalidate(ValidateType.SIZE);
		}
		public function set text(value:String):void
		{
//			_tf.text = value;
			this._text = value;
			invalidate(ValidateType.SIZE);
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
//			_tf.border = true;
			_tf.text = _text;
			addChild(_tf);
			if (_format != null) setTextFormat(_format);
		}
		
		override protected function layout():void
		{
			this._tf.text = _text;//被推迟
		}
		
		override public function get width():Number
		{
			if (_tf != null) return _tf.textWidth;
			else return super.width;
		}
		override public function get height():Number
		{
			if (_tf != null) return _tf.height;
			else return super.height;
		}
		
	}

}