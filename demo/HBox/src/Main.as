package 
{
	import com.weibo.controls.HBox;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author Qi Donghui
	 */
	public class Main extends Sprite 
	{
		private var _hb:HBox;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_hb = new HBox();
			_hb.x = 100;
			_hb.y = 100;
			addChild(_hb);
			
			_hb.addChild(new Rec());
			_hb.addChild(new Rec());
			_hb.addChild(new Rec());
			_hb.addChild(new Rec());
			_hb.addChild(new Rec());
			_hb.addChild(new Rec());
			
			//_hb.alignment = HBox.MIDDLE;
			_hb.alignment = HBox.BOTTOM;		
			_hb.spacing = 30;
			
			setTimeout(removeFirstChildren, 2000);
		}
		
		private function removeFirstChildren():void
		{
			_hb.removeChildAt(0);
		}
		
	}
	
}