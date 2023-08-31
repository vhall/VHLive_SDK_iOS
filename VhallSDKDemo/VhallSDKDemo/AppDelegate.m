//
//  AppDelegate.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/6.
//

#import "AppDelegate.h"
#import "VHLoginViewController.h"
#import "VHNavBaseViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 初始化
    DEMO_Setting.appKey = @"";
    DEMO_Setting.appSecretKey = @"";
    
    [VHallApi registerApp:DEMO_Setting.appKey SecretKey:DEMO_Setting.appSecretKey];

    // 键盘管理
    [self keyboardManager];

    // 进入登录页
    VHLoginViewController *loginVC = [[VHLoginViewController alloc] init];
    loginVC.vh_NavIsHidden = YES;
    VHNavBaseViewController *navC = [[VHNavBaseViewController alloc] initWithRootViewController:loginVC];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:navC];
    [self.window makeKeyAndVisible];

    return YES;
}

#pragma mark - 键盘管理
- (void)keyboardManager
{
    // 是都开启键盘工具
    [[IQKeyboardManager sharedManager] setEnable:YES];
    // 是否显示键盘提示工具栏
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    // 键盘弹出时，点击背景，键盘收回
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    // 下一步
    [IQKeyboardManager sharedManager].previousNextDisplayMode = IQPreviousNextDisplayModeAlwaysShow;
}

#pragma mark - 屏幕旋转
- (void)setLaunchScreen:(BOOL)launchScreen {
    _launchScreen = launchScreen;
    [self application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:nil];
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (self.isLaunchScreen) {
        return UIInterfaceOrientationMaskLandscapeRight;
    }

    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - 跳转返回通知
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    // 路由跳转回调
    if ([url.scheme isEqualToString:@"vhallsdk"] || [url.scheme isEqualToString:@"xxx.com"] || [url.scheme isEqualToString:@"yyy.xxx.com"]) {
        // 发送通知刷新订单状态
        [[NSNotificationCenter defaultCenter] postNotificationName:VH_GOODS_ORDERINFO object:self userInfo:nil];
        if (![VUITool isBlankString:url.resourceSpecifier]) {
            // 对url进行解码
            [VHProgressHud showToast:[VUITool vh_URLDecodedString:url.resourceSpecifier]];
            // 复制url携带的参数
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setString:[VUITool vh_URLDecodedString:url.resourceSpecifier]];
        }
    }
    return YES;
}


@end
