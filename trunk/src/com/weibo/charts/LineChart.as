package com.weibo.charts
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.weibo.charts.style.LineChartStyle;
	import com.weibo.charts.ui.ChartUIBase;
	import com.weibo.charts.ui.IDotUI;
	import com.weibo.charts.ui.ITipUI;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;

	public class LineChart extends CoordinateChart
	{
		private var _chartStyle:LineChartStyle;
		
		private var _arrDots:Array = [];
		
		private var _container:Sprite;
		
		private var _tipContainer:Sprite;
		
		private var _arrTips:Array = [];
		
		private var _tweens:TweenMax;
		
		public function LineChart(style:LineChartStyle)
		{
			super();
			_chartStyle = style;
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
			if(_tipContainer != null) while(_tipContainer.numChildren > 0) _tipContainer.removeChildAt(0);		
		}
		
		
		override protected function updateState():void
		{
			if (dataProvider == null) return;
			
			var total:int = dataProvider.length;
			var space:Number = this.area.width / total;
			if(_arrDots.length == 0)
			{
				_container.graphics.lineStyle(_chartStyle.lineThickness, _chartStyle.arrColors[0]);		
				
				var pheight:Number;
				var tx:Number;
				var dot:IDotUI;
				var tip:ITipUI;
				
				for(var i:int = 0; i < total ; i ++)
				{
					pheight = Math.round(this.coordinateLogic.getPosition(dataProvider[i].value));
					tx = Math.round(area.x +  space * 0.5  + i * space);
					dot = new _chartStyle.dotUI();
					ChartUIBase(dot).uiColor = _chartStyle.arrColors[i %  _chartStyle.arrColors.length];
					DisplayObject(dot).x = tx;				
					DisplayObject(dot).y = area.bottom;
					TweenMax.to(dot, 0.5,{y: pheight, onUpdate:doitNextFrame});
					_container.addChild(dot as DisplayObject);
					_arrDots[_arrDots.length] = dot;
					
					DisplayObject(dot).addEventListener(MouseEvent.ROLL_OVER, overDot);
					DisplayObject(dot).addEventListener(MouseEvent.ROLL_OUT, outDot);
					
					if(_chartStyle.baseStyle.tipType != 0)
					{			
						tip = new _chartStyle.tipUI();
						tip.setLabel(this.getStyle("tipFun")(dataProvider[i]), new TextFormat("Arial", null, 0xffffff));
						ChartUIBase(tip).uiColor = _chartStyle.arrColors[i %  _chartStyle.arrColors.length];
//						tip.show(_tipContainer, tx, pheight, this.area);							
						_tipContainer.addChild(tip as DisplayObject);
						_arrTips[_arrTips.length] = tip;
					}
				}
			}else{
				if(_dataProvider.length == _arrDots.length)
				{
					for(i = 0; i < _dataProvider.length; i ++)
					{
						dot = _arrDots[i];
						pheight = this.coordinateLogic.getPosition(dataProvider[i].value);
						tip = _arrTips[i];
						tip.setLabel(this.getStyle("tipFun")(dataProvider[i]));
						_container.graphics.clear();
						tx = Math.round(area.x +  space * 0.5  + i * space);
						if (i == 0) _tweens = TweenMax.to(dot, 1, { x: tx, ease:Cubic.easeOut} );
						else TweenMax.to(dot, 1, {x: tx, ease:Cubic.easeOut});
						TweenMax.to(dot, 1, {y: Math.round(pheight), ease:Cubic.easeOut, onUpdate:doitNextFrame});
					}
				}else {
					if (_tweens != null) {
						_tweens.complete(true,false);
						_tweens = null;
					}
					
					this.invalidate("all");
				}
			}
		}
		
		protected function outDot(event:Event):void
		{
			var dot:Object = event.target;
			var id:int = _arrDots.indexOf(dot);
			var tip:ITipUI = _arrTips[id];
			tip.hide();
		}
		
		protected function overDot(event:Event):void
		{
			var dot:Object = event.target;
			var id:int = _arrDots.indexOf(dot);
			var tip:ITipUI = _arrTips[id];
			tip.show(_tipContainer, DisplayObject(dot).x,  DisplayObject(dot).y, this.area);
		}
		
		private function doitNextFrame():void
		{
			addEventListener(Event.ENTER_FRAME, tweenning);
		}
		
		private function tweenning(e:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, tweenning);
			_container.graphics.clear();
			_container.graphics.lineStyle(_chartStyle.lineThickness, _chartStyle.lineColor);		
			var dot:DisplayObject = _arrDots[0];
			_container.graphics.moveTo(dot.x, dot.y);
			for(var i:int = 1, len:int = _arrDots.length; i < len; i ++)
			{
				dot = _arrDots[i];
				_container.graphics.lineTo(dot.x, dot.y);
			}
			drawShadow();
		}
		
		private function drawShadow():void
		{
			_container.graphics.lineStyle();
			_container.graphics.beginFill(0x9a9a9a, 0.12);
			var firstDot:DisplayObject = _arrDots[0];
			_container.graphics.moveTo(firstDot.x, firstDot.y);
			for(var i:int = 1, len:int = _arrDots.length; i < len; i ++)
			{
				var dot:DisplayObject = _arrDots[i];
				_container.graphics.lineTo(dot.x, dot.y);
			}
			var finalDot:DisplayObject = _arrDots[_arrDots.length - 1];
			_container.graphics.lineTo(finalDot.x, area.bottom);
			_container.graphics.lineTo(firstDot.x, area.bottom);
			_container.graphics.lineTo(firstDot.x, firstDot.y);
		}
		
	}
	
}