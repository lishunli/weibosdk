package com.weibo.charts.comp.axis
{
	import com.weibo.charts.ChartBase;
	import com.weibo.charts.DecorateBase;
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
		private var _type:String;
		
		private var _axisStyle:AxisStyle;
		
		private var labelContainer:Sprite;
		
		private var realArea:Rectangle;
		
// ==========================================
// 构造函数
// ------------------------------------------
		
		public function BasicAxis(target:ChartBase, type:String, style:AxisStyle = null)
		{
			super(target);
			_type = type;
			_axisStyle = style;
			if(_axisStyle == null) _axisStyle = new AxisStyle();
			addChild(target);
		}
		
// ==========================================
// 公开方法
// ------------------------------------------
		
		override public function setSize(w:Number, h:Number):void
		{
			super.setSize(w, h);
			target.setSize(w, h);
		}
		
// ==========================================
// 内部方法
// ------------------------------------------
		
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
			switch (_type)
			{
				case AxisType.LABEL_AXIS:
					return coordinateLogic.labelData;
					break;
				case AxisType.VALUE_AXIS:
					return coordinateLogic.valueData;
					break;
				case AxisType.SUB_VALUE_AXIS:
					return coordinateLogic.valueSubData;
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
			var tempRect:Rectangle = area.clone(); 
			for (var i:int = 0; i < count; i++)
			{
				var dataObject:Object = axisData[i];
				var label:DisplayObject;
				label = newLabel(null, dataObject.label);
				switch(_type)
				{
					case AxisType.LABEL_AXIS:
						leftBottom.y = Math.min(chartHeight - label.height, leftBottom.y);
//						realArea.bottom = Math.min(chartHeight - label.height, realArea.bottom);
						break;
					case AxisType.VALUE_AXIS:
//						trace(dataObject.label)
						leftBottom.x = Math.max(label.width, leftBottom.x);
//						realArea.left = Math.max(label.width, realArea.left);
						break;
					case AxisType.SUB_VALUE_AXIS:
//						trace(dataObject.label)
						tempRect.right = Math.min(chartWidth - label.width, tempRect.right);
//						realArea.left = Math.max(label.width, realArea.left);
						break;
				}
				//横坐标为标题类型的
				//只要有轴就会重新计算，所以这里不需要再重复触发计算
				if (_type == AxisType.LABEL_AXIS)
				{
					maxLength = Math.max(label.width, maxLength);
					coordinateLogic.labelLength = maxLength;
				}
			}
			realArea.left = leftBottom.x;
			realArea.bottom = leftBottom.y;
			realArea.right = tempRect.right;
			
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
			graphics.lineStyle(_axisStyle.thicknetss, _axisStyle.color);
			clearLabels();
			
			var count:int = axisData.length;
			var stageHSide:Point = labelContainer.globalToLocal(new Point(0, stage.stageWidth));
			for (var i:int = 0; i < count; i++)
			{
				var dataObject:Object = axisData[i];
				var label:DisplayObject = newLabel(labelContainer, dataObject.label);
				label.visible = true;
				switch(_type)
				{
					case AxisType.LABEL_AXIS:
					{
//						graphics.moveTo(dataObject.position + area.x, area.y);
//						graphics.lineTo(dataObject.position + area.x, area.bottom);
						label.x = dataObject.position + area.x - label.width/2;
						label.y = area.bottom + 5;
						if (label.x < stageHSide.x || (label.x + label.width) > stageHSide.y) label.visible = false;
						break;
					}
					case AxisType.VALUE_AXIS:
					{
//						graphics.moveTo(area.x, dataObject.position + area.y);
//						graphics.lineTo(area.right, dataObject.position + area.y);
						label.x = area.x - label.width;
						label.y = dataObject.position + area.y - label.height/2;
						break;
					}
					case AxisType.SUB_VALUE_AXIS:
					{
						label.x = area.right + 0;
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