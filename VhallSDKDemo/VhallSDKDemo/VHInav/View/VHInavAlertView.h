//
//  VHInavAlertView.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/20.
//

#import <UIKit/UIKit.h>

@interface VHInavAlertView : UIView

/// 容器
@property (nonatomic, strong) UIView * contentView;

/// 初始化
- (instancetype)initWithFrame:(CGRect)frame;

/// 显示
- (void)show;

/// 隐藏
- (void)disMissContentView;

@end
