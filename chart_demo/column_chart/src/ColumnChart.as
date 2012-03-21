package
{
	import com.weibo.charts.ChartBase;
	import com.weibo.charts.MultiColumnChart;
	import com.weibo.charts.MultiLineChart;
	import com.weibo.charts.comp.axis.AxisType;
	import com.weibo.charts.comp.axis.BasicAxis;
	import com.weibo.charts.comp.axis.BasicGrid;
	import com.weibo.charts.style.ColumnChartStyle;
	import com.weibo.charts.style.LineChartStyle;
	import com.weibo.charts.utils.ColorUtil;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.utils.setTimeout;
	
	[SWF(width="480", height="280", frameRate="60")]
	public class ColumnChart extends Sprite
	{
		private var _chart:ChartBase;
		
		
		private var _testData:Object = {
			axis:["2011-12-13","2011-12-14","2011-12-15","2011-12-16","2011-12-17","2011-12-18"],
			data:
			[
				{name:"微博数",value:["69","37","70","72","10","131"]}
			]
		};
		
		private var _testData2:Object = {
			axis:["2011-12-13","2011-12-14","2011-12-15","2011-12-16"],
			data:
			[
				{name:"微博数",value:["19","57","76","62"]},
				{name:"粉丝数",value:["100","20","100","140"]},
				{name:"关注数",value:["130","15","20","210"]}
			]
		};
		
		public function ColumnChart()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			addEventListener(Event.ENTER_FRAME, onSize);
			function onSize(evt:Event):void {
				if(stage.stageWidth > 0 && stage.stageHeight > 0) {
					removeEventListener(Event.ENTER_FRAME, onSize);
					init();
				}
			}
		}
		
		private function init():void
		{
			var obj:Object = this.loaderInfo.parameters;
			
			var style:ColumnChartStyle = new ColumnChartStyle();
//			style.useDifferentColor = true;
//			style.baseStyle.tipType = 1;
			
			if(obj["barColors"] != null) style.barColors = ColorUtil.getColorsFromRGB16(String(obj["barColors"]));
			if(obj["useDifferentColor"] != null) style.useDifferentColor = obj["useDifferentColor"] == 1;
			if(obj["tipType"] != null) style.baseStyle.tipType = obj["tipType"];	
			if(obj["valueUnit"] != null) style.valueUnit = obj["valueUnit"];
			
			_chart = new MultiColumnChart(style);
			_chart = new BasicAxis(_chart, AxisType.LABEL_AXIS);
			_chart = new BasicAxis(_chart, AxisType.VALUE_AXIS);
			_chart = new BasicAxis(_chart, AxisType.SUB_VALUE_AXIS);
			_chart = new BasicGrid(_chart);
			
			//TO DO 优化设置方案
			_chart.setStyle("labelGrid", true);	
			
			addChild(_chart);
			_chart.x = 10;
			_chart.y = 10;
			_chart.setSize(stage.stageWidth - 20, stage.stageHeight - 20);
//			_chart.dataProvider = _testData;			
			
			var para:Object = this.loaderInfo.parameters;
			if (ExternalInterface.available)
			{
				ExternalInterface.addCallback("setData", changeData);
				ExternalInterface.addCallback("setStyle", setStyle);
				setTimeout(function ():void{
					ExternalInterface.call(para["readyCallback"] || "readyCallback", para["swfID"]);
				}, 500);
			}
		}
		
		private function changeData(data:Object):void
		{
			_chart.dataProvider = data;
		}
		
		private function setStyle(value:Object):void
		{
			if(value["barColors"] != null) _chart.chartStyle["barColors"] = ColorUtil.getColorsFromRGB16(String(value["barColors"]));
			if(value["tipType"] != null) _chart.chartStyle["baseStyle"]["tipType"] = value["tipType"];
			if(value["useDifferentColor"] != null) _chart.chartStyle["useDifferentColor"] = value["useDifferentColor"] == 1;
		}
	}
}