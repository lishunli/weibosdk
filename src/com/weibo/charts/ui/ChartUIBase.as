package com.weibo.charts.ui
{
	import com.weibo.core.UIComponent;
	import com.weibo.managers.RepaintManager;
	
	import flash.display.DisplayObjectContainer;
	
	public class ChartUIBase extends UIComponent implements IChartUIBase
	{
		private var _uiWidth:Number = 30;
		private var _uiHeight:Number = 0;
		
		private var _uiColor:Number = 0xffffff;
		private var _uiAlpha:Number = 1;
		private var _outlineColor:Number = 0x000000;
		private var _outlineThicknesss:Number = 1;
		
		public function ChartUIBase()
		{
			super();
		}
		
		protected function inEffect():void
		{
			
		}
		
		public function addMe(parent:DisplayObjectContainer):void
		{
			parent.addChild(this);
		}
		
		public function removeMe():void
		{
			if (this.parent) parent.addChild(this);
		}

		public function get uiWidth():Number{return _uiWidth;}
		public function set uiWidth(value:Number):void
		{
			_uiWidth = value;
			this._validateTypeObject["size"] = true;
			RepaintManager.getInstance().addToRepaintQueue(this);		
		}

		public function get uiHeight():Number{return _uiHeight;}
		public function set uiHeight(value:Number):void
		{
			_uiHeight = value;
			this._validateTypeObject["size"] = true;
			RepaintManager.getInstance().addToRepaintQueue(this);
		}

		public function get uiColor():Number{return _uiColor;}
		public function set uiColor(value:Number):void
		{
			_uiColor = value;
			this._validateTypeObject["styles"] = true;
			RepaintManager.getInstance().addToRepaintQueue(this);
		}	

		public function get outlineColor():Number{return _outlineColor;}
		public function set outlineColor(value:Number):void
		{
			_outlineColor = value;
			this._validateTypeObject["styles"] = true;
			RepaintManager.getInstance().addToRepaintQueue(this);
		}

		public function get outlineThicknesss():Number{return _outlineThicknesss;}
		public function set outlineThicknesss(value:Number):void
		{
			_outlineThicknesss = value;
			this._validateTypeObject["styles"] = true;
			RepaintManager.getInstance().addToRepaintQueue(this);
		}

		public function get uiAlpha():Number{return _uiAlpha;}
		public function set uiAlpha(value:Number):void
		{
			_uiAlpha = value;
			this._validateTypeObject["styles"] = true;
			RepaintManager.getInstance().addToRepaintQueue(this);
		}
	}
}