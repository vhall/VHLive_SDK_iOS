//
//  VHInavApplyAlertView.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/20.
//

#import "VHInavAlertView.h"

@protocol VHInavApplyAlertViewDelegate <NSObject>

/// 申请连麦成功
- (void)applyInavSuccessful;

@end

@interface VHInavApplyAlertView : VHInavAlertView

/// 代理对象
@property (nonatomic, weak) id <VHInavApplyAlertViewDelegate> delegate;

/// 播放器
@property (nonatomic, strong) VHallMoviePlayer *moviePlayer;

/// 停止并收起弹窗
- (void)stopOrDismiss;

@end
