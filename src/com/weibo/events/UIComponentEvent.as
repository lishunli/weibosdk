package com.weibo.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Qi Donghui
	 */
	public class UIComponentEvent extends Event 
	{		
		public static const MOVE:String = "move";
		public static const LOCATE:String = "locate";
		
		public var data:Object;
		
		public function UIComponentEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			this.data = data;
			super(type, bubbles, cancelable);		
		} 
		
		public override function clone():Event 
		{ 
			return new UIComponentEvent(type, data, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("UIComponentEvent", "data", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}