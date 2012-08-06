package com.weibo.comp.userCard
{
	import com.weibo.controls.Border;
	import com.weibo.controls.Button;
	import com.weibo.controls.HBox;
	import com.weibo.controls.Image;
	import com.weibo.controls.Label;
	import com.weibo.controls.VBox;
	import com.weibo.core.UIComponent;
	import com.weibo.core.ValidateType;
	
	import flash.display.DisplayObject;
	import flash.text.TextFormat;
	
	/**
	 * 微博用户名片组件
	 * @author yaofei@staff.sina.com.cn
	 */	
	public class UserCard extends UIComponent implements IUserCard
	{
		[Embed(source="com/weibo/assets/v4/starV.png")]//加V-微博达人
		private var StarV:Class;
		[Embed(source="com/weibo/assets/v4/inattention_btn_over.gif")]//关注按钮-滑过状态
		private var ButtonOver:Class;
		[Embed(source="com/weibo/assets/v4/defaultHead.gif")]//默认头像
		private var DefaultHead:Class;
		[Embed(source="com/weibo/assets/v4/male.png")]//男头像
		private var Male:Class;
		[Embed(source="com/weibo/assets/v4/female.png")]//女头像
		private var Female:Class;
		
		private var followText:Label;
		private var fansText:Label;
		private var profileText:Label;
		
		protected var _dataProvider:UserCardVO;
		
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
		
		public function get data():UserCardVO
		{
			return _dataProvider;
		}
		
		public function set data(vo:UserCardVO):void
		{
			_dataProvider = vo;
			followText.text = vo.follow_count == -1 ? " " : vo.follow_count.toString();
			fansText.text = vo.fans_count == -1 ? " " : vo.fans_count.toString();
			profileText.text = vo.profile_count == -1 ? " " : vo.profile_count.toString();
			
			invalidate(ValidateType.SIZE);
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
			var contact:HBox = new HBox("left", "middle", "auto");
			var con1:VBox = new VBox("center");
			followText = new Label("", new TextFormat("Arial", 12, 0x333333));
			con1.addChild(followText);
			con1.addChild(new Label("关注", new TextFormat("Arial", 12, 0x0095cd)));
			var con2:VBox = new VBox("center");
			fansText = new Label("", new TextFormat("Arial", 12, 0x333333));
			con2.addChild(fansText);
			con2.addChild(new Label("粉丝", new TextFormat("Arial", 12, 0x0095cd)));
			var con3:VBox = new VBox("center");
			profileText = new Label("", new TextFormat("Arial", 12, 0x333333));
			con3.addChild(profileText);
			con3.addChild(new Label("微博", new TextFormat("Arial", 12, 0x0095cd)));
			
			contact.addChild(con1);
			contact.addChild(con2);
			contact.addChild(con3);
			contact.width = 155;
			
			
			//1  用户信息
			var userPanel:VBox = new VBox();
			userPanel.addChild(user_info);
//			var line:LineTool = new LineTool(2, 0xffcc00, 1, LineType.DOTTED);
//			line.apply(this, new Point(0, 0), new Point(100, 300));
			userPanel.addChild(contact);
			
			//2  加关注面板
			var controlBar:UIComponent = new HBox("right");
			
			var btn:UIComponent = new Button(new ButtonOver());
			controlBar.addChild(btn);
			controlBar.setSize(165, 34);
			
			//1 + 2 = 整体名片
			var totalCard:UIComponent = new VBox("left");
			totalCard.addChild(new Border(userPanel, 0, 5));
			totalCard.addChild(controlBar);
//			totalCard.setSize(165, 137);
			
			addChild(new Border(totalCard, 2, 5));
		}
		
		override protected function layout():void
		{
			
		}
		
//===================================
// 事件侦听器
		
	}
}