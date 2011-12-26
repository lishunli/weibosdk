package com.weibo.charts.service
{
	import flash.events.IEventDispatcher;

	public interface IWeiboChartService extends IEventDispatcher
	{
		function getData():void;
	}
}