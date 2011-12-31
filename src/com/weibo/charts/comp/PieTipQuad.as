package com.weibo.charts.comp
{
	import com.weibo.charts.PieChart;
	import com.weibo.charts.style.PieChartStyle;
	import com.weibo.charts.ui.ISectorUI;
	import com.weibo.charts.ui.ITipUI;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import com.weibo.charts.DecorateBase;
	
	/**
	 * 十字分割。分别扇形所在的四个角显示TIP
	 * @author yaofei
	 */	
	public class PieTipQuad extends DecorateBase
	{
		private var _style:PieChartStyle;
		
		private var _tipContainer:Sprite;
		
		private var _arrTips:Array = [];
		
		public function PieTipQuad(target:PieChart)
		{
			_style = new PieChartStyle();
			addChild(target);
			super(target);
		}
		
	//==========================================
	// 构造函数
	//------------------------------------------
		
		override protected function create():void
		{
			if(_tipContainer == null){
				_tipContainer = new Sprite();
				_tipContainer.mouseEnabled = false;
				_tipContainer.mouseChildren = false;
				addChild(_tipContainer);
			}
		}
		
	//==========================================
	// 私有方法
	//------------------------------------------
		
		override protected function destroy():void
		{
			if(_tipContainer != null) while(_tipContainer.numChildren > 0) _tipContainer.removeChildAt(0);
			_arrTips = [];
		}
		
		override protected function addEvents():void
		{
			super.addEvents();
			if (target) target.addEventListener(MouseEvent.MOUSE_OVER, mouseShowTip);
			if (target) target.addEventListener(MouseEvent.MOUSE_OUT, mouseHideTip);
//			_target.addEventListener(ChartEvent.CHART_DATA_CHANGED, );
		}
		
		override protected function removeEvents():void
		{
			super.removeEvents();
			if (target) target.removeEventListener(MouseEvent.MOUSE_OVER, mouseShowTip);
			if (target) target.removeEventListener(MouseEvent.MOUSE_OUT, mouseHideTip);
		}
		
		
		override protected function updateState():void
		{
			if(dataProvider != null)
			{
//				_tipContainer.visible = false;
				
				while (_tipContainer.numChildren > 0)	_tipContainer.removeChildAt(0);
//				if (dataProvider.length != 0 && totalNum != 0) drawTips();
			}
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
//			graphics.beginFill(0xfff000, 1);
//			graphics.drawCircle(0, 0, 500);
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
		
	//========================================
	// 事件侦听器
	//----------------------------------------
		
		private function mouseShowTip(event:MouseEvent):void
		{
			_tipContainer.graphics.clear();
			_tipContainer.graphics.lineStyle(1, this._style.lineColor, this._style.lineAlpha);
			
			var sector:ISectorUI = event.target as ISectorUI;
			if (sector) drawOneTip(sector);
		}
		
		private function mouseHideTip(event:MouseEvent):void
		{
			_tipContainer.graphics.clear();
			while (_tipContainer.numChildren > 0)	_tipContainer.removeChildAt(0);
		}
	}
}