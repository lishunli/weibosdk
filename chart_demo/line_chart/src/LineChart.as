package
{
	import com.weibo.charts.ChartBase;
	import com.weibo.charts.MultiLineChart;
	import com.weibo.charts.comp.axis.AxisType;
	import com.weibo.charts.comp.axis.BasicAxis;
	import com.weibo.charts.comp.axis.BasicGrid;
	import com.weibo.charts.style.LineChartStyle;
	import com.weibo.charts.utils.ColorUtil;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.utils.setTimeout;
	import flash.ui.ContextMenuItem;
	import flash.ui.ContextMenu;
	
	[SWF(width="480", height="280", frameRate="60")]
	public class LineChart extends Sprite
	{
		private var _chart:ChartBase;
		
		private var _testData:Object = {
			axis:["2011-12-13","2011-12-14","2011-12-15","2011-12-16"],
			data:
			[
				{name:"微博数",value:["69","37","70","72"]},
				{name:"粉丝数",value:["200","70","200","120"]},
				{name:"关注数",value:["190","10","90","290"]}
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
		
		public function LineChart()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var cmi:ContextMenuItem = new ContextMenuItem("weibo chart: v1.00", false, false);
			var cm:ContextMenu = new ContextMenu();
			cm.hideBuiltInItems();
			cm.customItems.push(cmi);
			this.contextMenu = cm;
			
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
			
			var style:LineChartStyle = new LineChartStyle();
			style.integer = true;
			
			if(obj["lineColors"] != null) style.colors = ColorUtil.getColorsFromRGB16(String(obj["lineColors"]));
			if(obj["shadowColors"] != null) style.shadowColors = ColorUtil.getColorsFromRGB16(String(obj["shadowColors"]));
			if(obj["shadowAlpha"] != null) style.shadowAlpha = obj["shadowAlpha"];
			if(obj["valueUnit"] != null) style.valueUnit = obj["valueUnit"];
			if(obj["touchSide"] != null) style.touchSide = obj["touchSide"] == 1;
			if(obj["tipType"] != null) style.tipType = obj["tipType"];
			
			_chart = new MultiLineChart(style);
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
				ExternalInterface.call(para["readyCallback"] || "readyCallback", para["swfID"]);
			}
		}
		
		private function changeData(data:Object):void
		{
			_chart.dataProvider = data;
		}
		
		private function setStyle(value:Object):void
		{	
			if(value["lineColors"] != null) _chart.chartStyle["colors"] = ColorUtil.getColorsFromRGB16(String(value["lineColors"]));
			if(value["shadowColors"] != null) _chart.chartStyle.shadowColors = ColorUtil.getColorsFromRGB16(String(value["shadowColors"]));
			if(value["shadowAlpha"] != null) _chart.chartStyle["shadowAlpha"] = value["shadowAlpha"];
			if(value["tipType"] != null) _chart.chartStyle["tipType"] = value["tipType"];
		}
		
	}
	
}