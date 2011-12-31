package com.weibo.charts.data
{
	import com.weibo.charts.ChartBase;

	/**
	 * 笛卡尔坐标处理核心类
	 * 处理与坐标第有关的各个类之间、与系统的关系
	 * @author yaofei
	 */	
	public class CoordinateLogic implements ICoordinateLogic
	{
		private var _dataProvider:Object;
		private var _chart:ChartBase;
		
		private var _axisType:String = "horizontal";
		
		private var valueLogic:ValueLogic;
		private var labelLogic:LabelLogic;
		
		private var alwaysShowZero:Boolean;
		
	//===========================================
	// 构造函数
	//-------------------------------------------
		
//		private var _labelKey:String = "label";
//		private var _valueKey:String = "value";
		
		public function CoordinateLogic(chart:ChartBase)
		{
			this._chart = chart;
			this.valueLogic = new ValueLogic(chart);
			this.labelLogic = new LabelLogic(chart);
		}
		
	//===========================================
	// 公开方法
	//-------------------------------------------
		
		public function set integer(value:Boolean):void { this.valueLogic.integer = value; }
		public function set alwaysShow0(value:Boolean):void { this.alwaysShowZero = value; }
		public function set axisType(value:String):void { this._axisType = value; }
		public function get axisType():String { return this._axisType; }
		public function set valueLength(value:Number):void { this.valueLogic.labelLength = value; }
		public function set labelLength(value:Number):void { this.labelLogic.labelLength = value; }
//		public function set valueKey(value:String):void { this._valueKey = value; }
//		public function set labelKey(value:String):void { this._labelKey = value; }
		
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
			this._dataProvider = value;
			
			this.valueLogic.alwaysShowZero = this.alwaysShowZero;
			this.valueLogic.axisLength = (axisType == "vertical") ? _chart.area.width : _chart.area.height;
//			this.valueLogic.dataProvider = dataProvider;
			parseValueData();
			
//			this.labelLogic.labelKey = _labelKey;
			this.labelLogic.axisLength = (axisType == "vertical") ? _chart.area.height : _chart.area.width;
			this.labelLogic.dataProvider = value.axis;
		}
		
		public function get dataProvider():Object
		{
			return this._dataProvider;
		}
		
		/**
		 * 根据数值获取坐标值
		 * @param data
		 * @return 
		 */		
		public function getPosition(value:Number):Number
		{
			if (!dataProvider)// || !data
			{
				return NaN;
			}
			return valueLogic.getPosition(value);
		}
		
	//===========================================
	// 私有方法
	//-------------------------------------------
		
		/** 从原始数据中取出最小值和最大值
		 * 并设置到数值轴
		 */		
		private function parseValueData():void
		{
			var count:int = this.dataProvider.length;
			var tempMininum:Number;
			var tempMaxinum:Number;
			
			for each (var data:Object in dataProvider.data)
			{
				for each(var value:Number in data.value)
				{
//					value = dataProvider[i].value;
					if (isNaN(value))
					{
						continue;
					}
					
					tempMininum = isNaN(tempMininum) ? value : Math.min(value, tempMininum);
					tempMaxinum = isNaN(tempMaxinum) ? value : Math.max(value, tempMaxinum);
				}
			}
			
			if (isNaN(tempMininum) || isNaN(tempMaxinum))
			{
				this.valueLogic.setData(0, 1);
//				this.dataMininum = 0;
//				this.dataMaxinum = 1;
			}
			else
			{
				this.valueLogic.setData(tempMininum, tempMaxinum);
//				this.dataMininum = tempMininum;
//				this.dataMaxinum = tempMaxinum;
			}
		}
	}
}