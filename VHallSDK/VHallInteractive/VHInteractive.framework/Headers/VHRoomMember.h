//
//  VHRoomMember.h
//  VHallInteractive
//
//  Created by 郭超 on 2022/8/31.
//  Copyright © 2022 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VHLiveSDK/VHallConst.h>
@interface VHRoomMember : NSObject

@property (nonatomic, assign) VHRoomRoleNameType role_name;         ///<角色  1主持人 2观众 3助理 4嘉宾
@property (nonatomic, copy) NSString *account_id;                   ///<用户id
@property (nonatomic, copy) NSString *join_id;                      ///<参会id
@property (nonatomic, copy) NSString *avatar;                       ///<头像
@property (nonatomic, copy) NSString *nickname;                     ///<昵称
@property (nonatomic, assign) NSInteger is_speak;                   ///<是否上麦中 1：上麦中 其他：未上麦
@property (nonatomic, assign) NSInteger device_type;                ///<设备类型 0未知 1手机端 2PC 3SDK
@property (nonatomic, assign) NSInteger device_status;              ///<设备检测状态 0:未检测 1:可以上麦 2:不可以上麦
@property (nonatomic, assign) BOOL is_banned;                       ///<是否被禁言
@property (nonatomic, assign) BOOL is_kicked;                       ///<是否被踢出
///
@end
