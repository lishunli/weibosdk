package com.weibo.charts.data
{
	
	
	/**
	 * ...
	 * @author yaofei@staff.sina.com.cn
	 */
	public interface IAxisLogic 
	{
		/**
		 * 图表数据
		 * @param value Object
		 */		
		function set dataProvider(value:Object):void;
		
		/**
		 * 图表数据
		 * @return Object
		 */		
		function get dataProvider():Object;
	}
	
}