//
//  VHPushScreenCardAlert.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/7/4.
//

#import "VHInavAlertView.h"

@interface VHPushScreenCardAlert : VHInavAlertView

/// 显示弹窗
/// - Parameter model: 推屏卡片数据
/// - Parameter isChat: 是否是消息通知(如果是消息通知就不用拉详情接口了)
- (void)showPushScreenCard:(VHPushScreenCardItem *)model isChat:(BOOL)isChat;

/// 隐藏
- (void)dismiss;

@end
