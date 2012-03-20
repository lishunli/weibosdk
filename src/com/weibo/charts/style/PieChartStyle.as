package com.weibo.charts.style
{
	import com.weibo.charts.ui.sectors.BorderSector;
	import com.weibo.charts.ui.tips.LabelTip;

	public class PieChartStyle
	{
		import com.weibo.charts.ui.IBarUI;
		import com.weibo.charts.ui.bars.BasicBar;
		
		/**
		 * 基础样式
		 */		
		public var baseStyle:ChartBaseStyle = new ChartBaseStyle();
		
		public var sectorUI:Class = BorderSector;
		
		public var tipUI:Class = LabelTip;
		
		public var errorColor:uint = 0xcccccc;
		
		public var arrColors:Array = [0xc6e17f, 0xf37f7f, 0x80b5d1, 0xefd87f, 0xd59feb];
		
		public var arrOutlineColors:Array = [0x94cd4c, 0xde5d5d, 0x4999bf, 0xe4bf11, 0xbd80cc];
		
		public var borderColors:Array = [0xffffff];
		public var borderThicknesss:Number = 1;
		public var showBorder:Boolean = false;
		public var radiusIn:Number = 59;
		
		public var tipColor:uint = 0x999999;
		public var lineColor:uint = 0x333333;
		public var lineAlpha:Number = 0.3;
		
		public var gap:Number = 0;
	}
}