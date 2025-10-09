//
//  CONSTS.h
//  VHSDKDemo
//
//  Created by vhall on 15/10/10.
//  Copyright © 2015年 vhall. All rights reserved.
//

#ifndef CONSTS_h
#define CONSTS_h

/*
   // 1、AppDelegate.mm 修改为.mm
   // 2、关闭bitcode
   // 3、plist中 App Transport Security Settings -> Allow Arbitrary Loads 设置为YES
   // 4、设置以下数据 检查 Bundle ID 即可观看直播

   //接口文档说明： http://www.vhall.com/index.php?r=doc/index/index

 #define DEMO_AppKey         @"替换成您自己的AppKey"        //详见：http://e.vhall.com/home/vhallapi/authlist
 #define DEMO_AppSecretKey   @"替换成您自己的AppSecretKey"  //AppSecretKey
 #define DEMO_ActivityId     @"" //活动id    详见：http://www.vhall.com/index.php?r=doc/detail/index&project_id=4&doc_id=27
 #define DEMO_AccessToken    @"" //发起直播Token 24小时有效 详见：http://www.vhall.com/index.php?r=doc/detail/index&project_id=4&doc_id=71
 #define DEMO_account        @"" //api注册账号 对应 third_user_id 详见：http://www.vhall.com/index.php?r=doc/detail/index&project_id=4&doc_id=70
 #define DEMO_password       @"" //密码 对应 pass字段

 */
//////////⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️发布到Github要删除以下内容 上边定义要去掉注释 重新运行demo工程 重要⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️

//#define DEMO_ActivityId     [GLEnvs current][@"ActivityId"]
//#define DEMO_AccessToken    [GLEnvs current][@"AccessToken"]
//#define DEMO_AppKey         [GLEnvs current][@"AppKey"]
//#define DEMO_account        [GLEnvs current][@"account"]
//#define DEMO_password       [GLEnvs current][@"password"]
//#define DEMO_AppSecretKey   [GLEnvs current][@"secretKey"]

// AppDelegate+DebugUpdate
// AppDelegate+Evns

////////⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️发布到Github要删除以上内容 重要⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️

// Log
#define VHLog(...) NSLog(__VA_ARGS__)

// 判断是否是 iphone 4
#define isIPhone4                       CGSizeEqualToSize(CGSizeMake(320, 480), [[UIScreen mainScreen] bounds].size)
// 判断是否是 iphone 5 / 5s / SE
#define isIPhone5_5s_SE                 CGSizeEqualToSize(CGSizeMake(320, 568), [[UIScreen mainScreen] bounds].size)
// 判断是否是 iphone 6 / 6s / 7 / 8
#define isIPhone6_6s_7_8                CGSizeEqualToSize(CGSizeMake(375, 667), [[UIScreen mainScreen] bounds].size)
// 判断是否是 iphone 6 Plus / 6s Plus / 7 Plus / 8 Plus
#define isIPhone6p_6sp_7p_8p            CGSizeEqualToSize(CGSizeMake(414, 736), [[UIScreen mainScreen] bounds].size)
// 判断是否是 iphone X / Xs / 11 Pro /  12 mini
#define isIPhoneX_Xs_11Pro_12Mini       CGSizeEqualToSize(CGSizeMake(375, 812), [[UIScreen mainScreen] bounds].size)
// 判断是否是 iphone Xs Max / XR / 11 / 11 Pro Max
#define isIPhoneXsMax_XR_11_11ProMax    CGSizeEqualToSize(CGSizeMake(414, 896), [[UIScreen mainScreen] bounds].size)
// 判断是否是 iphone 12 / 12 Pro
#define isIPhone12_12Pro                CGSizeEqualToSize(CGSizeMake(390, 844), [[UIScreen mainScreen] bounds].size)
// 判断是否是 iphone 12 Pro Max
#define isIPhone12ProMax                CGSizeEqualToSize(CGSizeMake(428, 926), [[UIScreen mainScreen] bounds].size)
// 是否是 刘海儿屏/异形屏
#define isAlien                         ([UIScreen mainScreen].bounds.size.height > 736 ? YES : NO)

// 获取屏幕尺寸
#define Screen_Bounds                   [UIScreen mainScreen].bounds
// 屏幕宽度
#define Screen_Width                    ([UIScreen mainScreen].bounds.size.width)
// 屏幕高度
#define Screen_Height                   ([UIScreen mainScreen].bounds.size.height)
// 状态栏高度
#define STATUS_BAR_H                    (isAlien ? 44.f : 20.f)
// 导航栏高度
#define NAVIGATION_BAR_H                (isAlien ? 88.f : 64.f)
// tabBar高度
#define TAB_BAR_H                       (isAlien ? (49.f + 34.f) : 49.f)
// 安全区域-底部高度
#define SAFE_BOTTOM                     (isAlien ? 34.f : 0.f)
// 安全区域-底部高度
#define SAFE_TOP                        (isAlien ? 20.f : 0.f)

#define SCREEN_SCALE [UIScreen mainScreen].scale
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

// 是否为横屏显示
#define VH_KScreenIsLandscape           UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation)

//以横屏为例 横屏292*375，竖屏375*206
#define VHWRateScale                    (Screen_Width/375.0)//竖屏
#define VHHRateSacle                    (Screen_Height/375.0)//横屏
//横竖屏比率
#define VHRateScale                     (VH_KScreenIsLandscape?VHHRateSacle:VHWRateScale)

