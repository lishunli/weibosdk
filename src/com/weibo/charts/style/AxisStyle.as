package com.weibo.charts.style
{
	import flash.text.TextFormat;

	/**
	 * 
	 * yaofei
	 */
	public class AxisStyle
	{
		//===== 标签轴部分 =====
		public var labelFun:Function;
		public var labelFormat:TextFormat = new TextFormat("Arial", 12, 0x999999, false);
		public var autoHide:Boolean = false;
		
		
		//===== 数值轴部分 =====
		public var valueFun:Function;
		public var valueFormat:TextFormat = new TextFormat("Arial", 12, 0x999999, false);
		
		
		public var valueLineColor:uint = 0xe7e7e7;
		public var valueLineThickness:Number = 1;
		
		
		public var marginLeft:Number = 3;
		public var marginRight:Number = 3;
		public var marginBottom:Number = 3;
	}
}