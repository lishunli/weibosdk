package com.weibo.charts.style
{
	import flash.text.TextFormat;

	/**
	 * 
	 * yaofei
	 */
	public class AxisStyle
	{
		
		public var labelFun:Function;
		public var valueFun:Function;
		
		public var labelFormat:TextFormat = new TextFormat("Arial", 12, 0x999999, false);
		public var valueFormat:TextFormat = new TextFormat("Arial", 12, 0x999999, false);
		
		public var valueLineColor:uint = 0xe7e7e7;
		public var valueLineThickness:Number = 1;
		
		public var autoHide:Boolean = false;
		
		public function AxisStyle()
		{
			
		}
	}
}