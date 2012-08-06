package com.weibo.controls
{
	import com.weibo.core.Container;
	import com.weibo.core.ValidateType;
	
	import flash.display.DisplayObject;
	
	/**
	 * 这是一个容器
	 * 排列方式：子对象按竖直方向
	 * @author yaofei
	 */	
	public class VBox extends Container
	{
//		public static const LEFT:String = "left";
//		public static const CENTER:String = "center";
//		public static const RIGHT:String = "right";
		
		/**
		 * 有效值：'left', 'center', 'right'
		 */		
		protected var _hAlign:String;
		
		/**
		 * 有效值：'top', 'middle', 'bottom'
		 */		
		protected var _vAlign:String;
		
		/**
		 * 值：'auto', 数值
		 * 默认值：'auto'
		 */		
		protected var _spacing:Object;
		
	//==================================
	// 构造函数
	//----------------------------------
		
		public function VBox(hAlign:String = "left", vAlign:String = "top", spacing:Object = 5)
		{
			listenChildrenSize = true;
			_spacing = spacing;
			_hAlign = hAlign;
			_vAlign = vAlign;
			super();
		}
		
//==================================
// 公开方法
		
		public function get spacing():Object { return _spacing; }
		
		public function set spacing(value:Object):void
		{
			_spacing = value;
			invalidate(ValidateType.SIZE);
		}
		
//==================================
// 内部方法
		
		
		override protected function layout():void
		{
			_width = 0;
			var childrenHeight:Number = 0;
			for (var i:int = 0; i < _content.numChildren; i++)
			{
				var d:DisplayObject = _content.getChildAt(i);
				_width = Math.max(d.width, width);
				childrenHeight += d.width;
			}
			
			//设置子对象X轴坐标
			for (i = 0; i < _content.numChildren; i++){
				d = _content.getChildAt(i);
				switch(_hAlign)
				{
					case "left":
						d.x = 0;
						break;
					default:
					case "center":
						d.x = (width - d.width) / 2;
						break;
					case "right":
						d.x = width - d.width;
						break;
				}
			}
			
			//自动分配间隔
			if (isNaN(Number(_spacing))){
				//自动容器尺寸时，间隔强制改为0
				if (autoSize){
					_spacing = 0;
				}
				//如果有设置尺寸或固定尺寸时，计算平均间隔
				else{
					_spacing = (_content.numChildren == 1) ? 0 : (height - childrenHeight) / (_content.numChildren - 1);
				}
			}
			
			if (autoSize){
				var start:Number = 0;
				for (i = 0; i < _content.numChildren; i++){
					d = _content.getChildAt(i);
					d.y = start;
					start += d.height + Number(_spacing);
				}
				_height = Math.max(0, start - Number(_spacing));
			}
			else{
				switch(_vAlign)
				{
					default:
					case "top":
						start = 0;
						break;
					case "middle":
						start = height - (childrenHeight + Number(_spacing)*(_content.numChildren-1)) / 2;
						break;
					case "bottom":
						start = height - childrenHeight - Number(_spacing)*(_content.numChildren-1);
						break;
				}
				for (i = 0; i < _content.numChildren; i++){
					d = _content.getChildAt(i);
					d.y = start;
					start += d.height + Number(_spacing);
				}
			}
			
		}
		
//==================================
// 事件侦听器
		
	}
}