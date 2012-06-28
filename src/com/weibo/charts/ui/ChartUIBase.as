package com.weibo.charts.ui
{
	import com.weibo.core.UIComponent;
	import com.weibo.core.ValidateType;
	
	import flash.display.DisplayObjectContainer;
	
	public class ChartUIBase extends UIComponent implements IChartUIBase
	{
		private var _uiWidth:Number = 30;
		private var _uiHeight:Number = 0;
		
		private var _uiColor:Number = 0xffccff;
		private var _uiAlpha:Number = 1;
		private var _outlineColor:Number = 0x000000;
		private var _outlineThicknesss:Number = 1;
		
		private var _selected:Boolean = false;
		private var _state:String;
		
		public function ChartUIBase()
		{
			super();
		}
		
		/*public function addMe(parent:DisplayObjectContainer):void
		{
			parent.addChild(this);
		}
		
		public function removeMe():void
		{
			if (this.parent) parent.addChild(this);
		}*/

		public function get uiWidth():Number{return _uiWidth;}
		public function set uiWidth(value:Number):void
		{
			_uiWidth = value;
			this.invalidate("size");
		}

		public function get uiHeight():Number{return _uiHeight;}
		public function set uiHeight(value:Number):void
		{
			_uiHeight = value;
			this.invalidate("size");
		}

		public function get uiColor():Number{return _uiColor;}
		public function set uiColor(value:Number):void
		{
			_uiColor = value;
			this.invalidate(ValidateType.STATE);
		}	

		public function get outlineColor():Number{return _outlineColor;}
		public function set outlineColor(value:Number):void
		{
			_outlineColor = value;
			this.invalidate(ValidateType.STATE);
		}

		public function get outlineThicknesss():Number{return _outlineThicknesss;}
		public function set outlineThicknesss(value:Number):void
		{
			_outlineThicknesss = value;
			this.invalidate(ValidateType.STATE);
		}

		public function get uiAlpha():Number{return _uiAlpha;}
		public function set uiAlpha(value:Number):void
		{
			_uiAlpha = value;
			this.invalidate(ValidateType.STATE);
		}

		public function get selected():Boolean { return _selected; }
		public function set selected(value:Boolean):void
		{
			_selected = value;
			this.invalidate(ValidateType.STATE);
		}
		
		public function get state():String
		{
			return _state;
		}
		public function set state(value:String):void
		{
			_state = value;
			invalidate();
		}

	}
}