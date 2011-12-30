package com.weibo.charts
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.weibo.charts.style.ColumnChartStyle;
	import com.weibo.charts.ui.ChartUIBase;
	import com.weibo.charts.ui.IBarUI;
	import com.weibo.charts.ui.ITipUI;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;

	public class ColumnChart extends CoordinateChart
	{
		private var _style:ColumnChartStyle;
		
		private var _arrBars:Array = [];
		
		private var _arrTips:Array = [];
		
		private var _container:Sprite;
		
		private var _tipContainer:Sprite;
		
		public function ColumnChart(style:ColumnChartStyle)
		{
			super();
			_style = style;
			this.area = new Rectangle(0,0,style.baseStyle.width, style.baseStyle.height);
			this.chartWidht = _style.baseStyle.width;
			this.chartHeight = _style.baseStyle.height;
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
			_arrTips = [];
		}
		
		
		override protected function updateState():void
		{
			if(dataProvider != null)
			{
				var total:int = dataProvider.length;
				var space:Number = this.area.width / total;
				if(_arrBars.length == 0)
				{
					for(var i:int = 0; i < total ; i ++)
					{
						var bar:IBarUI = new _style.barUI();
						var uiWidth:Number = space * 0.5;
						if (uiWidth < 4) uiWidth = 4;
						ChartUIBase(bar).uiWidth = space * 0.6;
						var pheight:Number = this.coordinateLogic.getPosition(dataProvider[i]);
						ChartUIBase(bar).uiHeight = Math.round(area.bottom - pheight);
						ChartUIBase(bar).uiColor = _style.arrColors[i %  _style.arrColors.length];
						ChartUIBase(bar).uiAlpha = _style.barAlpha;
						ChartUIBase(bar).outlineColor = _style.outlineColor ? uint(_style.outlineColor) : _style.arrOutlineColors[i %  _style.arrOutlineColors.length];
						DisplayObject(bar).x = area.x +  space * 0.5  + i * space;
						DisplayObject(bar).y = area.bottom;
						_container.addChild(bar as DisplayObject);
						_arrBars[_arrBars.length] = bar;
						if(_style.baseStyle.tipType != 0)
						{
							var tip:ITipUI = new _style.tipUI();
							tip.setLabel(this.tipFun(dataProvider[i]), new TextFormat("Arial", null, ChartUIBase(bar).outlineColor));
							tip.show(_tipContainer, DisplayObject(bar).x - tip.uiWidth * 0.5 - 2, area.bottom ,this.area);	
							TweenMax.to(tip, 1, {y: Math.round(pheight - DisplayObject(tip).height), ease:Cubic.easeOut});
							_arrTips[_arrTips.length] = tip;
						}
					}
				}else{
					if(_dataProvider.length == _arrBars.length)
					{
						for(i = 0; i < _dataProvider.length; i ++)
						{
							bar = _arrBars[i];
							pheight = this.coordinateLogic.getPosition(dataProvider[i]);
							ChartUIBase(bar).uiHeight = Math.round(area.bottom - pheight);
							tip = _arrTips[i];
							tip.setLabel(this.tipFun(dataProvider[i]));
							var xpos:Number = area.x + space * 0.5 + i * space;
							TweenMax.to(bar, 1, {x: xpos, ease:Cubic.easeOut});
							TweenMax.to(tip, 1, {x: xpos - tip.uiWidth * 0.5, ease:Cubic.easeOut});
							TweenMax.to(tip, 1, {y: Math.round(pheight - DisplayObject(tip).height), ease:Cubic.easeOut});
						}
					}else{
						//全部重置、下一次渲染
						this.invalidate("all");
					}
				}
			}
		}
		
		
	}
}