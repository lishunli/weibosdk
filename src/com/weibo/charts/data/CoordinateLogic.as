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
		
		private var _axisType:Boolean = false;
		
		private var valueLogic:ValueLogic;
		private var valueSubLogic:ValueLogic;
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
			this.valueLogic = new ValueLogic();
			this.valueSubLogic = new ValueLogic();
			this.labelLogic = new LabelLogic(chart);
		}
		
	//===========================================
	// 公开方法
	//-------------------------------------------
		
		public function set integer(value:Boolean):void
		{
			this.valueLogic.integer = value;
			this.valueSubLogic.integer = value;
		}
		
		public function set alwaysShow0(value:Boolean):void
		{
			this.alwaysShowZero = value;
		}
		
		public function get reverseAxis():Boolean { return this._axisType; }
		public function set reverseAxis(value:Boolean):void
		{
			this._axisType = value;
		}
		
		public function set valueLength(value:Number):void
		{
			this.valueLogic.labelLength = value;
		}
		
		public function set labelLength(value:Number):void
		{
			this.labelLogic.labelLength = value;
		}
		
//		public function set valueKey(value:String):void { this._valueKey = value; }
//		public function set labelKey(value:String):void { this._labelKey = value; }
		
		public function get labelData():Array
		{
			return this.labelLogic.axisData;
//			return reverseAxis ? this.valueLogic.axisData : this.labelLogic.axisData;
		}
		
		public function get valueData():Array
		{
			return this.valueLogic.axisData;
//			return reverseAxis ? this.labelLogic.axisData : this.valueLogic.axisData;
		}
		
		public function get valueSubData():Array
		{
			return valueSubLogic.axisData;
		}
		
		public function get labelGridData():Array { return this.labelLogic.gridData; }

		public function set dataProvider(value:Object):void
		{
			//复制一份数据?
			if (!value.axis)
			{
				this._dataProvider = {
					axis:[],
					data:[{name:"",value:[]}]
				};
				for each(var o:Object in value)
				{
					_dataProvider.axis.push(o.label);
					_dataProvider.data[0].value.push(o.value);
				}
			}
			else
			{
				this._dataProvider = value;
			}
			
			
			//处理主轴数据
			this.valueLogic.alwaysShowZero = this.alwaysShowZero;
			this.valueLogic.axisLength = reverseAxis ? _chart.area.width : _chart.area.height;
			parseValueData();
			
			//处理副轴数据
			this.valueSubLogic.alwaysShowZero = this.alwaysShowZero;
			this.valueSubLogic.axisLength = this.valueLogic.axisLength;
			parseSubValueData();
			
			//处理标签轴数据
//			this.labelLogic.labelKey = _labelKey;
			this.labelLogic.axisLength = reverseAxis ? _chart.area.height : _chart.area.width;
			this.labelLogic.dataProvider = dataProvider.axis;
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
		public function getPosition(value:Number, axis:int = 0):Number
		{
			if (!dataProvider)// || !data
			{
				return NaN;
			}
			if (axis == 0)
			{
				return valueLogic.getPosition(value);
			}
			else
			{
				return valueSubLogic.getPosition(value);
			}
		}
		
	//===========================================
	// 私有方法
	//-------------------------------------------
		
		/** 从原始数据中取出最小值和最大值
		 * 并设置到数值轴
		 */		
		private function parseValueData():void
		{
			var tempMininum:Number;
			var tempMaxinum:Number;
			
			for each (var data:Object in dataProvider.data)
			{
				if (data.useSubAxis) continue;
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
				//尚未实现固定长度，这是副轴逻辑
//				this.valueLogic.setSolidData(0, 1, 5);
			}
			else
			{
				this.valueLogic.setData(tempMininum, tempMaxinum);
				//尚未实现固定长度，这是副轴逻辑
//				this.valueLogic.setSolidData(tempMininum, tempMaxinum, 5);
			}
		}
		
		private function parseSubValueData():void
		{
			var tempMininum:Number;
			var tempMaxinum:Number;
			
			for each (var data:Object in dataProvider.data)
			{
				if (!data.useSubAxis) continue;
				for each(var value:Number in data.value)
				{
					if (isNaN(value))
					{
						continue;
					}
					
					tempMininum = isNaN(tempMininum) ? value : Math.min(value, tempMininum);
					tempMaxinum = isNaN(tempMaxinum) ? value : Math.max(value, tempMaxinum);
				}
				
			}
			//
//			trace(tempMininum, tempMaxinum, valueLogic.axisData.length)
			if (isNaN(tempMininum) || isNaN(tempMaxinum))
			{
				this.valueSubLogic.setSolidData(NaN, NaN, valueLogic.axisData.length);
			}
			else
			{
				this.valueSubLogic.setSolidData(tempMininum, tempMaxinum, valueLogic.axisData.length);
			}
		}
	}
}