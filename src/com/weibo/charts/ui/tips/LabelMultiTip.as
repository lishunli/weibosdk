package com.weibo.charts.ui.tips
{
	import com.weibo.charts.ui.ChartUIBase;
	import com.weibo.charts.ui.ITipUI;
	
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class LabelMultiTip extends ChartUIBase implements ITipUI
	{
		private var _t:TextField;
		
		public function LabelMultiTip()
		{
			super();
		}
		
		override protected function create():void
		{
			_t = new TextField();
			_t.autoSize = TextFieldAutoSize.LEFT;
			var tf:TextFormat = new TextFormat();
			tf.align = TextFormatAlign.CENTER;
			_t.defaultTextFormat = tf;
//			_t.border = true;
//			_t.multiline = true;
//			_t.wordWrap = true;
			_t.selectable = false;
			addChild(_t);
		}
		override public function get uiWidth():Number { return _t.width; }
		override public function set uiWidth(value:Number):void
		{
			_t.width = value;
			super.uiWidth = value;
		}
		override public function get uiHeight():Number { return _t.height; }
		override public function set uiHeight(value:Number):void
		{
			_t.height = value;
			super.uiHeight = value;
		}
		
		public function setLabel(value:String, tf:TextFormat = null, renderAsHTML:Boolean = false):void
		{
			if(renderAsHTML) _t.htmlText = value;
			else _t.text = value;
			if(tf != null){
				_t.defaultTextFormat = tf;
				_t.setTextFormat(tf);
			}
			_t.x = 0;
			_t.y = 0;
		}
		
		public function get labelWidth():Number
		{
			return _t.textWidth;
		}
		
		public function show(container:DisplayObjectContainer, x:Number, y:Number, area:Rectangle):void
		{
			move(x,y);
			container.addChild(this);
		}
		
		public function hide():void
		{
			
		}
		
	}
}