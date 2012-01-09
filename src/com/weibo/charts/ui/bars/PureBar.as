package com.weibo.charts.ui.bars
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.weibo.controls.Label;
	import com.weibo.core.UIComponent;
	
	import flash.events.Event;

	/**
	 * 
	 * @author yaofei
	 */	
	public class PureBar extends UIComponent
	{
		private var label:Label;
		
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
		
		override protected function create():void
		{
			
		}
		
		override protected function layout():void
		{
//			TweenMax.to(this, 1, {height: _height, ease:Cubic.easeOut});
			var alpha:Number = getStyle("alpha") as Number;
			var color:uint = getStyle("color") as uint;
			
			graphics.clear();
			graphics.beginFill(color);
			graphics.drawRect(0, 0, width, -height);
		}
		
		override protected function updateState():void
		{
			
		}
	}
}