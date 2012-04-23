package com.weibo.charts.comp
{
	import com.weibo.charts.ChartBase;
	import com.weibo.charts.DecorateBase;
	import com.weibo.charts.events.ChartEvent;
	
	import flash.display.Sprite;
	
	public class BasicNote extends DecorateBase
	{
		private var container:Sprite;
		
// ==========================================
// 构造函数
// ------------------------------------------
		
		public function BasicNote(target:ChartBase)
		{
			addChild(target);
			super(target);
			_style = 
				{
					colors:	[0xff0000, 0x59c9d8, 0x89c82d],
					space:	10,
					margin:	30
				}
		}
		
		
// ==========================================
// 公开方法
// ------------------------------------------
		/*
		override public function setSize(w:Number, h:Number):void
		{
			super.setSize(w, h);
			target.setSize(w, h);
		}
		*/
		
// ==========================================
// 内部方法
// ------------------------------------------
		
		override protected function create():void
		{
			if (container == null)
			{
				container = new Sprite();addChild(container);
			}
		}
		
		override protected function destroy():void
		{
			while (container.numChildren > 0) container.removeChildAt(0);
		}
		
		override protected function addEvents():void
		{
			super.addEvents();
			target.addEventListener(ChartEvent.CHART_DATA_CHANGED, onDataChange);
		}
		
		override protected function removeEvents():void
		{
			super.removeEvents();
			target.removeEventListener(ChartEvent.CHART_DATA_CHANGED, onDataChange);
		}
		
		override protected function updateState():void
		{
			if (!target.dataProvider) return;
			
			var colors:Array = chartStyle.colors;
			var space:Number = getStyle("space") as Number;
			var margin:Number = getStyle("margin") as Number;
			var shapenum:int = dataProvider.data.length;
			var currentX:Number = 0;
			var currentY:Number = 0;
			for (var i:int = 0; i < shapenum; i++)
			{
				var iconText:IconText = new IconText();
				container.addChild(iconText);
				iconText.color = colors[i];
				iconText.text = dataProvider.data[i].name;
				
				iconText.x = currentX;
				iconText.y = currentY;
				
				currentX += iconText.width + margin;
				/*if (iconText.x + iconText.width > width / 2)
				{
					currentX = 0;
					currentY += iconText.height + 5;
				}else
				{
					currentX = width / 2;
				}*/
			}
			
			container.x = int((chartWidth - container.width) / 2);
			container.y = int(chartHeight + space);
		}
		
		
//========================================
// 事件侦听器
//----------------------------------------
		
		private function onDataChange(e:ChartEvent):void
		{
			this.invalidate("all");
		}
	}
}



import com.weibo.charts.comp.Label;

import flash.display.Shape;
import flash.display.Sprite;

class IconText extends Sprite
{
	private var icon:Shape;
	private var label:Label;
	
	public function IconText()
	{
		icon = new Shape();
		icon.y = 5;
		label = new Label();
		label.x = 15;
		
		addChild(icon);
		addChild(label);
	}
	
	public function set text(value:String):void
	{
		label.text = value;
	}
	
	public function set color(color:uint):void {
		icon.graphics.clear();
//		icon.graphics.lineStyle(1, color, 1);
		icon.graphics.beginFill(color, 1);
		icon.graphics.drawRect(0, 0, 10, 10);
	}
}