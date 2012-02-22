package com.weibo.charts.comp
{
	import com.weibo.charts.ChartBase;
	import com.weibo.charts.DecorateBase;
	import com.weibo.charts.PieChart;
	import com.weibo.charts.events.ChartEvent;
	import com.weibo.charts.ui.ISectorUI;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	public class PieNote extends DecorateBase
	{
		private var container:Sprite;
		
		private var currentNote:IconText;
		
// ==========================================
// 构造函数
// ------------------------------------------
		
		public function PieNote(target:ChartBase)
		{
			addChild(target);
			super(target);
			_style = 
				{
					space:	10,
					margin:	30,
					left:	30
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
		
		override public function setSize(w:Number, h:Number):void
		{
			super.setSize(w, h);
			target.setSize(w, h);
		}
		
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
			target.addEventListener(MouseEvent.MOUSE_OVER, mouseShowTip);
			target.addEventListener(MouseEvent.MOUSE_OUT, mouseHideTip);
		}
		
		override protected function removeEvents():void
		{
			super.removeEvents();
			target.removeEventListener(ChartEvent.CHART_DATA_CHANGED, onDataChange);
			target.removeEventListener(MouseEvent.MOUSE_OVER, mouseShowTip);
			target.removeEventListener(MouseEvent.MOUSE_OUT, mouseHideTip);
		}
		
		override protected function updateState():void
		{
			if (!target.dataProvider) return;
			
			var colors:Array = PieChart(target).style.arrColors;
			var space:Number = getStyle("space") as Number;
			var margin:Number = getStyle("margin") as Number;
			var labelColor:uint = getStyle("labelColor") as uint;
			var activeColor:uint = getStyle("activeColor") as uint;
			
			var tf1:TextFormat = new TextFormat("Arial", null, labelColor, null, null, false);
			var tf2:TextFormat = new TextFormat("Arial", null, activeColor, null, null, false);
			
			var shapenum:int = dataProvider.length;
			var currentX:Number = getStyle("left") as Number;
			var currentY:Number = 0;
			for (var i:int = 0; i < shapenum; i++)
			{
				var iconText:IconText = new IconText();
				container.addChild(iconText);
				iconText.setStyle("color", colors[i]);
//				iconText.setStyle("labelColor", getStyle("labelColor"));
//				iconText.setStyle("activeColor", getStyle("activeColor"));
				iconText.setStyle("labelFormat", tf1);
				iconText.setStyle("activeFormat", tf2);
				iconText.setLabel(getStyle("tipFun").call(null, dataProvider[i]), true);
				
				iconText.x = currentX;
				iconText.y = currentY;
				
//				trace(currentX, currentY);
				currentY += iconText.height + 0;
				/*if (iconText.x + iconText.width > width / 2)
				{
					currentX = 0;
					currentY += iconText.height + 0;
				}else
				{
					currentX = width / 2;
				}*/
			}
			
//			container.x = (chartWidth - container.width) / 2;
			container.y = chartHeight + space;
		}
		
		
//========================================
// 事件侦听器
//----------------------------------------
		
		private function onDataChange(e:ChartEvent):void
		{
			this.invalidate("all");
		}
		
		private function mouseShowTip(event:MouseEvent):void
		{
			var sector:ISectorUI = event.target as ISectorUI;
			if (sector == null) return;
			
			var iconText:IconText = container.getChildAt(sector.index) as IconText;
			if (iconText == null) return;
			
			iconText.actived = true;
			currentNote = iconText;
		}
		
		private function mouseHideTip(event:MouseEvent):void
		{
			if (currentNote == null) return;
			
			currentNote.actived = false;
		}
	}
}


import com.weibo.charts.comp.Label;
import com.weibo.charts.ui.tips.LabelMultiTip;
import com.weibo.core.UIComponent;

import flash.display.Shape;
import flash.display.Sprite;
import flash.text.TextFormat;

class IconText extends UIComponent
{
	private var container:Sprite = new Sprite();
	private var icon:Shape;
	private var label:LabelMultiTip;
	private var _text:String = "";
	
	private var _actived:Boolean = false;
	
	public function IconText()
	{
		super();
	}

	public function set actived(value:Boolean):void
	{
		_actived = value;
		invalidate();
	}
	public function get actived():Boolean
	{
		return _actived;
	}
	
	public function setLabel(value:String, renderAsHTML:Boolean = false):void
	{
		_text = value;
//		trace(this.name, value)
//		label.format = tf;
		label.setLabel(_text, getStyle("labelFormat") as TextFormat, true);
//		label.text = "wfwfw";
		invalidate();
	}
	override public function get width():Number
	{
		return container.width;
	}
	override public function get height():Number
	{
		return container.height;
	}
	override protected function create():void
	{
		if (icon == null)
		{
			icon = new Shape();
		}
		if (label == null)
		{
			label = new LabelMultiTip();
		}
		
		container.addChild(icon);
		container.addChild(label);
		addChild(container);
	}
	
	override protected function destroy():void
	{
		container.removeChild(icon);
		container.removeChild(label);
		addChild(container);
	}
	
	override protected function updateState():void
	{
		if (actived)
		{
			label.setLabel(_text, getStyle("activeFormat") as TextFormat, true);
		}
		else
		{
			label.setLabel(_text, getStyle("labelFormat") as TextFormat, true);
		}
		label.x = 15;
		
		icon.graphics.clear();
//		icon.graphics.lineStyle(1, color, 1);
		icon.graphics.beginFill(getStyle("color") as uint, 1);
		icon.graphics.drawRect(0, 0, 10, 10);
		
		icon.y = (label.height - icon.height) / 2;
	}
}