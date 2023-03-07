//
//  VHAuthAlertView.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/2/22.
//

#import <UIKit/UIKit.h>
#import "VHInavAlertView.h"

@protocol VHAuthAlertViewDelegate <NSObject>

/// 填写的回调
/// - Parameter verifyValue: 验证权限的值
- (void)changeTextWithVerifyValue:(NSString *)verifyValue;

@end

@interface VHAuthAlertView : VHInavAlertView

/// 代理
@property (nonatomic, weak) id <VHAuthAlertViewDelegate> delegate;

/// 显示弹窗
/// - Parameter type: 密码/白名单
- (void)showAuthWithType:(NSString *)type;

@end
