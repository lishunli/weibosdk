package com.weibo.charts.comp.axis
{
	import com.weibo.charts.ChartBase;
	import com.weibo.charts.DecorateBase;
	import com.weibo.charts.data.ICoordinateLogic;
	import com.weibo.charts.events.ChartEvent;
	
	public class BasicGrid extends DecorateBase
	{
		
// ==========================================
// 构造函数
// ------------------------------------------
		
		public function BasicGrid(target:ChartBase)
		{
			addChild(target);
			super(target);
			_style = {
				thickness:	1,
				color:		0xe7e7e7
			}
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
			
			var color:uint = getStyle("color") as uint;
			var thickness:Number = getStyle("thickness") as Number;
			var showLabelGrid:Boolean = getStyle("labelGrid");
			
			graphics.clear();
			graphics.lineStyle(thickness, color);
			if (getStyle("background"))
			{
				graphics.beginFill(getStyle("bgColor") as uint, 1);
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
				axisData = coordinateLogic.reverseAxis ? coordinateLogic.labelData: coordinateLogic.labelGridData;
				count = axisData.length;
				for (i = 0; i < count; i++)
				{
					dataObject = axisData[i];
					graphics.moveTo(dataObject.position + target.area.x, target.area.y);
					graphics.lineTo(dataObject.position + target.area.x, target.area.bottom);
				}
			}
			
		}
		
		private function get coordinateLogic():ICoordinateLogic
		{
			return this.axisLogic as ICoordinateLogic;
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