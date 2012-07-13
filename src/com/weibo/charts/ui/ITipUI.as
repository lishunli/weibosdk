package com.weibo.charts.ui
{
	import com.weibo.charts.CoordinateChart;
	
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;

	public interface ITipUI extends IChartUIBase
	{
		/**
		 * 更新文本
		 * @param value
		 * @param tf
		 * @param renderAsHTML
		 */		
		function setLabel(value:String, tf:TextFormat = null, renderAsHTML:Boolean = false):void;
		
		/**
		 * 更新多条数据显示
		 * @param data
		 * @param index
		 * @param tf
		 */		
		function setContent(chart:CoordinateChart, index:int, tf:TextFormat = null):void;
		
		/**
		 * 添加到显示列表
		 * @param container
		 * @param xpos
		 * @param ypos
		 * @param area
		 */		
		function show(container:DisplayObjectContainer, xpos:Number, ypos:Number, area:Rectangle, skipEffect:Boolean = false):void;

		/**
		 * 隐藏TIP
		 */		
		function hide(skipEffect:Boolean = false):void;
	}
}