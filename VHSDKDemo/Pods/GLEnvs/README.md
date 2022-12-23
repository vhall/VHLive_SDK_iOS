![logo](https://github.com/GL9700/gl9700.github.io/blob/master/GLSLogo_800.png?raw=true)
# GLEnvs

[![CI Status](https://img.shields.io/travis/liandyii@msn.com/GLEnvs.svg?style=flat)](https://travis-ci.org/liandyii@msn.com/GLEnvs)
[![Version](https://img.shields.io/cocoapods/v/GLEnvs.svg?style=flat)](https://cocoapods.org/pods/GLEnvs)
[![License](https://img.shields.io/cocoapods/l/GLEnvs.svg?style=flat)](https://cocoapods.org/pods/GLEnvs)
[![Platform](https://img.shields.io/cocoapods/p/GLEnvs.svg?style=flat)](https://cocoapods.org/pods/GLEnvs)

可以快速切换已配置好的变量环境，也可以直接自定义变量环境。

## Installation

GLEnvs is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'GLEnvs'
```

## Quick Start
1. 进行配置
	```objc
	...
		GLEnvs *envs = [GLEnvs defaultWithEnvironments:@[
            @{
                @"测试环境":@{
                    @"host":@"http://192.168.1.1:8080",
                    @"nimKey":@"debugkey333",
                    @"wxKey":@"debugkey123"
                }  
            },@{
                @"正式环境":@{
                    @"host":@"https://www.baidu.com",
                    @"nimKey":@"releasekey111",
                    @"wxKey":@"releasekey222"
                }
            }
		]];
        envs.showTopLine = YES; // 是否在App中显示顶部提示条
        [envs enableWithShakeMotion:<#开启环境切换#> defaultIndex:<#环境的索引编号#>];
        //
        // 例如
        // [envs enableWithShakeMotion:YES defaultIndex:0]; // 用户可以切换环境且使用 envs[0] 作为当前环境
        //
	...
	```

2. 使用
	```objc
	...
	NSString * key = [GLEnvs loadEnv][@"nimKey"];	// [GLEnvs loadEvn]:获取当前环境，[@"nimKey"]:环境中对应的Key值
	...
	```
## Advanced
```objc
<GLEnvs.m>
...
// Manual invoke to change current environment
// 手动改变当前环境
+ manualChangeEnv:

/// Enable GLEnvs With ...
/// 改变环境

// Specify String in PasteBoard
// 从剪切板匹配指定字符串来判断是否开启摇一摇功能
- enableWithPasteBoardString: matchSuccess: matchFailed:

//匹配模式，默认完全匹配 (只在PasteBoard模式生效)
@property MatchType type; // MatchType:[完全 | 开头 | 包含 | 结尾]

// App Icon pop Menu at long touch
// 通过长按app图标弹出的菜单进行环境选择
- enableWithShortCutItemString: PresentConfig: defaultIndex: 


// Shake in Running
// 打开摇一摇环境切换菜单
- enableWithShakeMotion: defaultIndex: 

/// Get Inf
+ loadEnv // Get Current Environment
+ longEnvName // Get Current Environment Name
...
```



## History

<details>

<summary> - 1.5.9 - 2021-11-23</summary>
    <p> -- 修复 shortcutItem 在某些已知情况下不可用的情况 </p>
</details>

<summary> - 1.5.8 - 2021-11-23</summary>
    <p> -- 增加了实用 shortcutItem 来进行设置环境 (3d touch) </p>
</details>

<summary> - 1.5.4 - 2021-02-23</summary>
    <p> -- 增加了一个小功能: 使用`showTopLine`来控制是否显示顶部的提示条 </p>
    <p> -- 并且修改为默认不显示 </p>
</details>

<details>
<summary> - 1.5.3 - 2021-02-18</summary>
    <p> -- 修正了 顶栏状态显示层，遮挡操作事件的问题 </p>
</details>

<details>
<summary> - 1.5.2 - 2021-02-18</summary>
    <p> -- 修正了 顶栏状态显示，可能被干掉的问题 </p>
</details>

<details>    
<summary> - 1.5.1 - 2021-02-09</summary>
    <p> -- 增加了对于切换环境的监听器 </p>
</details>

<details>
<summary> - 1.5.0 - 2021-02-08</summary>
    <p> -- 包含了`OC`和`Swift`两个版本的`Demo`</p>
    <p> -- 优化了环境列表弹出机制</p>
</details>

<details>
<summary> - 1.4.0 - 2020-12-02</summary>
    <p> -- 增加了可以通过ShortCut ( 3D Touch 主屏图标 ) 来进行环境切换，并且可以自定义内页，来隐藏Debug模式</p>
</details>

<details>
<summary> - 1.3.0 - 2020-11-12</summary>
    <p> -- 增加关于开启和关闭，现在可以通过获取剪切板内容来开启或关闭测试模式。可自定义匹配模式</p>
</details>

<details>
<summary> - 1.2.8 - 2020-04-02</summary>
    <p> -- 修复一个在Debug状态下重修改环境字典未重新加载的问题（正式环境不受影响）</p>
</details>

<details>
<summary> - More...</summary>
<p> - 1.2.5</p>
    <p> -- 维护:增加了更加明确和更加详细的注释</p>
<p> - 1.2.4</p>
    <p> -- 迁移:Github</p>
<p> - 1.2.3</p>
    <p> -- 修复:方法交换问题</p>
    <p> -- 增加:版本号显示</p>
<p> - 1.2.2</p>
    <p> -- 修复:修复一个崩溃Bug，对event做类型验证然后再进行后续操作</p>
<p> - 1.2.1</p>
    <p> -- 优化:当前环境显示问题，从小方块修改成全屏条幅</p>
<p> - 1.2.0</p>
    <p> -- 修复:一系列在真机导致崩溃的问题</p>
<p> - 1.1.2</p>
    <p> -- fix Environment Save FAILED & Improve Save/Load to Archive</p>
<p> - 1.0.0</p>
    <p> -- first commit</p>
</details>

## Author
liguoliang, 36617161@qq.com

## License

GLEnvs is available under the MIT license. See the LICENSE file for more info.
