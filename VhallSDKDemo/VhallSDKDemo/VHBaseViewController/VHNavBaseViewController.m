//
//  VHNavBaseViewController.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/21.
//

#import "VHNavBaseViewController.h"

@interface VHNavBaseViewController ()

@end

@implementation VHNavBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // 导航禁止手势返回
    self.interactivePopGestureRecognizer.enabled = NO;
}

#pragma mark - 状态栏颜色
- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

@end
