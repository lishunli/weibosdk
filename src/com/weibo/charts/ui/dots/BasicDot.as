package com.weibo.charts.ui.dots 
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;
	import com.weibo.charts.ui.ChartUIBase;
	import com.weibo.charts.ui.IDotUI;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author yaofei@staff.sina.com.cn
	 */
	public class BasicDot extends ChartUIBase implements IDotUI
	{
		
		public function BasicDot() 
		{
			
		}
		
		override protected function create():void
		{
			this.graphics.clear();
			this.graphics.beginFill(0xffffff);
			this.graphics.lineStyle(1, uiColor);
			this.graphics.drawCircle(0,0,7);
			this.graphics.endFill();
			this.graphics.beginFill(uiColor);
			this.graphics.drawCircle(0,0,3);
			this.graphics.endFill();
			this.buttonMode = true;
		}
		
		override protected function addEvents():void
		{
			this.addEventListener(MouseEvent.ROLL_OVER, overThis);
			this.addEventListener(MouseEvent.ROLL_OUT, outThis);
		}
		
		private function outThis(e:MouseEvent):void
		{
			TweenMax.to(this, 0.3, {scaleX: 1, scaleY: 1});
		}
		
		private function overThis(e:MouseEvent):void
		{
			TweenMax.to(this, 0.5, {scaleX: 1.2, scaleY: 1.2, ease:Elastic.easeOut});
		}
		
	}

}