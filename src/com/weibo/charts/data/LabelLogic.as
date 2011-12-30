package com.weibo.charts.data
{
	import com.weibo.charts.ChartBase;
	import com.weibo.charts.events.ChartEvent;

	/**
	 * 标签轴处理逻辑
	 * @author yaofei
	 */	
	public class LabelLogic
	{
		public var axisLength:Number = 450;
		public var labelLength:Number = 30;
		
		private var _labelKey:String;
		private var _axisData:Array;
		private var _gridData:Array;
		
		private var chart:ChartBase;
		
// ==========================================
// 构造函数
// ------------------------------------------
		
		public function LabelLogic(chart:ChartBase)
		{
			this.chart = chart;
			super();
		}
		
// ==========================================
// 公开方法
// ------------------------------------------
		public function set labelKey(value:String):void { this._labelKey = value; }
		public function get labelKey():String { return this._labelKey; }
		public function get axisData():Array { return this._axisData; }
		public function get gridData():Array { return this._gridData; }

		/**
		 * 计算标签轴数据
		 * @param data
		 */		
		public function set dataProvider(data:Array):void
		{
			var count:int = data.length;
			var unit:Number = axisLength / count;
			_axisData = [];
			_gridData = [];
			
			var quotient:int = 1;//为避免文字重叠设置的标签出现的间隔。默认为1，即：每个标签都显示。
			if (labelLength > unit)
			{
				quotient = Math.ceil(labelLength / unit);
			}
			chart.dispatchEvent(new ChartEvent(ChartEvent.CHART_LABELAXIS_SHOW, labelLength > unit, true));
			
			var i:int;
			var startI:int = (quotient + count % quotient - 1) / 2;
			for (i = 0; i < count; i++)
			{
				//获取Label文字
				var label:String = (data[i] is String) ? data[i] :data[i][labelKey];
				if (chart.labelFun != null) label = chart.labelFun(label);
				
				if ((i - startI) % quotient == 0){
					_axisData.push({
					label:		label,
					position:	(i / count) * axisLength + unit / 2
					});
				}
			}
			
			for (i = 1; i < count; i++)
			{
				_gridData.push({
					position:	(i / count) * axisLength
				});
			}
			
		}
		
	}
}