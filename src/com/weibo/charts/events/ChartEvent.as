package com.weibo.charts.events
{
	import flash.events.Event;
	
	public class ChartEvent extends Event
	{
		/**
		 * 图表数据更新 
		 */		
		public static const CHART_DATA_RESULT:String = "chartDataResult";
		
		/**
		 * 图表数据改变 
		 */		
		public static const CHART_DATA_CHANGED:String = "chartDataChanged";
//		public static const CHART_RESIZE:String = "chartResize";
		//自适应轴文字宽度
		public static const CHART_AXIS_RESIZE:String = "chartAxisResize";
		
		/**
		 * 表示TIP是否带Label
		 * data为Boolean
		 */		
		public static const CHART_LABELAXIS_SHOW:String = "chartLabelAxisShow";
		
		/**
		 * 获取数据
		 */
		public static const GET_CHART_DATA:String = "getChartData";
		
		public var data:Object;
		
		public function ChartEvent(type:String, data:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.data = data;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new ChartEvent(type, data, bubbles, cancelable);
		}
		override public function toString():String
		{
			return formatToString("ChartEvent", "type", "data", "bubbles", "cancelable", "eventPhase");
		}
	}
}