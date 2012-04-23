package com.weibo.charts.style
{
	/**
	 * 
	 * yaofei
	 */
	public class GridStyle
	{
		public var addMore:Boolean = true;
		
		//=================
		// 网格线属性
		public var lineColor:uint = 0xe7e7e7;
		public var thickness:Number = 1;
		
		public var showLabelGrid:Boolean = false;
		
		public var alignLabel:Boolean = false;
		
		//=================
		// 背景
		public var background:Boolean = false;
		public var backgroundColor:uint = 0xfbfbfb;
		public var backgroundAlpha:Number = .3;
		
		//=================
		// 边框
		public var borderColor:uint = 0xc9c9c9;
		public var borderThickness:Number = 2;
		public var topBorder:Boolean = false;
		public var rightBorder:Boolean = false;
		public var bottomBorder:Boolean = false;
		public var leftBorder:Boolean = false;
		
		public function GridStyle()
		{
			
		}
	}
}