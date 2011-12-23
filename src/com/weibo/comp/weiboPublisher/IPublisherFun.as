package com.weibo.comp.weiboPublisher 
{
	import flash.display.DisplayObject;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Qi Donghui
	 */
	public interface IPublisherFun 
	{
		/**
		 * 重设发布文本
		 */
		function set text(text:String):void;
		
		/**
		 * 获取发布文本
		 */
		function get text():String;
		
		/**
		 * 添加文本
		 * @param	text
		 */
		function addText(text:String):void;
		
		/**
		 * 设置要发布的图片信息
		 */
		function set pic(picData:ByteArray):void;
		
		/**
		 * 获取已设置的图片信息
		 */
		function get pic():ByteArray;
		
		/**
		 * 在发布器的背景层添加子元素
		 * @param	obj		要添加到子元素
		 * @param	globalX		要添加的子元素的全局X位置
		 * @param	globalY		要添加的子元素的全局y位置
		 */
		function addUIToBack(obj:DisplayObject, globalX:Number, globalY:Number):void;
		
		/**
		 * 在发布器的最前景层添加子元素
		 * @param	obj		要添加到子元素
		 * @param	globalX		要添加的子元素的全局X位置
		 * @param	globalY		要添加的子元素的全局Y位置
		 */
		function addUIToFront(obj:DisplayObject, globalX:Number, globalY:Number):void;
		
	}
	
}