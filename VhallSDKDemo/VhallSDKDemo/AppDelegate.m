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
        
    BOOL ret =  [WXApi registerApp:@"wxc6c0a273cf2f67f7" universalLink:@"https://vhall/app/"];


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


/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
- (void)onReq:(BaseReq*)req{
    VHLog(@"SDK版本 === %@ === %@", [VHallApi sdkVersionEX], [VHRoom sdkVersionEX]);
}



/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 */
- (void)onResp:(BaseResp*)resp{
    VHLog(@"SDK版本 === %@ === %@", [VHallApi sdkVersionEX], [VHRoom sdkVersionEX]);
}

/* ! @brief 用于在iOS16以及以上系统上，控制OpenSDK是否读取剪切板中微信传递的数据以及读取的时机
 * 在iOS16以及以上系统，在SDK需要读取剪切板中微信写入的数据时，会回调该方法。没有实现默认会直接读取微信通过剪切板传递过来的数据
 * 注意：
 *      1. 只在iOS16以及以上的系统版本上回调;
 *      2. 不实现时，OpenSDK会直接调用读取剪切板接口，读取微信传递过来的数据;
 *      3. 若实现该方法：开发者需要通过调用completion(), 支持异步，通知SDK允许读取剪切板中微信传递的数据,
 *                    不调用completion()则代表不授权OpenSDK读取剪切板，会导致收不到onReq:, onResp:回调，无法后续业务流程。请谨慎使用
 *      4. 不要长时间持有completion不释放，可能会导致内存泄漏。
 */
- (void)onNeedGrantReadPasteBoardPermissionWithURL:(nonnull NSURL *)openURL completion:(nonnull WXGrantReadPasteBoardPermissionCompletion)completion{
    VHLog(@"SDK版本 === %@ === %@", [VHallApi sdkVersionEX], [VHRoom sdkVersionEX]);
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
