package com.weibo.comp.weiboPublisher.ui 
{
	import com.weibo.comp.weiboPublisher.events.PublisherEvent;
	import com.weibo.comp.weiboPublisher.style.TextViewStyle;
	import com.weibo.core.UIComponent;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Du hailiang | hailiang@staff.sina.com.cn
	 */
	public class TextView extends UIComponent 
	{
		private var _tf:TextField;
		private var _text:String;
		private var _letterLen:int;
		private var _style:TextViewStyle;
		private var _tempForamt:TextFormat;
		private var _changeFormat:Boolean = true;
		
		public function TextView(style:TextViewStyle = null)
		{
			if (!style)
			{
				_style = new TextViewStyle();
			}else
			{
				_style = style;
			}
			super();
		}
		
		override protected function create():void
		{
			_tf = new TextField();
			_tf.type = TextFieldType.INPUT;
			_tf.multiline = true;
			_tf.wordWrap = true;
			_tf.defaultTextFormat = _style.textFormat;
			
			_tempForamt = _tf.getTextFormat();
			_tempForamt.color = 0x999999;
			_tf.defaultTextFormat = _tempForamt;
			
			if (_style.hasBorder)
			{
				_tf.border = true;
				_tf.borderColor = _style.borderColor;
			}
			
			addChild(_tf);
		}
		
		override protected function addEvents():void
		{
			if (_tf != null)
			{
				_tf.addEventListener(Event.CHANGE, onTextChanged);
				_tf.addEventListener(Event.ADDED_TO_STAGE, onTFAddedToStage);
				_tf.addEventListener(MouseEvent.CLICK, onMouseClicked);
				_tf.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			}
		}
		
		private function onFocusOut(e:FocusEvent):void 
		{
			if (_tf.text == "")
			{
				_tf.setTextFormat(_tempForamt);
				_tf.defaultTextFormat = _tempForamt;
				_changeFormat = true;
				_tf.text = _style.defaultText;
			}
		}
		
		override protected function removeEvents():void
		{
			if (_tf != null)
			{
				_tf.removeEventListener(Event.CHANGE, onTextChanged);
				_tf.removeEventListener(Event.ADDED_TO_STAGE, onTFAddedToStage);
				_tf.removeEventListener(MouseEvent.CLICK, onMouseClicked);
				_tf.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			}
		}
		
		override protected function destroy():void
		{
			if (_tf != null)
			{
				removeChild(_tf);
				_text = null;
				_style = null;
				_letterLen = 0;
				_tf = null;
			}
		}		
		
		override protected function layout():void
		{
			_tf.width = _style.width;
			_tf.height = _style.height;
			
		}
		
		override protected function updateState():void
		{
			_tf.text = _style.defaultText;
		}
		
		private function onTFAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onTFAddedToStage);
			stage.focus = _tf;
			_tf.setSelection(0,_tf.text.length);
		}
		
		private function onTextChanged(e:Event):void 
		{
			_text = _tf.text;
			if (_changeFormat)
			{
				_tf.setTextFormat(_style.textFormat);
				_tf.defaultTextFormat = _style.textFormat;
				_changeFormat = false;
				trace("_changeFormat_changeFormat");
			}
			_letterLen = getStrLen(_text);
			var evt:PublisherEvent = new PublisherEvent(PublisherEvent.TEXT_UPDATE);
			evt.result = _letterLen;
			trace("caretIndex ::" + _tf.caretIndex);
			dispatchEvent(evt);
		}
		
		private function onMouseClicked(e:MouseEvent):void 
		{
			if (_tf.text == _style.defaultText)
			{
				text = "";
				//_tf.setTextFormat(_style.textFormat);
				//_changeFormat = false;
			}
		}
		
		public function get text():String 
		{
			return _text;
		}
		
		public function set text(value:String):void
		{
			_text = _tf.text = value;
			_letterLen = getStrLen(value);
			var evt:PublisherEvent = new PublisherEvent(PublisherEvent.TEXT_UPDATE);
			evt.result = _letterLen;
			dispatchEvent(evt);
		}
		
		public function get letterLen():int 
		{
			return _letterLen;
		}
		
		public function get tf():TextField 
		{
			return _tf;
		}
		
		private function getStrLen(str:String):int
		{
			var i:int, sum:int;
			sum=0;
			for (i=0; i < str.length; i++)
			{
				if ((str.charCodeAt(i) >= 0) && (str.charCodeAt(i) <= 255))
				{
					sum=sum + 1;
				}
				else
				{
					sum=sum + 2;
				}
			}
			return int(sum * .5 + .5);
		}
		
		public function addText(value:String):void
		{
			var str:String = _tf.text;
			var index:int = _tf.caretIndex;
			var str2:String = str.substring(0, index);
			var str3:String = str.substring(index);
			text = str2 + value + str3;
			if (value == "##")
			{
				tf.setSelection(index + 1, index + 1);
			}else {
				var len:int = index + value.length;
				tf.setSelection(len, len);
			}
			
			stage.focus = tf;
		}
		
	}

}