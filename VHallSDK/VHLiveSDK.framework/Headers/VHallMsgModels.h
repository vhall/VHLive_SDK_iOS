//
//  VHallMsgModels.h
//  VHallSDK
//
//  Created by Ming on 16/8/25.
//  Copyright © 2016年 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  聊天消息
 */
typedef NS_ENUM(NSInteger, ChatMsgType) {
    ChatMsgTypeText  = 0,    // 文本
    ChatMsgTypeImage = 1,    // 图片
    ChatMsgTypeLink  = 2,    // 链接
    ChatMsgTypeVideo = 3,    // 视频
    ChatMsgTypeVoice = 4,    // 音频
};
/*
   自定义消息通道
 **/
typedef NS_ENUM(NSInteger, ChatCustomType) {
    ChatCustomType_EditRole = 1,//支持修改角色
};

@interface VHallMsgModels : NSObject

@property (nonatomic, strong) id context;                           ///<附加消息
@property (nonatomic, strong) id data;                              ///<源数据
@property (nonatomic, assign) ChatCustomType eventType;             ///<自定义消息通道事件
@property (nonatomic, assign) BOOL privateMsg;                      ///<YES=私聊(含target_id)，NO=非私聊
@property (nonatomic, assign) NSInteger role_name;                  ///<用户类型 1:主持人 2：观众  3：助理 4：嘉宾
@property (nonatomic, assign) NSInteger pv;                         ///<频道在线连接数
@property (nonatomic, assign) NSInteger uv;                         ///<频道在线用户数
@property (nonatomic, assign) NSInteger bu;                         ///<频道业务单元
@property (nonatomic, copy) NSString *target_id;                    ///<消息接收方id (私聊的时候才有值)
@property (nonatomic, copy) NSString *join_id;                      ///<加入用户的id (消息中的 third_party_user_id用户唯一id)
@property (nonatomic, copy) NSString *account_id;                   ///<用户ID
@property (nonatomic, copy) NSString *user_name;                    ///<参会时的昵称
@property (nonatomic, copy) NSString *nick_name;                    ///<参会时的昵称
@property (nonatomic, copy) NSString *avatar;                       ///<头像url，如果没有则为空字符串
@property (nonatomic, copy) NSString *room;                         ///<房间号，即活动id
@property (nonatomic, copy) NSString *time;                         ///<发送时间，根据服务器时间确定
@property (nonatomic, copy) NSString *client;                       ///<消息来源
@property (nonatomic, copy) NSString *msg_id;                       ///<消息id
@property (nonatomic, copy) NSString *edit_role_type;               ///<编辑的角色修改的角色 1，2，3，4
@property (nonatomic, copy) NSString *edit_role_name;               ///<角色名称
@property (nonatomic, copy) NSString *role;                         ///<用户类型 host:主持人 guest：嘉宾 assistant：助理 user：观众

@end

//上下线消息
@interface VHallOnlineStateModel : VHallMsgModels
@property (nonatomic, assign) BOOL is_gag;                          ///<是否禁言
@property (nonatomic, assign) NSInteger device_status;              ///<设备状态
@property (nonatomic, assign) NSInteger device_type;                ///<设备类型
@property (nonatomic, copy) NSString *event;                        ///<online：上线消息  offline：下线消息
@property (nonatomic, copy) NSString *concurrent_user;              ///<房间内当前用户数uv
@property (nonatomic, copy) NSString *attend_count;                 ///<参会人数pv
@property (nonatomic, copy) NSString *tracksNum;                    ///<PV
@end


//聊天消息
@interface VHallChatModel : VHallMsgModels
@property (nonatomic, strong) VHallChatModel *replyMsg;             ///<回复消息，若无回复消息返回nil
@property (nonatomic, assign) ChatMsgType type;                     ///<聊天消息类型
@property (nonatomic, copy) NSArray *atList;                        ///<@用户列表，若无@用户返回nil
@property (nonatomic, copy) NSArray *imageUrls;                     ///<图片消息url列表
@property (nonatomic, copy) NSString *text;                         ///<聊天消息

@end

//自定义消息
@interface VHallCustomMsgModel : VHallMsgModels
@property (nonatomic, copy) NSString *jsonstr;                      ///<自定义消息，如果没有则为空字符串
@end

//历史评论
@interface VHCommentModel : VHallMsgModels
@property (nonatomic, copy) NSString *text;                         ///<评论内容
@property (nonatomic, copy) NSString *commentId;                    ///<评论ID
@property (nonatomic, copy) NSArray *imageUrls;                     ///<图片消息url列表
@property (nonatomic, copy) NSArray *atList;                        ///<@人列表
@property (nonatomic, strong) VHallChatModel *replyMsg;             ///<回复消息

@end
