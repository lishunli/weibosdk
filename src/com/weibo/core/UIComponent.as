package com.weibo.core
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	import com.weibo.managers.RepaintManager;
	
	public class UIComponent extends Sprite
	{
		protected var _validateTypeObject:Object = { };
		protected var _tag:int = -1;
		protected var _width:Number = 0;
		protected var _height:Number = 0;		
		
		public function UIComponent()
		{
			this.initialize();
		}
		
		protected function initialize():void
		{
			_validateTypeObject["all"]=true;
			validate();
		}
		
		public function validate():void
		{
			var type:String=getValidateType();
			switch (type)
			{
				default:
				case ValidateType.ALL:
					invalidate(); //清空之前的所有
					create(); //创建对象
					layout(); //布局对象
					updateState(); //更新对象状态
					addEvents(); //给对象添加事件
					break;
				case ValidateType.STYLES:
					invalidate(); //清空之前的所有
					create(); //创建对象
					layout(); //布局对象
					addEvents(); //给对象添加事件
					break;
				case ValidateType.SIZE:
					layout(); //布局对象
					break;
				case ValidateType.STATE:
					updateState(); //更新对象状态
					break;
			}
		}
		
		protected function invalidate():void
		{
			removeEvents();
			destroy();
		}
		
		/**
		 * 需要被子类重写，完成创建元素的目的
		 */
		protected function create():void
		{
			
		}
		
		/**
		 * 需要被子类重写，完成添加事件侦听的目的
		 */	
		protected function addEvents():void
		{
			
		}

		/**
		 * 需要被子类重写，完成移除事件侦听的目的
		 */		
		protected function removeEvents():void
		{
			
		}

		/**
		 * 需要被子类重写，完成销毁引用的目的
		 */		
		protected function destroy():void
		{
			
		}		
		
		/**
		 * 需要被子类重写，完成内容排版的目的
		 */		
		protected function layout():void
		{
			
		}
		
		/**
		 * 需要被子类重写，完成状态更新的目的
		 */		
		protected function updateState():void
		{
			
		}
		
		/**
		 * 将组件移到指定的位置
		 * @param xpos x坐标
		 * @param ypos y坐标
		 */
		public function move(xpos:Number, ypos:Number):void
		{
			this.x=Math.round(xpos);
			this.y=Math.round(ypos);
		}
		
		protected function getValidateType():String
		{
			if (_validateTypeObject["all"])
			{
				_validateTypeObject={};
				return ValidateType.ALL;
			}
			else if (_validateTypeObject["styles"])
			{
				_validateTypeObject={};
				return ValidateType.STYLES;
			}
			else if (_validateTypeObject["size"])
			{
				_validateTypeObject={};
				return ValidateType.SIZE;
			}
			else if (_validateTypeObject["state"])
			{
				_validateTypeObject={};
				return ValidateType.STATE;
			}
			return null;
		}		
		
		/**
		 * 组件标识
		 */
		public function get tag():int { return _tag; }
		public function set tag(value:int):void
		{
			_tag = value;
		}	
		
		/**
		 * 设置宽度，进入重新渲染流程
		 */
		override public function set width(w:Number):void
		{
			_width = w;
			_validateTypeObject["size"] = true;
			RepaintManager.getInstance().addToRepaintQueue(this);
		}		
		
		/**
		 * 设置高度，进入重新渲染流程
		 */
		override public function set height(h:Number):void
		{
			_height = h;
			_validateTypeObject["size"] = true;
			RepaintManager.getInstance().addToRepaintQueue(this);
		}
		
		/**
		 * 保证x位置为整数点
		 */
		override public function set x(value:Number):void
		{
			super.x = Math.round(value);
		}
		
		/**
		 * 保证y位置为整数点
		 */
		override public function set y(value:Number):void
		{
			super.y = Math.round(value);
		}		
	}
}