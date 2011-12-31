package com.weibo.charts.ui.bars
{
	import com.weibo.core.UIComponent;
	
	import flash.events.Event;

	/**
	 * 
	 * @author yaofei
	 */	
	public class PureBar extends UIComponent
	{
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
		
		override protected function layout():void
		{
			var alpha:Number = getStyle("alpha") as Number;
			var color:uint = getStyle("color") as uint;
			
			graphics.clear();
			graphics.beginFill(color);
			graphics.drawRect(0, 0, width, -height);
		}
	}
}