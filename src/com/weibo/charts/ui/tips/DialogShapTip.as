package com.weibo.charts.ui.tips
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;
	import com.weibo.charts.ui.ChartUIBase;
	import com.weibo.charts.ui.ITipUI;
	
	import flash.display.BlendMode;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class DialogShapTip extends ChartUIBase implements ITipUI
	{
		private var _t:TextField;
		
		private var _ydis:int = 9;
		
		private var _twidth:Number;
		private var _theight:Number;
		
		private var _space:Number = 10;
		
		public function DialogShapTip()
		{
			super();
		}
		
		override protected function create():void
		{
			if(_t == null)
			{
				_t = new TextField();
				_t.autoSize = TextFieldAutoSize.LEFT;
				_t.blendMode = BlendMode.LAYER;
				_t.selectable = false;
				addChild(_t);
			}	
		}
		
		override protected function layout():void
		{
			
		}
		
		override protected function addEvents():void
		{
			
		}
		
		override protected function removeEvents():void
		{
			
		}
		
		override protected function destroy():void
		{
//			if (_t != null)
//			{
//				removeChild(_t);
//				_t = null;
//			}
//			graphics.clear();
		}
		
		public function setLabel(value:String, tf:TextFormat=null, renderAsHTML:Boolean=false):void
		{
			if(renderAsHTML) _t.htmlText = value;
			else _t.text = value;
			if(tf != null){
				_t.defaultTextFormat = tf;
				_t.setTextFormat(tf);
			}			
			this.visible = false;
			this.scaleX = this.scaleY = 1;
			_twidth = _t.width + _space;
			_theight = _t.height;
			this.scaleX = this.scaleY = 0;
			this.visible = true;	
		}
		
		public function get labelWidth():Number
		{
			return 0;
		}
		
		public function show(container:DisplayObjectContainer, xpos:Number, ypos:Number, area:Rectangle):void
		{
//			trace(">>>" + x + ":::" + y);
			if ((xpos == 0 && ypos == 0) ||this.x != xpos || this.y != ypos)
			{				
				graphics.clear();			
				
				var tWidth:Number = _twidth;
				var tHeihgt:Number = _theight;
				var halfWidth:Number = tWidth * .5;
				var halfHeihgt:Number = tHeihgt * .5;
//				trace("this.x :: " + this.x, "this.y :: " + this.y);
//				trace("x :: " + x, "y :: " + y);
				var pointAry:Array = [];
				
				_ydis = 9;
				
				if (xpos - halfWidth < area.x)
				{
					if (ypos - tHeihgt - 4 < area.top)
					{
						_t.x = _space * 0.5;
						_t.y = 4;
						pointAry[0] = new Point(0, 0);
						pointAry[1] = new Point(7,4);
						pointAry[2] = new Point(tWidth,4);
						pointAry[3] = new Point(tWidth, tHeihgt + 4);
						pointAry[4] = new Point(0,tHeihgt + 4);
						
					}else {
						_t.x = _space * 0.5;
						_t.y = -tHeihgt - 4;
						pointAry[0] = new Point(0, _t.y);
						pointAry[1] = new Point(tWidth, _t.y);
						pointAry[2] = new Point(tWidth, -4);
						pointAry[3] = new Point(7, -4);
						pointAry[4] = new Point(0, 0);
						_ydis *= -1;
					}
				}else if (xpos + halfWidth > area.right)
				{
					if (ypos - tHeihgt - 4 < area.top)
					{
						_t.x = -tWidth + _space * 0.5;
						_t.y = 4;
						pointAry[0] = new Point(-tWidth, 4);
						pointAry[1] = new Point(-7, 4);
						pointAry[2] = new Point(0, 0);
						pointAry[3] = new Point(0, tHeihgt + 4);
						pointAry[4] = new Point(-tWidth, tHeihgt + 4);
						
					}else {
						_t.x = -tWidth + _space * 0.5;
						_t.y = -tHeihgt - 4;
						pointAry[0] = new Point(-tWidth, _t.y);
						pointAry[1] = new Point(0, _t.y);
						pointAry[2] = new Point(0, 0);
						pointAry[3] = new Point(-7, -4);
						pointAry[4] = new Point(-tWidth, -4);
						_ydis *= -1;
					}
					
				}else{
					if (ypos - tHeihgt - 4 < area.y)
					{
						_t.x = -halfWidth + _space * 0.5;
						_t.y = 4;
						pointAry[0] = new Point(-halfWidth, 4);
						pointAry[1] = new Point(-3.5, 4);
						pointAry[2] = new Point(0, 0);
						pointAry[3] = new Point(3.5, 4);
						pointAry[4] = new Point(halfWidth, 4);
						pointAry[5] = new Point(halfWidth, tHeihgt + 4);
						pointAry[6] = new Point(-halfWidth, tHeihgt + 4);
						
					}else {
						_t.x = -halfWidth + _space * 0.5;
						_t.y = -tHeihgt - 4;
						pointAry[0] = new Point(-halfWidth, _t.y);
						pointAry[1] = new Point(halfWidth, _t.y);
						pointAry[2] = new Point(halfWidth, -4);
						pointAry[3] = new Point(3.5, -4);
						pointAry[4] = new Point(0, 0);
						pointAry[5] = new Point(-3.5, -4);
						pointAry[6] = new Point(-halfWidth, -4);
						_ydis *= -1;
					}
				}
				
				var len:int = pointAry.length;
				
				graphics.beginFill(uiColor, uiAlpha);
				var point:Point = pointAry[0] as Point;
				graphics.moveTo(point.x, point.y);
				for (var i:int = 1; i < len; i++)
				{
					point = pointAry[i] as Point;
					graphics.lineTo(point.x, point.y);
				}
				point = pointAry[0] as Point;
				graphics.lineTo(point.x, point.y);
				graphics.endFill();
				
				move(xpos,ypos + _ydis);
//				trace("this.x :: " + this.x, "this.y :: " + this.y);
//				trace();
				container.addChild(this);
			}
			showEffect();
		}
		
		override public function move(x:Number, y:Number):void
		{
			super.move(x, y-9);
		}
		
		protected function showEffect():void
		{
			this.scaleX = this.scaleY = 0;
			TweenMax.to(this, 0.8, { scaleX:1, scaleY:1, ease:Elastic.easeOut} );
		}
		
		protected function hideEffect():void
		{
			TweenMax.to(this, 0.3, { scaleX:0, scaleY:0 } );
		}		
		
		public function hide():void
		{
			hideEffect();
		}
	}
}