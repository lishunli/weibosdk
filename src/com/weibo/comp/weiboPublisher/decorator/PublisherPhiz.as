package com.weibo.comp.weiboPublisher.decorator 
{
	import com.weibo.comp.weiboPublisher.events.PublisherEvent;
	import com.weibo.comp.weiboPublisher.Publisher;
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author Qi Donghui
	 */
	public class PublisherPhiz extends Publisher 
	{
		private var _target:Publisher;
		
		public function PublisherPhiz(target:Publisher) 
		{
			_target = target;
			addChild(_target);
		}
		
		/**
		 * 添加功能按钮，到显示列表中
		 */
		override public function addFunButton(btn:DisplayObject):void
		{
			_target.addFunButton(btn);
		}			
		
		override protected function addEvents():void
		{
			if (_target != null) _target.addEventListener(PublisherEvent.PUBLISH, onPublish);			
		}
		
		override protected function layout():void
		{
			
		}

		override protected function create():void
		{
						
		}		
		
		private function onPublish(e:PublisherEvent):void 
		{
			dispatchEvent(e.clone());
		}
		
	}

}