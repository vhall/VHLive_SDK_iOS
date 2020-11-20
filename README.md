# 微吼直播 SDK for iOS
 v5.0.0及后续版本<br>

[历史版本 v4.x.x](https://github.com/vhall/vhallsdk_live_ios_4.0)<br>
[历史版本 v4.0.0 以下版本](https://github.com/vhall/vhallsdk_live_ios)<br>

### 集成和调用方式

参见官方文档：http://www.vhall.com/saas/doc/310.html <br>

### APP工程集成SDK基本设置
1、工程中AppDelegate.m 文件名修改为 AppDelegate.mm<br>
2、关闭bitcode 设置<br>
3、plist 中 App Transport Security Settings -> Allow Arbitrary Loads 设置为YES<br>
4、注册`AppKey`  [VHallApi registerApp:`AppKey` SecretKey:`AppSecretKey`]; <br>
5、检查工程 `Bundle ID` 是否与`AppKey`对应 <br>
6、plist中添加相机、麦克风权限 <br>


### 上传App Store时会报模拟器错误
1、参见官方文档： https://www.vhall.com/saas/doc/296.html 中 打包上传 App Store 问题


### 使用CocoaPods 引入SDK
pod 'VHLiveSDK'<br>

使用互动功能SDK<br>
pod 'VHLiveSDK_Interactive'<br>

特别注意：v5.0.0 以下版本 pod 集成方式<br>
pod 'VHallSDK_Live'<br>
使用互动功能SDK<br>
pod 'VHallSDK_Interactive'<br>

### 版本更新信息

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

## 历史版本 
[历史版本 v4.0](https://github.com/vhall/vhallsdk_live_ios4.0)<br>
[历史版本 v4.0 以下版本](https://github.com/vhall/vhallsdk_live_ios)<br>

## 升级说明
1、v4.3.x 升级 v5.x 无接口变动直接 pod 替换升级即可 <br>
2、v4.x 升级 v5.x pod 替换升级后，参考v4.x版本升级说明 <br>

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
  pod 'VHLiveSDK_Interactive'

  pod 'BarrageRenderer','2.1.0'
  pod 'Masonry','1.1.0'
  pod 'MBProgressHUD','1.2.0'
  pod 'MLEmojiLabel','1.0.2'
  pod 'Reachability','3.2'
  pod 'SDWebImage','5.6.1'
  pod 'MJRefresh','3.3.1'
```

Demo 体验 appstore 搜索微吼小直播 应用设置填写 Appkey即可体验<br>

