## 新浪微博Flash SDK ##
  * 封装了OAuth授权登陆，使用login方法登录
  * 微博开放平台：http://open.weibo.com/
  * 提供callWeiboAPI用于调用大部分的微博开放平台接口
  * 提供updateStatus用于发微博接口

---

## 教程 ##
  * <a href='http://www.flashache.com/2012/04/21/weibo-flash-app-oauth2/'>微博Flash应用的授权机制说明</a>
  * <a href='http://www.flashache.com/2011/11/28/guide-to-weibo-flash-sdk-cn/'>Weibo Flash SDK OAuth2 Web 应用开发</a>
  * <a href='http://www.flashache.com/2011/11/29/weibo-flash-sdk-callweiboapi/'>使用Weibo Flash SDK通用接口callWeiboAPI</a>


---

## 线上Demo ##
  * <a href='http://flashsdk.sinaapp.com/proxy/FlashSDKOAuth2Proxy.html'>非安全域名网络应用接口测试(OAuth2)</a>（暂时这个应用没审核通过，只能使用测试用户：flashache01@sina.com，密码：123qwe ，别无聊改密码啊 :D）
  * <a href='http://flashsdk.sinaapp.com/WeiboFlashPlatformManual.html#selectedIndex=0'>新浪微博 Flash sdk API测试</a>

---

## 开发流程 | Developing Instruction (OAuth2) ##
### 1、确认应用类型 | Confirm type of your application ###
    * 桌面或者移动端应用 | Desktop or mobile application
    * 基于浏览器的网络应用 | Browser based web applicaiton
      * 安全域网络应用
      * 非安全域网络应用
PS:
  * 安全域白名单（ https://api.weibo.com/crossdomain.xml  ）中，并且基于https请求
  * 现有三方开发可以使用的域只有SAE (http://sae.sina.com.cn/)
### 2、授权登录 ###
  * 下列说明中使用到`_mb`，即是flash sdk `_MicroBlog`主类的实例，即`_mb: MicroBlog = new MicroBlog();` <br />
**2.1、桌面或者移动端应用**
使用用户名密码的方式授权登录，`_mb.login(username, password)`
  * 这种授权登录方式需要申请使用权限，详见：<a href='http://open.weibo.com/wiki/Oauth2#.E7.89.B9.E6.AE.8A.E6.9D.83.E9.99.90.E7.94.B3.E8.AF.B7'>特殊权限申请</a><br />
**2.2、安全域网络应用**
调用`_mb.login()`即可。
  * 现有可用的信任域只有SAE，并且需要基于https，否则将报安全沙箱错误<br />
<font color='#ff0000'>2.3、非安全域网络应用</font><font color='#990000'>（基本上三方开发的网络应用都属于这个类别）</font><br />
所谓非安全域网络应用，即受到了开放平台跨域文件crossdomian.xml的限制而无法访问api。主要是有两层限制，1、你的应用必须在白名单之中，2、你的swf请求必须基于https。<br />
我们可以使用代理接口的方式去跳过这个跨域文件限制，达到请求api的目的。即：<font color='#990000'>需要开发者部署自己的代理接口</font>。现在已有的代理接口脚本：
  * PHP版本，<a href='http://flashsdk.sinaapp.com/proxy/proxy.php_'>右键另存</a>，修改文件后缀即可。
有三方能提供的其他语言的代理接口脚本，欢迎发送给flashache@gmail.com<br />
PHP代理接口部署建议：
  1. php代理接口建议部署到SAE上，当然，如果你的服务器支持php的https请求，也可部署到自己的服务器上。
  1. 建议flash文件和代理接口文件在同一个域下。如果不在同一个域，代理接口需要开放flash文件所在的域名，即：需要部署跨域文件。
  1. 代理接口如果需要部署跨域文件，建议不要使用星号，而只开放所必须的几个域。

---

## 代码示例 ##
  * 本代码示例针对的是非安全域的网络应用
  * 下周会给出各个开发环境的应用demo，包括：flash builder/ flash ide/flash develop等等。
初始化，实例化`MicroBlog`对象：
```
_mb = new MicroBlog();
_mb.consumerKey = ""; //申请的App Key
_mb.consumerSecret = ""; //申请的App Secrect
_mb.proxyURI = "http://flashsdk.sinaapp.com/proxy/proxy.php"; //写你自己部署的代理接口地址
```
授权登录：
```
/**
 * 登录按钮被点击，调用登录逻辑
 */
protected function btnLogin_clickHandler(event:MouseEvent):void
{
    _mb.addEventListener(MicroBlogEvent.LOGIN_RESULT, onLoginResult);
    _mb.login();
}

/*
 * 成功登录，获取到access_token，expires_in和refresh_token
 */
protected function onLoginResult(e:MicroBlogEvent):void
{
    _mb.removeEventListener(MicroBlogEvent.LOGIN_RESULT, onLoginResult);
    trace(e.result["access_token"] + "::" + e.result["expires_in"] + "::" + e.result["refresh_token"]);  
}
```
调用通用接口callWeboAPI，获取当前登录用户的id
```
/**
 * 测试通过调用callWeiboAPI通用接口调用开放平台接口：“2/account/get_uid”
 */
protected function testAPI():void
{
    _mb.addEventListener("callWeiboApiResult", callWeiboApiResult);
    _mb.addEventListener("callWeiboApiError", callWeiboApiError);
    _mb.callWeiboAPI("2/account/get_uid", null, "GET", "callWeiboApiResult", "callWeiboApiError"); 
//注意，这里使用的callWeiboApiResult和callWeiboApiError字符串代表了两个自定义事件，你也可以使用自己定义的字符串区分各个api的调用。
}

/**
 * 成功调用api
 */
private function callWeiboApiResult(e:MicroBlogEvent):void
{
    trace(e.result.uid); //按照线上文档返回格式格式： {"uid":"3456676543"}
}

/**
 * 调用api失败，获取服务器返回的错误信息
 */
private function callWeiboApiError(e:MicroBlogErrorEvent):void
{
    trace(e.message);
}
```

---

## 温馨小提示 ##
  1. 提供的代码包`com.sina.microblog.data`中有两个有用的类，`MicroBlogUser`和`MicroBlogStatus`。调用`updateStatus`这个接口和调用`callWeiboAPI`不同的是，收到e.result对象不只是一个对象而已，而是被强类型过的，类型是`MocroBlogStatus`类型
  1. 针对使用callWeiboAPI这个接口，如果返回的数据类型是单条微博，或者微博数组，或者微博用户数据，则可使用`MicroBlogStatus`和`MicroBlogUser`来强类型数据，即：收到e.result之后，这个e.result是单条微博结构，则可以`new MicroBlogStatus(e.result)`来进行强类型了。
