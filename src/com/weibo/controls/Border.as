package com.weibo.controls
{
	import com.weibo.core.UIComponent;
	import com.weibo.core.ValidateType;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	
	/**
	 * 边框包装器
	 * 模型结构：border-padding-content
	 * 使用方法：装饰者模式。<p>new Border(displayObject);</p>
	 * @author yaofei
	 */	
	public class Border extends UIComponent
	{
		protected var _border:Number;
		protected var _padding:Number;
		
		protected var _target:DisplayObject;
		
		protected var _borderShape:Shape;
		
	//===============================
	// 构造函数
	//-------------------------------
		
		public function Border(target:DisplayObject, border:Number = 1, padding:Number = 5)
		{
			this._target = target;
			this._border = border;
			this._padding = padding;
			super();
		}
		
//===================================
// 公开方法
		
		public function get padding():Number
		{
			return _padding;
		}

		public function set padding(value:Number):void
		{
			_padding = value;
			invalidate(ValidateType.SIZE);
		}

		public function get border():Number
		{
			return _border;
		}

		public function set border(value:Number):void
		{
			_border = value;
			invalidate(ValidateType.SIZE);
		}
		
//===================================
// 内部方法
		
		override protected function create():void
		{
			addChild(_target);
			_borderShape = new Shape();
			addChild(_borderShape);
		}
		
		override protected function destroy():void
		{
			removeChild(_target);
			removeChild(_borderShape);
			_borderShape = null;
		}
		
		override protected function layout():void
		{
			_width = _target.width + _border*2 + _padding*2;
			_height = _target.height + _border*2 + _padding*2;
		}
		
		
		override protected function updateState():void
		{
//			trace(width, height)
			graphics.clear();
			graphics.beginFill(0xffffff, 1);
			graphics.drawRect(0, 0, width, height);
			
			_borderShape.graphics.clear();
			_borderShape.graphics.beginFill(0xcccccc, 1);
			_borderShape.graphics.drawRect(0, 0, width, height);
			
			_borderShape.graphics.drawRect(_border, _border, _target.width + _padding*2, _target.height + _padding*2);
			
			_target.x = _target.y = _border + _padding;
		}
		
		
		override public function setSize(w:Number, h:Number):void
		{
			throw new Error(this.toString() + " 不允许设置尺寸！");
		}
		override public function set width(w:Number):void
		{
			throw new Error(this.toString() + " 不允许设置尺寸！");
		}
		override public function set height(h:Number):void
		{
			throw new Error(this.toString() + " 不允许设置尺寸！");
		}
		
		/*override public function get width():Number
		{
			return _target.width + _border*2 + _padding*2;
		}
		override public function get height():Number
		{
			return _target.height + _border*2 + _padding*2;
		}*/
		
//===================================
// 事件侦听器
		
	}
}