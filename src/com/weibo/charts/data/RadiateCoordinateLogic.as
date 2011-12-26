package com.weibo.charts.data
{
	import com.weibo.charts.ChartBase;

	public class RadiateCoordinateLogic implements IRadiateLogic
	{
		private var _dataProvider:Array;
		private var _chart:ChartBase;
		
// ------------------------------------------
// 构造函数
// ------------------------------------------
		private var _labelKey:String = "label";
		private var _valueKey:String = "value";
		
		public function RadiateCoordinateLogic(chart:ChartBase)
		{
			this._chart = chart;
		}
		
// ------------------------------------------
// 公开方法
// ------------------------------------------
		public function set valueLength(value:Number):void {  }
		public function set labelLength(value:Number):void {  }
		public function set valueKey(value:String):void { this._valueKey = value; }
		public function set labelKey(value:String):void { this._labelKey = value; }
		public function get valueData():Array { return null; }
		public function get labelData():Array { return null; }
		public function get labelGridData():Array { return null; }

		public function set dataProvider(value:Object):void
		{
			this._dataProvider = value as Array;
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
			return NaN;
		}
		
// ------------------------------------------
// 私有方法
// ------------------------------------------
		
	}
}