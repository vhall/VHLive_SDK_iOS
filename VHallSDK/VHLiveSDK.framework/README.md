# VHYun_SDK_IM_iOS
微吼云 消息 iOS SDK 及 Demo


集成和调用方式，参见官方文档：http://www.vhallyun.com/docs/show/309.html <br>

### SDK 两种引入方式
1、pod 'VHYun_IM'<br>
检查库路径是否设置成功，没有请手动设置Frameworks路径 <br>
   "${PODS_ROOT}/VHCore/VHYunFrameworks" <br>
   "${PODS_ROOT}/VHYun_IM/VHYunFrameworks"<br>
2、手动下载拖入工程设置路径、Embed&Sign<br>
注意依赖 https://github.com/vhall/VHYun_SDK_Core_iOS.git VHCore库<br>

### APP工程集成SDK基本设置
1、关闭bitcode 设置<br>
2、plist 中 App Transport Security Settings -> Allow Arbitrary Loads 设置为YES<br>
3、注册`AppKey`  [VHLiveBase registerApp:`AppKey`]; <br>
4、检查工程 `Bundle ID` 是否与`AppKey`对应 <br>


### 版本更新信息
#### 版本 v2.3.4 更新时间：2025.03.18
更新内容：<br>
适配最新的VHCore<br>

#### 版本 v2.3.3 更新时间：2023.11.09
更新内容：<br>
更新VHCore依赖<br>

### 版本更新信息
#### 版本 v2.3.1 更新时间：2021.12.17
更新内容：<br>
支持bitcode<br>

#### 版本 v2.3.0 更新时间：2021.10.27
更新内容：<br>
兼容base重构版本<br>

#### 版本 v2.2.1 更新时间：2021.05.31
更新内容：<br>
1、日志上报优化<br>
2、发送聊天bug修复<br>

#### 版本 v2.2.0 更新时间：2021.04.20
更新内容：<br>
1、消息优化<br>
2、聊天接口新增context<br>
3、禁言接口调整<br>

#### 版本 v2.1.1 更新时间：2020.06.05
更新内容：<br>
1、新增发送自定义消息接口<br>

#### 版本 v2.1.0 更新时间：2020.03.12
更新内容：<br>
1、支持中途修改昵称等信息<br>
2、历史消息支持图文消息<br>

#### 版本 v2.0.1 更新时间：2019.09.09
更新内容：<br>
1、新增禁言全体禁言<br>
2、新增获取最近消息<br>
3、新增获取用户列表<br>
4、消息AI审核过滤<br>


#### 版本 v2.0.0 更新时间：2019.08.21
更新内容：<br>
1、新消息结构<br>
2、支持图文消息<br>
