//
//  VHSignInAlertView.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/22.
//

#import "VHInavAlertView.h"

@protocol VHSignInAlertViewDelegate <NSObject>

/// 收到主持人发起签到消息
- (void)startSign;

@end

@interface VHSignInAlertView : VHInavAlertView

/// 代理对象
@property (nonatomic, weak) id <VHSignInAlertViewDelegate> delegate;

/// 初始化
/// - Parameter frame: frame
/// - Parameter obj: 播放器
- (instancetype)initSignWithFrame:(CGRect)frame obj:(NSObject *)obj webinarInfoData:(VHWebinarInfoData *)webinarInfoData;

@end

