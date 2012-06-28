package com.weibo.ui
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;

	/**
	 * 默认鼠标样式
	 * @author yaofei@staff.sina.com.cn
	 */	
	public class MouseCursor
	{
//		public static const AUTO		:String = "auto";
//		public static const ARROW		:String = "arrow";
//		public static const BUTTON		:String = "button";
//		public static const HAND_UP		:String = "hand_up";
//		public static const HAND_DOWN	:String = "hand_down";
//		public static const IBEAM		:String = "ibeam";
//		public static const SIZE_RB		:String = "size_rightbottom";
		
		[Embed(source="com/weibo/assets/hand_up.png")]
		private static var HandUp:Class;
		private static var handUp:Bitmap = new HandUp();
		
		[Embed(source="com/weibo/assets/hand_down.png")]
		private static var HandDown:Class;
		private static var handDown:Bitmap = new HandDown();
		
		[Embed(source="com/weibo/assets/arrow_up.png")]
		private static var ArrowUp:Class;
		private static var arrowUp:Bitmap = new ArrowUp();
		
		[Embed(source="com/weibo/assets/size_rb.png")]
		private static var SizeRB:Class;
		private static var sizeRB:Bitmap = new SizeRB();
		
		
		public static function get HAND_UP():DisplayObject
		{
			handUp.x = -handUp.width / 2;
			handUp.y = -handUp.height / 2;
			return handUp;
		}
		
		public static function get HAND_DOWN():DisplayObject
		{
			handDown.x = -handDown.width / 2;
			handDown.y = -handDown.height / 2;
			return handDown;
		}
		
		public static function get ARROW_UP():DisplayObject
		{
			arrowUp.x = -arrowUp.width / 2;
			arrowUp.y = -arrowUp.height / 2;
			return arrowUp;
		}
		
		public static function get SIZE_RB():DisplayObject
		{
			sizeRB.x = -sizeRB.width / 2;
			sizeRB.y = -sizeRB.height / 2;
			return sizeRB;
		}
	}
}