package com.weibo.charts.ui.tips
{
	import com.weibo.charts.CoordinateChart;
	import com.weibo.charts.style.CoordinateChartStyle;
	import com.weibo.charts.ui.ChartUIBase;
	import com.weibo.charts.ui.IDotUI;
	import com.weibo.charts.ui.ITipUI;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;

	public class TipsManager
	{
		private var _targetChart:CoordinateChart;
		
		private var _tips:Array;
		
		private var _arrTips:Array = [];
		
		private var _tipContainer:DisplayObjectContainer;
		
		private var _targets:Array;
		
		private var _space:Number = 0;
		
		private var _uiMap:Dictionary = new Dictionary();
		
		private var _singleTip:ITipUI;
		
		/**
		 * 鼠标跟随的每个格子的大小 
		 */		
		private var _oneUnit:Number;
		
		private var _dataLen:int;
		private var _axisLen:int;
		
		private var _selectedID:int = -1;
		
		private var _chartPos:Point;
		
		public function TipsManager(targetChart:CoordinateChart)
		{
			_targetChart = targetChart;
			_targetChart.chartStyle
		}
		
		public function destroy():void
		{
//			for(var i:int = 0, len:int = _targets.length; i < len; i ++)
//			{
//				delete _uiMap[_targetChart[i]];
//			}
			_uiMap = new Dictionary();
			_targets = [];
			if(_tipContainer != null)
			{
				while(_tipContainer.numChildren > 0) _tipContainer.removeChildAt(0);
				_tipContainer = null;
			}
		}
		
		public function init(targets:Array, container:DisplayObjectContainer):void
		{
			_tipContainer = container;
			_targets = targets;
			
			
			_dataLen = _targetChart.dataProvider["data"].length;
			_axisLen = _targetChart.dataProvider["axis"].length;
			
			if(_targetChart.chartStyle["tipType"] == 3 || _targetChart.chartStyle["tipType"] == 4)
			{
				_oneUnit = _targetChart.chartStyle["touchSide"] ? _targetChart.area.width / (_targetChart.dataProvider["axis"].length - 1) :  _targetChart.area.width / _targetChart.dataProvider["axis"].length;			
				var TipClass:Class = _targetChart.chartStyle["tipUI"];
				_singleTip = new TipClass;
				
				_chartPos = _tipContainer.parent.localToGlobal(new Point(_tipContainer.x, _tipContainer.y));
				_tipContainer.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);	
				
			}else if(_targetChart.chartStyle["tipType"] != 0)
			{
				var dot:IDotUI;
				var tip:ITipUI;
				var tipFun:Function = _targetChart.chartStyle["tipFun"] as Function;
				TipClass = _targetChart.chartStyle["tipUI"];
				var tipStr:String = "";
				
				var dataAry:Array = _targetChart.dataProvider["data"] as Array;
				var lineLen:int = dataAry.length;		
				var lineDots:int = _targetChart.dataProvider["axis"].length;
				
				if(lineDots > 1) _space = chartStyle.touchSide ? _targetChart.area.width/(lineDots-1) : _targetChart.area.width/lineDots;
				else _space = chartStyle.touchSide ? 0 : _targetChart.area.width * 0.5;
				
				var pheight:Number;
				var tx:Number;
				
				for(var i:int = 0 ; i < lineLen ; i ++)
				{
					for(var j:int = 0; j < lineDots ; j ++)
					{
						dot = _targets[i * lineDots + j];
						tip = new TipClass;
						_uiMap[dot] = tip;
						
						var valueData:Array = _targetChart.coordinateLogic.dataProvider.data[i]["value"];
						var type:int = _targetChart.dataProvider["data"][i]["useSubAxis"] ? 1 : 0;
						//pheight = Math.round(this.coordinateLogic.getPosition(dataProvider["data"][j]["value"][i]));
						pheight = Math.round(_targetChart.coordinateLogic.getPosition(_targetChart.dataProvider["data"][i]["value"][j], type));
						if(lineDots > 1) tx = chartStyle.touchSide ? Math.round(_targetChart.area.x + j * _space) : Math.round(_targetChart.area.x + j * _space + _space * 0.5);
						else tx = Math.round(_targetChart.area.x + _space);
						
						tipStr = (tipFun == null) ? valueData[j] : tipFun(i, j);
						tip.setLabel(tipStr, new TextFormat("Arial", null, 0xffffff), true);
						ChartUIBase(tip).uiColor = _targetChart.chartStyle.colors[i %  (_targetChart.chartStyle.colors.length)];
						_arrTips[_arrTips.length] = tip;
						if(_targetChart.chartStyle["tipType"] == 2)
						{
							DisplayObject(dot).addEventListener(MouseEvent.ROLL_OVER, overDot);
							DisplayObject(dot).addEventListener(MouseEvent.ROLL_OUT, outDot);
						}else{
							tip.show(_tipContainer, tx,  pheight, _targetChart.area, true);	
							DisplayObject(tip).y = _targetChart.area.bottom;
						}
						_tipContainer.addChild(tip as DisplayObject);
					}
				}
			}
		}
		
		protected function onEnterFrame(event:Event):void
		{
			
			if(_tipContainer.mouseX > _targetChart.area.left &&
				_tipContainer.mouseX < _targetChart.area.right && 
				_tipContainer.mouseY > _targetChart.area.top &&
				_tipContainer.mouseY < _targetChart.area.bottom)
			{
				var pos:Number = (_tipContainer.stage.mouseX - _targetChart.area.left - _chartPos.x) / _oneUnit;		
				var id:int = _targetChart.chartStyle["touchSide"] ? Math.round(pos) : Math.floor(pos);
//				_singleTip.show(_tipContainer, _tipContainer.stage.mouseX, _tipContainer.stage.mouseY, _targetChart.area);		
//				if(_selectedID == id) return;
				
				var ty:Number = _tipContainer.mouseY;
				var tx:Number = _targetChart.area.left + _chartPos.x;
				
				if(_selectedID != id && _selectedID >= 0)
				{
					for(var i:int = 0; i < _dataLen ; i ++)
					{
						var dot:ChartUIBase = _targets[_selectedID + i * _axisLen];
						dot.selected = false;
					}
				}
				_selectedID = id;
				
				var tipFun:Function = _targetChart.chartStyle["tipFun"] as Function;
				var tipStr:String = "";
				
				var tipIPos:int = 0;
				var tipJPos:int = _selectedID;
				
				if(_targetChart.chartStyle["tipType"] == 3 || _dataLen == 1)
				{
					var finalDot:ChartUIBase = _targets[_selectedID];
					
					for(i = 0; i < _dataLen ; i ++)
					{
						dot = _targets[_selectedID + i * _axisLen];
						if(Math.abs(dot.y - ty) < Math.abs(finalDot.y - ty))
						{
							finalDot = dot;
							tipIPos = i;
						}
						dot.selected = false;
					}
					ty = finalDot.y;
					tx = finalDot.x;
					finalDot.selected = true;
				}else if(_targetChart.chartStyle["tipType"] == 4){
					for(i = 0; i < _dataLen ; i ++)
					{
						dot = _targets[id + i * _axisLen];
						if(i == 0) tx = dot.x;
						dot.selected = true;
					}
					
					for(i = 0; i < _dataLen ; i ++)
					{
						dot = _targets[id + i * _axisLen];
						if(i == 0) tx = dot.x;
						dot.selected = true;
					}
				}
				
				var valueData:Array = _targetChart.coordinateLogic.dataProvider.data[tipIPos]["value"];
				tipStr = (tipFun == null) ? valueData[tipJPos] : tipFun(tipIPos, tipJPos);			
				_singleTip.setContent(_targetChart, id, chartStyle.tipFormat);
				
				if(tx + ChartUIBase(_singleTip).uiWidth >= _targetChart.area.right) tx = _targetChart.area.right - ChartUIBase(_singleTip).uiWidth;
				if(ty + ChartUIBase(_singleTip).uiHeight >= _targetChart.area.bottom) ty = _targetChart.area.bottom - ChartUIBase(_singleTip).uiHeight;
				
				_singleTip.show(_tipContainer, tx, ty, _targetChart.area);
			}else{
				_singleTip.hide();
				if(_selectedID >= 0)
				{
					for(i = 0; i < _dataLen ; i ++)
					{
						dot = _targets[_selectedID + i * _axisLen];
						dot.selected = false;
					}
				}
					
				_selectedID = -1;
			}
		}
		
		public function updateInitState():void
		{
			if(_targetChart.chartStyle["tipType"] == 3 || _targetChart.chartStyle["tipType"] == 4)
			{
				_oneUnit = _targetChart.chartStyle["touchSide"] ? _targetChart.area.width / (_targetChart.dataProvider["axis"].length - 1) :  _targetChart.area.width / _targetChart.dataProvider["axis"].length;			
//				var TipClass:Class = _targetChart.chartStyle["tipUI"];
//				_singleTip = new TipClass;
//				_tipContainer.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
				_chartPos = _tipContainer.parent.localToGlobal(new Point(_tipContainer.x, _tipContainer.y));
				
			}else if(_targetChart.chartStyle["tipType"] != 0)
			{
				var dot:IDotUI;
				var tip:ITipUI;
				var tipFun:Function = _targetChart.getStyle("tipFun") as Function;
				var TipClass:Class = _targetChart.chartStyle["tipUI"];
				var tipStr:String = "";
				
				var dataAry:Array = _targetChart.dataProvider["data"] as Array;
				var lineLen:int = dataAry.length;		
				var lineDots:int = _targetChart.dataProvider["axis"].length;
				
				if(lineDots > 1) _space = chartStyle.touchSide ? _targetChart.area.width/(lineDots-1) : _targetChart.area.width/lineDots;
				else _space = chartStyle.touchSide ? 0 : _targetChart.area.width * 0.5;
				
				var pheight:Number;
				var tx:Number;
				
				for(var i:int = 0 ; i < lineLen ; i ++)
				{
					for(var j:int = 0; j < lineDots ; j ++)
					{
						dot = _targets[i * lineDots + j];
						tip = _uiMap[dot];
						
						var valueData:Array = _targetChart.coordinateLogic.dataProvider.data[i]["value"];
						var type:int = _targetChart.dataProvider["data"][i]["useSubAxis"] ? 1 : 0;
						//pheight = Math.round(this.coordinateLogic.getPosition(dataProvider["data"][j]["value"][i]));
						pheight = Math.round(_targetChart.coordinateLogic.getPosition(_targetChart.dataProvider["data"][i]["value"][j], type));
						if(lineDots > 1) tx = chartStyle.touchSide ? Math.round(_targetChart.area.x + j * _space) : Math.round(_targetChart.area.x + j * _space + _space * 0.5);
						else tx = Math.round(_targetChart.area.x + _space);
						
						tipStr = (tipFun == null) ? valueData[j] : tipFun(i, j);
						tip.setLabel(tipStr, new TextFormat("Arial", null, 0xffffff));
						ChartUIBase(tip).uiColor = _targetChart.chartStyle.colors[i %  (_targetChart.chartStyle.colors.length)];
						_arrTips[_arrTips.length] = tip;
						if(_targetChart.chartStyle["tipType"] == 2)
						{
							DisplayObject(dot).addEventListener(MouseEvent.ROLL_OVER, overDot);
							DisplayObject(dot).addEventListener(MouseEvent.ROLL_OUT, outDot);
						}else{
							var orgTy:Number = DisplayObject(dot).y;
							tip.show(_tipContainer, tx,  pheight, _targetChart.area, true);	
							DisplayObject(tip).y = orgTy;
						}
						_tipContainer.addChild(tip as DisplayObject);
					}
				}
			}
		}
		
		public function refresh():void
		{
			if(_targetChart.chartStyle["tipType"] != 1) return;
			
			for(var i:int = 0, len:int = _targets.length; i < len; i ++)
			{
				var dot:Object = _targets[i];
				var tip:ITipUI = _uiMap[dot];
				ChartUIBase(tip).move(DisplayObject(dot).x, DisplayObject(dot).y);
			}
		}
		
		protected function outDot(event:MouseEvent):void
		{
			var dot:Object = event.currentTarget;
			var tip:ITipUI = _uiMap[dot];
			tip.hide();
		}
		
		protected function overDot(event:MouseEvent):void
		{
			var dot:Object = event.currentTarget;
			var tip:ITipUI = _uiMap[dot];
			tip.show(_tipContainer, DisplayObject(dot).x,  DisplayObject(dot).y, _targetChart.area);
		}
		
		private function get chartStyle():CoordinateChartStyle
		{
			return _targetChart.coordinateLogic.chartStyle;
		}

	}
	
}