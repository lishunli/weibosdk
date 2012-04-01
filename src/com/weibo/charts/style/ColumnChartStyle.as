package com.weibo.charts.style
{
	import com.weibo.charts.ui.bars.PureBar;
	import com.weibo.charts.ui.tips.LabelTip;

	public class ColumnChartStyle extends CoordinateChartStyle
	{
		import com.weibo.charts.ui.IBarUI;
		import com.weibo.charts.ui.bars.BasicBar;
		
		
	//===================================
	// 主图形样式（柱形）
	//-----------------------------------
		
		public var barUI:Class = BasicBar;
		
		public var useDifferentColor:Boolean = false;
		
//		public var barAlpha:Number = 0.8;
		
		public var maxBarWidth:Number = 30;
		
		
		public function ColumnChartStyle()
		{
			barUI = PureBar;
			colors = [0x59c9d8, 0x89c82d, 0x80b5d1, 0xefd87f, 0xd59feb];
			gridStyle.addMore = true;
		}
	}
}