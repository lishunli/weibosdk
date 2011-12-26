package com.weibo.charts.ui
{
	import flash.display.DisplayObjectContainer;

	public interface IChartUIBase
	{
		function get x():Number;
		function set x(value:Number):void;
		
		function addMe(parent:DisplayObjectContainer):void;
		function removeMe():void;
		
		function get y():Number;
		function set y(value:Number):void;
		
		function get uiWidth():Number;
		function set uiWidth(value:Number):void;
		
		function get uiHeight():Number;
		function set uiHeight(value:Number):void;
		
		function get uiColor():Number;
		function set uiColor(value:Number):void;
		
		function get outlineColor():Number;
		function set outlineColor(value:Number):void;
		
		function get outlineThicknesss():Number;
		function set outlineThicknesss(value:Number):void;
	}
}