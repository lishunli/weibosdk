package com.weibo.charts.comp
{
	import com.weibo.charts.DecorateBase;
	import com.weibo.charts.PieChart;
	import com.weibo.charts.events.ChartEvent;
	import com.weibo.charts.style.PieChartStyle;
	import com.weibo.charts.ui.ISectorUI;
	import com.weibo.charts.ui.ITipUI;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	/**
	 * 蜘蛛腿方式引线
	 * @author yaofei
	 */	
	public class PieTipSpider extends DecorateBase
	{
//		private var _style:PieChartStyle;
		
		private var _tipContainer:Sprite;
		
		private var _arrTips:Array = [];
		
		
	//==========================================
	// 构造函数
	//------------------------------------------
		
		public function PieTipSpider(target:PieChart)
		{
			addChild(target);
			super(target);
		}
		
	//==========================================
	// 公开方法
	//------------------------------------------
		
		public function get style():PieChartStyle
		{
			return (target as PieChart).style;
		}
		
		override public function setSize(w:Number, h:Number):void
		{
			super.setSize(w, h);
			target.setSize(w, h);
		}
		
	//==========================================
	// 私有方法
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
		
		override protected function destroy():void
		{
			if(_tipContainer != null)
			{
				_tipContainer.graphics.clear();
				while(_tipContainer.numChildren > 0) _tipContainer.removeChildAt(0);
			}
			_arrTips = [];
		}
		
		override protected function addEvents():void
		{
			super.addEvents();
//			if (target) target.addEventListener(MouseEvent.MOUSE_OVER, mouseShowTip);
//			if (target) target.addEventListener(MouseEvent.MOUSE_OUT, mouseHideTip);
			target.addEventListener(ChartEvent.CHART_TIPS_SHOW, drawTips);
			target.addEventListener(ChartEvent.CHART_DATA_CHANGED, onChanged);
		}
		
		override protected function removeEvents():void
		{
			super.removeEvents();
//			if (target) target.removeEventListener(MouseEvent.MOUSE_OVER, mouseShowTip);
//			if (target) target.removeEventListener(MouseEvent.MOUSE_OUT, mouseHideTip);
			target.removeEventListener(ChartEvent.CHART_TIPS_SHOW, drawTips);
			target.removeEventListener(ChartEvent.CHART_DATA_CHANGED, onChanged);
		}
		
		
		override protected function updateState():void
		{
			if(dataProvider != null)
			{
//				_tipContainer.visible = false;
				
			}
			_tipContainer.graphics.clear();
			while (_tipContainer.numChildren > 0)	_tipContainer.removeChildAt(0);
//			if (dataProvider.length != 0 && totalNum != 0) drawTips();
		}
		
		
		
		private function drawTips(event:ChartEvent=null):void
		{
			var sectors:Array = event.data as Array;
			var i:int;
//			if (_dataProvider.length != sectors.length) trace("PieChart:length", _dataProvider.length);
			
			var leftTips:Array = [];
			var rightTips:Array = [];
			for(i = 0; i < sectors.length; i ++)
			{
				var sector:ISectorUI = sectors[i];
				
				var middleAngle:Number = (sector.startAngle + sector.endAngle) / 2;
				var margin:Number = sector.radius/2 * Math.abs(Math.sin(middleAngle));
				var lineLength:Number = sector.radius/4 * Math.abs(Math.sin(middleAngle));
				var x2:Number = area.x + area.width / 2 + Math.cos(middleAngle) * (sector.radius + margin);
				var y2:Number = area.y + area.height / 2 + Math.sin(middleAngle) * (sector.radius + margin);
				
				
				var tip:ITipUI = new style.tipUI();
				var tf:TextFormat = new TextFormat("Arial", null, style.tipColor);
				
//				getStyle("tipFun").call(null, dataProvider[i]);
				tip.setLabel(getStyle("tipFun").call(null, dataProvider[i]), tf, true);
				_tipContainer.addChild(tip as DisplayObject);
				_arrTips[_arrTips.length] = tip;
				
				//文字基础位置
				//拐角方向:右
				if (Math.cos(middleAngle) > 0)
				{
					rightTips.push({sector:sector, tip:tip});
					DisplayObject(tip).x = x2 + lineLength;
					DisplayObject(tip).y = y2 - DisplayObject(tip).height / 2;
				}
				//拐角方向:左
				else
				{
					leftTips.unshift({sector:sector, tip:tip});
					DisplayObject(tip).x = x2 - DisplayObject(tip).width - lineLength;
					DisplayObject(tip).y = y2 - DisplayObject(tip).height / 2;
				}
			}
			
			_tipContainer.graphics.clear();
			_tipContainer.graphics.lineStyle(1, this.style.lineColor, this.style.lineAlpha);
			repareTips(leftTips);
			repareTips(rightTips);
		}
		
		private function repareTips(tips:Array):void
		{
			var i:int;
			for (i = 0; i < tips.length - 2; i++)
			{
				if (tips[i+1].tip.y < tips[i].tip.y + tips[i].tip.height)
				{
					tips[i+1].tip.y = tips[i].tip.y + tips[i].tip.height;
				}
			}
			for (i = tips.length - 1; i > 1; i--)
			{
				if (tips[i-1].tip.y > tips[i].tip.y - tips[i-1].tip.height)
				{
					tips[i-1].tip.y = tips[i].tip.y - tips[i-1].tip.height;
				}
			}
			
			for (i = 0; i < tips.length; i++)
			{
				var sector:ISectorUI = tips[i].sector;
				var tip:ITipUI = tips[i].tip;
				
				var middleAngle:Number = (sector.startAngle + sector.endAngle) / 2;
				var dotIn:Number = Math.min((sector.radius - sector.radiusIn) / 2, 5);
				var x1:Number = area.x + area.width / 2 + Math.cos(middleAngle) * (sector.radius - dotIn);
				var y1:Number = area.y + area.height / 2 + Math.sin(middleAngle) * (sector.radius - dotIn);
				var margin:Number = sector.radius/2 * Math.abs(Math.sin(middleAngle));
				var lineLength:Number = sector.radius/4 * Math.abs(Math.sin(middleAngle));
				var x2:Number = area.x + area.width / 2 + Math.cos(middleAngle) * (sector.radius + margin);
				var y2:Number = tip.y + DisplayObject(tip).height / 2;
				
				/*
				var dot:Shape = new Shape();
				_tipContainer.addChild(dot);
				dot.graphics.clear();
				dot.graphics.beginFill(this.style.lineColor, this.style.lineAlpha);
				dot.graphics.drawCircle(x1, y1, 3);
				*/
				
				_tipContainer.graphics.moveTo(x1, y1);
				_tipContainer.graphics.lineTo(x2, y2);
				
				//根据文字调整后的位置画线
				//拐角方向:右
				if (Math.cos(middleAngle) > 0)
				{
					_tipContainer.graphics.lineTo(x2, y2);
					_tipContainer.graphics.lineTo(x2 + lineLength, y2);
				}
				//拐角方向:左
				else
				{
					_tipContainer.graphics.lineTo(x2, y2);
					_tipContainer.graphics.lineTo(x2 - lineLength, y2);
				}
			}
		}
		
		private function sort(list:Array):void
		{
			var i:int;
			var j:int;
			var min:int;
			var tmp:Object;
			for (i=0; i<list.length-1; i++)
			{
				min = i;
				for (j = i+1; j < list.length; j++)
				{
					if(list[j].time < list[min].time) min = j;
				}
				if (min != i)
				{
					tmp = list[min];
					list[min] = list[i];
					list[i] = tmp;
				}
			}
		}
		
	//========================================
	// 事件侦听器
	//----------------------------------------
		
		protected function onChanged(event:ChartEvent):void
		{
			destroy();
//			invalidate("all");trace("---------")
		}
		
		/*private function mouseShowTip(event:MouseEvent):void
		{
			_tipContainer.graphics.clear();
			_tipContainer.graphics.lineStyle(1, this.style.lineColor, this.style.lineAlpha);
			
			var sector:ISectorUI = event.target as ISectorUI;
//			if (sector) drawOneTip(sector);
		}
		
		private function mouseHideTip(event:MouseEvent):void
		{
			_tipContainer.graphics.clear();
			while (_tipContainer.numChildren > 0)	_tipContainer.removeChildAt(0);
		}*/
		
	}
}