package com.weibo.charts
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.weibo.charts.style.ColumnChartStyle;
	import com.weibo.charts.ui.IBarUI;
	import com.weibo.charts.ui.bars.PureBar;
	import com.weibo.core.UIComponent;
	
	import flash.display.Sprite;

	/**
	 * 
	 * yaofei
	 */
	public class ColumnChart extends CoordinateChart
	{
		private var _chartStyle:ColumnChartStyle;
		
		private var _container:Sprite;
		private var _tipContainer:Sprite;
		
		private var _arrBars:Array = [];
		
//		private var _arrTips:Array = [];
		
		public function ColumnChart(style:ColumnChartStyle)
		{
			_chartStyle = style;
			style.touchSide = false;
			super(_chartStyle);
//			this.coordinateLogic.integer = style.integer;
//			this.coordinateLogic.alwaysShow0 = style.alwaysShow0;
//			this.coordinateLogic.addMore = style.gridStyle.addMore;
			
//			setStyle("maxBarWidth", 30);
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
			
			var maxWidth:Number = _chartStyle.maxBarWidth;//getStyle("maxBarWidth") as Number;
			//原始柱子的宽度
			var tempColumnWidth:Number = (unit * .6) / shapenum;
			tempColumnWidth = Math.min(tempColumnWidth, maxWidth);
			//柱子之间的间隔
			var space:Number = (shapenum == 1) ? 0 : tempColumnWidth * .1;
			//与边框间隙，参照最左边柱
			var margin:Number = unit - (tempColumnWidth - space) * shapenum - space * (shapenum -1);
			margin /= 2;
//			if(axislength == 0 && shapenum == 0)
//			{
//			destroy();
			
			if (_arrBars.length > 0)
			{
				invalidate("all");
				_arrBars = [];
			} else {
				for(var i:int = 0; i < axislength ; i ++)
				{
					for (var j:int = 0; j < shapenum; j++)
					{
						var localXp:Number = margin + j * (tempColumnWidth + space);
						//使用主数值轴还是副数值轴的定位
						var type:int = dataProvider.data[j].useSubAxis ? 1 : 0;
						var h:Number = this.coordinateLogic.getPosition(dataProvider.data[j].value[i], type);
						h = area.height - h;
						
						var bar:UIComponent = new _chartStyle.barUI();
//						bar.setStyle("labelFun", _chartStyle.tipFun);
//						bar.setStyle("label", getStyle("label"));
						if (_chartStyle.tipType > 0)
						{
							(bar as IBarUI).label = dataProvider.data[j].value[i];
						}
						bar.y = area.bottom;
//						bar.setSize(tempColumnWidth - space, h);
						bar.width = tempColumnWidth - space;
						bar.height = 0;
						var barColor:uint;
						if (_chartStyle.useDifferentColor)
							barColor = _chartStyle.colors[i %  _chartStyle.colors.length];
						else
							barColor = _chartStyle.colors[j %  _chartStyle.colors.length];
						bar.setStyle("color", barColor)
//						bar.setStyle("borderColor", _chartStyle.outlineColor);
						bar.setStyle("labelColor", _chartStyle.tipUseBarColor ? barColor : _chartStyle.tipColor);
						bar.setStyle("alpha", _chartStyle.tipAlpha);
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