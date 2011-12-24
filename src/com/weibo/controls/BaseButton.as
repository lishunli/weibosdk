package com.weibo.controls 
{
	import com.weibo.core.UIComponent;
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
		
		public function BaseButton() 
		{
			
		}
		
		override protected function initialize():void 
		{
			if(_states == null) _states = new Dictionary();
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
			if (stage) stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUpHandler);			
			_hitArea.removeEventListener(MouseEvent.ROLL_OVER, onRollOverHandler);
			_hitArea.removeEventListener(MouseEvent.ROLL_OUT, onRollOutHandler);			
		}
		
		private function onStageMouseUpHandler(e:MouseEvent):void 
		{
			if (stage) stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUpHandler);
			if (_hitArea.hitTestPoint(stage.mouseX, stage.mouseY, true))
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
	}
}