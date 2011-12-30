package com.weibo.charts.ui.sectors
{
	import com.weibo.charts.ui.ChartUIBase;
	import com.weibo.charts.ui.ISectorUI;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import ghostcat.util.display.ColorUtil;
	
	/**
	 * 带边框的的扇形
	 * @author yaofei@staff.sina.com.cn
	 */
	public class BorderSector extends ChartUIBase implements ISectorUI
	{
		private var _basic:Sprite;
		private var _inShape:Sprite;
		
		private var _startAngle:Number;
		private var _endAngle:Number;
		private var _radiusIn:Number = 30;
		private var _radius:Number = 120;
		
		private var _index:int = -1;
		
		public function BorderSector()
		{
			super();
			this.mouseChildren = false;
		}
		
		public function get index():int { return this._index; }
		public function set index(value:int):void { this._index = value; }
		
		public function get radiusIn():Number { return _radiusIn; }
		public function set radiusIn(value:Number):void
		{
			_radiusIn = value;
			this.invalidate("size");
		}

		public function get endAngle():Number { return _endAngle; }
		public function set endAngle(value:Number):void
		{
			_endAngle = value;
			this.invalidate("size");
		}

		public function get startAngle():Number { return _startAngle; }
		public function set startAngle(value:Number):void
		{
			_startAngle = value;
			this.invalidate("size");
		}

		public function get radius():Number{ return _radius; }
		public function set radius(value:Number):void
		{
			_radius = value;
			this.invalidate("styles");
		}
		
		override protected function create():void
		{
			if(_basic == null)
			{
				_basic = new Sprite();
				addChild(_basic);
			}
			if(_inShape == null)
			{
				_inShape = new Sprite();
				addChild(_inShape);
			}
		}
		
		override protected function destroy():void
		{
			if (_basic && this.contains(_basic)) removeChild(_basic);
			_basic = null;
			if (_inShape && this.contains(_inShape)) removeChild(_inShape);
			_inShape = null;
		}
		
		override protected function layout():void
		{
			draw();
		}
		
		override protected function updateState():void
		{
			
		}
		
		private function draw():void
		{
			if (isNaN(this.startAngle) || isNaN(this.endAngle)) return;
			if (startAngle >= endAngle) return;
			_basic.graphics.clear();
			_inShape.graphics.clear();
			
			if (startAngle + Math.PI*2 == endAngle)
			{
				calculateCircle();
			}
			else
			{
				calculateSector();
			}
		}
		
		private function calculateCircle():void
		{
			_basic.graphics.lineStyle(1, ColorUtil.adjustBrightness(uiColor, -20), 1);
			_basic.graphics.beginFill(uiColor, .8);
			_basic.graphics.drawCircle(0, 0, radius);
			_basic.graphics.drawCircle(0, 0, radiusIn);
			_basic.graphics.endFill();
			
			var margin:Number = 2;
			_inShape.graphics.lineStyle(1, 0xffffff, .15);
//			_inShape.graphics.beginFill(uiColor);
			_inShape.graphics.drawCircle(0, 0, radius - margin);
			_inShape.graphics.drawCircle(0, 0, radiusIn + margin);
		}
		
		private function calculateSector():void
		{
			var side:Number = outlineThicknesss;
			var angle:Number = Math.asin(side / radius);
			var sOutAngle:Number = this.startAngle + angle;
			var eOutAngle:Number = this.endAngle - angle;
			angle = Math.asin(side / radiusIn);
			var sInAngle:Number = this.startAngle + angle;
			var eInAngle:Number = this.endAngle - angle;
			
			
			_basic.graphics.lineStyle(1, ColorUtil.adjustBrightness(uiColor, -20), 1);
			_basic.graphics.beginFill(uiColor, .8);
			drawSector(_basic.graphics, sOutAngle, eOutAngle, sInAngle, eInAngle, radius, radiusIn);
			
			var margin:Number = 2;
			side += margin;
			angle = Math.asin(side / (radius - margin));
			sOutAngle = this.startAngle + angle;
			eOutAngle = this.endAngle - angle;
			//内环角度
			angle = Math.asin(side / (radiusIn + margin));
			sInAngle = this.startAngle + angle;
			eInAngle = this.endAngle - angle;
			
			_inShape.graphics.lineStyle(1, 0xffffff, .15);
//			_inShape.graphics.beginFill(uiColor);
			drawSector(_inShape.graphics, sOutAngle, eOutAngle, sInAngle, eInAngle, radius - margin, radiusIn + margin);
		}
		private function drawSector(g:Graphics, sOutAngle:Number, eOutAngle:Number, sInAngle:Number, eInAngle:Number, outRadius:Number, inRadius:Number):void
		{
			var angle:Number;
			var xpos:Number;
			var ypos:Number;
			var points:Array = [];
			if (radiusIn >= radius) radiusIn = 0;
			//
			for (angle = sOutAngle; angle < eOutAngle; angle += .01)
			{
				xpos = Math.cos(angle) * outRadius;
				ypos = Math.sin(angle) * outRadius;
				points.push(new Point(xpos, ypos));
			}
			angle = eOutAngle;
			xpos = Math.cos(angle) * outRadius;
			ypos = Math.sin(angle) * outRadius;
			points.push(new Point(xpos, ypos));
			for (angle = eInAngle; angle > sInAngle; angle -= .01)
			{
				xpos = Math.cos(angle) * inRadius;
				ypos = Math.sin(angle) * inRadius;
				points.push(new Point(xpos, ypos));
			}
			angle = sInAngle;
			xpos = Math.cos(angle) * inRadius;
			ypos = Math.sin(angle) * inRadius;
			points.push(new Point(xpos, ypos));
			
			//绘图
			var point:Point = points.pop() as Point;
			if (point) g.moveTo(point.x, point.y);
			while (points.length > 0)
			{
				point = points.pop() as Point;
				g.lineTo(point.x, point.y);
			}
			g.endFill();
		}
		
	}

}