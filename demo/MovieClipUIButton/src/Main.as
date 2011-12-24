package 
{
	import com.weibo.controls.MovieClipUIButton;
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
			
			
			var btn:MovieClipUIButton = new MovieClipUIButton(new MyButtonSkin());
			btn.move(20, 20);
			addChild(btn);
			
			var btn2:MovieClipUIButton = new MovieClipUIButton(new MyButtonSkin2());
			btn2.move(20, 100);
			addChild(btn2);
		}
		
	}
	
}