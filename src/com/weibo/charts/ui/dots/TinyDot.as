package com.weibo.charts.ui.dots
{
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.weibo.charts.ui.ChartUIBase;
	import com.weibo.charts.ui.IDotUI;
	
	import flash.display.Shape;
	import flash.events.MouseEvent;
	
	public class TinyDot extends ChartUIBase implements IDotUI
	{
		private var _small:Shape;
		private var _big:Shape; 
		public function TinyDot()
		{
			super();
		}
		
		override protected function create():void
		{
			this.graphics.clear();
			this.graphics.beginFill(0xffffff,0);
			this.graphics.drawCircle(0,0,7);
			this.graphics.endFill();
			
			_small = new Shape();
			_small.graphics.beginFill(0xFFFFFF);
			_small.graphics.lineStyle(1,uiColor,1,false,"none","none");
			_small.graphics.drawCircle(0,0,2);
			_small.graphics.endFill();
			
			
			_big = new Shape();
			_big.graphics.beginFill(0xFFFFFF);
			_big.graphics.lineStyle(2.5,uiColor,1,true,"none","none");
			_big.graphics.drawCircle(0,0,3);
			_big.graphics.endFill();
			
			addChild(_small);
			this.buttonMode = true;
		}
		
		override protected function destroy():void
		{
			if(contains(_small)) removeChild(_small);
			if(contains(_big)) removeChild(_big);
			_small = null;
			_big = null;
		}
		
		override protected function addEvents():void
		{
			this.addEventListener(MouseEvent.ROLL_OVER, overThis);
			this.addEventListener(MouseEvent.ROLL_OUT, outThis);
		}
		
		private function outThis(e:MouseEvent = null):void
		{
			addChild(_small);
			if(contains(_big)) removeChild(_big);
		}
		
		private function overThis(e:MouseEvent = null):void
		{
			
			addChild(_big);
			if(contains(_small)) removeChild(_small);
			
		}
		
		override public function set selected(value:Boolean):void
		{
			if(value)
			{
				this.removeEventListener(MouseEvent.ROLL_OVER, overThis);
				this.removeEventListener(MouseEvent.ROLL_OUT, outThis);
				overThis();
			}else{
				outThis();
				addEvents();
			}
			
		}
		
	}
}