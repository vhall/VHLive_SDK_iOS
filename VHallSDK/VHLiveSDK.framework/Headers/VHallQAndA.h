//
//  VHallQAndA.h
//  VHallSDK
//
//  Created by Ming on 16/8/23.
//  Copyright © 2016年 vhall. All rights reserved.
//
// 问答
// !!!!:注意实例方法使用时机，看直播/回放————>在收到"播放连接成功回调"或"视频信息预加载成功回调"以后使用。

#import <Foundation/Foundation.h>
#import "VHallBasePlugin.h"
#import "VHallMsgModels.h"

@class VHallQAndA;

/// 提问消息
@interface VHallQuestionModel : NSObject
@property (nonatomic, copy) NSString *type;                      ///<类型 question：提问 answer：回答
@property (nonatomic, copy) NSString *question_id;      ///<问题ID
@property (nonatomic, copy) NSString *content;                   ///<提问/回答内容
@property (nonatomic, copy) NSString *join_id;                   ///<参会id
@property (nonatomic, copy) NSString *created_at;       ///<提问/回答时间 (mm:ss)
@property (nonatomic, copy) NSString *nick_name;        ///<昵称
@property (nonatomic, copy) NSString *avatar;                    ///<头像
@property (nonatomic, copy) NSString *created_time;     ///<提问/回答时间 (yyyy-MM-dd HH:mm:ss)，新版v3控制台创建的活动才有此值
@property (nonatomic, assign) BOOL isHaveAnswer;                 ///<是否有答案
@end

/// 回答消息
@interface VHallAnswerModel : VHallQuestionModel
@property (nonatomic, copy) NSString *answer_id;        ///<回答ID
@property (nonatomic, copy) NSString *role_name;        ///<回答人角色 host：主持人 guest：嘉宾 assistant：助手 user：观众答
@property (nonatomic, assign) BOOL is_open;                      ///<是否公开回答
@end

/// 问答消息
@interface VHallQAModel : VHallMsgModels
@property (nonatomic, strong) VHallQuestionModel *questionModel; ///<问题
@property (nonatomic, strong) NSMutableArray<VHallAnswerModel *> *answerModels;     ///<答案
@end

@protocol VHallQAndADelegate <NSObject>
@optional
/// 主播开启问答
- (void)vhallQAndADidOpened:(VHallQAndA *)QA;
/// 主播关闭问答
- (void)vhallQAndADidClosed:(VHallQAndA *)QA;
/// 问答消息
/// @param msgs 问答消息
- (void)reciveQAMsg:(NSArray <VHallQAModel *> *)msgs;

@end

@interface VHallQAndA : VHallBasePlugin

@property (nonatomic, weak) id <VHallQAndADelegate> delegate;

/// 是否开启问答
@property (nonatomic, assign, readonly) BOOL isOpen;

/// 问答名称
@property (nonatomic, assign, readonly) NSString *question_name;

/// 发送提问 （在收到播放器"播放连接成功回调"或"视频信息预加载成功回调"以后使用）
/// @param msg 提问内容
/// @param success 成功回调
/// @param reslutFailedCallback 失败回调，参数字典结构：{code：错误码，content：错误信息}
- (void)sendMsg:(NSString *)msg
        success:(void (^)(void))success
         failed:(void (^)(NSDictionary *failedData))reslutFailedCallback;


/// 获取问答历史记录 （在收到播放器"播放连接成功回调"或"视频信息预加载成功回调"以后使用）
/// @param showAll 保留字段（暂时无用）
/// @param success 成功回调
/// @param reslutFailedCallback 失败回调，参数字典结构：{code：错误码，content：错误信息}
- (void)getQAndAHistoryWithType:(BOOL)showAll
                        success:(void (^)(NSArray <VHallQAModel *> *msgs))success
                         failed:(void (^)(NSDictionary *failedData))reslutFailedCallback;
@end
