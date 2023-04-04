# VHallSDK_Live_iOS
> [历史版本 v4.0.0 以下版本](https://github.com/vhall/vhallsdk_live_ios)<br>



## 快速集成

### CocoaPods 方式

1. 在 `Podfile` 文件中增加如下内容:

   ```ruby
   pod 'VHLiveSDK'        # 使用 直播功能
   pod 'VHLiveSDK_Interactive' # 使用 互动直播
   ```

2. 执行如下命令

   > 建议：
   >
   > 1. 为了避免缓存导致的无法更新问题，请进行本地 CocoaPods 缓存文件清理 
   > 2. 如果必要，请移除工程目录下的 podfile.lock 文件及Pods文件夹，以更新版本

   ```shell
   $ pod cache clean --all # 清理 CocoaPods 缓存
   $ pod install	--repo-update # 下载&安装库
   ```

3. 设置 `info.plist` 网络权限、相机、麦克风 的使用权限

4. 设置 `BitCode` : `Project -> Build Settings -> Enable Bitcode` 值为 `NO`

5. 修改文件名 :  `AppDelegate.m` 改为 `AppDelegate.mm`，并添加如下内容:

   ```objective-c
   // AppDelegate.m
   - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     
   	[VHallApi registerApp:<#AppKey#> SecretKey:<#AppSecretKey#>];
     
   }
   ```

6. 检查工程中的 `Bundle ID` 是否与 `AppKey` 对应



## 快速使用

详细请参见[官方文档](http://www.vhall.com/saas/doc/310.html)



## FAQ

* 上传App Store时会报模拟器错误 : 参见 https://www.vhall.com/saas/doc/296.html 中` 打包上传 App Store 问题`



## 版本更新信息

#### 版本：v6.13.1 更新时间 2023.04.03
1. 【修复】可能导致crash的线程

#### 版本：v6.13.0 更新时间 2023.03.29
1. 【新增】1、SDK新增显示章节、视频打点能力 2、新增查看奖池，查看中奖名单等抽奖相关接口
2. 【优化】1、优化抽奖互动能力，新增支持口令等特殊抽奖条件 2、观看回放初始化播放位置的功能 3、优化了登录和其他已知问题
3. 【修复】一些可能导致crash的场景

#### 版本：v6.12.0 更新时间 2023.03.07
1. 【新增】新增支持验证SaaS观看限制（密码、白名单），对接流程见“链接”；
2. 【优化】对接直播发起端发起倒计时公告，对接流程见“链接”；
3. 【注意】从该版本开始，SDK将不再支持K值验证。
4. 【修复】nil导致的crash,线程问题等等

#### 版本：v6.11.0 更新时间 2022.12.23
1. 【新增】快问快答
2.  优化sdk中一些已知问题

#### 版本：v6.10.0 更新时间 2022.11.24
1. 【新增】预告页场景
2. 【新增】暖场视频
3.  优化sdk获取活动详情的时机
4.  优化sdk中一些已知问题

#### 版本：v6.9.0 更新时间 2022.10.28
1. 【新增】直播支持新的「连麦演示」布局
2. 【新增】支持文档融屏
3.  优化sdk互动直播的时候,提供主动配置旁路,主动配置大画面的能力
4.  优化sdk中一些已知问题

#### 版本：v6.8.0 更新时间 2022.9.23
1. 【新增】彩排权限
2. 【新增】主持人发起互动混流支持pc配置的图片和背景
3.  优化sdk中一些已知问题

#### 版本：v6.7.0 更新时间 2022.9.6
1. 【新增】点赞
2. 【新增】计时器
3. 【新增】礼物
4. 【新增】直播间彩排
5. 【新增】虚拟人数
6. 【新增】极简观看模式
7. 【新增】活动详情新增直播主持人信息，直播标题等
8. 【优化】SDK中一些已知问题

#### 版本 v6.6.0 更新时间：2022.08.09

更新内容：

1. 公告列表 
2. 观看直播增加k_id验证 
3. 聊天记录增加分页消息锚点 ，防止重复数据

#### 版本 v6.5.0 更新时间：2022.07.08

更新内容：

1. 新增视频轮巡功能，支持视频直播和互动直播参与轮巡
2. 优化互动连麦清晰度，动态切换互动清晰度
3. 修复部分已知BUG

#### 版本 v6.4.1 更新时间：2022.06.14

更新内容：
1. 优化抽奖相关业务

#### 版本 v6.4.0 更新时间：2022.06.01

更新内容：
1. 新增支持云导播活动的发起和推流
2. 问卷&问答支持修改显示名称
3. 播放器支持设置背景图片和背景色
4. 修改嘉宾和观众的设备检测流程
5. 修复已知问题

#### 版本 v6.3.4 更新时间：2022.05.13

更新内容：
1、开放动态过滤私聊,聊天消息体新增私聊标识
2、优化已知bug

#### 版本 v6.3.3 更新时间：2022.05.06

更新内容：
1、嘉宾进入互动新增权限列表VHRoomInfo增加permission字段 说明, VHRoomMessage 增加inviter_Id 字段
2、增加嘉宾作为主讲人邀请上麦
3、优化已知bug
#### 版本 v6.3.2 更新时间：2022.04.29

更新内容：
1、增加观看协议-回放和看直播前调用
2、增加观看协议功能 
3、优化已知bug

#### 版本 v6.3.1 更新时间：2022.03.31

更新内容：

1.观看相同账号踢出功能
2.优化部分代码

#### 版本 v6.3.0 更新时间：2022.03.22

更新内容：

1.美颜功能优化。新增红润、大眼、瘦脸、锐化、白牙、亮眼等美颜功能；
2.新增滤镜。支持接入自然款、粉嫩款、白亮款等6种滤镜；

#### 版本 v6.2.4 更新时间：2022.02.22

更新内容：

1. 新功能 - 化蝶多语种支持
2. 新功能 - 修改主持人、嘉宾、助理的角色名称

#### 版本 v6.2.2 更新时间：2021.12.14

更新内容：<br>
1、增加对关键词过滤的支持<br>
2、优化部分代码<br>

#### 版本 v6.2.1 更新时间：2021.11.10

更新内容：<br>
1、支持发起和观看无延迟直播<br>
2、修复已知问题<br>

#### 版本 v6.2.0 更新时间：2021.10.13
更新内容：<br>
1、支持1v15互动<br>
2、嘉宾加入直播支持传入头像<br>

#### 版本 v6.1.4 更新时间：2021.09.06
更新内容：<br>
1、修复部分活动下发起问答提问报错问题<br>
2、修复嘉宾加入正在演示文档的直播间文档不显示问题<br>

#### 版本 v6.1.3 更新时间：2021.08.23
更新内容：<br>
1、解决进入互动活动传密码或k值无效问题<br>
2、解决部分场景下播放器内存未释放问题<br>

#### 版本 v6.1.2 更新时间：2021.07.27
更新内容：<br>
1、初始化接口支持传入RSA私钥<br>
2、解决观众进入互动下麦后，发送聊天消息提示包含敏感词问题<br>

#### 版本 v6.1.1 更新时间：2021.07.01
更新内容：<br>
1、修复VHRoom进入房间多次回调的问题<br>

#### 版本 v6.1.0 更新时间：2021.06.29
更新内容：<br>
1、支持主播发起互动直播<br>
2、支持嘉宾加入互动直播<br>
3、优化已知问题<br>

#### 版本 v6.0.3 更新时间：2021.06.03
更新内容：<br>
1、解决播放回放，播放器状态处于启动状态时暂停无效问题<br>
2、优化长方形水印出现形变问题<br>
3、解决某些回放闪退问题<br>

#### 版本 v6.0.2 更新时间：2021.04.15
更新内容：<br>
1、新增跑马灯功能<br>
2、调整水印间距，适配刘海屏<br>
3、修复已知问题<br>

#### 版本 v6.0.1 更新时间：2021.04.02
更新内容：<br>
1、修复6.0版本初始化SDK需要传host问题<br>
2、看直播/回放播放器，新增视频尺寸回调<br>

#### 版本 v6.0.0 更新时间：2021.03.16
更新内容：<br>
1、发直播接口，在新版v3控制台创建的直播活动可不传access_token。<br>
2、抽奖新增接口，仅适用于新版控制台v3创建的直播所发起的抽奖。<br>
3、看直播/回放播放器，新增活动信息VHWebinarInfo，可获取当前在线人数与活动热度信息。<br>
4、发直播，可修改主播昵称。<br>
5、修复部分机型前后台切换，推流失败问题<br>
6、修复问答，主持人的回答消息昵称错误问题<br>
7、修复投屏播放过程中，无法切换视频问题<br>
8、修复播放回放时，无法切换视频问题<br>
9、修复iOS14下播放回放进入后台暂停后再进入前台无法播放问题<br>

升级v6.0.0注意：
1、6.0移除了回放评论功能，建议使用聊天代替，若使用了评论功能，升级6.0请务必进行修改，否则评论功能将失效。
2、移除了游客进入，新增第三方id登录，使用SDK功能必须先登录。

#### 版本 v5.0.2 更新时间：2021.01.25
更新内容：<br>
1、消息优化<br>
2、播放器优化<br>

#### 版本 v5.0.1 更新时间：2020.11.19
更新内容：<br>
1、日志上报新增字段<br>
2、上线消息中新增PV字段，解决web端观看量显示为0问题<br>


#### 版本 v5.0.0 更新时间：2020.10.28
更新内容：<br>
1、底层优化<br>
2、H5活动新增分页获取聊天记录<br>
3、H5点播开始播放状态修复<br>
4、文档翻页bug修复<br>
5、解决 Seek 精度问题<br>
6、Demo新增竖屏播放<br>

#### 版本 v4.3.4 更新时间：2020.07.02
更新内容：<br>
1、新增是否全体禁言字段<br>
1、新增签到倒计时取消功能<br>

#### 版本 v4.3.3 更新时间：2020.07.02
更新内容：<br>
1、解决文档初始化是否显示的bug<br>

#### 版本 v4.3.2 更新时间：2020.06.22
更新内容：<br>
1、回放文档bug修复<br>
2、预加载房间消息bug修复<br>

#### 版本 v4.3.1 更新时间：2020.06.15
更新内容：<br>
1、解决偶尔文档不加载问题<br>


#### 版本 v4.3.0 更新时间：2020.06.11
更新内容：<br>
1、新增水印功能<br>
2、扬声器设备占用优化（后台切换等情况）<br>
3、角色信息bug修复<br>
4、新增直播前连接消息服务<br>
5、解决回放显示文档问题<br>
6、优化demo|<br>


#### 版本 v4.2.1 更新时间：2020.05.21
更新内容：<br>
1、解决互动偶尔声音小问题<br>

#### 版本 v4.2.0 更新时间：2020.04.27
更新内容：<br>
1、支持投屏功能<br>
2、日志上报优化<br>

#### 版本 v4.1.2 更新时间：2020.04.20
更新内容：<br>
1、demo优化<br>
2、解决GPUimage 冲突bug<br>
3、解决偶尔web显示角色错误<br>
4、解决历史聊天信息不全问题<br>
5、回放静音失效问题<br>

#### 版本 v4.1.1 更新时间：2020.03.18
更新内容：<br>
1、解决回放后台播放bug<br>
2、支持pod集成 SDK<br>
3、H5 活动历史消息数据兼容<br>
4、上麦bug修复<br>

#### 版本 v4.1.0 更新时间：2020.02.27
更新内容：<br>
1、解决播放器bug<br>
2、优化Demo<br>

#### 版本 v4.0.1 更新时间：2019.09.16
更新内容：<br>
1、优化Demo<br>
2、修改美颜设置<br>


#### 版本 v4.0.0 更新时间：2019.09.02
更新内容：<br>
1、优化问卷展现形式<br>
2、修复已知bug<br>


## 历史版本 
[历史版本](https://github.com/vhall/vhallsdk_live_ios)<br>


## Demo

### Demo 结构
VHSDKDemo.xcworkspace   Demo工作空间，用于管理 VHSDKDemo和UIModel两个工程<br>
VHSDKDemo 	        App 层模拟用户 App  <br>
VHSDKUIModel            Demo UI层简单实现，以静态库形式提供App层使用，此模块是Demo一部分，仅供参考<br>
VHallSDK                微吼 SaaS 直播 SDK<br>

### Demo 使用说明
1、打开 工程 VHSDKDemo.xcworkspace <br>
2、填写 CONSTS.h 中的 信息，修改包名签名<br>
3、选择target 为 VHSDKDemo4.x 直接编译运行<br>
4、登录<br>
5、设置相关参数，发直播需要设置有效期内的直播token (AccessToken) 需要用 API 生成<br>



### 两种引入App 工程方式

1、打开 UIModel.xcodeproj 编译完成后 可以把  VHallSDK，UIModel 拷贝到目标App 工程直接引用，UIModel中使用了第三方库如有冲突自行删除冲突静态库即可<br>

2、源码依赖 UIModel，直接把VHSDKUIModel下UIModel文件夹拖到App工程中，podfile 添加 UIModel的依赖库，设置好依赖路径，pch 文件中 引入UIModel.h 编译即可。注：额外设置DLNA lib路径<br>

UIModel 依赖的第三方库如下，如版本不同自行调整
```
  pod 'VHallSDK_Interactive'
  pod 'BarrageRenderer','2.1.0'
  pod 'Masonry','1.1.0'
  pod 'MBProgressHUD','1.2.0'
  pod 'MLEmojiLabel','1.0.2'
  pod 'Reachability','3.2'
  pod 'SDWebImage','5.6.1'
  pod 'MJRefresh','3.3.1'
```

Demo 体验 appstore 搜索微吼小直播 应用设置填写 Appkey即可体验<br>
