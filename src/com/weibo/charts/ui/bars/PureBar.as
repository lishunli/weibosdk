package com.weibo.charts.ui.bars
{
	import com.weibo.charts.comp.Label;
	import com.weibo.charts.ui.IBarUI;
	import com.weibo.core.UIComponent;
	
	import flash.display.Shape;

	/**
	 * 
	 * @author yaofei
	 */	
	public class PureBar extends UIComponent implements IBarUI
	{
		private var _labelTip:Label;
		private var _highLight:Shape;
		
		public function PureBar()
		{
			super();
			_style =
			{
				color:	0xffcc00,
				alpha:	1,
				border: true
			}
			_width = 20;
			_height = 50;
		}
		
		public function set label(value:String):void
		{
			var labelFun:Function = getStyle("labelFun") as Function;
			var txt:String = getStyle("label") as String;
			if (labelFun != null)
			{
				value = labelFun(value);
			}
			else if (txt)
			{
				value = txt.replace(/{value}/g, value);
			}
			_labelTip.text = value;
			invalidate();
		}
		
		override protected function create():void
		{
			if (_labelTip == null)
			{
				_labelTip = new Label();
				addChild(_labelTip);
			}
			if (_highLight == null)
			{
				_highLight = new Shape();addChild(_highLight);
			}
		}
		
		override protected function updateState():void
		{
//			TweenMax.to(this, 1, {height: _height, ease:Cubic.easeOut});
			var alpha:Number = getStyle("alpha") as Number;
			var color:uint = getStyle("color") as uint;
			var labelColor:uint = getStyle("labelColor") as uint;
			
			_labelTip.color = labelColor;
			
			graphics.clear();
			graphics.lineStyle(1, color, 1);
			graphics.beginFill(color, alpha);
			graphics.drawRect(0, 0, width, -height);
			
			_highLight.graphics.clear();
			if (height > 2 && width > 2)
			{
				_highLight.graphics.beginFill(0xffffff, .7);
				_highLight.graphics.drawRect(1, -height+1, width-1, 1);
			}
			_labelTip.y = -height - _labelTip.height;
			_labelTip.x = (width - _labelTip.width) / 2;
		}
		
	}
}