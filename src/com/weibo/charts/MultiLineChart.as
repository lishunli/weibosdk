package com.weibo.charts
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.weibo.charts.style.LineChartStyle;
	import com.weibo.charts.ui.ChartUIBase;
	import com.weibo.charts.ui.IDotUI;
	import com.weibo.charts.ui.ITipUI;
	import flash.geom.Point;
	import ui.MultiLineTip;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;

	public class MultiLineChart extends CoordinateChart
	{
		private var _chartStyle:LineChartStyle;
		
		public var _arrDots:Array = [];
		
		private var _container:Sprite;
		
		private var _tipContainer:Sprite;
		
		private var _arrTips:Array = [];
		
		private var _tweens:TweenMax;
		
		private var j:int = 0;
		private var m:int = 0;
		private var point:Point;
		private var _tip:MultiLineTip;
		private var _space:Number = 0;
		private var preInd:int;
		
		public function MultiLineChart(style:LineChartStyle)
		{
			super();
			_chartStyle = style;
			this.area = new Rectangle(0,0,width,height);
		}
		
		override protected function create():void
		{
			if (_container == null)
			{
				_container =  new Sprite(); 
				addChild(_container);
			}
			if(_tipContainer == null){
				_tipContainer = new Sprite();
				_tipContainer.mouseEnabled = _tipContainer.mouseChildren = false;
				addChild(_tipContainer);
			}
			if (_tip == null)
			{
				_tip = new MultiLineTip();
			}
		}
		
		override protected function destroy():void
		{
			_arrDots = [];
			_arrTips = [];
			if(_container != null)
			{
				_container.graphics.clear();
				while(_container.numChildren > 0) _container.removeChildAt(0);
			}
			if (_tipContainer != null) while (_tipContainer.numChildren > 0) _tipContainer.removeChildAt(0);
			if (_tip != null)
			{
				if (contains(_tip))  removeChild(_tip);
				_tip = null;
				
			}
		}
		
		
		override protected function updateState():void
		{
			if (dataProvider == null) return;
			
			var total:int = dataProvider["axis"].length;
			_space = this.area.width / total;
			if(_arrDots.length == 0)
			{
				_container.graphics.lineStyle(_chartStyle.lineThickness, _chartStyle.lineColors[i]);
				this.graphics.beginFill(0, 0);
				this.graphics.drawRect(area.x, area.y, area.width, area.height);
				this.graphics.endFill();
				
				var pheight:Number;
				var tx:Number;
				var dot:IDotUI;
				var tip:ITipUI;
				var dataAry:Array = dataProvider["data"] as Array;
				var len:int = dataAry.length;
				
				for (j = 0; j < len; j++)
				{
					var dotAryT:Array = [];
					_container.graphics.endFill();
					for(var i:int = 0; i < total ; i ++)
					{
						pheight = Math.round(this.coordinateLogic.getPosition(dataProvider["data"][j]["value"][i]));
						tx = Math.round(area.x +  _space * 0.5  + i * _space);
						dot = new _chartStyle.dotUI();
						ChartUIBase(dot).uiColor = _chartStyle.lineColors[j];
						DisplayObject(dot).x = tx;				
						DisplayObject(dot).y = area.bottom;
						TweenMax.to(dot, 0.5, { y: pheight, onUpdate:dotNextFrame} );
						_container.addChild(dot as DisplayObject);
						dotAryT[dotAryT.length] = dot;
						
						
					}
					_arrDots[_arrDots.length] = dotAryT;
					_container.graphics.endFill();
					
				}
			}else{
				//if(_dataProvider.length == _arrDots.length)
				//{
					//for(i = 0; i < _dataProvider.length; i ++)
					//{
						//dot = _arrDots[i];
						//pheight = this.coordinateLogic.getPosition(dataProvider[i]);
						//tip = _arrTips[i];
						//tip.setLabel(this.tipFun(dataProvider[i]));
						//_container.graphics.clear();
						//tx = Math.round(area.x +  _space * 0.5  + i * _space);
						//if (i == 0) _tweens = TweenMax.to(dot, 1, { x: tx, ease:Cubic.easeOut} );
						//else TweenMax.to(dot, 1, {x: tx, ease:Cubic.easeOut});
						//TweenMax.to(dot, 1, {y: Math.round(pheight), ease:Cubic.easeOut, onUpdate:dotNextFrame});
					//}
				//}else {
					//if (_tweens != null) {
						//_tweens.complete(true,false);
						//_tweens = null;
					//}
					//
					//this.invalidate("all");
				//}
			}
		}
		
		private function dotNextFrame():void
		{
			_container.graphics.clear();
			
			var color:uint;
			for (var j:int = 0, arrLen:int = _arrDots.length; j < arrLen; j++)
			{
				color = _chartStyle.lineColors[j];
				_container.graphics.lineStyle(_chartStyle.lineThickness, color);
				if (j == 0)
				{
					_container.graphics.beginFill(color, 0.3);
				}
				var firstDot:DisplayObject = _arrDots[j][0];
				_container.graphics.moveTo(firstDot.x, firstDot.y);
				var dot:DisplayObject;
				for(var i:int = 1, len:int = _arrDots[j].length; i < len; i ++)
				{
					dot = _arrDots[j][i];
					_container.graphics.lineTo(dot.x, dot.y);
					
				}
				if (j == 0)
				{
					_container.graphics.lineStyle();
					_container.graphics.lineTo(dot.x, area.bottom);
					_container.graphics.lineTo(firstDot.x, area.bottom);
					_container.graphics.lineTo(firstDot.x, firstDot.y);
					_container.graphics.endFill();
				}
			}
			
		}
		
		override protected function addEvents():void
		{
			//addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
		}
		
		private function onStageMouseMove(e:MouseEvent):void 
		{
			point = new Point(e.stageX, e.stageY);
			var lX:Number = e.localX - (_space * .5);
			var ind:int = int(((lX - area.x) / _space)  + .5);
			for (var i:int = 0; i < _arrDots.length; i++)
			{
				_arrDots[i][preInd]["outThis"]();
				_arrDots[i][ind]["overThis"]();
			}
			preInd = ind;
			
			_tip.show(this, globalToLocal(point).x, globalToLocal(point).y, this.area);
			_tip.setLabel("是大家法拉盛的房间");
		}
		
		override protected function removeEvents():void
		{
			//removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
		}
		
	}
	
}