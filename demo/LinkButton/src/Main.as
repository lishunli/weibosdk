package 
{
	import com.weibo.controls.Label;
	import com.weibo.controls.LinkButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextFormat;
	
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
			
			var lb:LinkButton = new LinkButton("按钮", new TextFormat(null, null, 0x000000, null, null, false), 
														new TextFormat(null, null, 0xff0000, null, null, true), 
														null, null, new TextFormat(null, null, 0x00ff00));
			addChild(lb);
			//lb.paddingLeft = lb.paddingRight = 30;
			lb.move(100, 100);			
			//lb.toggle = true;
		}
		
	}
	
}