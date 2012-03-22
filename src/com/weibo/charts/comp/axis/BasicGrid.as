package com.weibo.charts.comp.axis
{
	import com.weibo.charts.ChartBase;
	import com.weibo.charts.DecorateBase;
	import com.weibo.charts.data.CoordinateLogic;
	import com.weibo.charts.events.ChartEvent;
	import com.weibo.charts.style.CoordinateChartStyle;
	
	public class BasicGrid extends DecorateBase
	{
		
// ==========================================
// 构造函数
// ------------------------------------------
		
		public function BasicGrid(target:ChartBase)
		{
			addChild(target);
			super(target);
		}
		
		
// ==========================================
// 公开方法
// ------------------------------------------
		
		
		
// ==========================================
// 内部方法
// ------------------------------------------
		
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
		
		override protected function updateState():void
		{
			if (!target.dataProvider) return;
			
			var color:uint = coordinateStyle.gridStyle.color;
			var thickness:Number = coordinateStyle.gridStyle.thickness;
			var showLabelGrid:Boolean = coordinateStyle.gridStyle.showLabelGrid;
			var alignLabel:Boolean = coordinateStyle.gridStyle.alignLabel;
			
			graphics.clear();
			graphics.lineStyle(thickness, color);
			if (coordinateStyle.gridStyle.background)
			{
				graphics.beginFill(coordinateStyle.gridStyle.backgroundColor, coordinateStyle.gridStyle.backgroundAlpha);
			}
			graphics.drawRect(area.x, area.y, area.width, area.height);
			
			var axisData:Array;
			var count:int;
			var dataObject:Object;
			var i:int;
			//画横线
			if (showLabelGrid || !coordinateLogic.reverseAxis)
			{
				axisData = coordinateLogic.reverseAxis ? coordinateLogic.labelGridData : coordinateLogic.valueData;
				count= axisData.length;
				for (i = 0; i < count; i++)
				{
					dataObject = axisData[i];
					graphics.moveTo(target.area.x, dataObject.position + target.area.y);
					graphics.lineTo(target.area.right, dataObject.position + target.area.y);
				}
			}
			
			//画竖线
			if (showLabelGrid || coordinateLogic.reverseAxis)
			{
				if (coordinateLogic.reverseAxis)
				{
					axisData = coordinateLogic.labelData;
				}
				else if (alignLabel)
				{
					axisData = coordinateLogic.labelData;
				}
				else
				{
					axisData = coordinateLogic.labelGridData;
				}
				count = axisData.length;
				for (i = 0; i < count; i++)
				{
					dataObject = axisData[i];
					graphics.moveTo(dataObject.position + target.area.x, target.area.y);
					graphics.lineTo(dataObject.position + target.area.x, target.area.bottom);
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
		
		
//========================================
// 事件侦听器
//----------------------------------------
		
		private function onDataChange(e:ChartEvent):void
		{
			this.invalidate();
		}
	}
}