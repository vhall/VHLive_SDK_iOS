//
//  ProgressHud.m
//  Recycle
//
//  Created by dengbin on 2018/11/22.
//  Copyright © 2018年 recycle. All rights reserved.
//

#import "VHProgressHud.h"

#define HUD_TAG          0x1122
#define DEFAULT_DURATION 6.0             //吐司时长


@interface VHHudCustomView : UIView
@property (nonatomic, strong) UILabel *tipLab;
@end

@implementation VHHudCustomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        self.backgroundColor = [[UIColor colorWithHex:@"000000"] colorWithAlphaComponent:0.7];
        self.layer.cornerRadius = 18;
        self.layer.masksToBounds = YES;
        [self addSubview:self.tipLab];
        [self.tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(8, 20, 8, 20));
        }];
    }

    return self;
}

- (UILabel *)tipLab
{
    if (!_tipLab) {
        _tipLab = [[UILabel alloc] init];
        _tipLab.textColor = [UIColor whiteColor];
        _tipLab.font = FONT(14);
        _tipLab.numberOfLines = 0;
        _tipLab.textAlignment = NSTextAlignmentCenter;
    }

    return _tipLab;
}

@end


@implementation VHProgressHud

+ (void)showToast:(NSString *)text {
    UIWindow *window = [[[UIApplication sharedApplication]delegate]window];

    [self showToast:text inView:window offsetY:0];
}

+ (void)showToast:(NSString *)text offsetY:(CGFloat)offsetY {
    UIWindow *window = [[[UIApplication sharedApplication]delegate]window];

    [self showToast:text inView:window offsetY:offsetY];
}

+ (void)showToast:(NSString *)text inView:(UIView *)view offsetY:(CGFloat)offsetY {
    MBProgressHUD *HUD = nil;

    if (!(HUD = [view viewWithTag:HUD_TAG])) {
        HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }

    //自定义
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.offset = CGPointMake(0, offsetY);
    VHHudCustomView *customView = [[VHHudCustomView alloc] init];
    HUD.customView = customView;
    HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    HUD.bezelView.color = [UIColor clearColor];
    HUD.label.text = @"";
    HUD.userInteractionEnabled = NO;

    if (text) {
        customView.tipLab.text = text;
    }

    HUD.tag = HUD_TAG;
    [HUD hideAnimated:YES afterDelay:DEFAULT_DURATION];
}

+ (MBProgressHUD *)showLoading:(NSString *)text {
    UIWindow *window = [[[UIApplication sharedApplication]delegate]window];

    return [self showLoading:text inView:window];
}

+ (MBProgressHUD *)showLoading:(NSString *)text inView:(UIView *)view {
    MBProgressHUD *HUD = nil;

    if (!(HUD = [view viewWithTag:HUD_TAG])) {
        HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }

    if (text.length > 0) {
        HUD.label.text = text;
    }

    HUD.graceTime = 0.3; //显示Loding的宽限期，如果请求在0.5s内已经完成则不会显示
    HUD.minShowTime = 0.5; //最小显示时间，避免一显示就被移除
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.offset = CGPointZero;
    HUD.label.font = [UIFont systemFontOfSize:16];
    HUD.label.textColor = [UIColor whiteColor];
    HUD.bezelView.style = MBProgressHUDBackgroundStyleBlur;
    HUD.bezelView.color = [UIColor colorWithWhite:0 alpha:0.5];
    HUD.tag = HUD_TAG;
    [HUD hideAnimated:YES afterDelay:999];
    return HUD;
}

+ (void)hideLoadingInView:(UIView *)view {
    MBProgressHUD *hud =  [view viewWithTag:HUD_TAG];

    [hud hideAnimated:NO];
}

+ (void)hideLoading {
    [self hideLoadingInView:[[[UIApplication sharedApplication]delegate]window]];
}

+ (MBProgressHUD *)showLoading {
    return [self showLoading:@""];
}

+ (MBProgressHUD *)showBackgroundFullLoading
{
    MBProgressHUD *HUD = nil;

    if (!(HUD = [[[[UIApplication sharedApplication]delegate]window] viewWithTag:HUD_TAG])) {
        HUD = [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication]delegate]window] animated:YES];
    }

    HUD.graceTime = 0.3; //显示Loding的宽限期，如果请求在0.5s内已经完成则不会显示
    HUD.minShowTime = 0.5; //最小显示时间，避免一显示就被移除
    // Change the background view style and color.
    HUD.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    HUD.backgroundView.color = [UIColor whiteColor];
    HUD.bezelView.color = [UIColor colorWithWhite:0 alpha:0.5];
    HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    HUD.tag = HUD_TAG;
    [HUD hideAnimated:YES afterDelay:999];
    return HUD;
}

@end
