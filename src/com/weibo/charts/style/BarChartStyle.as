package com.weibo.charts.style 
{
	import com.weibo.charts.ChartBase;
	import com.weibo.charts.ui.IBarUI;
	import com.weibo.charts.ui.bars.BasicBar;
	
	import flash.display.DisplayObject;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author yaofei@staff.sina.com.cn
	 */
	public class BarChartStyle 
	{		
		/**
		 * 基础样式
		 */		
		public var baseStyle:ChartBaseStyle = new ChartBaseStyle();
		
		/**
		 * 坐标轴的类型 
		 */		
		public var axisType:AxisStyle = new AxisStyle();
		
		/**
		 * 0：纯色，colors一维，alpha:一维数组
		 * 1：渐变，colors多维
		 * 2：九宫格可视皮肤，skin类
		 * 
		 * alpha:和colors对应
		 */
		public var barType:int;
		
		public var barUI:Class = BasicBar;
		
		public var colors:Array;
		
		public var alpha:Array;
		
		/**
		 * 默认和colors对应，alpha为1
		 */
		public var linesColor:Array;
		
		/**
		 * 线的粗细
		 */
		public var lineThickness:int;
		
		/**
		 * 文字的样式
		 */
		public var tf:TextFormat;
		
		public var skin:Class;
		
		//public var 
				
		public function BarChartStyle() 
		{
			
		}
		
	}

}