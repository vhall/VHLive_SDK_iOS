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
        
    // 键盘管理
    [self keyboardManager];
    
    // 进入登录页
    VHLoginViewController * loginVC = [[VHLoginViewController alloc] init];
    loginVC.vh_NavIsHidden = YES;
    VHNavBaseViewController * navC = [[VHNavBaseViewController alloc] initWithRootViewController:loginVC];
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
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    // 键盘弹出时，点击背景，键盘收回
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
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

@end
