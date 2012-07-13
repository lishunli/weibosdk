package com.weibo.charts
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.weibo.charts.style.ColumnChartStyle;
	import com.weibo.charts.ui.IBarUI;
	import com.weibo.charts.ui.tips.TipsManager;
	import com.weibo.core.UIComponent;
	import com.weibo.core.ValidateType;
	
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
		private var _tipsManager:TipsManager;
		
		private var _arrBars:Array = [];
		
//		private var _arrTips:Array = [];
		
		private var _lastLineNum:int;
		private var _lastAxisLen:int;
		
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
			_container =  new Sprite(); 
			addChild(_container);
			_tipContainer = new Sprite();
			addChild(_tipContainer);
//			_container.graphics.beginFill(0xff0cd0);
//			_container.graphics.drawCircle(0,0,90);
			
			if(_tipsManager == null)
			{
				_tipsManager = new TipsManager(this);
				_tipContainer = new Sprite();
				_tipContainer.mouseEnabled = _tipContainer.mouseChildren = false;
				addChild(_tipContainer);
			}
		}
		
		override protected function destroy():void
		{
			while(_container.numChildren > 0) _container.removeChildAt(0);
			while(_tipContainer.numChildren > 0) _tipContainer.removeChildAt(0);
			_arrBars = [];
//			_arrTips = [];
			
			_lastLineNum = 0;
			_lastAxisLen = 0;
			
			_tipsManager.destroy();
		}
		
		override protected function updateState():void
		{
			if (dataProvider == null) return;
			
			var axisLen:int = dataProvider.axis.length;
			var lineNum:int = dataProvider.data.length;
			
			var unit:Number = this.area.width / axisLen;//标签单元格大小（像素）
			var maxWidth:Number = _chartStyle.maxBarWidth;//最大宽度
			var tempColumnWidth:Number = (unit * .6) / lineNum;//原始柱子的宽度
			tempColumnWidth = Math.min(tempColumnWidth, maxWidth);
			var space:Number = (lineNum == 1) ? 0 : tempColumnWidth * .1;//柱子之间的间隔
			var margin:Number = unit - (tempColumnWidth - space) * lineNum - space * (lineNum -1);//与边框间隙，参照最左边柱
			margin /= 2;
			
			//创建
			if (_lastLineNum == 0){
				for(var i:int = 0; i < lineNum ; i ++)
				{
					for (var j:int = 0; j < axisLen; j++)
					{
						localXp = margin + i * (tempColumnWidth + space);
						var bar:UIComponent = new _chartStyle.barUI();
						bar.x = area.x + (j / axisLen) * area.width + localXp;
						bar.y = area.bottom;
						bar.width = tempColumnWidth - space;
						_container.addChild(bar);
						_arrBars.push(bar);
					}
				}
//				_tipsManager.init(_arrBars, _tipContainer);
			}
			//设置属性
			if (_lastLineNum == 0 || (_lastLineNum == lineNum && _lastAxisLen == axisLen)){
//				_tipsManager.updateInitState();
				for (i = 0; i < axisLen; i++)
				{
					for(j = 0; j < lineNum ; j ++)
					{
						var localXp:Number = margin + j * (tempColumnWidth + space);
						//使用主数值轴还是副数值轴的定位
						var type:int = dataProvider.data[j].useSubAxis ? 1 : 0;
						var h:Number = this.coordinateLogic.getPosition(dataProvider.data[j].value[i], type);
						h = area.height - h;
						bar = _arrBars[j*axisLen + i];
						if (_chartStyle.tipType > 0)
						{
							(bar as IBarUI).label = dataProvider.data[j].value[i];
						}
						
						var barColor:uint;
						if (_chartStyle.useDifferentColor)
							barColor = _chartStyle.colors[i %  _chartStyle.colors.length];
						else
							barColor = _chartStyle.colors[j %  _chartStyle.colors.length];
						
						bar.setStyle("color", barColor)
//						bar.setStyle("borderColor", _chartStyle.outlineColor);
						bar.setStyle("labelColor", _chartStyle.tipUseBarColor ? barColor : _chartStyle.tipColor);
						bar.setStyle("alpha", _chartStyle.tipAlpha);
						TweenLite.to(bar, 1, {
							x:area.x + (i / axisLen) * area.width + localXp,
							y:area.bottom,
							width:tempColumnWidth - space,
							height:h,
							ease:Cubic.easeOut
						});
					}
				}
			}
			else{
				this.invalidate(ValidateType.ALL);
			}
			_lastAxisLen = axisLen;
			_lastLineNum = lineNum;
		}
	}
	
}