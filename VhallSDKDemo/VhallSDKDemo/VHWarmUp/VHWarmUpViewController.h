//
//  WarmUpViewController.h
//  UIModel
//
//  Created by 郭超 on 2022/10/25.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VHBaseViewController.h"

@protocol VHWarmUpViewControllerDelegate <NSObject>

/// 直播开始
- (void)enterRoom;

@end
@interface VHWarmUpViewController : VHBaseViewController

/// 代理
@property (nonatomic, weak) id <VHWarmUpViewControllerDelegate> delegate;

/// 活动详情
@property (nonatomic, strong) VHWebinarInfoData * webinarInfoData;

@end
