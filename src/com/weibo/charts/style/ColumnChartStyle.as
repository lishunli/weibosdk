package com.weibo.charts.style
{
	import com.weibo.charts.ui.bars.PureBar;
	import com.weibo.charts.ui.tips.LabelTip;

	public class ColumnChartStyle
	{
		import com.weibo.charts.ui.IBarUI;
		import com.weibo.charts.ui.bars.BasicBar;
		
		/**
		 * 基础样式
		 */		
		public var baseStyle:ChartBaseStyle = new ChartBaseStyle();
		
		public var barUI:Class = BasicBar;
		
		public var tipUI:Class = LabelTip;
		
//		public var tipFun:Function;
		
		public var useDifferentColor:Boolean = false;
		
		public var arrColors:Array = [0x59c9d8, 0x89c82d, 0x80b5d1, 0xefd87f, 0xd59feb];
//		public var outlineColor:Object;
//		public var arrOutlineColors:Array = [0x94cd4c, 0xde5d5d, 0x4999bf, 0xe4bf11, 0xbd80cc];
		
//		public var barAlpha:Number = 0.8;
		
//		public var integer:Boolean = false;
		
		public var alwaysShow0:Boolean = true;
		
		public var valueUnit:String = "";
		
		public function ColumnChartStyle()
		{
			/*tipFun = function tipFun(obj:Object):String
			{
				var str:String = String(obj.value);
				return str;
			}*/
		}
	}
}