package com.weibo.comp.weiboPublisher.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Du hailiang | hailiang@staff.sina.com.cn
	 */
	public class PublisherEvent extends Event 
	{
		/**
		 * 事件实例所带的值
		 */
		public var result:Object;
		
		public static const PUBLISH:String = "publish"
		
		public function PublisherEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{
			var e:PublisherEvent = new PublisherEvent(type, bubbles, cancelable);
			e.result = result;
			return e;
		} 
		
		public override function toString():String 
		{ 
			return formatToString("PublisherEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}