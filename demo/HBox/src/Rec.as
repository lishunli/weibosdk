package  
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Qi Donghui
	 */
	public class Rec extends Sprite 
	{
		
		public function Rec() 
		{
			this.graphics.beginFill(0x000000);
			var w:Number = 30 + 30 * Math.random();
			var h:Number = 50 + 70 * Math.random();
			this.graphics.drawRect(0, 0, w, h);
			this.graphics.endFill();
		}
		
	}

}