package com.weibo.core
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**
	 * 同类显示对象池，不支持有参数的类。
	 * 集创建器、迭代器为一体。简化接口。
	 * 可以减轻频繁创建对象所造成的负荷。
	 * 采用堆栈，后进先出。
	 * 适合重用率效高的对象系列
	 * @author yaofei@staff.sina.com.cn
	 */	
	public class DisplayObjectPool
	{
		private var parent:DisplayObjectContainer;
		private var SpriteClass:Class;
		
		private var intelList:Array;
		private var currentIndex:int;
		
		public function DisplayObjectPool(parent:DisplayObjectContainer, spriteClass:Class)
		{
			this.parent = parent;
			this.SpriteClass = spriteClass;
			intelList = [];
		}
		
		
	//============================
	// 内部方法
		
		/**
		 * 获取长度
		 * @return 
		 */		
		public function get length():uint {
			return intelList.length;
		}
		
		/**
		 * 设置长度
		 * 和数组设置length一样，可以进行裁剪
		 * @param length
		 */		
		public function set length(length:uint):void {
			while(this.length > length) pop();
		}
		
		/**
		 * 根据序号获取对象
		 * 如不存在会自动推入一个新对象
		 * @param index
		 * @return 
		public function getChildAt(index:uint):DisplayObject {
			if(index > length)			return null;
			else if(index == length)	return push();
			else						return intelList[index] as DisplayObject;
		}
		 */		
		
		/**
		 * 根据序号获取对象
		 * @param index
		 * @return 
		 */		
		public function getChildAt(index:uint):DisplayObject {
			return intelList[index] as DisplayObject;
		}
		
		/**
		 * 获取对象序号
		 * @param obj
		 * @return 
		 */		
		public function getChildIndex(obj:DisplayObject):int {
			return intelList.indexOf(obj);
		}
		
		public function begin():void
		{
			currentIndex = 0;
		}
		
		public function next():DisplayObject
		{
			return getChildAt(currentIndex++) || push();
		}
		
		public function end():void
		{
			this.length = currentIndex;
		}
		
		
	//============================
	// 内部方法
		
		/**
		 * 添加一个对象
		 * @return 
		 */		
		private function push():DisplayObject {
			var intelObj:DisplayObject = new SpriteClass();
			parent.addChild(intelObj);
			intelList.push(intelObj);
			return intelObj;
		}
		
		/**
		 * 删除一个对象
		 * @return 
		 */		
		private function pop():DisplayObject {
			var intelObj:DisplayObject = intelList.pop() as DisplayObject;
			if(intelObj != null && parent.contains(intelObj))
				parent.removeChild(intelObj);
			return intelObj;
		}
		
	}
}