package com.weibo.charts.core
{
	import com.weibo.charts.core.ValidateType;
	
	import flash.display.Sprite;
	
	public class UIComponent extends Sprite
	{
		protected var _validateTypeObject:Object = {};
		
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
		
		public function create():void
		{
			
		}
		
		public function invalidate():void
		{
			removeEvents();
			destroy();
		}
		
		public function addEvents():void
		{
			
		}
		
		public function removeEvents():void
		{
			
		}
		
		public function destroy():void
		{
			
		}		
		
		public function layout():void
		{
			
		}
		
		public function updateState():void
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
		
	}
}