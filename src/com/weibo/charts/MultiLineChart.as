package com.weibo.charts
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.weibo.charts.style.LineChartStyle;
	import com.weibo.charts.ui.ChartUIBase;
	import com.weibo.charts.ui.IDotUI;
	import com.weibo.charts.ui.ITipUI;
	import com.weibo.charts.utils.ColorUtil;
	import com.weibo.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;

	public class MultiLineChart extends CoordinateChart
	{
		/**
		 * 图表样式 
		 */		
		private var _chartStyle:LineChartStyle;
		
		private var _dotArr:Array = [];
		
		private var _container:Sprite;
		
		private var _tipContainer:Sprite;
		
		private var _arrTips:Array = [];
		private var _arrDots:Array = [];
		
		private var _tweens:TweenMax;
		
		private var j:int = 0;
		private var m:int = 0;
		private var _space:Number = 0;
		private var _preLineLen:int;
		private var _preLineDots:int;
		
		public function MultiLineChart(style:LineChartStyle)
		{
			_chartStyle = style;
			super(style);		
			this.coordinateLogic.integer = style.integer;
			this.coordinateLogic.alwaysShow0 = true;
			this.coordinateLogic.touchSide = style.touchSide;
			this.area = new Rectangle(0,0,width,height);
		}
		
		override protected function create():void
		{
			if (_container == null)
			{
				_container =  new Sprite();
				addChild(_container);
			}
			
			if(_tipContainer == null && _chartStyle.tipType != 0){
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
			m = 0;
			_space = 0;
			_preLineLen = 0;
			_preLineDots = 0;
			
			if(_container != null)
			{
				_container.graphics.clear();
				while (_container.numChildren > 0) _container.removeChildAt(0);
			}			
			
			_arrTips = [];
			_arrDots = [];
			if(_tipContainer != null) while(_tipContainer.numChildren > 0) _tipContainer.removeChildAt(0);	
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
			
			if(lineDots > 1) _space = coordinateLogic.touchSide ? this.area.width/(lineDots-1) : this.area.width/lineDots;
			else _space = coordinateLogic.touchSide ? 0 : this.area.width * 0.5;

			if(_dotArr.length == 0)
			{
//				_container.graphics.clear();
//				_container.graphics.lineStyle(_chartStyle.lineThickness, _chartStyle.colors[i]);
//				this.graphics.beginFill(0, 0); ///////////////////////////////////////////////////////////// Test Area范围
//				this.graphics.drawRect(area.x, area.y, area.width, area.height);
//				this.graphics.endFill();
				
				for (j = 0; j < lineLen; j++)
				{
					var dotAryT:Array = [];
					var type:int;
//					_container.graphics.endFill();
					for(var i:int = 0; i < lineDots ; i ++)
					{
						var valueData:Array = coordinateLogic.dataProvider.data[j]["value"];
						
						type = dataProvider["data"][j]["useSubAxis"] ? 1 : 0;
						//pheight = Math.round(this.coordinateLogic.getPosition(dataProvider["data"][j]["value"][i]));
						pheight = Math.round(this.coordinateLogic.getPosition(dataProvider["data"][j]["value"][i], type));
						if(lineDots > 1) tx = coordinateLogic.touchSide ? Math.round(area.x + i * _space) : Math.round(area.x + i * _space + _space * 0.5);
						else tx = Math.round(area.x + _space);
						var DotClass:Class = _chartStyle.dotUI;
						dot = new DotClass();
						ChartUIBase(dot).uiColor = _chartStyle.colors[j % _chartStyle.colors.length];
						DisplayObject(dot).x = tx;	
						
						DisplayObject(dot).y = area.bottom;
						TweenMax.to(dot, 0.5, { y: pheight, onUpdate:dotNextFrame} );
						_container.addChild(dot as DisplayObject);
						dotAryT[dotAryT.length] = dot;
						
						_arrDots[_arrDots.length] = dot;
						
						if(_chartStyle.tipType != 0)
						{
							var TipClass:Class = _chartStyle.tipUI;
							tip = new TipClass;
							tipStr = (tipFun == null) ? valueData[i] : tipFun(valueData[i]);
							tip.setLabel(tipStr, new TextFormat("Arial", null, 0xffffff));
							ChartUIBase(tip).uiColor = _chartStyle.colors[j %  (_chartStyle.colors.length)];									
							_arrTips[_arrTips.length] = tip;
													
							if(_chartStyle.tipType == 2)
							{
								DisplayObject(dot).addEventListener(MouseEvent.ROLL_OVER, overDot);
								DisplayObject(dot).addEventListener(MouseEvent.ROLL_OUT, outDot);
							}else{
								tip.show(_tipContainer, tx,  pheight, this.area, true);	
								DisplayObject(tip).y = area.bottom;
							}
							_tipContainer.addChild(tip as DisplayObject);
						}						
					}
					_dotArr[_dotArr.length] = dotAryT;
//					_container.graphics.endFill();				
				}				
				_preLineDots = lineDots;
				_preLineLen = lineLen;			
			}else{
				if(_preLineLen == lineLen && _preLineDots == lineDots)
				{
					for (j = 0; j < lineLen; j++)
					{
						for (i = 0; i < lineDots; i++)
						{
							valueData = coordinateLogic.dataProvider.data[j]["value"];
							
							dot = _dotArr[j][i] as IDotUI;
							ChartUIBase(dot).uiColor = _chartStyle.colors[j % _chartStyle.colors.length];
							type = dataProvider["data"][j]["useSubAxis"] ? 1 : 0;
							pheight = Math.round(this.coordinateLogic.getPosition(dataProvider["data"][j]["value"][i],type));

							if(lineDots > 1) tx = coordinateLogic.touchSide ? Math.round(area.x + i * _space) : Math.round(area.x + i * _space + _space * 0.5);
							else tx = Math.round(area.x + _space);
							
							if(_chartStyle.tipType != 0)
							{
								tip = _arrTips[j * lineDots  + i ];
								
								tipStr = (tipFun == null) ? valueData[i] : tipFun(valueData[i]);
								tip.setLabel(tipStr, new TextFormat("Arial", null, 0xffffff));
								
								ChartUIBase(tip).uiColor = _chartStyle.colors[j %  (_chartStyle.colors.length)];	
								if(_chartStyle.tipType == 2)
								{
									DisplayObject(dot).addEventListener(MouseEvent.ROLL_OVER, overDot);
									DisplayObject(dot).addEventListener(MouseEvent.ROLL_OUT, outDot);
								}else{
									var orgTy:Number = DisplayObject(dot).y;
									tip.show(_tipContainer, tx,  pheight, this.area, true);	
									DisplayObject(tip).y = orgTy;
								}
							}
//							_container.graphics.clear();
							TweenMax.to(dot, 0.5, { x: tx, ease:Cubic.easeOut } );
							TweenMax.to(dot, 0.5, { y: pheight, ease:Cubic.easeOut, onUpdate:dotNextFrame } );
						}			
					}		
				}else {
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
				color = _chartStyle.colors[j % _chartStyle.colors.length];
				_container.graphics.lineStyle(_chartStyle.lineThickness, color);
				
				if(_chartStyle.shadowColors.length > j)
				{
					_container.graphics.beginFill(_chartStyle.shadowColors[j], _chartStyle.shadowAlpha);
				}
				
				var firstDot:DisplayObject = _dotArr[j][0];
				_container.graphics.moveTo(firstDot.x, firstDot.y);
				var dot:DisplayObject;
				
				for(var i:int = 0, len:int = _dotArr[j].length; i < len; i ++)
				{
					dot = _dotArr[j][i];
					
					_container.graphics.lineTo(dot.x, dot.y);
					
					if(_chartStyle.tipType != 0)
					{
						var tip:ITipUI = _arrTips[j * len  + i ];
						UIComponent(tip).move(DisplayObject(dot).x,  DisplayObject(dot).y);
					}					
				}
				
				if (_chartStyle.shadowColors.length > j)
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
		
		protected function outDot(event:MouseEvent):void
		{
			var dot:Object = event.target;
			var id:int = _arrDots.indexOf(dot);
			var tip:ITipUI = _arrTips[id];
			tip.hide();
		}
		
		protected function overDot(event:MouseEvent):void
		{
			var dot:Object = event.target;
			var id:int = _arrDots.indexOf(dot);
			var tip:ITipUI = _arrTips[id];
			tip.show(_tipContainer, DisplayObject(dot).x,  DisplayObject(dot).y, this.area);
		}
		
	}
	
}