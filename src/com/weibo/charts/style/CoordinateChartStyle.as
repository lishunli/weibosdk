package com.weibo.charts.style
{
	import com.weibo.charts.ui.dots.BasicDot;
	import com.weibo.charts.ui.tips.DialogShapeTip;
	
	import flash.text.TextFormat;

	/**
	 * 笛卡尔坐标系图表的样式
	 * yaofei
	 */
	public class CoordinateChartStyle extends ChartBaseStyle
	{
//		public var showBorder:Boolean = false;
//		public var borderThickness:int = 1;
//		public var borderColor:int = 0x000000;
		
	//===============================
	// 子对象样式
	//-------------------------------
		
		/**
		 * 轴样式
		 */		
		public var axisStyle:AxisStyle = new AxisStyle();
		
		/**
		 * 网格样式
		 */		
		public var gridStyle:GridStyle = new GridStyle();
		
	//===============================
	// 图表基础形态
	//-------------------------------
		
		/**
		 * 是否顶边 
		 */		
		public var touchSide:Boolean = true;
		
		/**
		 * 是否按整数方式将轴分段 
		 */		
		public var integer:Boolean = false;
		
		
		public var alwaysShow0:Boolean = true;
		
		
	//===================================
	// 主图形样式，如曲线、柱形等
	//-----------------------------------
		
		/**
		 * 主图形的颜色
		 */		
		public var colors:Array = [0x519ae5];
		
//		public var lineColor:uint = 0x333333;
		
//		public var lineThickness:int = 2;
		
		
	//===================================
	// Tip样式
	//-----------------------------------
		
		public var tipUI:Class;
		
		
		/**
		 * 0:不显示,1:一直显示，2:点触发,3:函数调用触发
		 */		
		public var tipType:int = 0;
		
		public var tipFun:Function;
		
		public var tipFormat:TextFormat = new TextFormat("Arial", 12, 0x999999, false);
		public var tipColor:uint = 0x333333;
		public var tipUseBarColor:Boolean;
		public var tipAlpha:Number = .6;
		
	//===================================
	// 其它
	//-----------------------------------
		
		/**
		 * 数值的单位，默认加在最后一个标签后面
		 */
		public var valueUnit:String = "";
		
		
	}
}