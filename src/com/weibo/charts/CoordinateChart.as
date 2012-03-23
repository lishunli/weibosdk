package com.weibo.charts
{
	import com.weibo.charts.data.CoordinateLogic;
	import com.weibo.charts.data.ICoordinateLogic;
	import com.weibo.charts.events.ChartEvent;
	import com.weibo.charts.style.CoordinateChartStyle;
	
	import flash.geom.Rectangle;

	/**
	 * 笛卡尔坐标系 基础图表抽象类
	 * @author yaofei
	 */	
	public class CoordinateChart extends ChartBase
	{
		public function CoordinateChart(style:CoordinateChartStyle = null)
		{
			super(style);
			axisLogic = new CoordinateLogic(this);
		}
		
		override public function set dataProvider(value:Object):void
		{
			/*if (!axisLogic)
			{
//				coordinateLogic.integer = _style.integer;
//				coordinateLogic.alwaysShow0 = true;
			}*/
			
			area = new Rectangle(0, 0, chartWidth, chartHeight);
			axisLogic.dataProvider = value;
			super.dataProvider = value;
			dispatchEvent(new ChartEvent(ChartEvent.CHART_DATA_CHANGED));
		}
		
		protected function get coordinateLogic():CoordinateLogic
		{
			return this.axisLogic as CoordinateLogic;
		}
	}
}