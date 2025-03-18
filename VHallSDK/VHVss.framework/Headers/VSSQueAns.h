//
//  VSSQueAns.h
//  VHallSDK
//
//  Created by vhall on 2019/7/5.
//  Copyright © 2019 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,VSSQueAnsEventType) {
    VSSQueAnsEventType_unkown,
    VSSQueAnsEventType_question_answer_open,        //主播打开问答
    VSSQueAnsEventType_question_answer_close,       //主播关闭问答
    VSSQueAnsEventType_question_answer_create,      //收到问答消息
    VSSQueAnsEventType_question_answer_commit,      //收到主播回答
};

//回答人信息
@interface VSSAnswerInfo : NSObject
@property (nonatomic, copy) NSString *join_id;   //参会id
@property (nonatomic, copy) NSString *ansId;    //回答id
@property (nonatomic, copy) NSString *creatTime; //回答时间
@property (nonatomic, copy) NSString *content;  //回答内容
@property (nonatomic, copy) NSString *avatar;   //回答者头像
@property (nonatomic, copy) NSString *nick_name; //回答者昵称
@property (nonatomic, copy) NSString *role_name; //回答者角色
@property (nonatomic, copy) NSString *isOpen;   //是否公开答案

@end



@interface VSSQueAnsInfo : NSObject
@property (nonatomic, copy) NSString *join_id;   ///<参会id
@property (nonatomic, copy) NSString *QAId;     //问题id
@property (nonatomic, copy) NSString *creatTime; //提问时间
@property (nonatomic, copy) NSString *content; //提问内容
@property (nonatomic, copy) NSString *avatar; //提问人头像
@property (nonatomic, copy) NSString *nick_name; //提问人昵称

@property (nonatomic, copy) NSString *sender_id;        //消息发送人id
@property (nonatomic, copy) NSString *sender_nickname; //消息发送人昵称

@property (nonatomic, strong) VSSAnswerInfo *answer;

@end


@protocol VSSQueAnsDelegate <NSObject>

@optional
- (void)VSSQueAnsDidReceviedMsg:(VSSQueAnsInfo *)info msgType:(VSSQueAnsEventType)type;


@end


///问答
@interface VSSQueAns : NSObject

@property (nonatomic, weak) id <VSSQueAnsDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
