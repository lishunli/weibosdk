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
		
		/**
		 * 主图形的颜色
		 */		
		public var colors:Array = [0x519ae5];
		
		
		public var border:Boolean = false;
		public var borderThickness:int = 1;
//		public var borderColor:int = 0x000000;
		
		/**
		 * 是否显示为百分比
		 */		
		public var isRate:Boolean = false;
	}
}