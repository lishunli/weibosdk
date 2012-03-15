package com.weibo.charts.data
{
	import com.weibo.charts.ChartBase;
	
	import org.casalib.util.DateUtil;
	
	/**
	 * 
	 * yaofei
	 */
	public class DateLogic extends LabelLogic
	{
		private var 
		
		public function DateLogic(chart:ChartBase)
		{
			super(chart);
		}
		
		override public function set dataProvider(data:Array):void
		{
			var i:int;
			var count:int = data.length;
			
			var dateList:Array = [];
			for (i = 0; i < count; i++)
			{
				var date:Date = new Date();
			}
			
			
			var unit:Number = coordinate.touchSide ? axisLength/(count-1) : axisLength/count;
			_axisData = [];
			_gridData = [];
			
			//为避免文字重叠，设置的标签出现的间隔。默认为1，即：每个标签都显示。
			var quotient:int = 1;
			coordinate.autoLabel = labelLength > unit;
//			chart.dispatchEvent(new ChartEvent(ChartEvent.CHART_LABELAXIS_SHOW, labelLength > unit, true));
			//如果标签过长，而按需要分配
			if (coordinate.autoLabel)
				quotient = Math.ceil(labelLength / unit);
			
			
			var startI:int = (quotient + count % quotient - 1) / 2;
			var position:Number;
			for (i = 0; i < count; i++)
			{
				//获取Label文字
//				var label:String = (data[i] is String) ? data[i] :data[i][labelKey];
//				if (chart.labelFun != null) label = chart.labelFun(label);
				
				if ((i - startI) % quotient == 0)
				{
					position = coordinate.touchSide ? i/(count-1)*axisLength : i/count*axisLength;
					if (!coordinate.touchSide) position += unit / 2;
					_axisData.push({
					label:		data[i],
					position:	position
					});
				}
			}
			
			for (i = 1; i < count; i++)
			{
				_gridData.push({
					position:	coordinate.touchSide ? i/(count-1)*axisLength : i/count*axisLength
				});
			}
			
		}
	}
}