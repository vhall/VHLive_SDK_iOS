//
//  VHDocFullScreenViewController.m
//  UIModel
//
//  Created by LiGuoliang on 2022/6/10.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHDocFullScreenViewController.h"
#define buttonSize CGSizeMake(80,40)

@interface VHDocFullScreenViewController ()
@property (nonatomic) BOOL isOnlyLandscape;
@property (nonatomic) UIButton *landscapeButton;
@property (nonatomic) UIButton *backButton;
@end

@implementation VHDocFullScreenViewController
- (UIButton *)landscapeButton {
    if(!_landscapeButton) {
        _landscapeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_landscapeButton setTitle:@"横屏" forState:UIControlStateNormal];
        [_landscapeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_landscapeButton addTarget:self action:@selector(onFocusLandscape) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_landscapeButton];
    }
    return _landscapeButton;
}
- (UIButton *)backButton {
    if(!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_backButton setImage:BundleUIImage(@"live_bottomTool_cancelClear") forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backButton];
    }
    return _backButton;
}
- (instancetype)init {
    if((self = [super init])){
        self.view.backgroundColor = [UIColor whiteColor];
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return self;
}

- (void)setDocView:(UIView *)docView {
    if([_docView superview] != nil) {
        [_docView removeFromSuperview];
        _docView = nil;
    }
    [self.view addSubview:docView];
    [self.view sendSubviewToBack:docView];
    _docView = docView;
}

- (void)onBack {
    self.isOnlyLandscape = NO;
    [self forceRotateUIInterfaceOrientation:UIInterfaceOrientationPortrait];
    [self dismiss];
}

- (void)onFocusLandscape {
    if(self.isOnlyLandscape == NO) {
        self.isOnlyLandscape = YES;
        [self forceRotateUIInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
    }else{
        self.isOnlyLandscape = NO;
        [self forceRotateUIInterfaceOrientation:UIInterfaceOrientationPortrait];
    }
}

//强制旋转屏幕方向
- (void)forceRotateUIInterfaceOrientation:(UIInterfaceOrientation)orientation {
    [[UIDevice currentDevice] setValue:@(orientation) forKey:@"orientation"];
}

- (void)dismiss {
    __weak typeof(self) wself = self;
    [self.presentingViewController dismissViewControllerAnimated:NO completion:^{
        __strong typeof(wself) self = wself;
            if(self.handleDismiss) {
                self.handleDismiss(self.docView);
                self.docView.transform = CGAffineTransformIdentity;
            }
        }];
}

- (void)viewDidLayoutSubviews {
    self.docView.transform = CGAffineTransformIdentity;
    CGRect r = (CGRect){.origin=CGPointZero, .size=self.view.bounds.size};
    self.docView.frame = r;
    self.backButton.frame = (CGRect){
        .origin = CGPointMake(10, 40), .size=buttonSize
    };
    self.landscapeButton.frame = (CGRect) {
        .origin = {
            .x = r.size.width - 100,
            .y = r.size.height - 40 - 40
        },
        .size = buttonSize
    };
}

- (BOOL)shouldAutorotate {
    return YES;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    if(self.isOnlyLandscape) {
        return UIInterfaceOrientationLandscapeRight;
    }
    return UIInterfaceOrientationPortrait;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if(self.isOnlyLandscape) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    if(size.width > size.height) {
        [_landscapeButton setTitle:@"竖屏" forState:UIControlStateNormal];
    }else{
        [_landscapeButton setTitle:@"横屏" forState:UIControlStateNormal];
    }
}
@end
