package
{
	import com.weibo.charts.ChartBase;
	import com.weibo.charts.MultiLineChart;
	import com.weibo.charts.comp.axis.AxisType;
	import com.weibo.charts.comp.axis.BasicAxis;
	import com.weibo.charts.comp.axis.BasicGrid;
	import com.weibo.charts.style.LineChartStyle;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.utils.setTimeout;
	
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
//		
//		
//		
//		private var _testData:Object = {
//			axis:["2011-12-13","2011-12-14", "1231"],
//			data:
//			[
//				{name:"微博数",value:["69","90", "100"]}
//			]
//		};
		
		
		
//		private var _testData:Object = {
//			axis:["2011-12-13"],
//			data:
//			[
//				{name:"微博数",value:["69"]}
//			]
//		};
//		
		
		
		public function LineChart()
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
			var style:LineChartStyle = new LineChartStyle();
			style.baseStyle.tipType = 1;
			style.baseStyle.integer = true;
			style.baseStyle.touchSide = false;
			style.lineColors = [0x519ae5, 0x519a8, 0x519aee]
			_chart = new MultiLineChart(style);
			_chart = new BasicAxis(_chart, AxisType.LABEL_AXIS);
			_chart = new BasicAxis(_chart, AxisType.VALUE_AXIS);
			_chart = new BasicAxis(_chart, AxisType.SUB_VALUE_AXIS);
			_chart = new BasicGrid(_chart);
			addChild(_chart);
			_chart.x = 10;
			_chart.y = 10;
			_chart.setSize(stage.stageWidth - 20, stage.stageHeight - 20);
			_chart.dataProvider = _testData;
			
			var para:Object = this.loaderInfo.parameters;
			if (ExternalInterface.available)
			{
				ExternalInterface.addCallback("setData", changeData);
				ExternalInterface.addCallback("setStyle", setStyle);
				setTimeout(function ():void{
					//					ExternalInterface.call("alert", para["swfInit"]);
					ExternalInterface.call(para["readyCallback"] || "readyCallback", para["swfID"]);
				}, 500);
			}
			
//			stage.addEventListener(MouseEvent.CLICK, onstageclick);
		}
		
		private function changeData(data:Object):void
		{
			_chart.dataProvider = data;
		}
		
		private function setStyle(value:Object):void
		{
			
		}

//		private function onstageclick(event:MouseEvent):void
//		{
//			_chart.dataProvider = _testData2;
//		}
	}
}