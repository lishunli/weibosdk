package com.weibo.controls
{
	import com.weibo.core.UIComponent;
	import com.weibo.core.ValidateType;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	/**
	 * 带有可用状态的按钮
	 * @author yaofei@staff.sina.com.cn
	 */	
	public class Button extends UIComponent
	{
		private var states:Dictionary;
		private var currentState:String;
		private var currentObject:DisplayObject;
		
//		private var upState:DisplayObject;
//		private var overState:DisplayObject;
//		private var downState:DisplayObject;
//		private var disabledState:DisplayObject;
		
		private var _buttonDown:Boolean;
		
		private var _labelText:Label;
		
		private var _enabled:Boolean = true;
		
		public function Button(upState:DisplayObject, 
							   overState:DisplayObject = null, 
							   downState:DisplayObject = null, 
							   disabledState:DisplayObject = null)
		{
			states = new Dictionary();
			states["upState"] = upState;
			states["overState"] = overState;
			states["downState"] = downState;
			states["disabledState"] = disabledState;
			
			super();
			this.buttonMode = true;
			this.mouseChildren = false;
		}
		
//===================================
// 公开方法
		
		public function set upState(state:DisplayObject):void
		{
			states["upState"] = state;
			if (currentState == "upState")	setState("upState");
		}
		
		public function set overState(state:DisplayObject):void
		{
			states["overState"] = state;
			if (currentState == "overState")	setState("overState");
		}
		
		public function set downState(state:DisplayObject):void
		{
			states["downState"] = state;
			if (currentState == "downState")	setState("downState");
		}
		
		public function set disabledState(state:DisplayObject):void
		{
			states["disabledState"] = state;
			if (currentState == "disabledState")	setState("disabledState");
		}
		
		public function set label(value:String):void
		{
			_labelText.text = value;
			invalidate(ValidateType.SIZE);
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			setState("disabledState");
			_enabled = mouseEnabled = value;
		}
		
		override public function get width():Number
		{
			return currentObject ? currentObject.width : 0;
		}
		
		override public function get height():Number
		{
			return currentObject ? currentObject.height : 0;
		}
		
//===================================
// 内部方法
		
		override protected function create():void
		{
			setState("upState");
			
			_labelText = new Label("", new TextFormat("Arial", 12, 0x666666));
			addChild(_labelText);
		}
		
		override protected function addEvents():void
		{
			super.addEvents();
			
			addEventListener(MouseEvent.ROLL_OVER, stateHandler);
			addEventListener(MouseEvent.ROLL_OUT, stateHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, stateHandler);
			addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		override protected function updateState():void
		{
			_labelText.x = (width - _labelText.width) / 2;
			_labelText.y = (height - _labelText.height) / 2;
		}
		
		protected function setState(value:String):void
		{
			currentState = value;
			if (currentObject && contains(currentObject)) removeChild(currentObject);
			
			var button:DisplayObject = states[value] || states["upState"];
			currentObject = button;
			if (button) addChildAt(button, 0);
			
		}
		
//===================================
// 事件侦听器
		
		/*private function buttonOnDown(event:MouseEvent):void
		{
			trace(simpleButton);
			simpleButton.upState = simpleButton.overState;
		}*/
		
		private function stateHandler(event:MouseEvent):void
		{
			switch(event.type)
			{
				case MouseEvent.ROLL_OVER:
//					if (event.buttonDown) break;
					if (!_buttonDown) setState("overState");
					break;
				case MouseEvent.ROLL_OUT:
//					if (event.buttonDown) break;
					if (!_buttonDown) setState("upState");
					break;
				case MouseEvent.MOUSE_DOWN:
					setState("downState");
					_buttonDown = true;
					stage.addEventListener(MouseEvent.MOUSE_UP, stateHandler);
					break;
				case MouseEvent.MOUSE_UP:
					setState("upState");
					_buttonDown = false;
					stage.removeEventListener(MouseEvent.MOUSE_UP, stateHandler);
					break;
				default:
					break;
			}
		}
		
		private function clickHandler(event:MouseEvent):void
		{
			if (!enabled) event.stopImmediatePropagation();
		}
	}
}