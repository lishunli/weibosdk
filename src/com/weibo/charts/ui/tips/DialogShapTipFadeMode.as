package com.weibo.charts.ui.tips 
{
	import com.greensock.TweenMax;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Qi Donghui
	 */
	public class DialogShapTipFadeMode extends DialogShapTip 
	{		
		public function DialogShapTipFadeMode() 
		{
			super();
		}
		
		override public function setLabel(value:String, tf:TextFormat = null, renderAsHTML:Boolean = false):void
		{
			super.setLabel(value, tf, renderAsHTML);
			this.scaleX = this.scaleY = 1;
			this.alpha = 0;
		}
		
		override protected function showEffect():void
		{
			TweenMax.to(this, 0.3, { alpha:1} );
		}
		
		override protected function hideEffect():void
		{
			TweenMax.to(this, 0.2, { alpha:0 } );
		}			
		
	}

}