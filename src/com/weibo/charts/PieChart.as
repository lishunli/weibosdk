package com.weibo.charts
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.weibo.charts.events.ChartEvent;
	import com.weibo.charts.style.PieChartStyle;
	import com.weibo.charts.ui.ChartUIBase;
	import com.weibo.charts.ui.ISectorUI;
	import com.weibo.core.UIComponent;
	import com.weibo.util.ColorUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class PieChart extends ChartBase
	{
		private var _chartStyle:PieChartStyle;
		
		private var _arrBars:Array = [];
		
		private var _tweenMaxes:Array = [];
		
		private var graphicsValue:Array;
		private var graphicsTotal:Number;
		
		private var _container:Sprite;
		
		
		private var totalNum:Number;
		
		private var errorSector:DisplayObject;
		
	//==========================================
	// 构造函数
	//------------------------------------------
		
		public function PieChart(style:PieChartStyle)
		{
			super(style);
			_chartStyle = style;
		}
		
	//==========================================
	// 接口
	//------------------------------------------
		
		public function get style():PieChartStyle
		{
			return _chartStyle;
		}
		
		override public function set dataProvider(value:Object):void
		{
//			area = new Rectangle(0, 0, chartWidth, chartHeight);
			totalNum = 0;
			for (var i:int = 0; i < value.length; i++)
			{
				totalNum += Number(value[i].value);
			}
			
			graphicsValue = [];
			graphicsTotal = 0;
			if (totalNum > 0)
			{
				for each (var o:Object in value)
				{
					var percent:Number = o.value / totalNum;
					var v:Number;
					if (percent > 0 && percent < 0.01)
						v = 0.01 * totalNum;
					else
						v = o.value;
					graphicsTotal += v;
					graphicsValue.push(v);
				}
			}
			
//			if (!axisLogic)
//			{
//				axisLogic = new RadiateLogic(this);
//			}
//			axisLogic.dataProvider = value;
			super.dataProvider = value;
			dispatchEvent(new ChartEvent(ChartEvent.CHART_DATA_CHANGED));
		}
		
	//==========================================
	// 私有方法
	//------------------------------------------
		
		override protected function create():void
		{
			if(_container == null){
				_container =  new Sprite(); 
				addChild(_container);
			}
		}
		
		override protected function destroy():void
		{
			if(_container != null) while(_container.numChildren > 0) _container.removeChildAt(0);
			_arrBars = [];
			
			while (_tweenMaxes.length > 0)
			{
				var tweenMax:TweenMax = _tweenMaxes.pop();
				tweenMax.complete(false, true);
			}
		}
		
		override protected function addEvents():void
		{
			super.addEvents();
			addEventListener(Event.RENDER, drawTipsHandler);
			if (_container) _container.addEventListener(MouseEvent.MOUSE_OVER, mouseShowTip);
			if (_container) _container.addEventListener(MouseEvent.MOUSE_OUT, mouseHideTip);
		}
		
		override protected function removeEvents():void
		{
			super.removeEvents();
			removeEventListener(Event.RENDER, drawTipsHandler);
			if (_container) _container.removeEventListener(MouseEvent.MOUSE_OVER, mouseShowTip);
			if (_container) _container.removeEventListener(MouseEvent.MOUSE_OUT, mouseHideTip);
		}
		
		override protected function updateState():void
		{
			if(dataProvider == null) return;
			
			var colors:Array;
			if (_chartStyle.colors)
			{
				colors = _chartStyle.colors;
			}
			else
			{
				var unit:int = 360 / dataProvider.length;
				colors = [];
				for (var j:int = 0; j < dataProvider.length; j++)
					colors.push(ColorUtil.HSB2RGB(j * unit, 70, 90));
			}
			
			
			
			area = new Rectangle(0, 0, chartWidth, chartHeight);
//			_tipContainer.visible = false;
			var sector:ISectorUI;
			var startAngle:Number;
			var tweenMax:TweenMax;
			if (errorSector && this.contains(errorSector)) this.removeChild(errorSector);
			
			if (dataProvider.length == 0 || totalNum == 0)
			{
				startAngle = -Math.PI / 2;
				sector = new this._chartStyle.sectorUI();
				sector.radius = Math.min(area.width / 2, area.height / 2);
				sector.radiusIn = _chartStyle.radiusIn;
				sector.startAngle = startAngle;
//				ChartUIBase(sector).outlineThicknesss = _chartStyle.gap;
				sector.endAngle = startAngle + Math.PI * 2;
				sector.x = area.x + area.width / 2;
				sector.y = area.y + area.height / 2;
				(sector as UIComponent).setStyle("color", _chartStyle.errorColor);
//				(sector as UIComponent).setStyle("borderThicknesss", _chartStyle.borderThicknesss);
				destroy();
				errorSector = sector as DisplayObject;
				addChild(errorSector);
				_arrBars.push(sector);
				drawTipsHandler(null);
			}
			else if (_arrBars.length == 0)
			{
				var total:int = dataProvider.length;
				startAngle = -Math.PI / 2;
				for(var i:int = 0; i < total ; i ++)
				{
					sector = new this._chartStyle.sectorUI();
					sector.index = i;
					sector.radius = Math.min(area.width / 2, area.height / 2);
					sector.radiusIn = _chartStyle.radiusIn;
					(sector as UIComponent).setStyle("color", colors[i %  colors.length]);
//					(sector as UIComponent).setStyle("outlineColor", _chartStyle.arrOutlineColors[i %  _chartStyle.arrOutlineColors.length]);
//					(sector as UIComponent).setStyle("borderThicknesss", _chartStyle.borderThicknesss);
					ChartUIBase(sector).outlineThicknesss = _chartStyle.gap;
					//为了能看到数据值很小的图形，设置最小值
					var sectorAngle:Number = Math.PI * 2 * (graphicsValue[i] / graphicsTotal);
					var endAngle:Number = startAngle + sectorAngle;
					endAngle = Math.min(endAngle, Math.PI * 2 - Math.PI / 2);
					endAngle = Math.max(endAngle, startAngle);
					sector.startAngle = startAngle;
					sector.endAngle = endAngle;
					_container.addChild(sector as DisplayObject);
					_arrBars.push(sector);
					
					var angle:Number = (endAngle + startAngle) / 2;
					DisplayObject(sector).x = area.x + area.width / 2 + Math.cos(angle) * leaveDistance;
					DisplayObject(sector).y = area.y + area.height / 2 + Math.sin(angle) * leaveDistance;
					var xpos:Number = area.x + area.width / 2;
					var ypos:Number = area.y + area.height / 2;
					
					if (total == 1)
					{
						DisplayObject(sector).x = xpos;
						DisplayObject(sector).y = ypos;
						refreshTip();
					}
					else
					{
						tweenMax = TweenMax.to(sector, 1, {x:xpos, ease:Cubic.easeOut, onComplete:refreshTip});
						TweenMax.to(sector, 1, {y:ypos, ease:Cubic.easeOut});
						_tweenMaxes.push(tweenMax);
					}
					startAngle = endAngle;
				}
			}else{
				if(_dataProvider.length == _arrBars.length)
				{
					startAngle = -Math.PI / 2;
					for(i = 0; i < _dataProvider.length; i ++)
					{
						sectorAngle = Math.PI * 2 * (graphicsValue[i] / graphicsTotal);
						endAngle = startAngle + sectorAngle;
						endAngle = Math.min(endAngle, Math.PI * 2 - Math.PI / 2);
						endAngle = Math.max(endAngle, startAngle);
						sector = _arrBars[i];
						tweenMax = TweenMax.to(sector, 1, {startAngle:startAngle, ease:Cubic.easeOut, onComplete:refreshTip});
						TweenMax.to(sector, 1, {endAngle:endAngle, ease:Cubic.easeOut});
						_tweenMaxes.push(tweenMax);
						
						startAngle = endAngle;
					}
				}else{
					this.invalidate("all");
					return;
				}
			}
			
		}
		
		private function refreshTip():void
		{
//			_tipContainer.visible = true;
			if (stage) stage.invalidate();
		}
		
		private function get leaveDistance():Number
		{
			var radius:Number = Math.min(area.width / 2, area.height / 2);
			var distance:Number = _chartStyle.leavePercent ? radius * _chartStyle.leavePercent: _chartStyle.leaveDistance;
			distance = Math.abs(distance);
			return distance;
		}
		
	//==========================================
	// 事件侦听器
	//------------------------------------------
		
		private function drawTipsHandler(event:Event):void
		{
			dispatchEvent(new ChartEvent(ChartEvent.CHART_TIPS_SHOW, _arrBars, true, true));
		}
		
		private function mouseShowTip(event:MouseEvent):void
		{
			var sector:ISectorUI = event.target as ISectorUI;
			
			var angle:Number = (sector.endAngle + sector.startAngle) / 2;
			
			var xpos:Number = area.x + area.width / 2 + Math.cos(angle) * leaveDistance;
			var ypos:Number = area.y + area.height / 2 + Math.sin(angle) * leaveDistance;
			sector.x = area.x + area.width / 2;
			sector.y = area.y + area.height / 2;
			
			if (dataProvider.length > 1)
			{
				TweenMax.to(sector, 1, {x:xpos, ease:Cubic.easeOut});
				TweenMax.to(sector, 1, {y:ypos, ease:Cubic.easeOut});
			}
		}
		
		private function mouseHideTip(event:MouseEvent):void
		{
			var xpos:Number = area.x + area.width / 2;
			var ypos:Number = area.y + area.height / 2;
			
			var sector:ISectorUI = event.target as ISectorUI;
			
			if (dataProvider.length > 1)
			{
				TweenMax.to(sector, 1, {x:xpos, ease:Cubic.easeOut});
				TweenMax.to(sector, 1, {y:ypos, ease:Cubic.easeOut});
			}
		}
		
		
	}
}