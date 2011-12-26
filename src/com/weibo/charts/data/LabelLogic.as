package com.weibo.charts.data
{
	import com.weibo.charts.ChartBase;
	import com.weibo.charts.events.ChartEvent;

	public class LabelLogic
	{
		public var axisLength:Number = 450;
		public var labelLength:Number = 30;
		
		private var _dataProvider:Array;
		
		private var _labelKey:String;
		private var _axisData:Array;
		private var _gridData:Array;
		
		private var chart:ChartBase;
		
// ------------------------------------------
// 构造函数
// ------------------------------------------
		
		public function LabelLogic(chart:ChartBase)
		{
			this.chart = chart;
			super();
		}
		
// ------------------------------------------
// 公开方法
// ------------------------------------------
		public function set labelKey(value:String):void { this._labelKey = value; }
		public function get labelKey():String { return this._labelKey; }
		public function get axisData():Array { return this._axisData; }
		public function get gridData():Array { return this._gridData; }

		public function set dataProvider(value:Object):void
		{
			this._dataProvider = value as Array;
			this.parseDataProvider();
		}
		public function get dataProvider():Object
		{
			return this._dataProvider;
		}
		
		/**
		 * @param data
		 * @return 
		 * 根据数值获取坐标值
		 */		
		/*public function getPosition(data:Object):Number
		{
			return NaN;
		}*/
		
// ------------------------------------------
// 私有方法
// ------------------------------------------
		
		/** 分析数据
		 */		
		private function parseDataProvider():void
		{
			var count:int = this.dataProvider.length;
			var unit:Number = axisLength / count;
			_axisData = [];
			_gridData = [];
			
			var quotient:int = 1;//间隔数量
			if (labelLength > unit)
			{
				quotient = Math.ceil(labelLength / unit);
			}
			chart.dispatchEvent(new ChartEvent(ChartEvent.CHART_LABELAXIS_SHOW, labelLength > unit, true));
			
			var i:int;
			var startI:int = (quotient + count % quotient - 1) / 2;
			for (i = 0; i < count; i++)
			{
				var label:String = dataProvider[i][labelKey];
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
			
			//labelLength
		}
		
		/** 计算轴数据
		 */		
		private function calculateAxisData():Array
		{
			
			return null;
		}
	}
}