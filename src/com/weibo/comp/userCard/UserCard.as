package com.weibo.comp.userCard
{
	import com.weibo.controls.Border;
	import com.weibo.controls.Box;
	import com.weibo.controls.Button;
	import com.weibo.controls.HBox;
	import com.weibo.controls.Image;
	import com.weibo.controls.Label;
	import com.weibo.controls.VBox;
	import com.weibo.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.text.TextFormat;
	
	/**
	 * 微博用户名片组件
	 * @author yaofei@staff.sina.com.cn
	 */	
	public class UserCard extends UIComponent implements IUserCard
	{
		[Embed(source="assets/starV.png")]//加V-微博达人
		private var StarV:Class;
		[Embed(source="assets/inattention_btn_over.gif")]//关注按钮-滑过状态
		private var ButtonOver:Class;
		[Embed(source="assets/defaultHead.gif")]//默认头像
		private var DefaultHead:Class;
		[Embed(source="assets/male.png")]//男头像
		private var Male:Class;
		[Embed(source="assets/female.png")]//女头像
		private var Female:Class;
		
		protected var _dataProvider:Object;
		
	//===================================
	// 构造函数
		
		public function UserCard()
		{
			super();
			setSize(300, 200);
		}
		
//===================================
// 公开方法
		
		public function get displayObject():DisplayObject
		{
			return this;
		}
		
		public function get dataProvider():Object
		{
			return _dataProvider;
		}
		
		public function set dataProvider(data:Object):void
		{
			_dataProvider = data;
		}
		
//===================================
// 内部方法
		
		override protected function create():void
		{
			//1.1 用户基本资料
			var user_info:HBox = new HBox();
			user_info.alignment = HBox.MIDDLE;
			user_info.spacing = 10;
			
			//1.1.1
			var head:Image = new Image(DefaultHead);
			head.setSize(30, 30);
			
			//1.1.2
			var user_info_basic:VBox = new VBox();
			//1.1.2.1
			var user_info_basic_namePro:HBox = new HBox();
			var userName:Label = new Label("昵称", new TextFormat("Arial", 12, 0x0095cd));
			var userStar:Image = new Image(StarV);
			user_info_basic_namePro.alignment = HBox.MIDDLE;
			user_info_basic_namePro.addChild(userName);
			user_info_basic_namePro.addChild(userStar);
			
			//1.1.2.2
			var user_info_basic_others:HBox = new HBox();
			var sex:Image = new Image(Male);
			var userPos:Label = new Label("北京", new TextFormat("Arial", 12, 0xb6b6b6));
			user_info_basic_others.alignment = HBox.MIDDLE;
			user_info_basic_others.addChild(sex);
			user_info_basic_others.addChild(userPos);
			
			user_info_basic.addChild(user_info_basic_namePro);
			user_info_basic.addChild(user_info_basic_others);
			user_info.addChild(head);
			user_info.addChild(user_info_basic);
			
			//1.2 人脉关系部分
			var contact:HBox = new HBox();
			var con1:VBox = new VBox();
			con1.addChild(new Label("0000", new TextFormat("Arial", 12, 0x333333)));
			con1.addChild(new Label("关注", new TextFormat("Arial", 12, 0x0095cd)));
			var con2:VBox = new VBox();
			con2.addChild(new Label("0000", new TextFormat("Arial", 12, 0x333333)));
			con2.addChild(new Label("粉丝", new TextFormat("Arial", 12, 0x0095cd)));
			var con3:VBox = new VBox();
			con3.addChild(new Label("0000", new TextFormat("Arial", 12, 0x333333)));
			con3.addChild(new Label("微博", new TextFormat("Arial", 12, 0x0095cd)));
			
			contact.addChild(con1);
			contact.addChild(con2);
			contact.addChild(con3);
			
			
			//1  用户信息
			var user:VBox = new VBox();
			user.addChild(user_info);
//			var line:LineTool = new LineTool(2, 0xffcc00, 1, LineType.DOTTED);
//			line.apply(this, new Point(0, 0), new Point(100, 300));
//			user.addChild(LineTool
			user.addChild(contact);
			
			//2  加关注面板
			var attention:Box = new Box();
			var btn:UIComponent = new Button(new ButtonOver());
			attention.addChild(btn);
			attention.setSize(165, 34);
			
			//1 + 2 = 整体名片
			var totalCard:UIComponent = new VBox();
			totalCard.addChild(user);
			totalCard.addChild(attention);
			totalCard.setSize(165, 137);
			
			addChild(new Border(totalCard, 2, 5));
		}
		
		override protected function layout():void
		{
			
		}
		
//===================================
// 事件侦听器
		
	}
}