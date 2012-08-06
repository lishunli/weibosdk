package com.weibo.controls 
{
	import com.weibo.core.Container;
	import com.weibo.core.ValidateType;
	
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author Qi Donghui
	 */
	public class HBox extends Container 
	{
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
		
		
		
		private var _alignment:String = NONE;
		
		public static const TOP:String = "top";
		public static const BOTTOM:String = "bottom";
		public static const MIDDLE:String = "middle";
		public static const NONE:String = "none";		
		
		public function HBox(hAlign:String = "left", vAlign:String = "middle", spacing:Object = 5) 
		{
			listenChildrenSize = true;
			_spacing = spacing;
			_hAlign = hAlign;
			_vAlign = vAlign;
			super();
		}
		
		override protected function layout():void
		{
			/*_width = 0;
			_height = 0;
			var xpos:Number = 0;
			for(var i:int = 0; i < _content.numChildren; i++)
			{
				var child:DisplayObject = _content.getChildAt(i);
				child.x = xpos;
				xpos += child.width;
				xpos += _spacing;
				_width += child.width;
				_height = Math.max(_height, child.height);
			}
			_width += _spacing * (_content.numChildren - 1);*/
			
			_height = 0;
			var childrenWidth:Number = 0;
			for (var i:int = 0; i < _content.numChildren; i++)
			{
				var d:DisplayObject = _content.getChildAt(i);
				_height = Math.max(d.height, height);
				childrenWidth += d.width;
			}
			
			//设置子对象X轴坐标
			for (i = 0; i < _content.numChildren; i++){
				d = _content.getChildAt(i);
				switch(_vAlign)
				{
					case "top":
						d.y = 0;
						break;
					default:
					case "middle":
						d.y = (height - d.height) / 2;
						break;
					case "bottom":
						d.y = height - d.height;
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
					_spacing = (_content.numChildren == 1) ? 0 : (width - childrenWidth) / (_content.numChildren - 1);
				}
			}
			
			if (autoSize){
				var start:Number = 0;
				for (i = 0; i < _content.numChildren; i++){
					d = _content.getChildAt(i);
					d.x = start;
					start += d.width + Number(_spacing);
				}
				_width = Math.max(0, start - Number(_spacing));
			}
			else{
				switch(_hAlign)
				{
					default:
					case "left":
						start = 0;
						break;
					case "center":
						start = width - (childrenWidth + Number(_spacing)*(_content.numChildren-1)) / 2;
						break;
					case "right":
						start = width - childrenWidth - Number(_spacing)*(_content.numChildren-1);
						break;
				}
				for (i = 0; i < _content.numChildren; i++){
					d = _content.getChildAt(i);
					d.x = start;
					start += d.width + Number(_spacing);
				}
			}
			
		}
		
		override protected function updateState():void
		{
//			graphics.clear();
//			graphics.lineStyle(1,0xff9900);
//			graphics.drawRect(0,0,width,height);
//			doAlignment();
		}
		
		/**
		 * 垂直排版
		 */
		protected function doAlignment():void
		{
			if(_alignment != NONE)
			{
				for(var i:int = 0; i < _content.numChildren; i++)
				{
					var child:DisplayObject = _content.getChildAt(i);
					if(_alignment == TOP)
					{
						child.y = 0;
					}
					else if(_alignment == BOTTOM)
					{
						child.y = _height - child.width;
					}
					else if(_alignment == MIDDLE)
					{
						child.y = (_height - child.width) / 2;
					}
				}
			}
		}		
		
		
		/**
		 * 水平间隔
		 */
		public function get spacing():Object { return _spacing; }
		public function set spacing(value:Object):void 
		{
			_spacing = value;
			invalidate(ValidateType.SIZE);				
		}
		
		/**
		 * 垂直方向的对齐方式
		 */
		public function get alignment():String { return _alignment; }
		public function set alignment(value:String):void 
		{
			_alignment = value;
			invalidate(ValidateType.SIZE);				
		}
		
	}

}