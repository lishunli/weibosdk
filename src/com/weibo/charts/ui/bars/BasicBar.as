package com.weibo.charts.ui.bars 
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.greensock.layout.ScaleMode;
	import com.weibo.charts.ui.ChartUIBase;
	import com.weibo.charts.ui.IBarUI;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	/**
	 * 纯色的Bar
	 * @author yaofei@staff.sina.com.cn
	 */
	public class BasicBar extends ChartUIBase
	{
		private var _tempUIHeight:Number = 2;
		
		private var _ori:Boolean = false;
		
		private var _hasInit:Boolean = false;
		
		private var _outline:Sprite;
		private var _outlineMask:Sprite;
		
		private var _b:Sprite;
		
		public function BasicBar() 
		{
			
		}
		
		override protected function create():void
		{
			if(_b == null)
			{
				_b = new Sprite();
				addChild(_b);
				_b.graphics.clear();
//				_b.graphics.beginFill(outlineColor);
//				_b.graphics.drawRect(-uiWidth*0.5 - 1, -3, uiWidth + 2, 3);
//				_b.graphics.lineStyle(outlineThicknesss, outlineColor, 1, false, ScaleMode.NONE);
//				_b.graphics.moveTo(-uiWidth*0.5 - 1, -3);
//				_b.graphics.lineTo(uiWidth*0.5 + 1, -3);
//				_b.graphics.lineTo(uiWidth*0.5 + 1, 0);
//				_b.graphics.lineTo(-uiWidth*0.5 - 1, 0);
//				_b.graphics.lineTo(-uiWidth*0.5 - 1, -3);
//				_b.graphics.endFill();
				_b.graphics.beginFill(uiColor, uiAlpha);
//				_b.graphics.drawRect(-uiWidth*0.5, -2, uiWidth, 1);
				_b.graphics.drawRect(-uiWidth * 0.5, -10, uiWidth , 10);
				_b.graphics.endFill();
				
//				_b.graphics.lineStyle(outlineThicknesss, outlineColor, 1, false, ScaleMode.NONE);
//				_b.graphics.drawRect(-uiWidth * 0.5 + outlineThicknesss * 0.5, -10 + outlineThicknesss *0.5, uiWidth - outlineThicknesss, 10- 0.5* outlineThicknesss);
//				_b.graphics.lineTo(
				
				_b.graphics.beginFill(outlineColor);
				_b.graphics.drawRect(-uiWidth*0.5, -10, uiWidth + outlineThicknesss, outlineThicknesss);
				_b.graphics.drawRect(-uiWidth*0.5, -10, outlineThicknesss, 10);
				_b.graphics.drawRect(uiWidth*0.5, -10, outlineThicknesss, 10);
				_b.graphics.drawRect(-uiWidth*0.5, -outlineThicknesss, uiWidth, outlineThicknesss);
				
				_b.scale9Grid = new Rectangle(-uiWidth*0.5 + outlineThicknesss, -10 + outlineThicknesss, uiWidth - 2 * outlineThicknesss, 10 - 2 * outlineThicknesss);
				_b.scaleY = 0;
			}
			
		}
		
		override protected function destroy():void
		{
			_b = null;
		}
		
		override protected function layout():void
		{
			TweenMax.to(_b, 1, {height: uiHeight, ease:Cubic.easeOut});
		}
		
		override protected function updateState():void
		{
			
		}
	}

}