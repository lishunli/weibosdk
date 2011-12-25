package com.weibo.controls 
{
	import com.weibo.managers.RepaintManager;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Qi Donghui
	 */
	public class LinkButton extends BaseButton 
	{
		protected var _text:String;
		
		protected var _tf:TextField;
		
		protected var _overFormat:TextFormat;
		protected var _outFormat:TextFormat;
		protected var _downFormat:TextFormat;
		protected var _disableFormat:TextFormat;
		protected var _selectedFormat:TextFormat;
		
		protected var _la:Label;
		
		protected var _paddingLeft:Number = 0;
		protected var _paddingRight:Number = 0;
		protected var _paddingTop:Number = 0;
		protected var _paddingBottom:Number = 0;
		
		protected var _area:Sprite;
		
		public function LinkButton(text:String, outFormat:TextFormat = null, overFormat:TextFormat = null,downFormat:TextFormat = null,  disableFormat:TextFormat = null, selectedFormat:TextFormat = null) 
		{
			_text = text;
			_outFormat = outFormat;
			_overFormat = overFormat;
			_downFormat = downFormat;
			_disableFormat = disableFormat;
			_selectedFormat = selectedFormat;
			super();
		}
		
		override protected function create():void
		{
			_la = new Label(_text, _outFormat);	
			addChildAt(_la, 0);
		}
		
		override protected function layout():void
		{
			_la.x = _paddingLeft;
			_la.y = _paddingTop;
			_area.graphics.clear();
			_area.graphics.beginFill(0);
			_area.graphics.drawRect(0, 0, _paddingLeft + _paddingRight + _la.width, _paddingTop + _paddingBottom + _la.height);
			_area.graphics.endFill();
			this.visible = true;
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			_area = new Sprite();
			_area.alpha = 0;
			addChild(_area);
			initUI(_area, outUI, downUI, overUI);
		}
		
		override protected function updateState():void
		{
			if (_la != null)
			{
				if (_selected)
				{
					if (_selectedFormat != null) _la.setTextFormat(_selectedFormat);
					else if (_downFormat != null) _la.setTextFormat(_downFormat);
					else if (_overFormat != null) _la.setTextFormat(_overFormat);
				}
				else {
					backToNormalState();
				}
			}
		}			
		
		private function overUI():void
		{
			_la.setTextFormat(_overFormat);
		}
		
		private function outUI():void
		{
			_la.setTextFormat(_outFormat);
		}
		
		private function downUI():void
		{
			_la.setTextFormat(_overFormat);
		}		
		
		public function get paddingLeft():Number { return _paddingLeft; }
		public function set paddingLeft(value:Number):void 
		{
			this.visible = false;
			_paddingLeft = value;
			_validateTypeObject["size"] = true;
			RepaintManager.getInstance().addToRepaintQueue(this);
		}
		
		public function get paddingRight():Number { return _paddingRight; }
		public function set paddingRight(value:Number):void 
		{
			this.visible = false;
			_paddingRight = value;
			_validateTypeObject["size"] = true;
			RepaintManager.getInstance().addToRepaintQueue(this);			
		}
		
		public function get paddingTop():Number { return _paddingTop; }
		public function set paddingTop(value:Number):void 
		{
			this.visible = false;
			_paddingTop = value;
			_validateTypeObject["size"] = true;
			RepaintManager.getInstance().addToRepaintQueue(this);			
		}
		
		public function get paddingBottom():Number { return _paddingBottom; }
		public function set paddingBottom(value:Number):void 
		{
			this.visible = false;
			_paddingBottom = value;
			_validateTypeObject["size"] = true;
			RepaintManager.getInstance().addToRepaintQueue(this);			
		}
		
	}

}