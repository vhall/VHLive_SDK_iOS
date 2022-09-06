//
//  VHallRehearsalObject.h
//  VHallSDK
//
//  Created by 郭超 on 2022/8/25.
//  Copyright © 2022 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VHallBasePlugin.h"

NS_ASSUME_NONNULL_BEGIN

@protocol VHallRehearsalObjectDelegate <NSObject>

/// 开始彩排
- (void)didToStartRehearsal;

/// 结束彩排
- (void)didToStopRehearsal;

@end


@interface VHallRehearsalObject : VHallBasePlugin

@property (nonatomic, weak) id <VHallRehearsalObjectDelegate> delegate; ///<代理

@end

NS_ASSUME_NONNULL_END
