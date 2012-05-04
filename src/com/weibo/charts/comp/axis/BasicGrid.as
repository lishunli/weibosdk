package com.weibo.charts.comp.axis
{
	import com.weibo.charts.ChartBase;
	import com.weibo.charts.DecorateBase;
	import com.weibo.charts.data.CoordinateLogic;
	import com.weibo.charts.events.ChartEvent;
	import com.weibo.charts.style.CoordinateChartStyle;
	import com.weibo.charts.style.GridStyle;
	
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	
	public class BasicGrid extends DecorateBase
	{
		private var border:Shape;
		
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
		
		override protected function create():void
		{
			super.create();
			border = new Shape();
			addChildAt(border, 0);
		}
		override protected function destroy():void
		{
			super.destroy();
			removeChild(border);
			border = null;
		}
		
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
			
			var gridStyle:GridStyle = coordinateStyle.gridStyle;
			var showLabelGrid:Boolean = gridStyle.showLabelGrid;
			
			graphics.clear();
			//背景
			if (gridStyle.background)
			{
				graphics.beginFill(gridStyle.backgroundColor, gridStyle.backgroundAlpha);
			}
			graphics.lineStyle(gridStyle.thickness, gridStyle.lineColor);
			graphics.drawRect(area.x, area.y, area.width, area.height);
			
			
			//===== 边框 =====
			border.graphics.clear();
			border.graphics.lineStyle(gridStyle.borderThickness, gridStyle.borderColor, 1, false, LineScaleMode.NONE, CapsStyle.ROUND);
			//----- 左边
			if (gridStyle.leftBorder)
			{
				border.graphics.moveTo(area.left, area.top);
				border.graphics.lineTo(area.left, area.bottom);
			}
			//----- 底边
			if (gridStyle.bottomBorder)
			{
				border.graphics.moveTo(area.left, area.bottom);
				border.graphics.lineTo(area.right, area.bottom);
			}
			//----- 右边
			if (gridStyle.rightBorder)
			{
				border.graphics.moveTo(area.right, area.bottom);
				border.graphics.lineTo(area.right, area.top);
			}
			//----- 顶边
			if (gridStyle.topBorder)
			{
				border.graphics.moveTo(area.right, area.top);
				border.graphics.lineTo(area.left, area.top);
			}
			
			var axisData:Array;
			var count:int;
			var dataObject:Object;
			var i:int;
			//画横线
			if (coordinateStyle.gridStyle.showValueGrid && (showLabelGrid || !coordinateLogic.reverseAxis))
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
					count = axisData.length;
					for (i = 0; i < count; i++)
					{
						dataObject = axisData[i];
						graphics.moveTo(dataObject.position + target.area.x, target.area.y);
						graphics.lineTo(dataObject.position + target.area.x, target.area.bottom);
					}
				}
				else if (gridStyle.alignLabel)
				{
					axisData = coordinateLogic.labelData;
					count = axisData.length;
					for (i = 0; i < count; i++)
					{
						dataObject = axisData[i];
						if (coordinateStyle.axisStyle.labelFun != null && 
							coordinateStyle.axisStyle.labelFun(dataObject.label) == "")
						{
							continue;
						}
						graphics.moveTo(dataObject.position + target.area.x, target.area.y);
						graphics.lineTo(dataObject.position + target.area.x, target.area.bottom);
					}
				}
				else
				{
					axisData = coordinateLogic.labelGridData;
					count = axisData.length;
					for (i = 0; i < count; i++)
					{
						dataObject = axisData[i];
						graphics.moveTo(dataObject.position + target.area.x, target.area.y);
						graphics.lineTo(dataObject.position + target.area.x, target.area.bottom);
					}
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