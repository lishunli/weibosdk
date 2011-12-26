package com.weibo.charts.ui.dots 
{
	import com.greensock.easing.Elastic;
	import com.greensock.TweenMax;
	import com.weibo.charts.ui.ChartUIBase;
	import com.weibo.charts.ui.IDotUI;
	import com.weibo.charts.utils.ColorUtil;
	import flash.display.GradientType;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	
	/**
	 * ...
	 * @author Qi Donghui
	 */
	public class BasicShadowDot extends ChartUIBase implements IDotUI 
	{
		public function BasicShadowDot() 
		{
			
		}
		
		override protected function create():void
		{
			outThis();
			this.filters = [new DropShadowFilter(3,90,0xcccccc,0.75,3,3)]
		}
		
		override protected function addEvents():void
		{
			this.addEventListener(MouseEvent.ROLL_OVER, overThis);
			this.addEventListener(MouseEvent.ROLL_OUT, outThis);
		}
		
		private function outThis(e:MouseEvent = null):void
		{
			this.graphics.clear();
			this.graphics.beginFill(0xffffff);
			this.graphics.lineStyle(1, uiColor);
			this.graphics.drawCircle(0,0,6);
			this.graphics.endFill();
			this.graphics.beginFill(uiColor);
			this.graphics.drawCircle(0,0,1);
			this.graphics.endFill();
			this.buttonMode = true;					
		}
		
		private function overThis(e:MouseEvent = null):void
		{
			this.graphics.clear();		
			var mx:Matrix = new Matrix();
			mx.createGradientBox(14, 14, 90, -7, -7);			
			this.graphics.beginGradientFill(GradientType.LINEAR, [ColorUtil.adjustBrightness(uiColor, 70), uiColor], 
			[1, 1], [0, 155], mx);
			this.graphics.drawCircle(0,0,7);
			this.graphics.endFill();
		}		
		
	}

}