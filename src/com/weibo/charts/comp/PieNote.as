package com.weibo.charts.comp
{
	import com.weibo.charts.ChartBase;
	import com.weibo.charts.DecorateBase;
	import com.weibo.charts.PieChart;
	import com.weibo.charts.events.ChartEvent;
	import com.weibo.charts.ui.ISectorUI;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	public class PieNote extends DecorateBase
	{
		[Embed(source="com/weibo/charts/assets/male.png")]
		private var Male:Class;
		private var male:Bitmap = new Male();
		[Embed(source="com/weibo/charts/assets/female.png")]
		private var Female:Class;
		private var female:Bitmap = new Female();
		
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
					left:	30,
					align:	"horizontal"
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
			
			var colors:Array = PieChart(target).style.colors;
			var space:Number = getStyle("space") as Number;
			var margin:Number = getStyle("margin") as Number;
			var labelColor:uint = getStyle("labelColor") as uint;
			var activeColor:uint = getStyle("activeColor") as uint;
			
			var tf1:TextFormat = new TextFormat("Arial", null, labelColor, null, null, false);
			var tf2:TextFormat = new TextFormat("Arial", null, activeColor, null, null, false);
			
			var shapenum:int = dataProvider.length;
			for (var i:int = 0; i < shapenum; i++)
			{
				var iconText:IconText = new IconText();
				container.addChild(iconText);
				var label:String = dataProvider[i].label;
				if (label.indexOf("男") != -1)
					iconText.icon = male;
				else if (label.indexOf("女") != -1)
					iconText.icon = female;
				else
					iconText.icon = null;
				iconText.setStyle("color", colors[i]);
//				iconText.setStyle("labelColor", getStyle("labelColor"));
//				iconText.setStyle("activeColor", getStyle("activeColor"));
				iconText.setStyle("labelFormat", tf1);
				iconText.setStyle("activeFormat", tf2);
				iconText.setLabel(getStyle("tipFun").call(null, dataProvider[i]), true);
			}
			
			var currentX:Number = 0;
			var currentY:Number = 0;
			if (getStyle("align") == "horizontal")
			{
				currentX = 0;
				currentY = 0;
				for (i = 0; i < container.numChildren; i++)
				{
					iconText = container.getChildAt(i) as IconText;
					
					iconText.x = currentX;
					iconText.y = currentY;
					if (iconText.x + iconText.width > width / 2)
					{
						currentX = 0;
						currentY += iconText.height + 0;
					}
					else
					{
						currentX = width / 2;
					}
				}
			}
			else
			{
				currentY = 0;
				for (i = 0; i < container.numChildren; i++)
				{
					iconText = container.getChildAt(i) as IconText;
					
					iconText.y = currentY;
					currentY += iconText.height + 0;
				}
			}
			
			container.x = (chartWidth - container.width) / 2;
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
			if (sector == null || sector.index == -1) return;
			
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


import com.weibo.charts.ui.tips.LabelMultiTip;
import com.weibo.core.UIComponent;
import com.weibo.core.ValidateType;

import flash.display.DisplayObject;
import flash.display.Shape;
import flash.display.Sprite;
import flash.text.TextFormat;

class IconText extends UIComponent
{
	private var container:Sprite = new Sprite();
	private var _defaultIcon:Shape;
	private var _icon:DisplayObject;
	private var label:LabelMultiTip;
	private var _text:String = "";
	
	private var _actived:Boolean = false;
	
	public function IconText()
	{
		_defaultIcon = new Shape();
		super();
	}
	

	public function get icon():DisplayObject
	{
		return _icon;
	}

	public function set icon(value:DisplayObject):void
	{
		_icon = value;
		invalidate(ValidateType.ALL);
	}
	
	public function get actived():Boolean{return _actived;}
	public function set actived(value:Boolean):void
	{
		_actived = value;
		invalidate();
	}
	
	public function setLabel(value:String, renderAsHTML:Boolean = false):void
	{
		_text = value;
		label.setLabel(_text, getStyle("labelFormat") as TextFormat, true);
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
		if (_icon == null)
		{
			_icon = _defaultIcon;
		}
		label = new LabelMultiTip();
		
		container.addChild(_icon);
		container.addChild(label);
		addChild(container);
	}
	
	override protected function destroy():void
	{
		if (_icon && container.contains(_icon)) container.removeChild(_icon);
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
		
		_defaultIcon.graphics.clear();
		if (_icon == _defaultIcon)
		{
			if (getStyle("border"))	_defaultIcon.graphics.lineStyle(1, getStyle("color") as uint, 1);
			_defaultIcon.graphics.beginFill(getStyle("color") as uint, 1);
			_defaultIcon.graphics.drawRect(0, 0, 10, 10);
		}
		
		
		_icon.y = (label.height - _icon.height) / 2;
	}
}