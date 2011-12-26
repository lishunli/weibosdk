package com.weibo.charts.ui
{
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
		 * 添加到显示列表
		 * @param container
		 * @param xpos
		 * @param ypos
		 * @param area
		 */		
		function show(container:DisplayObjectContainer, xpos:Number, ypos:Number, area:Rectangle):void;

		/**
		 * 隐藏TIP
		 */		
		function hide():void;
	}
}