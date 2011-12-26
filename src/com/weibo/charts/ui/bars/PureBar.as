package com.weibo.charts.ui.bars
{
	import com.weibo.charts.ui.ChartUIBase;
	import com.weibo.charts.ui.IBarUI;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * 
	 * YaoFei
	 */
	public class PureBar extends ChartUIBase implements IBarUI
	{
		
		public function PureBar()
		{
			sprite.addEventListener(Event.RENDER, renderHandler);
			renderHandler();
		}
	}
}