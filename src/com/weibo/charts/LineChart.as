package com.weibo.charts
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.weibo.charts.style.LineChartStyle;
	import com.weibo.charts.ui.ChartUIBase;
	import com.weibo.charts.ui.ITipUI;
	import com.weibo.charts.ui.dots.NullDot;
	import com.weibo.charts.ui.tips.TipsManager;
	import com.weibo.util.ColorUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	public class LineChart extends CoordinateChart
	{
		/**
		 * 图表样式 
		 */		
		private var _chartStyle:LineChartStyle;
		
		private var _shapeContainer:Sprite;
		private var _tipContainer:Sprite;
		private var _tipsManager:TipsManager
		
		private var _dotArr:Array = [];
		private var _arrTips:Array = [];
		private var _arrDots:Array = [];
		
		private var _lastLineNum:int;
		private var _lastAxisLen:int;
		
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
			_dotArr = [];
			_arrTips = [];
			_arrDots = [];
			
			_lastLineNum = 0;
			_lastAxisLen = 0;
			
			if(_shapeContainer != null)
			{
				_shapeContainer.graphics.clear();
				while (_shapeContainer.numChildren > 0) _shapeContainer.removeChildAt(0);
				_shapeContainer = null;
			}
			
			_tipsManager.destroy();
		}
		
		override protected function updateState():void
		{
			if (dataProvider == null) return;
			
			var pheight:Number;
			var tx:Number;
			var dot:ChartUIBase;
			var tip:ITipUI;
			var tipFun:Function = this.getStyle("tipFun") as Function;
			var tipStr:String = "";
			
			var axisLen:int = dataProvider["axis"].length;
			var lineNum:int = dataProvider["data"].length;
			
			var unit:Number;
			if (_chartStyle.touchSide && axisLen>1)
			{
				unit = this.area.width/(axisLen-1);
			}
			else
			{
				unit = this.area.width/axisLen;
			}

			//创建
			if (_lastLineNum == 0)
			{
				for (var i:int = 0; i < lineNum; i++)
				{
					var dotAryT:Array = [];
					var lineShape:LineShape = getChildShapeAt(i) as LineShape;
					for(var j:int = 0; j < axisLen ; j ++)
					{
						var DotClass:Class = _chartStyle.dotUI || NullDot;
						dot = new DotClass();
						if(_chartStyle.touchSide && axisLen > 1)
							dot.x = area.x + j * unit;
						else
							dot.x = area.x + j * unit + unit * 0.5;
						dot.y = area.bottom;
						lineShape.addChild(dot);
						dotAryT.push(dot);
						_arrDots.push(dot);
					}
					_dotArr.push(dotAryT);
				}
				_tipsManager.init(_arrDots, _tipContainer);
			}
			if (_lastLineNum == 0 || (_lastLineNum == lineNum && _lastAxisLen == axisLen))
			{
				_tipsManager.updateInitState();
				for (i = 0; i < lineNum; i++)
				{
					var k:int = 0;
					for (j = 0; j < axisLen; j++)
					{
						var type:int;
						dot = _dotArr[i][j];
						dot.uiColor = _chartStyle.colors[i % _chartStyle.colors.length];
						type = dataProvider["data"][i]["useSubAxis"] ? 1 : 0;
						pheight = area.y + this.coordinateLogic.getPosition(dataProvider["data"][i]["value"][j], type);
						
						if (k < coordinateLogic.labelData.length && coordinateLogic.labelData[k].index == j)
						{
							dot.state = "show";
							k++;
						}
						else
						{
							dot.state = "hide";
						}

						if(_chartStyle.touchSide && axisLen > 1)
							tx = area.x + j * unit;
						else
							tx = area.x + j * unit + unit * 0.5;
						
						TweenLite.to(dot, .7, { x: tx, ease:Cubic.easeOut } );
						TweenLite.to(dot, .7, { y: pheight, ease:Cubic.easeOut } );
					}
				}
				TweenLite.to(null, 3, {onUpdate:dotNextFrame } );
			}
			else
			{
				this.invalidate("all");
			}
			
			_lastAxisLen = axisLen;
			_lastLineNum = lineNum;
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
				
				for(var i:int = 0, len:int = _dotArr[j].length; i < len; i ++)
				{
					dot = _dotArr[j][i];
					
					lineShape.backGraphics.lineTo(dot.x, dot.y);
					lineShape.lineGraphics.lineTo(dot.x, dot.y);			
				}
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

	private var side:Shape;
	
	
	public function LineShape()
	{
		side = new Shape();
		line = new Shape();
		addChild(side);
		addChild(line);
	}
	
	public function get backGraphics():Graphics
	{
		return side.graphics;
	}
	
	public function get lineGraphics():Graphics
	{
		return line.graphics;
	}
}