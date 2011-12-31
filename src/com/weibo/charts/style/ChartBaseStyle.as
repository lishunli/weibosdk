package com.weibo.charts.style
{
	import flash.display.DisplayObject;

	public class ChartBaseStyle
	{
		public var showBorder:Boolean = false;
		
		public var borderThickness:int = 1;
		
		public var borderColor:int = 0x000000;
		
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
		
		/**
		 * 0：不显示,1:一直显示，2：需要触发 
		 */		
		public var tipType:int = 0;
		
	}
}