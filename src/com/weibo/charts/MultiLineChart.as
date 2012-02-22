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
	import flash.geom.Rectangle;
	import flash.text.TextFormat;

	public class MultiLineChart extends CoordinateChart
	{
		private var _chartStyle:LineChartStyle;
		
		private var _dotArr:Array = [];
		
		private var _container:Sprite;
		
		private var _tweens:TweenMax;
		
		private var j:int = 0;
		private var m:int = 0;
		private var _space:Number = 0;
		private var _preLineLen:int;
		private var _preLineDots:int;
		
		public function MultiLineChart(style:LineChartStyle)
		{
			super();
			_chartStyle = style;
			this.coordinateLogic.integer = style.integer;
			this.area = new Rectangle(0,0,width,height);
		}
		
		override protected function create():void
		{
			trace("Function :: create");
			if (_container == null)
			{
				_container =  new Sprite(); 
				addChild(_container);
			}
		}
		
		override protected function destroy():void
		{
			_dotArr.length = 0;
			trace("Function :: destroy");
			
			j = 0;
			m = 0;
			_space = 0;
			_preLineLen = 0;
			_preLineDots = 0;
			
			if(_container != null)
			{
				_container.graphics.clear();
				while (_container.numChildren > 0) _container.removeChildAt(0);
			}			
		}
		
		
		override protected function updateState():void
		{
			trace("Function :: updateState");
			if (dataProvider == null) return;
			
			var pheight:Number;
			var tx:Number;
			var dot:IDotUI;
			
			var dataAry:Array = dataProvider["data"] as Array;
			var lineLen:int = dataAry.length;
			
			var lineDots:int = dataProvider["axis"].length;
			_space = this.area.width / lineDots;
			
			trace("~~~~~~~~~~~");
			trace("_dotArr.length :: " + _dotArr.length);
			trace("~~~~~~~~~~~");
			
			if(_dotArr.length == 0)
			{
				_container.graphics.clear();
				_container.graphics.lineStyle(_chartStyle.lineThickness, _chartStyle.lineColors[i]);
				this.graphics.beginFill(0, 0);
				this.graphics.drawRect(area.x, area.y, area.width, area.height);
				this.graphics.endFill();
				
				for (j = 0; j < lineLen; j++)
				{
					var dotAryT:Array = [];
					var type:int;
					_container.graphics.endFill();
					for(var i:int = 0; i < lineDots ; i ++)
					{
						type = dataProvider["data"][j]["useSubAxis"] ? 1 : 0;
						//pheight = Math.round(this.coordinateLogic.getPosition(dataProvider["data"][j]["value"][i]));
						pheight = Math.round(this.coordinateLogic.getPosition(dataProvider["data"][j]["value"][i], type));
						tx = Math.round(area.x +  _space * 0.5  + i * _space);
						dot = new _chartStyle.dotUI();
						ChartUIBase(dot).uiColor = _chartStyle.lineColors[j];
						DisplayObject(dot).x = tx;				
						DisplayObject(dot).y = area.bottom;
						TweenMax.to(dot, 0.5, { y: pheight, onUpdate:dotNextFrame} );
						_container.addChild(dot as DisplayObject);
						dotAryT[dotAryT.length] = dot;
						
						
					}
					_dotArr[_dotArr.length] = dotAryT;
					_container.graphics.endFill();
					
				}
				
				_preLineDots = lineDots;
				_preLineLen = lineLen;
				trace("_dotArr.length :: " + _dotArr.length);
				
			}else
			{
				if(_preLineLen == lineLen && _preLineDots == lineDots)
				{
					for (j = 0; j < lineLen; j++)
					{
						for (i = 0; i < lineDots; i++)
						{
							dot = _dotArr[j][i] as IDotUI;
							type = dataProvider["data"][j]["useSubAxis"] ? 1 : 0;
							pheight = Math.round(this.coordinateLogic.getPosition(dataProvider["data"][j]["value"][i],type));
							tx = Math.round(area.x +  _space * 0.5  + i * _space);
							_container.graphics.clear();
							TweenMax.to(dot, 0.5, { x: tx, ease:Cubic.easeOut } );
							TweenMax.to(dot, 0.5, { y: pheight, ease:Cubic.easeOut, onUpdate:dotNextFrame } );
						}
						
					}
					
				}else {
					//_dotArr.length = 0;
					trace("invalidate all :: " + _preLineDots);
					this.invalidate("all");
				}
			}
		}
		
		private function dotNextFrame():void
		{
			_container.graphics.clear();
			
			var color:uint;
			for (var j:int = 0, arrLen:int = _dotArr.length; j < arrLen; j++)
			{
				color = _chartStyle.lineColors[j];
				_container.graphics.lineStyle(_chartStyle.lineThickness, color);
				if (j == 0)
				{
					_container.graphics.beginFill(color, 0.3);
				}
				var firstDot:DisplayObject = _dotArr[j][0];
				_container.graphics.moveTo(firstDot.x, firstDot.y);
				var dot:DisplayObject;
				for(var i:int = 1, len:int = _dotArr[j].length; i < len; i ++)
				{
					dot = _dotArr[j][i];
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
		
		public function get dotArr():Array 
		{
			return _dotArr;
		}
		
	}
	
}