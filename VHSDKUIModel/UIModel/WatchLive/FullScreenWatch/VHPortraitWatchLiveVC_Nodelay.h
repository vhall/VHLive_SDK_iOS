//
//  VHPortraitWatchLiveVC_Nodelay.h
//  UIModel
//
//  Created by xiongchao on 2021/11/2.
//  Copyright © 2021 www.vhall.com. All rights reserved.
//

#import "VHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface VHPortraitWatchLiveVC_Nodelay : VHBaseViewController
/// 活动id
@property(nonatomic,copy)NSString * roomId;
/// 活动观看密码
@property(nonatomic,copy)NSString * kValue;
@property(nonatomic,copy)NSString * k_id;   //活动维度下k值的唯一ID

/// 互动美颜开关
@property (nonatomic, assign) BOOL interactBeautifyEnable;
@end

NS_ASSUME_NONNULL_END
