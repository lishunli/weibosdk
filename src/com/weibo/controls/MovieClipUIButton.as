package com.weibo.controls 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Qi Donghui
	 */
	public class MovieClipUIButton extends BaseButton 
	{
		private var _ui:MovieClip;
		
		public function MovieClipUIButton(ui:MovieClip) 
		{
			_ui = ui;
			_ui.gotoAndStop(1);
			super();
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			if (_ui.getChildByName("area") != null)
			{
				var area:Sprite = _ui.getChildByName("area") as Sprite;
			}else {
				area = new MovieClip();
				area.graphics.beginFill(0);
				area.graphics.drawRect(0, 0, _ui.width, _ui.height);
				area.graphics.endFill();
				_ui.addChild(area);
			}
			area.alpha = 0;
			initUI(area, outUI, downUI, overUI);
			addChild(_ui);
		}
		
		private function overUI():void
		{
			_ui.gotoAndStop(2);
		}
		
		private function outUI():void
		{
			_ui.gotoAndStop(1);
		}
		
		private function downUI():void
		{
			_ui.gotoAndStop(3);
		}
	}

}