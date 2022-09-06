//
//  VHWatchLiveTimerView.h
//  UIModel
//
//  Created by 郭超 on 2022/7/22.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VHWatchLiveTimerView : UIView

/// 展示计时器
- (void)showTimerView:(NSInteger)duration is_timeout:(BOOL)is_timeout;

/// 关闭计时器
- (void)dismiss;

/// 显示计时器
- (void)isShowView;

/// 暂停
- (void)timerPause;

/// 恢复
- (void)timerResume:(NSInteger)duration is_timeout:(BOOL)is_timeout;

@end

NS_ASSUME_NONNULL_END
