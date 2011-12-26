package com.weibo.charts 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Qi Donghui
	 */
	public class WeiboChartEvent extends Event 
	{
		public static const WEIBO_CHART_STATUS:String = "weiboChartStatus";
		
		
		
		/**
		 * 渲染完毕的code码
		 */
		public static const RENDER_COMPLETE:String = "0";
		
		/**
		 * 
		 */
		public static const GET_DATA_ERROR:String = "1";
		
		/**
		 * 当前状态的code码
		 */
		public var code:String;
		
		public function WeiboChartEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new WeiboChartEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("WeiboChartEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}