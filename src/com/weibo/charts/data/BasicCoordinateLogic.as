package com.weibo.charts.data
{
	import com.weibo.charts.ChartBase;

	public class BasicCoordinateLogic implements ICoordinateLogic
	{
		private var _dataProvider:Array;
		private var _chart:ChartBase;
		
		private var _axisType:String = "horizontal";
		
		private var valueLogic:ValueLogic;
		private var labelLogic:LabelLogic;
		
		private var alwaysShowZero:Boolean;
		
// ------------------------------------------
// 构造函数
// ------------------------------------------
		private var _labelKey:String = "label";
		private var _valueKey:String = "value";
		
		public function BasicCoordinateLogic(chart:ChartBase)
		{
			this._chart = chart;
			this.valueLogic = new ValueLogic(chart);
			this.labelLogic = new LabelLogic(chart);
		}
		
// ------------------------------------------
// 公开方法
// ------------------------------------------
		public function set integer(value:Boolean):void { this.valueLogic.integer = value; }
		public function set alwaysShow0(value:Boolean):void { this.alwaysShowZero = value; }
		public function set axisType(value:String):void { this._axisType = value; }
		public function get axisType():String { return this._axisType; }
		public function set valueLength(value:Number):void { this.valueLogic.labelLength = value; }
		public function set labelLength(value:Number):void { this.labelLogic.labelLength = value; }
		public function set valueKey(value:String):void { this._valueKey = value; }
		public function set labelKey(value:String):void { this._labelKey = value; }
		
		public function get horizontalData():Array
		{
			return (axisType == "vertical") ? this.valueLogic.axisData : this.labelLogic.axisData;
		}
		
		public function get verticalData():Array
		{
			return (axisType == "vertical") ? this.labelLogic.axisData : this.valueLogic.axisData;
		}
		
		public function get labelGridData():Array { return this.labelLogic.gridData; }

		public function set dataProvider(value:Object):void
		{
			this._dataProvider = value as Array;
			
			this.valueLogic.alwaysShowZero = this.alwaysShowZero;
			this.valueLogic.axisLength = (axisType == "vertical") ? _chart.area.width : _chart.area.height;
			this.valueLogic.dataProvider = dataProvider;
			
			this.labelLogic.labelKey = _labelKey;
			this.labelLogic.axisLength = (axisType == "vertical") ? _chart.area.height : _chart.area.width;
			this.labelLogic.dataProvider = dataProvider;
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
		public function getPosition(data:Object):Number
		{
			if (!dataProvider || !data)
			{
				return NaN;
			}
			var value:Number = valueLogic.getPosition(data[_valueKey]);
			return value;
		}
		
// ------------------------------------------
// 私有方法
// ------------------------------------------
		
	}
}