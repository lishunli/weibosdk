package com.weibo.charts.comp
{
	import com.weibo.charts.ChartBase;
	import com.weibo.charts.data.IAxisLogic;
	import com.weibo.charts.events.ChartEvent;
	import com.weibo.managers.RepaintManager;
	
	import flash.geom.Rectangle;
	
	/**
	 * 图表装饰的基类
	 * @author YaoFei
	 */	
	public class DecorateBase extends ChartBase
	{
		private var _target:ChartBase;
		
		public function DecorateBase(target:ChartBase)
		{
			this._target = target;
			super();
		}
//		final public function get target():ChartBase { return this._target; }
		final public function get target():ChartBase { return getRoot(this); }
		
		override protected function addEvents():void
		{
			super.addEvents();
			target.addEventListener(ChartEvent.CHART_DATA_CHANGED, onDataChange);
		}
		override protected function removeEvents():void
		{
			super.removeEvents();
			target.removeEventListener(ChartEvent.CHART_DATA_CHANGED, onDataChange);
		}
		
		override public function get area():Rectangle{return target.area;}
		override public function set area(value:Rectangle):void
		{
			target.area = value;
		}
		
		override public function get dataProvider():Array{return target.dataProvider;}
		override public function set dataProvider(value:Array):void
		{
			target.dataProvider = value;
		}
		
		override public function get axisLogic():IAxisLogic{return target.axisLogic;}
		override public function set axisLogic(value:IAxisLogic):void
		{
			target.axisLogic = value;
		}
		
		override public function get labelFun():Function {return target.labelFun}
		override public function set labelFun(value:Function):void{
			target.labelFun = value;
		}
		
		override public function get valueFun():Function {return target.valueFun}
		override public function set valueFun(value:Function):void{
			target.valueFun = value;
		}
		
		override public function get tipFun():Function {return target.tipFun}
		override public function set tipFun(value:Function):void{
			target.tipFun = value;
		}
		
		override public function get chartWidht():Number{return target.chartWidht;}
		override public function set chartWidht(value:Number):void
		{
			target.chartWidht = value;
		}
		
		override public function get chartHeight():Number{return target.chartHeight;}
		override public function set chartHeight(value:Number):void
		{
			target.chartHeight = value;
		}
		
		protected function onDataChange(e:ChartEvent):void
		{
			_validateTypeObject["state"] = true;
			RepaintManager.getInstance().addToRepaintQueue(this);
		}
		internal function get parentTarget():ChartBase
		{
			return this._target;
		}
		private function getRoot(chart:ChartBase):ChartBase
		{
			if (chart is DecorateBase)	return getRoot((chart as DecorateBase).parentTarget);
			return chart;
		}
	}
	
}