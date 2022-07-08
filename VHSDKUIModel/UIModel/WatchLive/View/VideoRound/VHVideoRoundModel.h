//
//  VHVideoRoundModel.h
//  UIModel
//
//  Created by 郭超 on 2022/6/21.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VHVideoRoundModel : NSObject

/// 校验用户id轮询
- (void)videoRoundUsers:(NSArray *)uids roomId:(NSString *)roomId;

/// 开始轮询
- (void)startVideoRoundRoomId:(NSString *)roomId;

/// 关闭轮询
- (void)closeVideoRound;

/// 轮询列表
- (void)getRoundUsers;

@end
