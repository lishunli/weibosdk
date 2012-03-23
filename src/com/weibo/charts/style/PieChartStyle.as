package com.weibo.charts.style
{
	import com.weibo.charts.ui.sectors.BorderSector;
	import com.weibo.charts.ui.tips.LabelMultiTip;

	public class PieChartStyle extends ChartBaseStyle
	{
		import com.weibo.charts.ui.IBarUI;
		import com.weibo.charts.ui.bars.BasicBar;
		
		
	//===================================
	// 主图形样式
	//-----------------------------------
		
		/**
		 * 扇形的UI类
		 */		
		public var sectorUI:Class = BorderSector;
		
		/**
		 * 在无数据或数据错误时饼图的颜色
		 */		
		public var errorColor:uint = 0xcccccc;
		
//		public var colors:Array;// = [0xc6e17f, 0xf37f7f, 0x80b5d1, 0xefd87f, 0xd59feb];
//		public var outlineColors:Array;// = [0x94cd4c, 0xde5d5d, 0x4999bf, 0xe4bf11, 0xbd80cc];
		
		
		
//		public var showBorder:Boolean = false;
//		public var borderColors:Array;// = [0xffffff];
		
//		public var borderThicknesss:Number = 1;
		
		/**
		 * 饼空心圆半径（像素），不能大于饼图半径
		 */		
		public var radiusIn:Number = 59;
		
		public var leavePercent:Number = .2;
		public var leaveDistance:Number = 10;
		
		/**
		 * 饼图扇形之间的间隔（像素）
		 */		
		public var gap:Number = 0;
		
		
	//===================================
	// TIP样式
	//-----------------------------------
		
		public var tipUI:Class = LabelMultiTip;
		public var tipColor:uint = 0x999999;
		public var tipFun:Function;
		
		public var tipLineColor:uint = 0x333333;
		public var tipLineAlpha:Number = 0.3;
		
		public function PieChartStyle()
		{
//			colors = null;
		}
	}
}