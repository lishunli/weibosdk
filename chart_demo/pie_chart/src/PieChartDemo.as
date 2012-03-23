package
{
	import com.weibo.charts.ChartBase;
	import com.weibo.charts.PieChart;
	import com.weibo.charts.comp.PieTipSpider;
	import com.weibo.charts.style.PieChartStyle;
	import com.weibo.charts.ui.tips.LabelMultiTip;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	[SWF(width="480", height="280", frameRate="60")]
	public class PieChartDemo extends Sprite
	{
		private var _chart:ChartBase;
		
		private var _total:Number;
		
		/*
		private var _testData:Object = [
			{"label":"北京", "value":327},
			{"label":"深圳", "value":423},
			{"label":"上海", "value":221},
			{"label":"北京", "value":327},
			{"label":"深圳", "value":423},
			{"label":"上海", "value":221},
			{"label":"北京", "value":327},
			{"label":"深圳", "value":423},
			{"label":"上海", "value":221}
		];
		*/
		
		public function PieChartDemo()
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
			var style:PieChartStyle = new PieChartStyle();
			style.tipUI = LabelMultiTip;
//			style.borderThicknesss = 5;
			var smallerlen:Number = (stage.stageWidth > stage.stageHeight) ? stage.stageHeight : stage.stageWidth;
			style.radiusIn = (smallerlen - 20) * 0.2;
			style.gap = 3;			
			
			_chart = new PieChart(style);
			_chart = new PieTipSpider(_chart as PieChart);	
			_chart.setStyle("tipFun", this.tipFun);		
			//TO DO 优化设置方案
			_chart.setStyle("labelGrid", true);	
			
			addChild(_chart);
			_chart.setSize(stage.stageWidth - 30, stage.stageHeight - 40);
			_chart.move(stage.stageWidth * 0.5 - 0.5 * _chart.width, stage.stageHeight * 0.5 - 0.5 * _chart.height);
//			changeData(_testData);			
			
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
			//计算总数
			_total = 0;
			for(var i:int = 0; i < data.length ;i ++)
			{
				_total += Number(data[i].value);
			}
			_chart.dataProvider = data;
		}
		
		private function setStyle(value:Object):void
		{
			
		}
		
		public function tipFun(obj:Object):String
		{
			var str:String = obj.label;
			var value:Number = obj.value / _total * 100;
			var valueHTML:String;
			if (value > 0 && value < 0.01)
			{
				value = 0.01;
				valueHTML = "小于<font size='18'>" + value.toFixed(2) + "</font>";
			}
			else if (value < 100 && value > 99.99)
			{
				value = 99.99;
				valueHTML = "大于<font size='18'>" + value.toFixed(2) + "</font>";
			}
			else
			{
				valueHTML = "<font size='18'>" + value.toFixed(2) + "</font>";
			}
			return str + " " + valueHTML + "%";
		}
	}
}