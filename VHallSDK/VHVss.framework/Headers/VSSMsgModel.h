//
//  VSSMsgModel.h
//  VHVSS
//
//  Created by vhall on 2019/9/17.
//  Copyright © 2019 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VHCore/VHMessage.h>

NS_ASSUME_NONNULL_BEGIN

//1主持人 2观众 3助理 4嘉宾
typedef NS_ENUM(NSInteger,VSSUserRole) {
    VSSUserRole_Unkown,
    VSSUserRole_Host,
    VSSUserRole_User,
    VSSUserRole_Assistant,
    VSSUserRole_Guest,
};

@interface VSSMsgModel : NSObject

//@property (nonatomic, copy) NSString *senderId;//发送者ID（暂无）
//@property (nonatomic, copy, nullable) NSString *senderName;//发送者昵称（暂无）

@property (nonatomic, strong) VHMessage *msg;  

@property (nonatomic) VSSUserRole userRole;                     //消息事件所对应的目标用户角色
@property (nonatomic, copy) NSString *targetId;                 //消息事件所对应的目标用户ID
@property (nonatomic, copy) NSString *targetName;     //消息事件所对应的目标用户昵称

@property (nonatomic, copy) NSString *hostId;   //房主id

@property (nonatomic,assign) BOOL targetIsMyself;  //是否是针对自己的消息（消息事件所对应的目标用户是否为自己）


- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithMsg:(VHMessage *)msg;

@end

NS_ASSUME_NONNULL_END
