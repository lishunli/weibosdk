package com.weibo.controls 
{
	import com.weibo.core.UIComponent;
	import com.weibo.managers.RepaintManager;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Qi Donghui
	 */
	public class BaseButton extends UIComponent 
	{
		protected var _states:Dictionary;
		
		private var _hitArea:Sprite;
		
		protected var _toggle:Boolean = false;
		protected var _selected:Boolean = false;
		
		public function BaseButton() 
		{
			
		}
		
		override protected function initialize():void
		{
			if (_states == null) _states = new Dictionary();
		}
		
		override protected function addEvents():void
		{
			if (_hitArea != null)
			{
				_hitArea.addEventListener(MouseEvent.ROLL_OVER, onRollOverHandler);
				_hitArea.addEventListener(MouseEvent.ROLL_OUT, onRollOutHandler);
				_hitArea.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			}
		}
		
		override protected function removeEvents():void
		{
			if (_hitArea != null)
			{
				_hitArea.removeEventListener(MouseEvent.ROLL_OVER, onRollOverHandler);
				_hitArea.removeEventListener(MouseEvent.ROLL_OUT, onRollOutHandler);
				_hitArea.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			}		
		}
		
		public function initUI(hitArea:Sprite, upUI:Function = null, downUI:Function = null, overUI:Function = null, disableUI:Function = null):void
		{
			_hitArea = hitArea;
			_hitArea.buttonMode = true;
			
			if(upUI != null) _states["up"] = upUI;
			if(downUI != null) _states["down"] = downUI;
			if(overUI != null) _states["over"] = overUI;
			if(disableUI != null) _states["disable"] = disableUI;
			
			_validateTypeObject["all"] = true;
			validate();
		}
		
		private function onMouseDownHandler(e:MouseEvent):void 
		{
			if (_states["down"] != null)
			{
				var fun:Function = _states["down"];
				fun.call();
			}
			if (_toggle)
			{
				selected = !_selected;
			}else {
				if (stage) stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUpHandler);			
				_hitArea.removeEventListener(MouseEvent.ROLL_OVER, onRollOverHandler);
				_hitArea.removeEventListener(MouseEvent.ROLL_OUT, onRollOutHandler);			
			}
		}
		
		private function onStageMouseUpHandler(e:MouseEvent):void 
		{
			if (stage) stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUpHandler);
			backToNormalState();
			_hitArea.addEventListener(MouseEvent.ROLL_OVER, onRollOverHandler);
			_hitArea.addEventListener(MouseEvent.ROLL_OUT, onRollOutHandler);			
		}
		
		private function onRollOutHandler(e:MouseEvent):void 
		{
			if (_states["up"] != null)
			{
				var fun:Function = _states["up"];
				fun.call();
			}
		}
		
		private function onRollOverHandler(e:MouseEvent):void 
		{
			if (_states["over"] != null)
			{
				var fun:Function = _states["over"];
				fun.call();
			}
		}
		
		protected function backToNormalState():void
		{
			if (stage && _hitArea.hitTestPoint(stage.mouseX, stage.mouseY, true))
			{
				if (_states["over"] != null)
				{
					var fun:Function = _states["over"];
					fun.call();
				}
			}else {
				if (_states["up"] != null)
				{
					fun = _states["up"];
					fun.call();
				}
			}	
		}
		
		public function get toggle():Boolean { return _toggle; }
		public function set toggle(value:Boolean):void 
		{
			_toggle = value;
		}
		
		public function get selected():Boolean { return _selected; }
		public function set selected(value:Boolean):void 
		{
			_selected = value;
			
			if (_selected) {
				_hitArea.removeEventListener(MouseEvent.ROLL_OVER, onRollOverHandler);
				_hitArea.removeEventListener(MouseEvent.ROLL_OUT, onRollOutHandler);
			}else {
				_hitArea.addEventListener(MouseEvent.ROLL_OVER, onRollOverHandler);
				_hitArea.addEventListener(MouseEvent.ROLL_OUT, onRollOutHandler);
			}
			
			_validateTypeObject["state"] = true;
			RepaintManager.getInstance().addToRepaintQueue(this);
		}
	}
}