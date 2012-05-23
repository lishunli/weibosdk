package com.weibo.charts.ui.dots 
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;
	import com.weibo.charts.ui.ChartUIBase;
	import com.weibo.charts.ui.IDotUI;
	
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author yaofei@staff.sina.com.cn
	 */
	public class BasicDot extends ChartUIBase implements IDotUI
	{
		
		public function BasicDot() 
		{
			this.buttonMode = true;
		}
		
		override protected function addEvents():void
		{
			this.addEventListener(MouseEvent.ROLL_OVER, overThis);
			this.addEventListener(MouseEvent.ROLL_OUT, outThis);
		}
		
		override protected function updateState():void
		{
			this.graphics.clear();
			this.graphics.beginFill(0xffffff);
			this.graphics.lineStyle(1, uiColor);
			this.graphics.drawCircle(0,0,7);
			this.graphics.endFill();
			this.graphics.beginFill(uiColor);
			this.graphics.drawCircle(0,0,3);
			this.graphics.endFill();
		}
		
		private function outThis(e:MouseEvent):void
		{
			if(!selected) outEffect();
		}
		
		private function overThis(e:MouseEvent):void
		{
			if(!selected) overEffect();
		}
		
		override protected function overEffect(skipEffect:Boolean=false):void
		{
			if(!skipEffect) TweenMax.to(this, 0.5, {scaleX: 1.2, scaleY: 1.2, ease:Elastic.easeOut});
			else this.scaleX = this.scaleY = 1.2;
		}
		
		override protected function outEffect(skipEffect:Boolean=false):void
		{
			if(!skipEffect) TweenMax.to(this, 0.3, {scaleX: 1, scaleY: 1});
			else this.scaleX = this.scaleY = 1;
		}
		
		override public function set selected(value:Boolean):void
		{
			if(value)
			{
				this.removeEventListener(MouseEvent.ROLL_OVER, overThis);
				this.removeEventListener(MouseEvent.ROLL_OUT, outThis);
				this.overEffect(false);
			}else{
				this.outEffect(false);
				addEvents();
			}
			
		}
		
	}

}