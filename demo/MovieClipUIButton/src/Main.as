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
			btn2.move(20, 70);
			addChild(btn2);
			
			var btn3:MovieClipUIButton = new MovieClipUIButton(new MyButtonSkin());
			btn3.move(20, 120);
			addChild(btn3);		
			btn3.toggle = true;
			
			var btn4:MovieClipUIButton = new MovieClipUIButton(new MyButtonSkin3());
			btn4.move(20, 170);
			addChild(btn4);		
			btn4.toggle = true;			
			btn4.selected = true;
		}
		
	}
	
}