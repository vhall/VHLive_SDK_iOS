//
//  VHBaseViewController.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/6.
//

#import "VHBaseViewController.h"

@interface VHBaseViewController ()

@end

@implementation VHBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.accessibilityLabel = VHTest_Base_BackBtn;
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    [leftBtn setImage:[UIImage imageNamed:@"vh_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(clickLeftBarItem) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBarItem;

    // 导航栏不透明
    self.navigationController.navigationBar.translucent = NO;
    // 设置导航栏字体颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    // 导航栏背景色
    if (@available(iOS 15.0,*)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance setBackgroundImage:[UIImage imageWithColor:VHMainColor]];
        [appearance setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor whiteColor] }];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    } else {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:VHMainColor] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor whiteColor] }];
    }

    //进入前后台相关监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

#pragma mark - 前后台处理
//前台（子类重写）
- (void)appWillEnterForeground {
}

//后台（子类重写）
- (void)appDidEnterBackground {
}

#pragma mark - 点击返回
- (void)clickLeftBarItem
{
    [self.navigationController popViewControllerAnimated:YES];
    // 结束自动化测试
    [VUITool sendTestsNotificationCenterWithKey:VHTests_END otherInfo:[NSDictionary dictionary]];
}

#pragma mark - 导航栏显隐
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (self.vh_NavIsHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if (self.vh_NavIsHidden) {
        if ([self vh_pushOrPopIsHidden] == NO) {
            [self.navigationController setNavigationBarHidden:NO animated:animated];
        }
    }
}

#pragma mark - 监听push下一个或 pop 上一个，是否隐藏导航栏
- (BOOL)vh_pushOrPopIsHidden {
    NSArray *viewcontrollers = self.navigationController.viewControllers;

    if (viewcontrollers.count > 0) {
        VHBaseViewController *vc = viewcontrollers[viewcontrollers.count - 1];
        return vc.vh_NavIsHidden;
    }

    return NO;
}

#pragma mark - 状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - delloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
