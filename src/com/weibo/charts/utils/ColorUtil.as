package com.weibo.charts.utils
{
	/**
	 * 颜色工具类
	 * YaoFei
	 */
	public class ColorUtil
	{
		public static var defaultColors:Array = [0x999999];
		
		/**
		 * 转换字符串到uint色值数组
		 * @param value String "#333333"
		 * @return Array
		 * 
		 */		
		public static function getColorsFromRGB16(value:String):Array
		{
			if (!value) return null;
			
			var colors:Array = value.match(/[0-9a-fA-F]{2,6}/g);
			for (var i:int = 0; i < colors.length; i++)
			{
				colors[i] = parseInt(colors[i], 16);
			}
			return colors;
		}
		public static function getColorFromRGB16(value:String):uint
		{
			if (!value) return 0;
			var colors:Array = value.match(/[0-9a-fA-F]{2,6}/g);
			if (colors && colors.length > 0) return parseInt(colors[0], 16);
			else return 0;
		}
		
		public static function HSB2RGB(H:Number, S:Number, B:Number):uint
		{
			var nH:Number, nS:Number, nV:Number;
			var nR:Number, nG:Number, nB:Number;
			var hi:Number, f:Number, p:Number, q:Number, t:Number;
			
			nH = H / 360;
			nS = S / 100;
			nV = B / 100;
			
			if (S == 0)
			{
				nR = nV * 255;
				nG = nV * 255;
				nB = nV * 255;
			}
			else 
			{
				hi = nH * 6;
				if (hi == 6) hi = 0;
				f = int(hi);
				p = nV * (1 - nS);
				q = nV * (1 - nS * (hi - f));
				t = nV * (1 - nS * (1 - (hi - f)));
				
				if (f == 0)
				{
					nR = nV;
					nG = t;
					nB = p;
				}
				else if (f == 1)
				{
					nR = q;
					nG = nV;
					nB = p;
				}
				else if (f == 2)
				{
					nR = p;
					nG = nV;
					nB = t;
				}
				else if (f == 3)
				{
					nR = p;
					nG = q;
					nB = nV;
				}
				else if (f == 4)
				{
					nR = t;
					nG = p;
					nB = nV;
				}
				else
				{
					nR = nV;
					nG = p;
					nB = q;
				}
			}
			return ((nR * 255) << 16) | ((nG * 255) << 8) | (nB * 255);
		}
		
		/**
		 * 调整亮度
		 *
		 * @param rgb	颜色值
		 * @param brite	颜色变化量
		 * 这个值表示的是颜色的数值增加量，数值由-255至255，为0则不改变。
		 * @return	返回一个新的颜色值
		 */
		public static function adjustBrightness(rgb:uint, brite:Number):uint
		{
			var r:Number = Math.max(Math.min(((rgb >> 16) & 0xFF) + brite, 255), 0);
			var g:Number = Math.max(Math.min(((rgb >> 8) & 0xFF) + brite, 255), 0);
			var b:Number = Math.max(Math.min((rgb & 0xFF) + brite, 255), 0);
			
			return RGB(r,g,b);
		} 
		
		/**
		 * 合并颜色值
		 * 
		 * @param r	红
		 * @param g	绿
		 * @param b	蓝
		 * @return	返回一个新的颜色值
		 * 
		 */		
		public static function RGB(r:uint,g:uint,b:uint):uint
		{
			return (r << 16) | (g << 8) | b;
		}		
		
	}
}