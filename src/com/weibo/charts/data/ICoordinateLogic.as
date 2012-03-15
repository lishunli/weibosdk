package com.weibo.charts.data
{
	import com.weibo.charts.IWeiboChart;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * 笛卡尔坐标系的轴逻辑
	 * @author yaofei@staff.sina.com.cn
	 */
	public interface ICoordinateLogic extends IAxisLogic
	{
		/**
		 * 是否反转XY轴，如：BarChart会反转X和Y轴
		 * @param value Boolean
		 */		
		function set reverseAxis(value:Boolean):void;
		
		/**
		 * 是否反转XY轴，如：BarChart会反转X和Y轴
		 * @return Boolean
		 */		
		function get reverseAxis():Boolean;
		
		/**
		 * 标签轴文字的宽（高）度，单位：像素
		 * @param value Number
		 */		
		function set labelLength(value:Number):void;
		
		/**
		 * 数值轴文字的宽（高）度，单位：像素
		 * @param value Number
		 */		
		function set valueLength(value:Number):void;
		
		/**
		 * 数值轴是否显示整数
		 * @param value Boolean
		 */		
		function set integer(value:Boolean):void;
		
		/**
		 * 是否总显示0坐标
		 * @param value
		 */		
		function set alwaysShow0(value:Boolean):void;
		
		/**
		 * 获取标签轴数据
		 * @return Array
		 */		
		function get labelData():Array;
		
		/**
		 * 获取标签轴的网格数据
		 * @return Array
		 */		
		function get labelGridData():Array;
		
		/**
		 * 获取数值轴数据
		 * @return Array
		 */		
		function get valueData():Array;
		
		/**
		 * 获取数值轴数据
		 * @return Array
		 */		
		function get valueSubData():Array;
		
		/**
		 * 根据数据获取坐标值
		 * @param data
		 * @return Number
		 */		
		function getPosition(value:Number, axis:int = 0):Number;
	}
	
}