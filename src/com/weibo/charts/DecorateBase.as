package com.weibo.charts
{
	import com.weibo.charts.data.IAxisLogic;
	
	import flash.geom.Rectangle;
	
	/**
	 * 图表装饰的基类。所有的装饰对象都需要继承此类使用。
	 * 样式		chartStyle
	 * 坐标轴线	axisLogic
	 * 区域		area
	 * @author YaoFei
	 */	
	public class DecorateBase extends ChartBase
	{
		protected var _target:ChartBase;
		
	//========================================
	// 构造函数
	//----------------------------------------
		
		public function DecorateBase(target:ChartBase)
		{
			this._target = target;
			super();
			this.area = new Rectangle(0, 0, width, height);
		}
		
	//========================================
	// 公开方法
	//----------------------------------------
		
		override public function get chartStyle():Object { return target.chartStyle; }
		override public function set chartStyle(value:Object):void
		{
			target.chartStyle = value;
		}
		
		/**
		 * 找到核心图表组件类，如：LineChart
		 * @return ChartBase
		 */		
		final public function get target():ChartBase { return getRoot(this); }
		
		
		override public function get area():Rectangle{return target.area;}
		override public function set area(value:Rectangle):void
		{
			target.area = value;
		}
		
		override public function get dataProvider():Object {return target.dataProvider;}
		override public function set dataProvider(value:Object):void
		{
			target.dataProvider = value;
		}
		
		override public function get axisLogic():IAxisLogic{return target.axisLogic;}
		override public function set axisLogic(value:IAxisLogic):void
		{
			target.axisLogic = value;
		}
		override public function get chartWidth():Number{return target.chartWidth;}
		override public function set chartWidth(value:Number):void
		{
			target.chartWidth = value;
		}
		
		override public function get chartHeight():Number{return target.chartHeight;}
		override public function set chartHeight(value:Number):void
		{
			target.chartHeight = value;
		}
		
		/**
		 * 保证任何装饰者都可以使用此方法设置宽高
		 * @param w
		 * @param h
		 */		
		override public function setSize(w:Number, h:Number):void
		{
			super.setSize(w, h);
			target.setSize(w, h);
		}
		
		
		
	//========================================
	// 内部方法
	//----------------------------------------
		
		internal function get parentTarget():ChartBase
		{
			return this._target;
		}
		
		private function getRoot(chart:ChartBase):ChartBase
		{
			if (chart is DecorateBase)	return getRoot((chart as DecorateBase).parentTarget);
			return chart;
		}
		
		
	//========================================
	// 事件侦听器
	//----------------------------------------
		
		
	}
	
}