package com.weibo.comp.weiboPublisher.decorator 
{
	import com.weibo.comp.weiboPublisher.Publisher;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	
	/**
	 * ...
	 * @author Qi Donghui
	 */
	public class PublisherImg extends Publisher 
	{
		private var _target:Publisher;
		
		public function PublisherImg(target:Publisher) 
		{
			_target = target;
		}
		
		/**
		 * 添加功能按钮，到显示列表中
		 */
		override public function addFunButton(btn:DisplayObject):void
		{
			if (_target != null) _target.addFunButton(btn);
		}
		
		override protected function create():void
		{
			if (_target != null) _target.addFunButton(new SimpleButton());
		}
		
		
	}

}