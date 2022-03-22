//
//  VHBeautyAlertView.m
//  UIModel
//
//  Created by jinbang.li on 2022/3/4.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHBeautyAlertView.h"
//确定是0,取消为1
typedef void(^OperationClick)(NSInteger index);
@interface VHBeautyAlertView()
//点击-确定是0,取消为1
@property (nonatomic,copy) OperationClick click;
@end
@implementation VHBeautyAlertView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.frame = CGRectMake(0, 0, VH_KScreenIsLandscape?VHScreenHeight:VHScreenWidth, VH_KScreenIsLandscape?VHScreenWidth:VHScreenHeight);
    }
    return self;
}
- (instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0,VHScreenWidth, VHScreenHeight);
    }
    return self;
}
- (void)alertContent:(CGSize)alertSize AlertType:(AlertViewType)alertType alertString:(NSString *)alertString clickCall:(void(^)(NSInteger index))operation{
    self.click = operation;
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VHScreenWidth, VHScreenHeight)];
    bgview.backgroundColor = [UIColor blackColor];
    bgview.alpha = 0.9;
    bgview.userInteractionEnabled = YES;
    [self addSubview:bgview];
    // 311 * 145.5
    UIView *contentView = [[UIView alloc] init];
    contentView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    contentView.layer.cornerRadius = 8;
    [bgview addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.width.mas_equalTo(alertSize.width);
        make.height.mas_equalTo(alertSize.height);
    }];
    //适配两个弹框
    UILabel *label = [UILabel creatWithFont:16 TextColor:@"#262626" Text:alertString];
    label.textAlignment =  NSTextAlignmentCenter;
    [contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(kAdaptScale * 40.5);
        make.centerX.offset(0);
        make.width.equalTo(contentView.mas_width).offset(0);
        make.height.mas_equalTo(kAdaptScale * 22);
    }];
    
    //分割线
    UILabel *hLine = [[UILabel alloc] init];
    hLine.backgroundColor = [UIColor colorWithHex:@"#CCCCCC"];
    [contentView addSubview:hLine];
    [hLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kAdaptScale * 95.5);
        make.left.right.offset(0);
        make.height.mas_equalTo(0.5*kAdaptScale);
    }];
    if (alertType == AlertView_One) {
        UIButton *sure = [UIButton creatWithTitle:@"确定" titleFont:16 titleColor:@"#FB3A32" backgroundColor:@"#FFFFFF"];
        sure.tag = 100;
        [sure addTarget:self action:@selector(operation:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:sure];
        sure.layer.cornerRadius = 8*kAdaptScale;
        [sure mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(hLine.mas_bottom).offset(0);
            make.bottom.right.offset(0);
            make.width.mas_equalTo(alertSize.width);
        }];
    }else if (alertType == AlertView_Two){
        //竖分割线
        UILabel *vLine = [[UILabel alloc] init];
        vLine.backgroundColor = [UIColor colorWithHex:@"#CCCCCC"];
        [contentView addSubview:vLine];
        [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(hLine.mas_bottom).offset(0);
            make.width.mas_equalTo(0.5*kAdaptScale);
            make.centerX.offset(0);
            make.bottom.offset(0);
        }];
        //确定取消按键
        UIButton *cancel = [UIButton creatWithTitle:@"取消" titleFont:16 titleColor:@"#595959" backgroundColor:@"#FFFFFF"];
        [cancel addTarget:self action:@selector(operation:) forControlEvents:UIControlEventTouchUpInside];
        cancel.tag = 101;
        [contentView addSubview:cancel];
        cancel.layer.cornerRadius = 8*kAdaptScale;
        [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(hLine.mas_bottom).offset(0);
            make.bottom.left.offset(0);
            make.width.mas_equalTo((alertSize.width)/2 -0.5);
        }];
        UIButton *sure = [UIButton creatWithTitle:@"确定" titleFont:16 titleColor:@"#FB3A32" backgroundColor:@"#FFFFFF"];
        sure.tag = 100;
        [contentView addSubview:sure];
        [sure addTarget:self action:@selector(operation:) forControlEvents:UIControlEventTouchUpInside];
        sure.layer.cornerRadius = 8*kAdaptScale;
        [sure mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(hLine.mas_bottom).offset(0);
            make.bottom.right.offset(0);
            make.width.mas_equalTo((alertSize.width)/2 -0.5);
        }];
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
- (void)operation:(UIButton *)sender{
    [self removeFromSuperview];
    if (self.click) {
        self.click(sender.tag - 100);
    }
}
+ (void)showBeatyAlertView:(AlertViewType)alertType alertTip:(NSString *)tip clickCall:(void(^)(NSInteger index))operation{
    VHBeautyAlertView *alert = [[VHBeautyAlertView alloc] init];
    [alert alertContent:CGSizeMake(kBeautyAlertViewWidth, kBeautyAlertViewHeight) AlertType:alertType alertString:tip clickCall:operation];
}

@end
