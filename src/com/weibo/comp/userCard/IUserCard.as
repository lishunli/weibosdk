package com.weibo.comp.userCard
{
	import com.weibo.comp.IWeiboUI;

	public interface IUserCard extends IWeiboUI
	{
		function get data():UserCardVO;
		function set data(vo:UserCardVO):void;
	}
}