package 
{
	import com.weibo.comp.weiboPublisher.decorator.PublisherCounter;
	import com.weibo.comp.weiboPublisher.decorator.PublisherImg;
	import com.weibo.comp.weiboPublisher.decorator.PublisherPhiz;
	import com.weibo.comp.weiboPublisher.events.PublisherEvent;
	import com.weibo.comp.weiboPublisher.Publisher;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Qi Donghui
	 */
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);		
			var p:Publisher = new Publisher();	
			p = new PublisherCounter(p); //增加计数显示
			p = new PublisherPhiz(p); //增加表情
			p = new PublisherImg(p); //增加本地图片上传
			p.addEventListener(PublisherEvent.PUBLISH, onPublish);
			addChild(p);
		}
		
		private function onPublish(e:PublisherEvent):void 
		{
			
		}
		
	}
	
}