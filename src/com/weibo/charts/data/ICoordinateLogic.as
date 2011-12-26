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
		 * 方向类型，用于区分BarChart和ColumnChart
		 * @param value String
		 */		
		function set axisType(value:String):void;
		
		/**
		 * 方向类型，用于区分BarChart和ColumnChart
		 * @return String
		 */		
		function get axisType():String;
		
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
		 * 指定数据中表示标签的KEY值，默认为：“label”
		 * @param value String
		 */		
		function set labelKey(value:String):void;
		
		/**
		 * 指定数据中表示数值的KEY值，默认为：“value”
		 * @param value String
		 */		
		function set valueKey(value:String):void;
		
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
		 * 获取横轴数据
		 * @return Array
		 */		
		function get horizontalData():Array;
		
		/**
		 * 获取纵轴数据
		 * @return Array
		 */		
		function get verticalData():Array;
		
		/**
		 * 获取标签轴的网格数据
		 * @return Array
		 */		
		function get labelGridData():Array;
		
		/**
		 * 根据数据获取坐标值
		 * @param data
		 * @return Number
		 */		
		function getPosition(data:Object):Number;
	}
	
}