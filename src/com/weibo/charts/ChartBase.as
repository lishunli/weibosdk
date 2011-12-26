package com.weibo.charts
{
	import com.weibo.charts.data.IAxisLogic;
	import com.weibo.charts.effects.IEffect;
	import com.weibo.charts.events.ChartEvent;
	import com.weibo.managers.RepaintManager;
	import com.weibo.charts.service.IWeiboChartService;
	import com.weibo.core.UIComponent;
	
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	
	/**
	 * 图表组件的抽象类 
	 * @author qidonghui
	 * 
	 */	
	public class ChartBase extends UIComponent
	{
		protected var _dataService:IWeiboChartService;
		public var effect:IEffect;
		
		private var _axisLogic:IAxisLogic;
		
		protected var _dataProvider:Array;
		
		private var _chartWidht:Number;
		
		private var _chartHeight:Number;
		
		private var _area:Rectangle;
		
		private var _labelFun:Function;
		
		private var _valueFun:Function;
		
		private var _tipFun:Function;
		
		public function ChartBase()
		{
			super();
		}
		
		public function setDataByJS(value:Array):void
		{
			_dataProvider = value;
		}
		
		protected function onChartResult(e:ChartEvent):void
		{
			this.dataProvider = e.data as Array;
		}
		
		protected function onChartChange(event:ChartEvent):void
		{
			_validateTypeObject["state"] = true;
			RepaintManager.getInstance().addToRepaintQueue(this);
		}
		
		override protected function addEvents():void
		{
			super.addEvents();
//			addEventListener(ChartEvent.CHART_RESIZE, onChartResize);
			addEventListener(ChartEvent.CHART_DATA_CHANGED, onChartChange);
//			if(_dataService != null) _dataService.addEventListener(ChartEvent.CHART_DATA_RESULT, onChartResult);
//			if(ExternalInterface.available) ExternalInterface.addCallback("setData", setDataByJS);
		}
		
		override protected function removeEvents():void
		{
			super.removeEvents();
//			removeEventListener(ChartEvent.CHART_RESIZE, onChartResize);
			if(_dataService != null) _dataService.removeEventListener(ChartEvent.CHART_DATA_RESULT, onChartResult);
		}
		
		public function get dataService():IWeiboChartService { return _dataService; }
		public function set dataService(value:IWeiboChartService):void
		{
			_dataService = value;
		}

		public function get dataProvider():Array { return _dataProvider; }
		public function set dataProvider(value:Array):void
		{
			_dataProvider = value;
//			_validateTypeObject["state"] = true;
//			RepaintManager.getInstance().addToRepaintQueue(this);
//			dispatchEvent(new ChartEvent(ChartEvent.CHART_DATA_CHANGED));
		}

		public function get axisLogic():IAxisLogic{return _axisLogic;}
		public function set axisLogic(value:IAxisLogic):void
		{
			_axisLogic = value;
		}

		public function get area():Rectangle{return _area;}
		public function set area(value:Rectangle):void
		{
			_area = value;
		}

		public function get labelFun():Function{return _labelFun;}
		public function set labelFun(value:Function):void
		{
			_labelFun = value;
		}

		public function get valueFun():Function{return _valueFun;}
		public function set valueFun(value:Function):void
		{
			_valueFun = value;
		}

		public function get tipFun():Function{return _tipFun;}
		public function set tipFun(value:Function):void
		{
			_tipFun = value;
		}

		public function get chartWidht():Number{return _chartWidht;}
		public function set chartWidht(value:Number):void
		{
			_chartWidht = value;
		}

		public function get chartHeight():Number{return _chartHeight;}
		public function set chartHeight(value:Number):void
		{
			_chartHeight = value;
		}
	}
}