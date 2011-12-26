package com.weibo.charts.style 
{
	import com.weibo.charts.comp.axis.IAxisRenderer;
	import com.weibo.charts.comp.axis.IGridRender;

	/**
	 * ...
	 * @author yaofei@staff.sina.com.cn
	 */
	public class AxisStyle 
	{
		/**
		 * 水平 轴类型
		 */		
		public static const HORIZONTAL_AXIS:String = "horizontalAxis";
		
		/**
		 * 垂直轴类型 
		 */		
		public static const VERTICAL_AXIS:String = "verticalAxis";
		
		/**
		 * 轴类型，水平或者垂直 
		 */		
		public var type:String = "horizontalAxis";
		
//		public static const VALUE_AXIS:String = "valueAxis";
//		public static const LABEL_AXIS:String = "labelAxis";
//		public var axisType:String = "valueAxis";
		
		public var color:int = 0x000000;
		
		public var thicknetss:int = 1;
		
		public function AxisStyle(type:String = "horizontalAxis") 
		{
			this.type = type;
//			this.axisType = axisType;
		}
		
	}

}