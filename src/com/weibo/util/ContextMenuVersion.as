package com.weibo.util {
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	/**
	 * 隐藏右键。在右键中显示当前工程版本。
	 * @author Qi Donghui
	 */
	public class ContextMenuVersion 
	{
		
		/**
		 * 为flash右键添加版本号等信息
		 * 
		 * @param	label				本flash的名称
		 * @param	version			版本号
		 * @param	hideBuiltIn		是否隐藏默认的右键选项
		 * @return
		 */
		public static function version(label : String, version : String = "1.00", hideBuiltIn : Boolean = true) : ContextMenu 
		{
			label += ": v" + version;
			
			var cmi : ContextMenuItem = new ContextMenuItem(label, false, false);
			/*var item:ContextMenuItem = new ContextMenuItem("众乐网");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, goZLL);*/
			
			var cm : ContextMenu = new ContextMenu();
			if(hideBuiltIn) cm.hideBuiltInItems();
			cm.customItems.push(cmi);
			//cm.customItems.push(item);
			return cm;
		}
		
       /* private static function goZLL(event:ContextMenuEvent):void {
            navigateToURL(new URLRequest("http://www.zll.cn"), "_blank");
        }*/	
	}
}
