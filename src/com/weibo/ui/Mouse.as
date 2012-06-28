package com.weibo.ui
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	/**
	 * 鼠标形态工具
	 * 方便Flash显示特殊鼠标形态
	 * @author yaofei@staff.sina.com.cn
	 */	
	public class Mouse extends Sprite
	{
		private static var instance:Mouse;
		
		
		public function Mouse(singleton:Singleton)
		{
			super();
			if (!singleton) throw new IllegalOperationError("无需实例化");
			
			this.mouseEnabled = false;
			addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageListener);
		}
		
		private static function getInstance():Mouse {
			if(instance == null)
			{
				instance = new Mouse(new Singleton());
			}
			return instance;
		}
		
//===================================
// 公开方法
		
		/**
		 * 开启特殊形态
		 * @param stage 舞台
		 */		
		public static function register(stage:Stage):void
		{
			getInstance().visible = false;
			stage.addChild(getInstance());
		}
		
		/**
		 * 关闭特殊形态，返回系统鼠标
		 * 
		 */		
		public static function unregister():void
		{
			cursor = null;
			if (instance.stage && instance.stage.contains(instance))
			{
				instance.stage.removeChild(instance);
			}
			instance = null;
		}
		
		/**
		 * 设置需要的形态
		 * @param cursor:DisplayObject 如需要可使用MouseCursor内默认样式
		 */		
		public static function set cursor(cursor:DisplayObject):void
		{
			if (cursor)
			{
				getInstance().mouseMoveListener(null);
				flash.ui.Mouse.hide();
				getInstance().clear();
				getInstance().addChild(cursor);
			}
			else
			{
				flash.ui.Mouse.show();
				getInstance().clear();
			}
		}
		
//===================================
// 内部方法
		
		private function clear():void {
			while(this.numChildren > 0)
				removeChildAt(0);
		}
		
//===================================
// 事件侦听器
		
		private function addedToStageListener(evt:Event):void {
			stage.addEventListener(Event.MOUSE_LEAVE, mouseLeaveListener);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveListener);
		}
		
		private function removedFromStageListener(evt:Event):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveListener);
		}
		
		private function mouseLeaveListener(evt:Event):void
		{
			this.visible = false;
		}
		
		private function mouseMoveListener(evt:MouseEvent):void
		{
			if (stage)
			{
				stage.addChild(this);//置顶
				if (evt)	this.visible = true;//判断的功能：开始不显示；传入null(鼠标没有移动而改变了指针时)要更新指针。
				x = stage.mouseX;
				y = stage.mouseY;
			}
			
//			if(evt) evt.updateAfterEvent();
		}
	}
}

class Singleton{}
