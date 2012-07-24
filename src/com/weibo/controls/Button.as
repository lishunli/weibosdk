package com.weibo.controls
{
	import com.weibo.core.UIComponent;
	import com.weibo.core.ValidateType;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
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
		private var _currentState:String;
		private var currentObject:DisplayObject;
		
//		private var upState:DisplayObject;
//		private var overState:DisplayObject;
//		private var downState:DisplayObject;
//		private var disabledState:DisplayObject;
		
		private var _buttonDown:Boolean;
		
		protected var _iconContainer:Sprite;
		protected var _icon:DisplayObject;
		protected var _labelText:Label;
		
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
		
		public function set icon(object:DisplayObject):void
		{
			_icon = object;
			
			invalidate(ValidateType.STATE);
		}
		
		public function set label(value:String):void
		{
			_labelText.text = value;
			invalidate(ValidateType.SIZE);
		}
		
		/**
		 * @return Label 文本对象
		 */		
		public function get labelComponent():Label
		{
			return _labelText;
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
		
		protected function get currentState():String
		{
			return _currentState;
		}
		
		override protected function create():void
		{
			setState("upState");
			
			_iconContainer = new Sprite();
			addChild(_iconContainer);
			
			_labelText = new Label("", new TextFormat("Arial", 12, 0x666666));
			addChild(_labelText);
		}
		
		override protected function destroy():void
		{
			if (_labelText){
				if (contains(_labelText))	removeChild(_labelText);
				_labelText = null;
			}
			if (_iconContainer){
				if (contains(_iconContainer))	removeChild(_iconContainer);
				while (_iconContainer.numChildren > 0)	removeChildAt(0);
				_iconContainer = null;
			}
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
			while (_iconContainer.numChildren > 0){
				_iconContainer.removeChildAt(0);
			}
			
			if (_icon){
				_iconContainer.addChild(_icon);
			}
			
			_labelText.x = (width - _labelText.width) / 2;
			_labelText.y = (height - _labelText.height) / 2;
			
//			this.graphics.clear();
//			this.graphics.lineStyle(1, 0xccff00);
//			this.graphics.drawRect(0,0,width,height);
		}
		
		protected function setState(value:String):void
		{
			_currentState = value;
			if (currentObject && contains(currentObject)) removeChild(currentObject);
			
			var button:DisplayObject = states[value] || states["upState"];
			currentObject = button;
			if (button) addChildAt(button, 0);
			
			invalidate(ValidateType.STATE);
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