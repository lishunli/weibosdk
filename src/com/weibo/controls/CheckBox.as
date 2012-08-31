package com.weibo.controls
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;

	public class CheckBox extends Sprite
	{
		public static const CHECK_ON:String = "check_on";
		public static const CHECK_OFF:String = "check_off";
		
		[Embed(source="../assets/check_on.png")]
		private const CheckOn:Class;
		
		[Embed(source="../assets/check_off.png")]
		private const CheckOff:Class;
		
		
		private const checkOn:DisplayObject = new CheckOn();
		private const checkOff:DisplayObject = new CheckOff();
		
		private const checkIcon:DisplayObjectContainer = new Sprite();
		private var labelText:Label;
		private var iconWidth:Number = 14;
		
		public function CheckBox(textFormat:TextFormat=null)
		{
			labelText = new Label("", textFormat || new TextFormat("Arial", 12, 0x666666));
			labelText.mouseEnabled = false;
			labelText.x = 16;
			checkIcon.y = 3;
			addChild(checkIcon);
			addChild(labelText);
			goto(0);
			this.buttonMode = true;
			this.addEventListener(MouseEvent.CLICK, clickListener);
		}
		private function clickListener(event:MouseEvent):void {
			selected = !selected;
		}
		
		
		/**公开方法
		 -------------------------------------------------------*/
		public function set label(value:String):void {
			labelText.text = value;
		}
		public function get label():String {
			return labelText.text;
		}
		//选中状态
		public function setSelected(value:Boolean):void
		{
			if (value == selected) return;
			if (value)	goto(1);
			else		goto(0);
		}
		public function set selected(value:Boolean):void
		{
			if (value == selected) return;
			if (value)	goto(1);
			else		goto(0);
			dispatchEvent(new Event(Event.CHANGE, false, false));
		}
		public function get selected():Boolean
		{
			if (contains(checkOn))	return true;
			return false;
		}
		//可用状态
		public function set enabled(value:Boolean):void {
			mouseEnabled = mouseChildren = value;
//			labelText.textColor = value ? 0x666666 : 0xcccccc;
			checkIcon.alpha = value ? 1 : .6;
		}
		public function get enabled():Boolean {
			return mouseEnabled;
		}
		//边距
		public function set margin(value:Number):void {
			labelText.x = iconWidth + value;
		}
		public function get margin():Number {
			return labelText.x - iconWidth;
		}
		
		private function goto(frame:int):void
		{
			while (checkIcon.numChildren > 0)
			{
				checkIcon.removeChildAt(0);
			}
			switch (frame)
			{
				case 0:
					checkIcon.addChild(checkOff);
					break;
				case 1:
					checkIcon.addChild(checkOn);
					break;
			}
		}
	}
}