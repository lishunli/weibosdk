package com.weibo.comp.weiboPublisher 
{
	import com.weibo.comp.weiboPublisher.data.PublisherVO;
	import com.weibo.comp.weiboPublisher.events.PublisherEvent;
	import com.weibo.comp.weiboPublisher.ui.TextView;
	import com.weibo.core.UIComponent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	/**
	 * 发布器的核心功能
	 * @author Qi Donghui
	 */
	public class Publisher extends UIComponent implements IPublisherFun
	{
		/**
		 * 要发布的数据
		 */
		protected var _vo:PublisherVO;
		
		/**
		 * 发布器核心最上层的容器，成功错误提示等等的内容
		 */
		private var _frontCont:Sprite;
		
		/**
		 * 发布器核心下层的容器
		 */
		private var _backCont:Sprite;
		
		/**
		 * 弹出面板的容器，每次只有唯一的显示对象
		 */
		private var _panelCont:Sprite;
		
		/**
		 * 文本框
		 */
		private var _tv:TextView;
		
		/**
		 * 发布按钮
		 */
		private var _publishBtn:DisplayObject;
		
		public function Publisher() 
		{
			super();
		}
		
		/**
		 * 完成创建元素的目的
		 */
		override protected function create():void
		{
			_tv = new TextView();
			addChild(_tv);
			trace("targettargettargettargettargettargettargettargettargettargettarget" + _tv);
		}
		
		/**
		 * 完成添加事件侦听的目的
		 */	
		override protected function addEvents():void
		{
			
		}

		/**
		 *完成移除事件侦听的目的
		 */		
		override protected function removeEvents():void
		{
			
		}

		/**
		 * 完成销毁引用的目的
		 */		
		override protected function destroy():void
		{
			
		}		
		
		/**
		 * 完成内容排版的目的
		 */		
		override protected function layout():void
		{
			
		}
		
		/**
		 * 需要被子类重写，完成状态更新的目的
		 */		
		override protected function updateState():void
		{
			
		}
		
		/**
		 * 设置宽度，进入重新渲染流程
		 */
		override public function set width(w:Number):void
		{
			super.width = w;
			_tv.width = w;
		}		
		
		/**
		 * 设置高度，进入重新渲染流程
		 */
		override public function set height(h:Number):void
		{
			super.height = h;
			_tv.height = h;
		}
		
		/**
		 * 添加功能按钮，到显示列表中
		 */
		public function addFunButton(obj:DisplayObject):void
		{
			
		}
		
		/**
		 * 添加功能面板
		 * @param	obj
		 * @param	globalX
		 * @param	globalY
		 */
		public function addFunPanel(obj:DisplayObject, globalX:Number, globalY:Number):void
		{
			
		}
		
		/**
		 * 在发布器的背景层添加子元素
		 * @param	obj		要添加到子元素
		 * @param	globalX		要添加的子元素的全局X位置
		 * @param	globalY		要添加的子元素的全局y位置
		 */
		public function addUIToBack(obj:DisplayObject, globalX:Number, globalY:Number):void
		{
			var localPoint:Point = _frontCont.globalToLocal(new Point(globalX, globalY));
		}
		
		/**
		 * 在发布器的最前景层添加子元素
		 * @param	obj		要添加到子元素
		 * @param	globalX		要添加的子元素的全局X位置
		 * @param	globalY		要添加的子元素的全局Y位置
		 */
		public function addUIToFront(obj:DisplayObject, globalX:Number, globalY:Number):void
		{
			
		}
		
		/**
		 * 获得发布器的文本
		 */
		public function get text():String { return _vo.text; }
		
		/**
		 * 重设发布器的文本
		 */
		public function set text(value:String):void 
		{
			_vo.text = value;
			var e:PublisherEvent = new PublisherEvent(PublisherEvent.TEXT_UPDATE);
			e.result = value.length;
			dispatchEvent(e);
		}
		
		/**
		 * 获得图片信息
		 */
		public function get pic():ByteArray { return _vo.pic; }
		
		/**
		 * 设置要发布的图片的信息
		 */
		public function set pic(value:ByteArray):void 
		{
			_vo.pic = value;
			
		}
		
		/**
		 * 给发布器添加文本
		 * @param	text
		 */
		public function addText(text:String):void
		{
			
		}
		
		private function textUpdate():void
		{
			var e:PublisherEvent = new PublisherEvent(PublisherEvent.TEXT_UPDATE);
			e.result = _vo.text.length;
			dispatchEvent(e);
		}
		
		
	}

}