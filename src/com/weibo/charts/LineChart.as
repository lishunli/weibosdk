package com.weibo.charts
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.weibo.charts.style.LineChartStyle;
	import com.weibo.charts.ui.ChartUIBase;
	import com.weibo.charts.ui.IDotUI;
	import com.weibo.charts.ui.ITipUI;
	import com.weibo.charts.ui.dots.NullDot;
	import com.weibo.charts.ui.tips.TipsManager;
	import com.weibo.charts.utils.ColorUtil;
	import com.weibo.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;

	public class LineChart extends CoordinateChart
	{
		/**
		 * 图表样式 
		 */		
		private var _chartStyle:LineChartStyle;
		
		private var _dotArr:Array = [];
		
		private var _shapeContainer:Sprite;
		
		private var _tipContainer:Sprite;
		private var _tipsManager:TipsManager
		
		private var _arrTips:Array = [];
		private var _arrDots:Array = [];
		
		private var _tweens:TweenMax;
		
		private var j:int = 0;
		private var _space:Number = 0;
		private var _preLineLen:int;
		private var _preLineDots:int;
		
		public function LineChart(style:LineChartStyle)
		{
			_chartStyle = style;
			super(style);		
//			this.coordinateLogic.integer = style.integer;
//			this.coordinateLogic.alwaysShow0 = true;
//			this.coordinateLogic.touchSide = style.touchSide;
//			this.coordinateLogic.addMore = style.gridStyle.addMore;
//			this.area = new Rectangle(0,0,width,height);
		}
		
		
		
		public function get dotArr():Array 
		{
			return _dotArr;
		}
		
		
		override protected function create():void
		{
			if (_shapeContainer == null)
			{
				_shapeContainer =  new Sprite();
				addChild(_shapeContainer);
			}
			
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
//			_dotArr.length = 0;
			_dotArr = [];
			
			j = 0;
			_space = 0;
			_preLineLen = 0;
			_preLineDots = 0;
			
			if(_shapeContainer != null)
			{
				_shapeContainer.graphics.clear();
				while (_shapeContainer.numChildren > 0) _shapeContainer.removeChildAt(0);
//				_shapeContainer = null;
			}
			
			_arrTips = [];
			_arrDots = [];
			
			_tipsManager.destroy();
		}
		
		override protected function updateState():void
		{
			if (dataProvider == null) return;
			
			var pheight:Number;
			var tx:Number;
			var dot:IDotUI;
			var tip:ITipUI;
			var tipFun:Function = this.getStyle("tipFun") as Function;
			var tipStr:String = "";
			
			var dataAry:Array = dataProvider["data"] as Array;
			var lineLen:int = dataAry.length;
			
			var lineDots:int = dataProvider["axis"].length;
			
			if(lineDots > 1) _space = _chartStyle.touchSide ? this.area.width/(lineDots-1) : this.area.width/lineDots;
			else _space = _chartStyle.touchSide ? 0 : this.area.width * 0.5;

			if (_dotArr.length == 0)
			{
				for (j = 0; j < lineLen; j++)
				{
					var dotAryT:Array = [];
					var type:int;
					var lineShape:LineShape = getChildShapeAt(j) as LineShape;
					for(var i:int = 0; i < lineDots ; i ++)
					{
						var valueData:Array = coordinateLogic.dataProvider.data[j]["value"];
						
						type = dataProvider["data"][j]["useSubAxis"] ? 1 : 0;
						pheight = Math.round(area.y + this.coordinateLogic.getPosition(dataProvider["data"][j]["value"][i], type));
						if(lineDots > 1) tx = _chartStyle.touchSide ? Math.round(area.x + i * _space) : Math.round(area.x + i * _space + _space * 0.5);
						else tx = Math.round(area.x + _space);
						var DotClass:Class = _chartStyle.dotUI || NullDot;
						dot = new DotClass();
						ChartUIBase(dot).uiColor = _chartStyle.colors[j % _chartStyle.colors.length];
						DisplayObject(dot).x = tx;	
						
						DisplayObject(dot).y = area.bottom;
						TweenMax.to(dot, 0.5, { y: pheight, onUpdate:dotNextFrame} );		
						lineShape.addChild(dot as DisplayObject);
						dotAryT[dotAryT.length] = dot;	
						_arrDots[_arrDots.length] = dot;					
					}
					_dotArr[_dotArr.length] = dotAryT;		
				}		
				_tipsManager.init(_arrDots, _tipContainer);
				_preLineDots = lineDots;
				_preLineLen = lineLen;			
			}
			else
			{
				if (_preLineLen == lineLen && _preLineDots == lineDots)
				{
					_tipsManager.updateInitState();
					for (j = 0; j < lineLen; j++)
					{
						for (i = 0; i < lineDots; i++)
						{
							valueData = coordinateLogic.dataProvider.data[j]["value"];							
							dot = _dotArr[j][i] as IDotUI;
							ChartUIBase(dot).uiColor = _chartStyle.colors[j % _chartStyle.colors.length];
							type = dataProvider["data"][j]["useSubAxis"] ? 1 : 0;
							pheight = Math.round(area.y + this.coordinateLogic.getPosition(dataProvider["data"][j]["value"][i],type));

							if(lineDots > 1) tx = _chartStyle.touchSide ? Math.round(area.x + i * _space) : Math.round(area.x + i * _space + _space * 0.5);
							else tx = Math.round(area.x + _space);
//							_container.graphics.clear();
							TweenMax.to(dot, 0.5, { x: tx, ease:Cubic.easeOut } );
							TweenMax.to(dot, 0.5, { y: pheight, ease:Cubic.easeOut, onUpdate:dotNextFrame } );
						}			
					}
				}
				else
				{
					this.invalidate("all");
				}
			}
		}
		
		private function dotNextFrame():void
		{
			var backThichness:Number = _chartStyle.lineThickness;
			if (_chartStyle.border) backThichness += _chartStyle.borderThickness * 2;
			
			var color:uint;
			for (var j:int = 0, arrLen:int = _dotArr.length; j < arrLen; j++)
			{
				color = _chartStyle.colors[j % _chartStyle.colors.length];
				var borderColor:uint = ColorUtil.adjustBrightness(color, -50);
				var lineShape:LineShape = getChildShapeAt(j) as LineShape;
				lineShape.backGraphics.clear();
				lineShape.backGraphics.lineStyle(backThichness, borderColor);
//				lineShape.gridGraphics.clear();
//				lineShape.gridGraphics.lineStyle(1, _chartStyle.shadowGridColors[j], _chartStyle.shadowGridAlpha);
				lineShape.lineGraphics.clear();
				lineShape.lineGraphics.lineStyle(_chartStyle.lineThickness, color);
				
				if(_chartStyle.shadowColors.length > j)
				{
					lineShape.backGraphics.beginFill(_chartStyle.shadowColors[j], _chartStyle.shadowAlpha);
				}
				
				var firstDot:DisplayObject = _dotArr[j][0];
				if (firstDot)
				{
					lineShape.backGraphics.moveTo(firstDot.x, firstDot.y);
					lineShape.lineGraphics.moveTo(firstDot.x, firstDot.y);
				}
				var dot:DisplayObject;
				var i:int, len:int = _dotArr[j].length;
				for(i = 0; i < len; i ++)
				{
					dot = _dotArr[j][i];
					
					lineShape.backGraphics.lineTo(dot.x, dot.y);
					lineShape.lineGraphics.lineTo(dot.x, dot.y);			
				}
				
				/*if (_chartStyle.shadowGridColors.length > j)//曲线网格
				{
					for(i = 0; i < len; i ++)
					{
						dot = _dotArr[j][i];
						
						lineShape.gridGraphics.moveTo(dot.x, dot.y);
						lineShape.gridGraphics.lineTo(dot.x, area.bottom);			
					}
				}*/
				
				_tipsManager.refresh();
				
				if (_chartStyle.shadowColors.length > j)
				{
					lineShape.backGraphics.lineStyle();
					lineShape.backGraphics.lineTo(dot.x, area.bottom);
					lineShape.backGraphics.lineTo(firstDot.x, area.bottom);
					lineShape.backGraphics.lineTo(firstDot.x, firstDot.y);
					lineShape.backGraphics.endFill();
				}
			}			
		}
		
		private function getChildShapeAt(index:int):LineShape
		{
			if (index < _shapeContainer.numChildren)
			{
				return _shapeContainer.getChildAt(index) as LineShape;
			}
			else
			{
				var lineShape:LineShape = new LineShape();
				_shapeContainer.addChild(lineShape);
				return lineShape;
			}
		}
		
	}
	
}


import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;

class LineShape extends Sprite
{
	private var line:Shape;

	private var grid:Shape;

	private var side:Shape;
	
	
	public function LineShape()
	{
		side = new Shape();
//		grid = new Shape();
		line = new Shape();
		addChild(side);
//		addChild(grid);
		addChild(line);
	}
	
	public function get backGraphics():Graphics
	{
		return side.graphics;
	}
	
	public function get gridGraphics():Graphics
	{
		return grid.graphics;
	}
	
	public function get lineGraphics():Graphics
	{
		return line.graphics;
	}
}