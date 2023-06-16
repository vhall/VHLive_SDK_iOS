//
//  VHallChat.h
//  VHallSDK
//
//  Created by Ming on 16/8/23.
//  Copyright © 2016年 vhall. All rights reserved.
//
//聊天
// !!!!:注意实例方法使用时机，发直播————>在收到"直播连接成功回调"以后使用；看直播/回放————>在收到"播放连接成功回调"或"视频信息预加载成功回调"以后使用。

#import <Foundation/Foundation.h>
#import "VHallBasePlugin.h"
@class VHallChatModel;
@class VHallOnlineStateModel;
@class VHallCustomMsgModel;
@class VHallGiftModel;

@protocol VHallChatDelegate <NSObject>
@optional

/// 收到上下线消息
/// @param msgs 消息详情
- (void)reciveOnlineMsg:(NSArray <VHallOnlineStateModel *> *)msgs;

/// 收到聊天消息
/// @param msgs msgs 消息详情
- (void)reciveChatMsg:(NSArray <VHallChatModel *> *)msgs;

/// 收到自定义消息
/// @param msgs msgs 消息详情
- (void)reciveCustomMsg:(NSArray <VHallCustomMsgModel *> *)msgs;

/// 删除消息
/// @param msgId 消息id
- (void)deleteChatMsgId:(NSString *)msgId;

/// 收到自己被禁言/取消禁言
/// @param forbidChat YES:禁言 NO:取消禁言
- (void)forbidChat:(BOOL)forbidChat;

/// 收到全体禁言/取消全体禁言
/// @param allForbidChat YES:禁言 NO:取消禁言
- (void)allForbidChat:(BOOL)allForbidChat;

/// 收到虚拟人数消息
/// @param update_online_num 增加的虚拟在线人数
/// @param update_pv 增加的虚拟热度
- (void)vhBaseNumUpdateToUpdate_online_num:(NSInteger)update_online_num
                                 update_pv:(NSInteger)update_pv;

/// 云导播房间流状态
/// @param haveStream 是否有流
- (void)directorStream:(BOOL)haveStream;

/// 是否开启了问答禁言
/// @param isQaStatus YES:开启 NO:未开启
- (void)isQaStatus:(BOOL)isQaStatus;

/// 轮巡开始
- (void)videoRoundStart;

/// 轮巡结束
- (void)videoRoundEnd;

/// 轮巡列表
/// @param uids 需要轮巡用的列表
- (void)videoRoundUsers:(NSArray *)uids;

@end

@interface VHallChat : VHallBasePlugin

@property (nonatomic, weak) id <VHallChatDelegate> delegate;

/// 是否被禁言（YES：自己被禁言或全体被禁言，NO：自己未被禁言且全体未被禁言）
@property (nonatomic, assign, readonly) BOOL isSpeakBlocked;

/// 是否被禁言
@property (nonatomic, assign, readonly) BOOL isMeSpeakBlocked;

/// 是否全体被禁言
@property (nonatomic, assign, readonly) BOOL isAllSpeakBlocked;

/// 是否开启了问答禁言 YES 开启 NO 未开启
@property (nonatomic, assign, readonly) BOOL isQaStatus;

/// 发送聊天内容
/// @param msg 消息内容
/// @param success 成功回调
/// @param reslutFailedCallback 失败回调 字典结构：{code：错误码，content：错误信息}
- (void)sendMsg:(NSString *)msg
        success:(void (^)(void))success
         failed:(void (^)(NSDictionary *failedData))reslutFailedCallback;

/// 发送自定义消息
/// @param jsonStr 消息内容
/// @param success 成功回调
/// @param reslutFailedCallback 失败回调 字典结构：{code：错误码，content：错误信息}
- (void)sendCustomMsg:(NSString *)jsonStr
              success:(void (^)(void))success
               failed:(void (^)(NSDictionary *failedData))reslutFailedCallback;

/// 获取100条聊天历史记录，返回至多100条数据，最新消息在数组最后一位
/// @param showAll NO 只获取本次直播产生的聊天记录，YES 获取包含以前开播产生的聊天记录 （H5活动该参数无效，默认YES）
/// @param success 成功回调 返回聊天历史记录
/// @param reslutFailedCallback 失败回调 字典结构：{code：错误码，content：错误信息}
- (void)getHistoryWithType:(BOOL)showAll
                   success:(void (^)(NSArray <VHallChatModel *> *msgs))success
                    failed:(void (^)(NSDictionary *failedData))reslutFailedCallback;

/// 分页获取聊天历史记录，最新消息在数组最后一位（仅支持H5活动，Flash活动若使用该方法效果同上：getHistoryWithType:YES） (v5.0新增)
/// @param page_num 当前页码数，第一页从1开始
/// @param page_size 每页的数据个数
/// @param start_time 查询该时间至今的所有聊天记录，若不指定时间可传nil。格式如：@"2020-01-01 12:00:00"
/// @param success 成功回调 msgs：聊天历史记录
/// @param reslutFailedCallback 失败回调 字典结构：{code：错误码，content：错误信息}
- (void)getHistoryWithPage_num:(NSInteger)page_num
                     page_size:(NSInteger)page_size
                    start_time:(NSString *)start_time
                       success:(void (^)(NSArray <VHallChatModel *> *msgs))success
                        failed:(void (^)(NSDictionary *failedData))reslutFailedCallback;

/// 获取当前房间聊天列表（仅支持化蝶） (v6.4.1新增)
/// @param msg_id 聊天记录 锚点消息id,此参数存在时anchor_path 参数必须存在
/// @param page_num 当前页码数，第一页从1开始
/// @param page_size 获取条目数量
/// @param start_time 间至今的所有聊天记录，若不指定时间可传nil。格式如：@"2020-01-01 12:00:00"
/// @param is_role 0：不筛选主办方 1：筛选主办方 默认是0
/// @param anchor_path 锚点方向，up 向上查找，down 向下查找,此参数存在时 msg_id 参数必须存在,默认down
/// @param success 成功回调 msgs：聊天历史记录
/// @param reslutFailedCallback 失败回调 字典结构：{code：错误码，content：错误信息}
- (void)getInteractsChatGetListWithMsg_id:(NSString *)msg_id
                                 page_num:(NSInteger)page_num
                                page_size:(NSInteger)page_size
                               start_time:(NSString *)start_time
                                  is_role:(NSInteger)is_role
                              anchor_path:(NSString *)anchor_path
                                  success:(void (^)(NSArray <VHallChatModel *> *msgs))success
                                   failed:(void (^)(NSDictionary *failedData))reslutFailedCallback;

@end
