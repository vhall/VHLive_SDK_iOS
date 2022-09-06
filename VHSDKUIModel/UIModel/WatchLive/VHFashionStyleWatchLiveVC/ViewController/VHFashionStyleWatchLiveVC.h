//
//  VHFashionStyleWatchLiveVC.h
//  UIModel
//
//  Created by 郭超 on 2022/7/21.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface VHFashionStyleWatchLiveVC : VHBaseViewController
/// 活动id
@property(nonatomic,copy)NSString * roomId;
/// 活动观看密码
@property(nonatomic,copy)NSString * kValue;
/// 互动美颜开关
@property (nonatomic, assign) BOOL interactBeautifyEnable;

@end

NS_ASSUME_NONNULL_END
