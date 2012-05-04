package com.weibo.charts.style
{
	import com.weibo.charts.ui.dots.BasicDot;
	import com.weibo.charts.ui.tips.DialogShapeTip;

	public class LineChartStyle extends CoordinateChartStyle
	{
		
	//===================================
	// 主图形样式（曲线、阴影、点等）
	//-----------------------------------
		
//		public var lineColor:uint = 0x333333;
		public var lineThickness:int = 2;
		
		public var shadowAlpha:Number = 0.3;
		public var shadowColors:Array = [0x519ae5];
		
//		public var shadowGridAlpha:Number = 1;
//		public var shadowGridColors:Array = [0x519ae5];
		
		public var dotUI:Class;
		
		
	//===============================
	// 
	//-------------------------------
		
		
		
		public function LineChartStyle()
		{
			tipUI = DialogShapeTip;
			dotUI = BasicDot;
			
			colors = [0x519ae5];
		}
	}
}