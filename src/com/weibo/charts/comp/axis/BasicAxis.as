package com.weibo.charts.comp.axis
{
	import com.weibo.charts.ChartBase;
	import com.weibo.charts.comp.DecorateBase;
	import com.weibo.charts.data.ICoordinateLogic;
	import com.weibo.charts.events.ChartEvent;
	import com.weibo.charts.style.AxisStyle;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	public class BasicAxis extends DecorateBase
	{
		private var _style:AxisStyle;
		
		private var labelContainer:Sprite;
		
		private var realArea:Rectangle;
		
		public function BasicAxis(target:ChartBase, style:AxisStyle = null)
		{
			super(target);		
			_style = style;
			if(_style == null) _style = new AxisStyle();
			addChild(target);
		}
		
		override protected function create():void
		{
			if (!labelContainer)		labelContainer = new Sprite();
			if (!this.contains(labelContainer))		this.addChild(labelContainer);
		}
		override protected function destroy():void
		{
			if (labelContainer)
			{
//				while (labelContainer.numChildren > 0) labelContainer.removeChildAt(0);
				if (this.contains(labelContainer))	this.removeChild(labelContainer);
				labelContainer = null;
			}
		}
		override protected function addEvents():void
		{
			target.addEventListener(ChartEvent.CHART_DATA_CHANGED, onChartChanged);
			target.addEventListener(ChartEvent.CHART_AXIS_RESIZE, onChartAxisResize);
			super.addEvents();
		}
		override protected function removeEvents():void
		{
			target.removeEventListener(ChartEvent.CHART_DATA_CHANGED, onChartChanged);
			target.removeEventListener(ChartEvent.CHART_AXIS_RESIZE, onChartAxisResize);
			super.removeEvents();
		}
		
		private function onChartChanged(event:ChartEvent):void
		{
			onChartAxisResize();
		}
		private function get axisData():Array
		{
			switch (_style.type)
			{
				case AxisStyle.HORIZONTAL_AXIS:
					return coordinateLogic.horizontalData;
					break;
				case AxisStyle.VERTICAL_AXIS:
					return coordinateLogic.verticalData;
					break;
			}
			return null;
		}
//		private var axisData:Array;
		private function onChartAxisResize(event:ChartEvent = null):void
		{
			if (!dataProvider) return;
			
			var count:int = axisData.length;
			var realArea:Rectangle = area.clone();//new Rectangle(0, 0, chartWidht, chartHeight);
			//var lastArea:Rectangle = area.clone();//realArea.clone();
			var maxLength:Number = 20;
			var leftBottom:Point = new Point(area.left, area.bottom);
			for (var i:int = 0; i < count; i++)
			{
				var dataObject:Object = axisData[i];
				var label:DisplayObject;
				label = newLabel(null, dataObject.label);
				switch(_style.type)
				{
					case AxisStyle.HORIZONTAL_AXIS:
						leftBottom.y = Math.min(chartHeight - label.height, leftBottom.y);
//						realArea.bottom = Math.min(chartHeight - label.height, realArea.bottom);
						break;
					case AxisStyle.VERTICAL_AXIS:
//						trace(dataObject.label)
						leftBottom.x = Math.max(label.width, leftBottom.x);
//						realArea.left = Math.max(label.width, realArea.left);
						break;
				}
				//横坐标为标题类型的
				//只要有轴就会重新计算，所以这里不需要再重复触发计算
				if (_style.type == AxisStyle.HORIZONTAL_AXIS)
				{
					maxLength = Math.max(label.width, maxLength);
					coordinateLogic.labelLength = maxLength;
				}
			}
			realArea.left = leftBottom.x;
			realArea.bottom = leftBottom.y;
			
			//area.containsRect(realArea) && 
			if (!area.equals(realArea) && area.width > 0 && area.height > 0)
			{
				area = realArea;//area.intersection(realArea);
				
				axisLogic.dataProvider = dataProvider;
//				onChartAxisResize();
				target.dispatchEvent(new ChartEvent(ChartEvent.CHART_AXIS_RESIZE));
//				target.dispatchEvent(new ChartEvent(ChartEvent.CHART_RESIZE, null, true));
			}
//			else {
//				trace(_style.axisType, "Rectange相同");
//			}
		}
		
		override protected function updateState():void
		{
			if (!dataProvider) return;
			
			graphics.clear();
			graphics.lineStyle(_style.thicknetss, _style.color);
			clearLabels();
			
			var count:int = axisData.length;
			var stageHSide:Point = labelContainer.globalToLocal(new Point(0, stage.stageWidth));
			for (var i:int = 0; i < count; i++)
			{
				var dataObject:Object = axisData[i];
				var label:DisplayObject = newLabel(labelContainer, dataObject.label);
				label.visible = true;
				switch(_style.type)
				{
					case AxisStyle.HORIZONTAL_AXIS:
					{
//						graphics.moveTo(dataObject.position + area.x, area.y);
//						graphics.lineTo(dataObject.position + area.x, area.bottom);
						label.x = dataObject.position + area.x - label.width/2;
						label.y = area.bottom + 5;
						if (label.x < stageHSide.x || (label.x + label.width) > stageHSide.y) label.visible = false;
						break;
					}
					case AxisStyle.VERTICAL_AXIS:
					{
//						graphics.moveTo(area.x, dataObject.position + area.y);
//						graphics.lineTo(area.right, dataObject.position + area.y);
						label.x = area.x - label.width;
						label.y = dataObject.position + area.y - label.height/2;
						break;
					}
				}
			}
		}
		
		private function get coordinateLogic():ICoordinateLogic
		{
			return this.axisLogic as ICoordinateLogic;
		}
		
		private function newLabel(parent:DisplayObjectContainer, text:String = ""):DisplayObject
		{
			var label:TextField = new TextField();
			if (parent)	parent.addChild(label);
			label.selectable = false;
			label.autoSize = "left";
			label.defaultTextFormat = new TextFormat("Arial", 12, 0x999999, false);
			label.text = text;
			
			return label;
		}
		private function clearLabels():void
		{
			while (labelContainer.numChildren > 0)
			{
				labelContainer.removeChildAt(0);
			}
		}
	}
}