//头部高度45 + 10//55
#define kVHBeautyTopHeight              (VHRateScale*45)
//滑动条高度 16 + 24//61
#define kVHSliderHeight                 (VHRateScale*20)
//美颜单元格高度 20+6+20+24
#define kVHCellBeautyHeight             (VHRateScale*46)
//美颜单元格宽度 44
#define kVHCellBeautyWidth              (VHRateScale*34)
//滤镜单元格高度
#define kVHCellFilterHeight             (VHRateScale*85)
//滤镜单元格宽度
#define kVHCellFilterWidth              (VHRateScale*48)
//弹框高度
#define kBeautyAlertViewHeight          (VHRateScale * 145.5)
//弹框宽度
#define kBeautyAlertViewWidth           (VHRateScale * 311)

// 默认 常规字体
#define FONT(s)              [UIFont systemFontOfSize:s]
// 默认 常规斜体
#define FONT_Italic(s)       [UIFont fontWithName:@"HelveticaNeue-Italic" size:s]
// 默认 偏细字体
#define FONT_Light(s)        [UIFont fontWithName:@"HelveticaNeue-Light" size:s]
// 默认 偏细斜体
#define FONT_LightItalic(s)  [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:s]
// 默认 细体
#define FONT_Thin(s)         [UIFont fontWithName:@"HelveticaNeue-Thin" size:s]
// 默认 细斜体
#define FONT_ThinItalic(s)   [UIFont fontWithName:@"HelveticaNeue-ThinItalic" size:s]
// 默认 加粗字体
#define FONT_Blod(s)         [UIFont boldSystemFontOfSize:s]
// 默认 加粗斜体
#define FONT_BoldItalic(s)   [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:s]
// 默认 中粗字体
#define FONT_Medium(s)       [UIFont fontWithName:@"HelveticaNeue-Medium" size:s]
// 默认 中粗斜体
#define FONT_MediumItalic(s) [UIFont fontWithName:@"HelveticaNeue-MediumItalic" size:s]
// 平方细体
#define PF_THIN(s)           [UIFont fontWithName:@"PingFangSC-Thin" size:s]
// 平方字体加粗
#define PF_Medium(s)         [UIFont fontWithName:@"PingFangSC-Medium" size:s]

// 设置 控件 边框角标，宽度，颜色
#define ViewBorderRadius(View, Radius, Width, Color) \
                                                     \
    [View.layer setCornerRadius:(Radius)];           \
    [View.layer setBorderWidth:(Width)];             \
    [View.layer setBorderColor:[Color CGColor]]

// 设置 控件 角标
#define ViewRadius(View, Radius)           \
                                           \
    [View.layer setCornerRadius:(Radius)]; \
    [View.layer setMasksToBounds:YES]

//设置坐标
#define BMCGRect(x, y, w, h) CGRectMake(x, y, w, h)

//设置角标
#define TabbarBedge(index, x)                                                      \
                                                                                   \
    UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:index]; \
    item.badgeValue = [NSString stringWithFormat:x]

//清空角标
#define CleanTabbarBedge(index)                                                       \
                                                                                      \
    UITabBarItem *tabItem = [self.tabBarController.tabBar.items objectAtIndex:index]; \
    tabItem.badgeValue = nil

// 获取本地图片进行加载
#define ImageNamed(fileName) [UIImage imageNamed:fileName]

//获取系统版本
#define IOS_VERSION        [[[UIDevice currentDevice] systemVersion] floatValue]
//APP版本号  1.0.1
#define APPVersion         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
//APPbuild版本号
#define APPBuildVersion    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
//获取应用名称
#define APP_NAME           [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
// 获取当前系统语言
#define CurrentLanguage    ([[NSLocale preferredLanguages] objectAtIndex:0])

// 信息存储
#define UserDefaults       [NSUserDefaults standardUserDefaults]
// 消息中心
#define NotificationCenter [NSNotificationCenter defaultCenter]
// 获取application
#define SharedApplication  [UIApplication sharedApplication]
// 工程 bundle
#define Bundle             [NSBundle mainBundle]
// 主屏幕
#define MainScreen         [UIScreen mainScreen]
// 设备 uuid
#define Device_UUID        [[NSUUID UUID] UUIDString]

// 主色调
#define VHMainColor        [UIColor colorWithHex:@"#FB3A32"]
#define VHBlack15          [UIColor colorWithHex:@"#D9D9D9"]
#define VHBlack25          [UIColor colorWithHex:@"#BFBFBF"]
#define VHBlack45          [UIColor colorWithHex:@"#8C8C8C"]
#define VHBlack65          [UIColor colorWithHex:@"#595959"]
#define VHBlack85          [UIColor colorWithHex:@"#262626"]
#define VHWhite35          [UIColor colorWithHex:@"#595959"]
#define VHWhite45          [UIColor colorWithHex:@"#737373"]
#define VHWhite65          [UIColor colorWithHex:@"#A6A6A6"]
#define VHWhite85          [UIColor colorWithHex:@"#D9D9D9"]

// 随机颜色
#define randomColor        random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
//rgb取色 + 透明度
#define RGBA(r, g, b, a) [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:a]
//rgb取色
#define RGB(r, g, b)     RGBA(r, g, b, 1)
// 0xffffff 16进制取色
#define RGBHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

// 通知
/// 商品通知
#define VH_GOODS_ORDERINFO  @"VH_GOODS_ORDERINFO"

/// 抽奖通知
#define VH_LOTTERY_END      @"VH_LOTTERY_END"

#endif /* CONSTS_h */
