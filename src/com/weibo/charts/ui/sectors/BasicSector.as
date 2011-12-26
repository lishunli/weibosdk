package com.weibo.charts.ui.sectors
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.weibo.charts.managers.RepaintManager;
	import com.weibo.charts.ui.ChartUIBase;
	import com.weibo.charts.ui.IBarUI;
	import com.weibo.charts.ui.ISectorUI;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 纯色的扇形
	 * @author yaofei@staff.sina.com.cn
	 */
	public class BasicSector extends ChartUIBase implements ISectorUI
	{
		private var _basic:Sprite;
		
		private var _startAngle:Number;
		private var _endAngle:Number;
		private var _radiusIn:Number = 30;
		private var _radius:Number = 120;
		
		public function get radiusIn():Number { return _radiusIn; }
		public function set radiusIn(value:Number):void
		{
			_radiusIn = value;
			this._validateTypeObject["size"] = true;
			RepaintManager.getInstance().addToRepaintQueue(this);
		}

		public function get endAngle():Number { return _endAngle; }
		public function set endAngle(value:Number):void
		{
			_endAngle = value;
			this._validateTypeObject["size"] = true;
			RepaintManager.getInstance().addToRepaintQueue(this);
		}

		public function get startAngle():Number { return _startAngle; }
		public function set startAngle(value:Number):void
		{
			_startAngle = value;
			this._validateTypeObject["size"] = true;
			RepaintManager.getInstance().addToRepaintQueue(this);
		}

		public function get radius():Number{ return _radius; }
		public function set radius(value:Number):void
		{
			_radius = value;
			this._validateTypeObject["styles"] = true;
			RepaintManager.getInstance().addToRepaintQueue(this);
		}
		
		override public function create():void
		{
			if(_basic == null)
			{
				_basic = new Sprite();
				addChild(_basic);
			}
		}
		
		override public function destroy():void
		{
			if (_basic && this.contains(_basic)) removeChild(_basic);
			_basic = null;
		}
		
		override public function layout():void
		{
			draw();
		}
		override public function updateState():void
		{
			
		}
		private function draw():void
		{
			_basic.graphics.clear();
			
			if (_startAngle >= _endAngle) return;
			
			_basic.graphics.lineStyle(outlineThicknesss, outlineColor);
			_basic.graphics.beginFill(uiColor);
			
			var angle:Number;
			var xpos:Number;
			var ypos:Number;
			var insidePoints:Array = [];
			if (radiusIn >= radius) radiusIn = 0;
			for (angle = _startAngle; angle < _endAngle; angle += .01)
			{
				xpos = Math.cos(angle) * _radiusIn;
				ypos = Math.sin(angle) * _radiusIn;
				insidePoints.push(new Point(xpos, ypos));
				
				xpos = Math.cos(angle) * _radius;
				ypos = Math.sin(angle) * _radius;
				if (angle == _startAngle)
				{
					_basic.graphics.moveTo(xpos, ypos);
				}
				else
				{
					_basic.graphics.lineTo(xpos, ypos);
				}
			}
			angle = _endAngle;
			xpos = Math.cos(angle) * _radiusIn;
			ypos = Math.sin(angle) * _radiusIn;
			insidePoints.push(new Point(xpos, ypos));
			
			xpos = Math.cos(angle) * _radius;
			ypos = Math.sin(angle) * _radius;
			_basic.graphics.lineTo(xpos, ypos);
			
			while (insidePoints.length > 0)
			{
				var point:Point = insidePoints.pop() as Point;
				_basic.graphics.lineTo(point.x, point.y);
			}
			_basic.graphics.endFill();
		}
		
	}

}