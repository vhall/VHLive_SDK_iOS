//
//  VSSQuestionnaire.h
//  VSSDemo
//
//  Created by vhall on 2019/7/1.
//  Copyright © 2019 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger,VSSQuestionMsgType){
    VSSQuestionMsgType_questionnaire_push, //问卷发送
    VSSQuestionMsgType_questionnaire_repush, //问卷推屏
};



NS_ASSUME_NONNULL_BEGIN

@interface VSSQuestion : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *imageUrlString;
@property (nonatomic, assign) BOOL isPublic;
@property (nonatomic, copy) NSString *questionId;
@property (nonatomic, copy) NSString *releaseTime;
@property (nonatomic, assign) VSSQuestionMsgType msgType;

@end

///VSS问卷
@class VSSQuestionnaire;

@protocol VSSQuestionnaireDelegate <NSObject>

@optional
//收到问卷推送消息的回调
- (void)questionnaire:(VSSQuestionnaire *)questionnaire didReceivedQuestion:(VSSQuestion *)question;

@end




///问卷
@interface VSSQuestionnaire : NSObject

@property (nonatomic, weak) id <VSSQuestionnaireDelegate> delegate;

//创建问卷
- (void)creatWithJoinId:(NSString *)joinId
               question:(VSSQuestion *)question
                success:(void (^)(NSDictionary *response))success
                failure:(void (^)(NSError *error))failure;


//获取问卷列表 isPublic是否公共文档，1是0否
- (void)requestQuestionListWithHostId:(NSString *)hostId
                                 page:(NSUInteger)page
                             pageSize:(NSUInteger)pageSize
                             keywords:(nullable NSString *)keywords
                             isPublic:(BOOL)isPublic
                              success:(void (^)(NSDictionary *response))success
                              failure:(void (^)(NSError *error))failure;

//发布问卷
- (void)publishWithJoinId:(NSString *)joinId
               questionId:(NSString *)questionId
                  success:(void (^)(NSDictionary *response))success
                  failure:(void (^)(NSError *error))failure;


//取消发布问卷
- (void)cancelPublicQWithJoinId:(NSString *)joinId
                     questionId:(NSString *)questionId
                        success:(void (^)(NSDictionary *response))success
                        failure:(void (^)(NSError *error))failure;

//获取统计列表
- (void)requestStatisticsListWithJoinId:(NSString *)joinId
                                   page:(NSUInteger)page
                               pageSize:(NSUInteger)pageSize
                                success:(void (^)(NSDictionary *response))success
                                failure:(void (^)(NSError *error))failure;

//更新问卷
- (void)questoinUpdateWithJoinId:(NSString *)joinId
                      questionId:(NSString *)questionId
                        question:(VSSQuestion *)question
                         success:(void (^)(NSDictionary *response))success
                         failure:(void (^)(NSError *error))failure;

///观看端Api

//获取问卷列表
- (void)requestQuestionListWithJoinId:(NSString *)joinId
                                 page:(NSUInteger)page
                             pageSize:(NSUInteger)pageSize
                             keywords:(nullable NSString *)keywords
                              success:(void (^)(NSDictionary * _Nonnull))success
                              failure:(void (^)(NSError * _Nonnull))failure;

//提交答案
- (void)submitWithQuestionId:(NSString *)questionId
                    answerId:(NSString *)answerId
                      extend:(nullable NSString *)extend
                     success:(void (^)(NSDictionary *response))success
                     failure:(void (^)(NSError *error))failure;


@end

NS_ASSUME_NONNULL_END
