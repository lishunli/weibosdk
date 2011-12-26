package com.weibo.charts 
{
	
	/**
	 * ...
	 * @author Qi Donghui
	 */
	public interface IWeiboChart 
	{
		/**
		 * 根据chart对应的数据格式设置json对象
		 * @param	str
		 */
		function setData(value:Object):void
		
		/**
		 * 设置后端提供服务的接口地址
		 * @param	value
		 */
		function dataURL(value:String):void;
		
		/**
		 * 提供给flash的js回调函数，用于将内部状态（code码）传给js，供提示
		 * @param	value
		 */
		//function jsCallbackFun(value:String):void;
	}
	
}