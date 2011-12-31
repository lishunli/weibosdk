package com.weibo.charts
{
	import com.weibo.charts.data.IAxisLogic;
	import com.weibo.charts.effects.IEffect;
	import com.weibo.charts.events.ChartEvent;
	import com.weibo.charts.service.IWeiboChartService;
	import com.weibo.core.UIComponent;
	
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
		
		protected var _dataProvider:Object;
		
		private var _area:Rectangle;
		
//		private var _labelFun:Function;
//		
//		private var _valueFun:Function;
		
//		private var _tipFun:Function;
		
		public function ChartBase()
		{
			_width = 450;
			_height = 260;
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
			invalidate();
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

		public function get dataProvider():Object { return _dataProvider; }
		public function set dataProvider(value:Object):void
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
/*
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

//		public function get tipFun():Function{return _tipFun;}
		public function set tipFun(value:Function):void
		{
			_tipFun = value;
		}
*/
		public function get chartWidth():Number{return width;}
		public function set chartWidth(value:Number):void
		{
			width = value;
		}

		public function get chartHeight():Number{return height;}
		public function set chartHeight(value:Number):void
		{
			height = value;
		}
	}
}