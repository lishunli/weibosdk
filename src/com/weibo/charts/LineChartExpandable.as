package com.weibo.charts 
{
	import com.weibo.charts.data.BasicCoordinateLogic;
	import com.weibo.charts.data.ICoordinateLogic;
	import com.weibo.charts.events.ChartEvent;
	import com.weibo.charts.style.LineChartExpandableStyle;
	import com.weibo.charts.ui.ChartUIBase;
	import com.weibo.charts.ui.IDotUI;
	import com.weibo.charts.ui.ITipUI;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	/**
	 * 数据点可展开的图表
	 * @author Qi Donghui
	 */
	public class LineChartExpandable extends ChartBase 
	{		
		private var _style:LineChartExpandableStyle;
		
		private var _arrDots:Array = [];
		
		private var _container:Sprite;
		
		private var _tipContainer:Sprite;
		
		private var _arrTips:Array = [];
		
		private var _cacheData:Dictionary = new Dictionary(); 
		
		//当前所在层级
		private var _level:int = 0;
		
		//当前所在层对应上一层级的数据位置
		private var _index:int = 0;
		
		public function LineChartExpandable(style:LineChartExpandableStyle) 
		{
			super();
			_style = style;
			this.area = new Rectangle(0,0,style.baseStyle.width, style.baseStyle.height);
			this.chartWidht = style.baseStyle.width;
			this.chartHeight = _style.baseStyle.height;
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
		
		override protected function updateState():void
		{		
			if (dataProvider == null) return;
			var total:int = dataProvider.length;
			var space:Number = this.area.width / total;
			
			_container.graphics.lineStyle(_style.lineThickness, _style.lineColor);		
			
			var pheight:Number;
			var tx:Number;
			var dot:IDotUI;
			var tip:ITipUI;
			
			for(var i:int = 0; i < total ; i ++)
			{
				pheight = Math.round(this.coordinateLogic.getPosition(dataProvider[i]));
				tx = Math.round(area.x +  space * 0.5  + i * space);
				dot = new _style.dotUI();
				ChartUIBase(dot).uiColor = _style.arrColors[i %  _style.arrColors.length];
				DisplayObject(dot).x = tx;				
				DisplayObject(dot).y = pheight;
				//DisplayObject(dot).y = area.bottom;
				//TweenMax.to(dot, 0.5,{y: pheight, onUpdate:doitNextFrame});
				_container.addChild(dot as DisplayObject);
				_arrDots[_arrDots.length] = dot;
				
				DisplayObject(dot).addEventListener(MouseEvent.ROLL_OVER, overDot);
				DisplayObject(dot).addEventListener(MouseEvent.ROLL_OUT, outDot);
				DisplayObject(dot).addEventListener(MouseEvent.CLICK, clickDot);
				
				
				if(_style.baseStyle.tipType != 0)
				{			
					tip = new _style.tipUI();
					tip.setLabel(this.tipFun(dataProvider[i]), new TextFormat("Arial", null, 0xffffff));
					ChartUIBase(tip).uiColor = _style.arrColors[i %  _style.arrColors.length];	
					_tipContainer.addChild(tip as DisplayObject);
					_arrTips[_arrTips.length] = tip;
				}
			}
			drawShadow();
		}
		
		override public function set dataProvider(value:Array):void
		{
			if (!axisLogic)
			{
				this.axisLogic = new BasicCoordinateLogic(this);
				coordinateLogic.integer = _style.integer;
			}
			area = new Rectangle(0, 0, chartWidht, chartHeight);
			this.axisLogic.dataProvider = value;
			super.dataProvider = value;
			dispatchEvent(new ChartEvent(ChartEvent.CHART_DATA_CHANGED));
		}
		
		private function clickDot(e:MouseEvent):void 
		{
			dispatchEvent(new ChartEvent(ChartEvent.GET_CHART_DATA, "aaaa", true));
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
		
		private function get coordinateLogic():ICoordinateLogic
		{
			return this.axisLogic as ICoordinateLogic;
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