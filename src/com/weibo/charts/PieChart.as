package com.weibo.charts
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.weibo.charts.data.RadiateCoordinateLogic;
	import com.weibo.charts.events.ChartEvent;
	import com.weibo.charts.managers.RepaintManager;
	import com.weibo.charts.style.PieChartStyle;
	import com.weibo.charts.ui.ISectorUI;
	import com.weibo.charts.ui.ITipUI;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;

	public class PieChart extends ChartBase
	{
		private var _style:PieChartStyle;
		
		private var _arrBars:Array = [];
		
		private var _arrTips:Array = [];
		
		private var _tweenMaxes:Array = [];
		
		private var _container:Sprite;
		
		private var _tipContainer:Sprite;
		
		private var totalNum:Number;
		
		private var errorSector:DisplayObject;
		
		public function PieChart(style:PieChartStyle)
		{
			super();
			_style = style;
			this.area = new Rectangle(0, 0, style.baseStyle.width, style.baseStyle.height);
			this.chartWidht = style.baseStyle.width;
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
				_tipContainer.mouseEnabled = false;
				_tipContainer.mouseChildren = false;
				addChild(_tipContainer);
			}
		}
		
		override protected function destroy():void
		{
			if(_container != null) while(_container.numChildren > 0) _container.removeChildAt(0);
			if(_tipContainer != null) while(_tipContainer.numChildren > 0) _tipContainer.removeChildAt(0);
			_arrBars = [];
			_arrTips = [];
			
			while (_tweenMaxes.length > 0)
			{
				var tweenMax:TweenMax = _tweenMaxes.pop();
				tweenMax.complete(false, true);
			}
		}
		
		override protected function addEvents():void
		{
			super.addEvents();
//			addEventListener(Event.RENDER, drawTips);
			if (_container) _container.addEventListener(MouseEvent.MOUSE_OVER, mouseShowTip);
			if (_container) _container.addEventListener(MouseEvent.MOUSE_OUT, mouseHideTip);
		}
		
		override protected function removeEvents():void
		{
			super.removeEvents();
//			removeEventListener(Event.RENDER, drawTips);
			if (_container) _container.removeEventListener(MouseEvent.MOUSE_OVER, mouseShowTip);
			if (_container) _container.removeEventListener(MouseEvent.MOUSE_OUT, mouseHideTip);
		}
		
		override public function set dataProvider(value:Array):void
		{
			area = new Rectangle(0, 0, chartWidht, chartHeight);
			totalNum = 0;
			for (var i:int = 0; i < value.length; i++)
			{
				totalNum += Number(value[i].value);
			}
			
			if (!axisLogic)
			{
				axisLogic = new RadiateCoordinateLogic(this);
			}
			axisLogic.dataProvider = value;
			super.dataProvider = value;
			dispatchEvent(new ChartEvent(ChartEvent.CHART_DATA_CHANGED));
		}
		
		override protected function updateState():void
		{
			if(dataProvider != null)
			{
				_tipContainer.visible = false;
				var sector:ISectorUI;
				var startAngle:Number;
				var tweenMax:TweenMax;
				if (errorSector && this.contains(errorSector)) this.removeChild(errorSector);
				if (dataProvider.length == 0 || totalNum == 0)
				{
					startAngle = -Math.PI / 2;
					sector = new this._style.sectorUI();
					sector.radius = Math.min(area.width / 2, area.height / 2);
					sector.radiusIn = _style.radiusIn;
					sector.startAngle = startAngle;
					sector.endAngle = startAngle + Math.PI * 2;
					sector.x = area.x + area.width / 2;
					sector.y = area.y + area.height / 2;
					sector.uiColor = _style.errorColor;
					sector.outlineThicknesss = _style.borderThicknesss;
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
						sector = new this._style.sectorUI();
						sector.index = i;
						sector.radius = Math.min(area.width / 2, area.height / 2);
						sector.radiusIn = _style.radiusIn;
						sector.uiColor = _style.arrColors[i %  _style.arrColors.length];
						sector.outlineColor = _style.arrOutlineColors[i %  _style.arrOutlineColors.length];
						sector.outlineThicknesss = _style.borderThicknesss;
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
						_validateTypeObject["all"] = true;
						RepaintManager.getInstance().addToRepaintQueue(this);
						return;
					}
				}
				
				while (_tipContainer.numChildren > 0)	_tipContainer.removeChildAt(0);
//				if (dataProvider.length != 0 && totalNum != 0) drawTips();
			}
		}
		
		private function refreshTip():void
		{
//			if (stage) stage.invalidate();
			_tipContainer.visible = true;
		}
		
		private function mouseShowTip(event:MouseEvent):void
		{
			_tipContainer.graphics.clear();
			_tipContainer.graphics.lineStyle(1, this._style.lineColor, this._style.lineAlpha);
			
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
			
			if (sector) drawOneTip(sector);
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
			
			_tipContainer.graphics.clear();
			while (_tipContainer.numChildren > 0)	_tipContainer.removeChildAt(0);
		}
		
		/**
		 * 鼠标滑过时显示单一注释
		 * @param sector
		 */		
		private function drawOneTip(sector:ISectorUI):void
		{
			if (sector == null) return;
			
			var middleAngle:Number = (sector.startAngle + sector.endAngle) / 2;
			var dotIn:Number = Math.min((sector.radius - sector.radiusIn) / 2, 10);
			var x1:Number = area.x + area.width / 2 + Math.cos(middleAngle) * (sector.radius - dotIn);
			var y1:Number = area.y + area.height / 2 + Math.sin(middleAngle) * (sector.radius - dotIn);
			var margin:Number = 30;
//			var x2:Number = area.x + area.width / 2 + Math.cos(middleAngle) * (sector.radius + dotIn);
//			var y2:Number = area.y + area.height / 2 + Math.sin(middleAngle) * (sector.radius + dotIn);
			
			var dot:Shape = new Shape();
			_tipContainer.addChild(dot);
			dot.graphics.clear();
			dot.graphics.beginFill(this._style.lineColor, this._style.lineAlpha);
			dot.graphics.drawCircle(x1, y1, 3);
			
			_tipContainer.graphics.moveTo(x1, y1);
//			_tipContainer.graphics.lineTo(x2, y2);
			
			
			var tip:ITipUI = new _style.tipUI();
			var tf:TextFormat = new TextFormat("Arial", null, _style.tipColor);
			tip.setLabel(this.tipFun(dataProvider[sector.index]), tf);
			_tipContainer.addChild(tip as DisplayObject);
			_arrTips[_arrTips.length] = tip;
			
			var leftTop:Point = globalToLocal(new Point(0, 0));
			var rect:Rectangle = new Rectangle(leftTop.x, leftTop.y, stage.stageWidth, stage.stageHeight);
			rect.inflate(-5, -5);
//			_tipContainer.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			//拐角方向:右
			if (Math.cos(middleAngle) > 0)
			{
				//拐角方向:右上
				if (Math.sin(middleAngle) < 0)
				{
					tip.x = rect.right - tip.uiWidth;
					tip.y = rect.y;
					_tipContainer.graphics.lineTo(rect.right - tip.uiWidth, rect.y + tip.uiHeight / 2);
					_tipContainer.graphics.lineTo(rect.right, 				rect.y + tip.uiHeight / 2);
				}
				//拐角方向:右下
				else
				{
					tip.x = rect.right - tip.uiWidth;
					tip.y = rect.bottom - tip.uiHeight;
					_tipContainer.graphics.lineTo(rect.right - tip.uiWidth, rect.bottom - tip.uiHeight / 2);
					_tipContainer.graphics.lineTo(rect.right, 				rect.bottom - tip.uiHeight / 2);
				}
				
			}
			//拐角方向:左
			else
			{
				//拐角方向:左上
				if (Math.sin(middleAngle) < 0)
				{
					tip.x = rect.x;
					tip.y = rect.y;
					_tipContainer.graphics.lineTo(rect.x + tip.uiWidth, rect.y + tip.uiHeight / 2);
					_tipContainer.graphics.lineTo(rect.x, 				rect.y + tip.uiHeight / 2);
				}
				//拐角方向:左下
				else
				{
					tip.x = rect.x;
					tip.y = rect.bottom - tip.uiHeight;
					_tipContainer.graphics.lineTo(rect.x + tip.uiWidth, rect.bottom - tip.uiHeight / 2);
					_tipContainer.graphics.lineTo(rect.x, 				rect.bottom - tip.uiHeight / 2);
				}
			}
		}
		
		private function drawTips(event:Event=null):void
		{
			_tipContainer.graphics.clear();
			_tipContainer.graphics.lineStyle(1, this._style.lineColor, this._style.lineAlpha);
			var i:int;
			if (_dataProvider.length != _arrBars.length) trace("PieChart:length", _dataProvider.length);
			for(i = 0; i < _arrBars.length; i ++)
			{
				var sector:ISectorUI = _arrBars[i];
				
				var middleAngle:Number = (sector.startAngle + sector.endAngle) / 2;
				var dotIn:Number = Math.min((sector.radius - sector.radiusIn) / 2, 10);
				var x1:Number = area.x + area.width / 2 + Math.cos(middleAngle) * (sector.radius - dotIn);
				var y1:Number = area.y + area.height / 2 + Math.sin(middleAngle) * (sector.radius - dotIn);
				var margin:Number = 30;
				var x2:Number = area.x + area.width / 2 + Math.cos(middleAngle) * (sector.radius + dotIn);
				var y2:Number = area.y + area.height / 2 + Math.sin(middleAngle) * (sector.radius + dotIn);
				
				var dot:Shape = new Shape();
				_tipContainer.addChild(dot);
				dot.graphics.clear();
				dot.graphics.beginFill(this._style.lineColor, this._style.lineAlpha);
				dot.graphics.drawCircle(x1, y1, 3);
				
				_tipContainer.graphics.moveTo(x1, y1);
				_tipContainer.graphics.lineTo(x2, y2);
				
				
				var tip:ITipUI = new _style.tipUI();
				var tf:TextFormat = new TextFormat("Arial", null, _style.tipColor);
				tip.setLabel(this.tipFun(dataProvider[i]), tf);
				_tipContainer.addChild(tip as DisplayObject);
				_arrTips[_arrTips.length] = tip;
				
				
				//拐角方向:右
				if (Math.cos(middleAngle) > 0)
				{
					_tipContainer.graphics.lineTo(x2, y2);
					_tipContainer.graphics.lineTo(x2 + DisplayObject(tip).width, y2);
					DisplayObject(tip).x = x2;
					DisplayObject(tip).y = y2 - DisplayObject(tip).height;
				}
				//拐角方向:左
				else
				{
					_tipContainer.graphics.lineTo(x2, y2);
					_tipContainer.graphics.lineTo(x2 - DisplayObject(tip).width, y2);
					DisplayObject(tip).x = x2 - DisplayObject(tip).width;
					DisplayObject(tip).y = y2 - DisplayObject(tip).height;
				}
			}
		}
	}
}