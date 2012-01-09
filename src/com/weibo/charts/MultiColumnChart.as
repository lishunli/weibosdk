package com.weibo.charts
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.weibo.charts.style.ColumnChartStyle;
	import com.weibo.charts.ui.bars.PureBar;
	import com.weibo.core.UIComponent;
	
	import flash.display.Sprite;

	/**
	 * 
	 * yaofei
	 */
	public class MultiColumnChart extends CoordinateChart
	{
		private var _chartStyle:ColumnChartStyle;
		
		private var _container:Sprite;
		private var _tipContainer:Sprite;
		
		private var _arrBars:Array = [];
		
//		private var _arrTips:Array = [];
		
		public function MultiColumnChart(style:ColumnChartStyle)
		{
			_chartStyle = style;
			super();
		}
		
		override protected function create():void
		{
			if(_container == null){
				_container =  new Sprite(); 
				addChild(_container);
			}
			if(_tipContainer == null){
				_tipContainer = new Sprite();
				addChild(_tipContainer);
			}
		}
		
		override protected function destroy():void
		{
			if(_container != null) while(_container.numChildren > 0) _container.removeChildAt(0);
			if(_tipContainer != null) while(_tipContainer.numChildren > 0) _tipContainer.removeChildAt(0);
			_arrBars = [];
//			_arrTips = [];
		}
		
		override protected function updateState():void
		{
			if (dataProvider == null) return;
			
			var axislength:int = dataProvider.axis.length;
			var shapenum:int = dataProvider.data.length;
			
			//标签单元格大小（像素）
			var unit:Number = this.area.width / axislength;
			//与边框间隙，参照最左边柱
			var margin:Number = unit * .2;
			//原始柱子的宽度
			var tempColumnWidth:Number = (unit - margin * 2) / shapenum;
			var space:Number = (shapenum == 1) ? 0 : tempColumnWidth * .1;
			
//			if(axislength == 0 && shapenum == 0)
//			{
//			destroy();
			
			if (_arrBars.length > 0)
			{
				invalidate("all");
				_arrBars = [];
			}else{
				for(var i:int = 0; i < axislength ; i ++)
				{
					for (var j:int = 0; j < dataProvider.data.length; j++)
					{
						var localXp:Number = margin + j * (tempColumnWidth + space);
						var type:int = dataProvider.data[j].useSubAxis ? 1 : 0;
						var h:Number = this.coordinateLogic.getPosition(dataProvider.data[j].value[i], type);
						var bar:UIComponent = new PureBar();
						bar.y = area.bottom;
//						bar.setSize(tempColumnWidth - space, h);
						bar.width = tempColumnWidth - space;
						bar.height = 0;
						bar.setStyle("color", _chartStyle.arrColors[j %  _chartStyle.arrColors.length]);
						bar.setStyle("borderColor", _chartStyle.outlineColor);
						bar.x = area.x + (i / axislength) * area.width + localXp;
						_container.addChild(bar);
						TweenMax.to(bar, 1, {height:h, ease:Cubic.easeOut});
						_arrBars.push(bar);
					}
					
				}
			}
		}
	}
	
}