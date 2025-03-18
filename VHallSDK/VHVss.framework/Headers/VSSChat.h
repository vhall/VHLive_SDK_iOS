//
//  VSSChat.h
//  VSSDemo
//
//  Created by vhall on 2019/7/4.
//  Copyright © 2019 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <VHCore/VHMessage.h>

NS_ASSUME_NONNULL_BEGIN

//消息类型
typedef NS_ENUM(NSInteger,VSSChatMsgType) {
    VSSChatMsgType_text = 0,            //文本聊天消息
    VSSChatMsgType_image = 1,           //图片消息
    VSSChatMsgType_link = 2,            //url链接
    VSSChatMsgType_video = 3,           //视频
    VSSChatMsgType_voice = 4,           //语音
    VSSChatMsgType_permit_all = 5,      //取消全员禁言
    VSSChatMsgType_disable_all = 6,     //全员禁言
    VSSChatMsgType_disable = 7,         //主播禁言某用户
    VSSChatMsgType_permit = 8,          //主播取消某用户的禁言
    VSSChatMsgType_room_kickout = 9,          //某用户被踢出
    VSSChatMsgType_room_kickout_cancel = 10,   //某用户被取消踢出
    VSSChatMsgType_room_director_stream = 11,
    // 云导播房间流状态
    VSSChatMsgType_room_live_start = 29,   //开始直播
    VSSChatMsgType_room_live_over = 30,   //结束直播
};

//上下线消息类型
typedef NS_ENUM(NSInteger,VSSChatOnlineMsgType) {
    VSSChatOnlineMsgType_Unkonw,    //无
    VSSChatOnlineMsgType_Leave,     //下线消息
    VSSChatOnlineMsgType_Join,      //上线消息
};

@protocol VSSChatDelegate <NSObject>

@optional
///上下线消息回调
- (void)onlineMessage:(VHMessage *)message type:(VSSChatOnlineMsgType)type;
///聊天消息回调 （type 0-4）
- (void)chatMessage:(VHMessage *)message type:(VSSChatMsgType)type;
///禁言/取消禁言、踢出消息回调 （type 5-9）
- (void)otherMessage:(VHMessage *)message type:(VSSChatMsgType)type targetIsMyself:(BOOL)targetIsMyself;
///自定义消息回调
- (void)customMessage:(VHMessage *)message;
@end

@interface VSSChat : NSObject

@property (nonatomic, weak) id <VSSChatDelegate> delegate;

///是否开启了全体禁言
@property (nonatomic, assign) BOOL allBan;

///自己是否被禁言
@property (nonatomic, assign) BOOL banChat;

///踢出/取消踢出用户  status：1踢出 0取消踢出  account_id：被操作的用户id
+ (void)setKickedToStatus:(NSString *)status
               account_id:(NSString *)account_id
                   success:(void(^)(NSDictionary *responseObject))successBlock
                  failure:(void(^)(NSError *error))failureBlock;
///禁言/取消禁言用户  status：1禁言 0取消禁言  account_id：被操作的用户id
+ (void)setBannedToStatus:(NSString *)status
               account_id:(NSString *)account_id
                   success:(void(^)(NSDictionary *responseObject))successBlock
                  failure:(void(^)(NSError *error))failureBlock;
///获取当前在线用户列表用户列表.  isLastPage:是否为最后一页数据
+ (void)getOnlineListPage:(NSInteger)page
                 pageSize:(NSInteger)pageSize
                 nickname:(NSString *)nickname
                   success:(void(^)(NSDictionary *_Nonnull responseObject , BOOL isLastPage))successBlock
                  failure:(void(^)(NSError *_Nonnull error))failureBlock;
///获取踢出用户列表.
+ (void)getKickedListPage:(NSInteger)page
                 pageSize:(NSInteger)pageSize
                   success:(void(^)(NSDictionary *responseObject))successBlock
                  failure:(void(^)(NSError *error))failureBlock;
///获取当前禁言用户列表.
+ (void)getBannedListPage:(NSInteger)page
                 pageSize:(NSInteger)pageSize
                   success:(void(^)(NSDictionary *responseObject))successBlock
                  failure:(void(^)(NSError *error))failureBlock;
///发送文本消息
- (void)sendMessage:(NSString *)message completed:(void (^)(NSError *error))completed;

///发送自定义消息
- (void)sendCustomMsg:(NSString *)message
               success:(void(^)(NSDictionary *responseObject))successBlock
              failure:(void(^)(NSError *error))failureBlock;

///发送图片
- (void)sendImage:(UIImage *)image
         progress:(nullable void (^)(NSProgress * progress))progressBlock
           success:(void(^)(NSDictionary *responseObject))successBlock
          failure:(void(^)(NSError *error))failureBlock;

///发送图片
- (void)sendImagesMessage:(NSArray *)images text:(NSString *)text completed:(void (^)(NSError *error))completed;

/////获取聊天记录
//- (void)getChatMsgWithPageNum:(NSUInteger)page
//                     pageSize:(NSUInteger)size
//                    startTime:(NSString *)time
//                   completion:(void(^)(NSArray <VHMessage*> *result))msgArray
//                       failed:(void(^)(NSError *error))failed;

///获取SaaS 聊天记录
- (void)getSaaSChatMsgWithPageNum:(NSUInteger)page
                         pageSize:(NSUInteger)size
                        startTime:(NSString *)time
                       completion:(void(^)(NSArray <VHMessage*> *result))msgArray
                           failed:(void(^)(NSError *error))failed;

@end

NS_ASSUME_NONNULL_END
