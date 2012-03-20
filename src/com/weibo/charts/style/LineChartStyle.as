package com.weibo.charts.style
{
	import com.weibo.charts.ui.dots.BasicDot;
	import com.weibo.charts.ui.tips.DialogShapTip;

	public class LineChartStyle
	{		
		/**
		 * 基础样式
		 */		
		public var baseStyle:ChartBaseStyle = new ChartBaseStyle();
		
		public var tipUI:Class = DialogShapTip;
		
		public var dotUI:Class = BasicDot;	
		
		public var lineColors:Array = [0x519ae5];
		
		public var lineColor:uint = 0x333333;
		
		public var lineThickness:int = 2;
		
		
		
//		public var touchSide:
		
	}
}