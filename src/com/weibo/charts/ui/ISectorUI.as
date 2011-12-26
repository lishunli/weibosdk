package com.weibo.charts.ui
{
	public interface ISectorUI extends IChartUIBase
	{
		function get index():int;
		function set index(value:int):void;
		function get radius():Number;
		function set radius(value:Number):void;
		function get radiusIn():Number;
		function set radiusIn(value:Number):void;
		function get startAngle():Number;
		function set startAngle(value:Number):void;
		function get endAngle():Number;
		function set endAngle(value:Number):void;
	}
}