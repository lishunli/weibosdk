package com.weibo.charts
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.weibo.charts.data.RadiateLogic;
	import com.weibo.charts.events.ChartEvent;
	import com.weibo.charts.style.PieChartStyle;
	import com.weibo.charts.ui.ISectorUI;
	
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
		
		private var _container:Sprite;
		
		
		private var totalNum:Number;
		
		private var errorSector:DisplayObject;
		
	//==========================================
	// 构造函数
	//------------------------------------------
		
		public function PieChart(style:PieChartStyle)
		{
			super();
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
			
			if (!axisLogic)
			{
				axisLogic = new RadiateLogic(this);
			}
			axisLogic.dataProvider = value;
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
			addEventListener(Event.RENDER, drawTips);
			if (_container) _container.addEventListener(MouseEvent.MOUSE_OVER, mouseShowTip);
			if (_container) _container.addEventListener(MouseEvent.MOUSE_OUT, mouseHideTip);
		}
		
		override protected function removeEvents():void
		{
			super.removeEvents();
			removeEventListener(Event.RENDER, drawTips);
			if (_container) _container.removeEventListener(MouseEvent.MOUSE_OVER, mouseShowTip);
			if (_container) _container.removeEventListener(MouseEvent.MOUSE_OUT, mouseHideTip);
		}
		
		override protected function updateState():void
		{
			if(dataProvider != null)
			{
			area = new Rectangle(0, 0, chartWidth, chartHeight);
//				_tipContainer.visible = false;
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
					sector.endAngle = startAngle + Math.PI * 2;
					sector.x = area.x + area.width / 2;
					sector.y = area.y + area.height / 2;
					sector.uiColor = _chartStyle.errorColor;
					sector.outlineThicknesss = _chartStyle.borderThicknesss;
					destroy();
					errorSector = sector as DisplayObject;
					addChild(errorSector);
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
						sector.uiColor = _chartStyle.arrColors[i %  _chartStyle.arrColors.length];
						sector.outlineColor = _chartStyle.arrOutlineColors[i %  _chartStyle.arrOutlineColors.length];
						sector.outlineThicknesss = _chartStyle.borderThicknesss;
						var sectorAngle:Number = Math.PI * 2 * (dataProvider[i].value / totalNum);
						var endAngle:Number = startAngle + sectorAngle;
						sector.startAngle = startAngle;
						sector.endAngle = endAngle;
						_container.addChild(sector as DisplayObject);
						_arrBars.push(sector);
						
						var angle:Number = (endAngle + startAngle) / 2;
						DisplayObject(sector).x = area.x + area.width / 2 + Math.cos(angle) * 50;
						DisplayObject(sector).y = area.y + area.height / 2 + Math.sin(angle) * 50;
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
							sectorAngle = Math.PI * 2 * (dataProvider[i].value / totalNum);
							endAngle = startAngle + sectorAngle;
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
		}
		
		private function refreshTip():void
		{
//			_tipContainer.visible = true;
			if (stage) stage.invalidate();
		}
		
	//==========================================
	// 事件侦听器
	//------------------------------------------
		
		private function drawTips(event:Event):void
		{
			dispatchEvent(new ChartEvent(ChartEvent.CHART_TIPS_SHOW, _arrBars, true, true));
		}
		
		private function mouseShowTip(event:MouseEvent):void
		{
			var sector:ISectorUI = event.target as ISectorUI;
			
			var angle:Number = (sector.endAngle + sector.startAngle) / 2;
			var xpos:Number = area.x + area.width / 2 + Math.cos(angle) * 5;
			var ypos:Number = area.y + area.height / 2 + Math.sin(angle) * 5;
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