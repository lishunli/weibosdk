package com.weibo.charts.data
{
	import com.weibo.charts.ChartBase;
	
	/**
	 * 笛卡尔坐标系数值轴算法
	 * 取出最大值最小值
	 * 返回数值坐标的数据
	 * @author yaofei
	 */
	public class ValueLogic
	{
		public var axisLength:Number = 320;
		public var labelLength:Number = 20;
		
		private var _dataProvider:Array;
		
		//数据层的最大最小值
		private var dataMininum:Number;
		private var dataMaxinum:Number;
		//坐标轴的最大最小值
		private var minimum:Number;
		private var maximum:Number;
		//单元格的单位数值
		private var majorUnit:Number;
		//是否总显示0
		public var alwaysShowZero:Boolean;
		//是否在坐标轴上总显示整数
		public var integer:Boolean = false;
		
		//数据中表示Label的Key值文字，用于匹配数据
		private var _labelKey:String;
		//数值坐标的数据，用于绘制图形
		private var _axisData:Array;
		
		//引用核心图表对象
		private var chart:ChartBase;
		
// ------------------------------------------
// 构造函数
// ------------------------------------------
		
		public function ValueLogic(chart:ChartBase)
		{
			this.chart = chart;
			super();
		}
		
// ------------------------------------------
// 公开方法
// ------------------------------------------
		
		/**
		 * 数据中表示Label的Key值文字，用于匹配数据
		 * @param value
		 */		
		public function set labelKey(value:String):void { this._labelKey = value; }
		
		/**
		 * 数据中表示Label的Key值文字，用于匹配数据
		 * @return 
		 */		
		public function get labelKey():String { return this._labelKey; }
		
		/**
		 * 数值坐标的数据，用于绘制图形
		 * @return 
		 */		
		public function get axisData():Array { return this._axisData; }
		
		/**
		 * 传入原始数据
		 * @param value
		 */		
		public function setData(min:Number, max:Number):void
		{
//			this._dataProvider = value as Array;
//			this.parseDataProvider();
			
			this.minimum = this.dataMininum = min;
			this.maximum = this.dataMaxinum = max;
			this.checkMinAndMax();
			
			this.calculateUnit();
			this.adjustMinAndMax();
			this._axisData = this.calculateAxisData();
		}
		/*public function get dataProvider():Object
		{
			return this._dataProvider;
		}*/
		
		/**
		 * @param data
		 * @return 
		 * 根据数值获取坐标值
		 */		
		public function getPosition(data:Object,a:String=null):Number
		{
//			if (!data) return NaN;
			
			var range:Number = this.maximum - this.minimum;
			if(range == 0)
			{
				return 0;
			}
			
			var position:Number;
			if (coordinateLogic.axisType == "vertical")
			{
				position = (Number(data) - this.minimum) / range * this.axisLength;
			}
			else
			{
				position = (this.maximum - Number(data)) / range * this.axisLength;
			}
			
			return position;
		}
		
// ------------------------------------------
// 私有方法
// ------------------------------------------
		
		private function get coordinateLogic():ICoordinateLogic
		{
			return this.chart.axisLogic as ICoordinateLogic;
		}
		
		private function calculateUnit():void
		{
			var range:Number = this.maximum - this.minimum;
			var maxNumLabels:Number = axisLength / (labelLength * 1.6);//暂定
			var tempMajorUnit:Number = range / maxNumLabels;
			
			var order:Number = Math.ceil(Math.log(tempMajorUnit) * Math.LOG10E);
			var roundedMajorUnit:Number = Math.pow(10, order);
			
			var diff:Number = Math.ceil(tempMajorUnit / Math.pow(10,order-1));
			if (!this.integer || order > 0)
			{
				tempMajorUnit = diff * Math.pow(10,order-1);
			}
			else
			{
				tempMajorUnit = roundedMajorUnit;
			}
			
			
			this.majorUnit = roundToPrecision(tempMajorUnit, 10);
		}
		
		private function checkMinAndMax():void
		{
			if (this.minimum > this.maximum)
			{
				var tempnum:Number = this.minimum;
				this.minimum = this.maximum;
				this.maximum = this.minimum;
			}
			else if (this.minimum == this.maximum)
			{
				this.maximum = this.maximum + 1;
			}
			
			if (this.alwaysShowZero)
			{
				this.minimum = 0;
			}
		}
		
		private function adjustMinAndMax():void
		{
			if (this.minimum != 0)
			{
				var oldMinimun:Number = this.dataMininum;
				this.minimum = Math.floor(this.dataMininum / this.majorUnit) * majorUnit;
				if (oldMinimun == this.minimum)
				{
					this.minimum -= majorUnit;
				}
			}
			if (this.maximum != 0)
			{
				var oldMaximum:Number = this.dataMaxinum;
				this.maximum = Math.ceil(dataMaxinum / this.majorUnit) * majorUnit;
				if (oldMaximum == this.maximum)
				{
					this.maximum += majorUnit;
				}
			}
			this.minimum = roundToPrecision(minimum, 10);
			this.maximum = roundToPrecision(maximum, 10);
		}
		
		/** 计算轴数据
		 */		
		private function calculateAxisData():Array
		{
			var tempUnit:Number = this.majorUnit;
			if (tempUnit == 0)
			{
				return [];
			}
			var value:Number = this.minimum;
			var data:Array = [getAxisData(value)];
			while (value < this.maximum)
			{
//				value += tempUnit;
				value = roundToPrecision(value + tempUnit, 10);
				data.push(getAxisData(value));
			}
			return data;
		}
		
		private function getAxisData(value:Number):Object
		{
//			value = roundToPrecision(value, 10);
			var label:String = value.toString();
			if (chart.valueFun != null) label = chart.valueFun(value);
			var data:Object = {
				label:		label,
				value:		value,
				position:	getPosition(value)
			}
			return data;
		}
		
		public function roundToPrecision(number:Number, precision:int = 0):Number
		{
			var decimalPlaces:Number = Math.pow(10, precision);
			return Math.round(decimalPlaces * number) / decimalPlaces;
		}
	}
}