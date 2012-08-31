package com.weibo.charts.ui.tips
{
	import com.greensock.TweenMax;
	import com.weibo.charts.CoordinateChart;
	import com.weibo.charts.ui.ChartUIBase;
	import com.weibo.charts.ui.ITipUI;
	
	import flash.display.BlendMode;
	import flash.display.CapsStyle;
	import flash.display.DisplayObjectContainer;
	import flash.display.GradientType;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;

	public class BasicMouseFollowTip extends ChartUIBase implements ITipUI
	{
		private var _t:TextField;
		
		private var _isShown:Boolean = false;
		
		public function BasicMouseFollowTip()
		{
			
		}
		
		
		override protected function create():void
		{
			if(_t == null)
			{
				_t = new TextField();
				_t.multiline = true;
				_t.autoSize = TextFieldAutoSize.LEFT;
//				_t.blendMode = BlendMode.LAYER;
				_t.selectable = false;
				_t.x = _t.y = 5;
				addChild(_t);
			}
			
			this.filters = [new DropShadowFilter(2,45,0,0.5)];
		}
		
		public function setContent(chart:CoordinateChart, index:int, tf:TextFormat = null):void
		{
			
		}
		
		/**
		 * 更新文本
		 * @param value
		 * @param tf
		 * @param renderAsHTML
		 */		
		public function setLabel(value:String, tf:TextFormat = null, renderAsHTML:Boolean = false):void
		{
			if(renderAsHTML) _t.htmlText = value;
			else _t.text = value;
			if(tf != null){
				_t.defaultTextFormat = tf;
				_t.setTextFormat(tf);
			}
			
			this.graphics.clear();
			this.graphics.lineStyle(1, 0xcccccc,1,false,"normal", CapsStyle.ROUND);
			this.graphics.beginFill(0xffffff);
//			this.graphics.beginGradientFill(GradientType.LINEAR, [0xcccccc, 0xffffff], [1, 1], [0,255]);
			this.graphics.drawRoundRect(0,0,_t.textWidth + 13, _t.textHeight + 13, 8, 8);
			this.graphics.endFill();
			
			uiWidth = _t.textWidth + 13;
			uiHeight = _t.textHeight + 13;
		}
		
		/**
		 * 添加到显示列表
		 * @param container
		 * @param xpos
		 * @param ypos
		 * @param area
		 */		
		public function show(container:DisplayObjectContainer, xpos:Number, ypos:Number, area:Rectangle, skipEffect:Boolean = false):void
		{
			TweenMax.to(this, 0.3, {x: xpos, y:ypos});
//			move(xpos, ypos);			
			if(_isShown) return;
			_isShown = true;		
			this.alpha = 0;
			this.visible = false;
			container.addChild(this);
			showEffect(skipEffect);
		}
		
		/**
		 * 隐藏TIP
		 */		
		public function hide(skipEffect:Boolean = false):void
		{
			if(!_isShown) return;
			_isShown = false;
			hideEffect(skipEffect);
		}
		
		protected function showEffect(skipEffect:Boolean):void
		{
			if(!skipEffect) TweenMax.to(this, 0.3, { autoAlpha: 1} );
			else{
				this.alpha = 1;
				this.visible = true;
			}
		}
		
		protected function hideEffect(skipEffect:Boolean):void
		{
			if(!skipEffect) TweenMax.to(this, 0.3, { autoAlpha: 0 } );
			else{
				this.alpha = 0;
				this.visible = false;		
			}
		}
		
	}
}