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
/// - Parameters:
///   - uids: 用户id列表
///   - webinar_id: 活动id
///   - pass_room_id: 房间id
- (void)videoRoundUsers:(NSArray *)uids webinar_id:(NSString *)webinar_id pass_room_id:(NSString *)pass_room_id;

/// 开始轮询
/// - Parameter webinar_id: 活动id
- (void)startVideoRound:(NSString *)webinar_id pass_room_id:(NSString *)pass_room_id;

/// 关闭轮询
- (void)closeVideoRound;

/// 轮询列表
/// - Parameters:
///   - webinar_id: 活动id
///   - pass_room_id: 房间id
- (void)getRoundUsers:(NSString *)webinar_id pass_room_id:(NSString *)pass_room_id;

@end
