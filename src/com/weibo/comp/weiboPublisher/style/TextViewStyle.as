package com.weibo.comp.weiboPublisher.style 
{
	import flash.text.TextFormat;
	/**
	 * 设置文本框的相关样式
	 * @author hailiang Du | hailiang@staff.sina.com.cn
	 */
	public class TextViewStyle 
	{
		/**
		 * Boolean 文本框是否有边框
		 */
		public var hasBorder:Boolean = true;
		
		/**
		 * uint 文本框的边框的颜色
		 */
		public var borderColor:uint = 0xD1D1D1;
		
		/**
		 * int 文本框的宽
		 */
		public var width:int = 500;
		
		/**
		 * int 文本框的高度
		 */
		public var height:int = 70;
		
		/**
		 * 文本框的TextFormat
		 */
		public var textFormat:TextFormat = new TextFormat("宋体,Helvetica,Arial,sans-serif", 12, 0x222222);
		 
		/**
		 * String 文本框里面默认的文案
		 */
		public var defaultText:String = "有什么新鲜事告诉大家";
		
		
		public function TextViewStyle() 
		{
			textFormat.leading = 2;
		}
		
	}

}