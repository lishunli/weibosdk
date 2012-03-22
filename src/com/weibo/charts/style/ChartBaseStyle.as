package com.weibo.charts.style
{
	import flash.display.DisplayObject;

	public class ChartBaseStyle
	{
		public var showBg:Boolean = false;
		
		public var bgAlpha:Number = 0;
		
		public var bgColor:int = 0xffffff;
		
		/**
		 * 背景图片地址 
		 */		
		public var bgURL:String = "";
		
		/**
		 * 背景显示对象 
		 */		
		public var bg:DisplayObject = null;
		
	}
}