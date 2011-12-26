package com.weibo.charts.comp.axis
{
	import com.weibo.charts.ChartBase;
	import com.weibo.charts.comp.DecorateBase;
	import com.weibo.charts.data.ICoordinateLogic;
	import com.weibo.charts.events.ChartEvent;
	import com.weibo.charts.style.GridStyle;
	
	public class BasicGrid extends DecorateBase
	{
		private var _style:GridStyle;
		
		public function BasicGrid(target:ChartBase, style:GridStyle = null)
		{
			this._style = style;
			if(this._style == null) this._style = new GridStyle();
			addChild(target);
			super(target);
		}
		
		override protected function updateState():void
		{
			if (!target.dataProvider) return;
			
			graphics.clear();
			graphics.lineStyle(this._style.thicknetss, this._style.color);
			graphics.drawRect(area.x, area.y, area.width, area.height);
			
			var axisData:Array;
			var count:int;
			var dataObject:Object;
			//纵轴
			axisData = (coordinateLogic.axisType == "vertical") ? coordinateLogic.labelGridData : coordinateLogic.verticalData;
			count= axisData.length;
			var i:int;
			for (i = 0; i < count; i++)
			{
				dataObject = axisData[i];
				graphics.moveTo(target.area.x, dataObject.position + target.area.y);
				graphics.lineTo(target.area.right, dataObject.position + target.area.y);
			}
			//横轴
//			trace((coordinateLogic.axisType))
			axisData = (coordinateLogic.axisType == "vertical") ? coordinateLogic.horizontalData : coordinateLogic.labelGridData;
			count = axisData.length;
			for (i = 0; i < count; i++)
			{
				dataObject = axisData[i];
				graphics.moveTo(dataObject.position + target.area.x, target.area.y);
				graphics.lineTo(dataObject.position + target.area.x, target.area.bottom);
			}
		}
		
		private function get coordinateLogic():ICoordinateLogic
		{
			return this.axisLogic as ICoordinateLogic;
		}
	}
}