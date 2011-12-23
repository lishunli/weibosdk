package com.weibo.comp.weiboPublisher.decorator 
{
	import com.weibo.comp.weiboPublisher.Publisher;
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author Qi Donghui
	 */
	public class PublisherCounter extends Publisher 
	{
		private var _target:Publisher;
		
		public function PublisherCounter(target:Publisher) 
		{
			_target = target;
		}
		
		/**
		 * 添加功能按钮，到显示列表中
		 */
		override public function addFunButton(btn:DisplayObject):void
		{
			_target.addFunButton(btn);
		}		
		
	}

}