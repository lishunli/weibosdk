package com.weibo.util.data
{
	import flash.utils.Dictionary;

	/**
	 * 存储、设置唯一值对的对象
	 * @author Aaron Wei
	 * @langversion 3.0
	 * @playerversion Flash 9+
	 * @productversion Seed1.0
	 */
	public class HashSet extends Object
	{
		private var _length:int;
		private var _container:Dictionary;

		/**
		 * 构造函数
		 * <p>创建hash对象</p>
		 * @langversion 3.0
		 * @playerversion Flash 9+
		 * @productversion Seed1.0
		 */
		public function HashSet()
		{
			super();
			_container=new Dictionary();
			_length=0;
		}

		/**
		 * 增加一个对象
		 * @langversion 3.0
		 * @playerversion Flash 9+
		 * @productversion Seed1.0
		 */
		public function add(o:*):void
		{
			if (!contains(o))
			{
				_length++;
			}
			_container[o]=o;
		}

		/**
		 * 增加一个或多个对象
		 * @langversion 3.0
		 * @playerversion Flash 9+
		 * @productversion Seed1.0
		 */
		public function addAll(arr:Array):void
		{
			for each (var k:*in arr)
			{
				add(k);
			}
		}

		/**
		 * 移除一个对象
		 * @langversion 3.0
		 * @playerversion Flash 9+
		 * @productversion Seed1.0
		 */
		public function remove(o:*):Boolean
		{
			if (contains(o))
			{
				delete _container[o];
				_length--;
				return true;
			}
			return false;
		}

		/**
		 * 移除一个或多个对象
		 * @langversion 3.0
		 * @playerversion Flash 9+
		 * @productversion Seed1.0
		 */
		public function removeAll(arr:Array):void
		{
			for each (var k:*in arr)
			{
				remove(k);
			}
			return;
		}

		/**
		 * 判断是否包含该对象
		 * @langversion 3.0
		 * @playerversion Flash 9+
		 * @productversion Seed1.0
		 * @return Boolean类型，为true则包含该对象，为false则不包含该对象
		 */
		public function contains(o:*):Boolean
		{
			return _container[o] !== undefined;
		}

		/**
		 * 判断是否包含一个或多个对象
		 * @langversion 3.0
		 * @playerversion Flash 9+
		 * @productversion Seed1.0
		 * @return Boolean类型，为true则包含该对象组中所有对象，为false则不包含该对象组所有对象
		 */
		public function containsAll(arr:Array):Boolean
		{
			var i:int=0;
			while (i < arr.length)
			{
				if (!contains(arr[i]))
				{
					return false;
				}
				i++;
			}
			return true;
		}

		/**
		 * hash对象遍历键值执行操作
		 * @langversion 3.0
		 * @playerversion Flash 9+
		 * @productversion Seed1.0
		 */
		public function foreach(func:Function):void
		{
			for each (var k:*in _container)
			{
				func(k);
			}
			return;
		}

		/**
		 * 将hash对象键值转换为数组
		 * @langversion 3.0
		 * @playerversion Flash 9+
		 * @productversion Seed1.0
		 * @return Aarry
		 */
		public function toArray():Array
		{
			var arr:*=new Array(_length);
			var i:int=0;
			for each (var k:*in _container)
			{
				arr[i]=k;
				i++
			}
			return arr;
		}

		/**
		 * 清空hash对象
		 * @langversion 3.0
		 * @playerversion Flash 9+
		 * @productversion Seed1.0
		 */
		public function clear():void
		{
			_container=new Dictionary();
			_length=0;
			return;
		}

		/**
		 * hash对象子节点长度
		 * @langversion 3.0
		 * @playerversion Flash 9+
		 * @productversion Seed1.0
		 * @return int
		 */
		public function size():int
		{
			return _length;
		}

		/**
		 * 判断hash对象是否为空
		 * @langversion 3.0
		 * @playerversion Flash 9+
		 * @productversion Seed1.0
		 * @return Boolean
		 */
		public function isEmpty():Boolean
		{
			return _length == 0;
		}
	}
}