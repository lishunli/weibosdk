package com.weibo.charts.comp.axis
{
	import com.weibo.charts.ChartBase;
	import com.weibo.charts.DecorateBase;
	import com.weibo.charts.data.CoordinateLogic;
	import com.weibo.charts.events.ChartEvent;
	import com.weibo.charts.style.CoordinateChartStyle;
	
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
		
		private var labelContainer:Sprite;
		
		private var realArea:Rectangle;
		
// ==========================================
// 构造函数
// ------------------------------------------
		
		public function BasicAxis(target:ChartBase, type:String)
		{
			super(target);
			_type = type;
			addChild(target);
		}
		
// ==========================================
// 公开方法
// ------------------------------------------
		
		
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
			target.addEventListener(ChartEvent.CHART_DATA_CHANGED, onDataChange);
//			target.addEventListener(ChartEvent.CHART_DATA_CHANGED, onChartChanged);
			target.addEventListener(ChartEvent.CHART_AXIS_RESIZE, onChartAxisResize);
			super.addEvents();
		}
		
		override protected function removeEvents():void
		{
			target.removeEventListener(ChartEvent.CHART_DATA_CHANGED, onDataChange);
//			target.removeEventListener(ChartEvent.CHART_DATA_CHANGED, onChartChanged);
			target.removeEventListener(ChartEvent.CHART_AXIS_RESIZE, onChartAxisResize);
			super.removeEvents();
		}
		
		
		override protected function updateState():void
		{
			if (!dataProvider) return;
			
			var color:uint = coordinateStyle.axisStyle.valueLineColor;
			var thickness:Number = coordinateStyle.axisStyle.valueLineThickness;
			
			graphics.clear();
			graphics.lineStyle(thickness, color);
			clearLabels();
			
			var count:int = axisData.length;
			var stageHSide:Point = labelContainer.globalToLocal(new Point(0, stage.stageWidth));
			for (var i:int = 0; i < count; i++)
			{
				var dataObject:Object = axisData[i];
				
//				var label:DisplayObject = newLabel(labelContainer, dataObject, i == count-1);
				var label:DisplayObject;
//				label.visible = true;
				switch(_type)
				{
					case AxisType.LABEL_AXIS:
					{
						label = newLabel(labelContainer, dataObject, false);
						label.x = dataObject.position + area.x - label.width/2;
						label.y = area.bottom + coordinateStyle.axisStyle.marginBottom;
//						if (label.x < stageHSide.x || (label.x + label.width) > stageHSide.y) label.visible = false;
						break;
					}
					case AxisType.VALUE_AXIS:
					{
						label = newLabel(labelContainer, dataObject, i == count-1);
						label.x = area.x - label.width - coordinateStyle.axisStyle.marginLeft;
						label.y = dataObject.position + area.y - label.height/2;
						break;
					}
					case AxisType.SUB_VALUE_AXIS:
					{
						label = newLabel(labelContainer, dataObject, i == count-1);
						label.x = area.right + coordinateStyle.axisStyle.marginRight;
						label.y = dataObject.position + area.y - label.height/2;
						break;
					}
				}
				
				if (label)
				{
					label.x = Math.round(label.x);
					label.y = Math.round(label.y);
				}
			}
		}
		
		private function get coordinateStyle():CoordinateChartStyle
		{
			return chartStyle as CoordinateChartStyle;
		}
		
		private function get coordinateLogic():CoordinateLogic
		{
			return this.axisLogic as CoordinateLogic;
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
		
		private function get labelFun():Function
		{
			switch (_type)
			{
				case AxisType.LABEL_AXIS:
					return coordinateStyle.axisStyle.labelFun;
					break;
				case AxisType.VALUE_AXIS:
					return coordinateStyle.axisStyle.valueFun;
					break;
				case AxisType.SUB_VALUE_AXIS:
					return coordinateStyle.axisStyle.valueFun;
					break;
			}
			return null;
		}
		
		private function get axisUint():String
		{
			switch (_type)
			{
				case AxisType.VALUE_AXIS:
					return coordinateStyle.valueUnit;
					break;
				case AxisType.SUB_VALUE_AXIS:
					return coordinateStyle.valueSubUnit;
					break;
			}
			return "";
		}
		
		private function newLabel(parent:DisplayObjectContainer, dataObject:Object, showUnit:Boolean = false):DisplayObject
		{
			var text:String = dataObject.label;
//			var unit:String = getStyle("unit") as String;
			//暂时保留
			var txt:String = getStyle("label") as String;
			var textformat:TextFormat = coordinateStyle.axisStyle.labelFormat;
			
			if (labelFun != null)
			{
				text = labelFun(dataObject.label);
			}
			else if (txt)
			{
				text = txt.replace(/{value}/g, text);
			}
			
			//暂时只对标签轴起作用
			if (coordinateStyle.axisStyle.showValueUnit && showUnit)
			{
				text = text + axisUint;
			}
			 
			var label:TextField = new TextField();
			if (parent)	parent.addChild(label);
			label.selectable = false;
			label.autoSize = "left";
			label.defaultTextFormat = textformat;
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
		
//========================================
// 事件侦听器
//----------------------------------------
		
		private function onDataChange(e:ChartEvent):void
		{
			onChartAxisResize();
			this.invalidate();
		}
		
		/**
		 * 根据轴的文字调整图表尺寸
		 * @param event
		 */		
		private function onChartAxisResize(event:ChartEvent = null):void
		{
			if (!dataProvider) return;
			
			var count:int = axisData.length;
			var maxLength:Number = 2;
//			var leftBottom:Point = new Point(area.left, area.bottom);
			var realArea:Rectangle = area.clone();//new Rectangle(0, 0, chartWidht, chartHeight);
//			var tempRect:Rectangle = area.clone();
			for (var i:int = 0; i < count; i++)
			{
				var dataObject:Object = axisData[i];
				var label:DisplayObject;
				label = newLabel(null, dataObject, i == count-1);
				switch(_type)
				{
					case AxisType.LABEL_AXIS:
						realArea.bottom = Math.min(chartHeight - label.height - coordinateStyle.axisStyle.marginBottom, realArea.bottom);
						break;
					case AxisType.VALUE_AXIS:
						realArea.left = Math.max(label.width + coordinateStyle.axisStyle.marginLeft, realArea.left);
						if (i == (count-1)) realArea.top = Math.max(realArea.top, label.height/2);
						break;
					case AxisType.SUB_VALUE_AXIS:
						realArea.right = Math.min(chartWidth - label.width - coordinateStyle.axisStyle.marginRight, realArea.right);
						break;
				}
				//横坐标为标题类型的
				//只要有轴就会重新计算，所以这里不需要再重复触发计算
				if (_type == AxisType.LABEL_AXIS)
				{
					maxLength = Math.max(label.width, maxLength);
				}
			}
			//是否隐藏遮盖的文本
			if (_type == AxisType.LABEL_AXIS && coordinateStyle.axisStyle.autoHide)
				coordinateLogic.labelLength = maxLength;
			
//			realArea.left = leftBottom.x;
//			realArea.bottom = leftBottom.y;
//			realArea.right = tempRect.right;
			
			//area.containsRect(realArea) && 
			if (!area.equals(realArea) && area.width > 0 && area.height > 0)
			{
				area = realArea;//area.intersection(realArea);
				
				axisLogic.dataProvider = dataProvider;
				target.dispatchEvent(new ChartEvent(ChartEvent.CHART_AXIS_RESIZE));
			}
			else {
//				trace(_style.axisType, "Rectange相同");
//				area.left -= coordinateStyle.axisStyle.marginY;
//				area.bottom -= coordinateStyle.axisStyle.marginX;
			}
		}
		
	}
}