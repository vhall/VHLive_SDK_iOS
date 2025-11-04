//
//  VHExamObject.h
//  VHLiveSDK
//
//  Created by 郭超 on 2022/11/17.
//  Copyright © 2022 vhall. All rights reserved.
//

#import "VHallBasePlugin.h"
#import "VHallRawBaseModel.h"
#import "VHMessage.h"

// 答题前置条件检查
@interface VHExamUserFormCheckModel : VHallRawBaseModel
@property (nonatomic, assign) BOOL is_answer;       ///<是否已答题 0.否 1.是
@property (nonatomic, assign) BOOL is_fill;         ///<是否需要填写表单 0.否 1.是
@end

// 初始化用户表单
@interface VHExamGetUserFormInfoModel : VHallRawBaseModel
@property (nonatomic, copy) NSString *form_data;    ///<表单信息
@property (nonatomic, copy) NSString *title;        ///<试卷标题
@property (nonatomic, copy) NSString *user_info;    ///<用户填写信息
@property (nonatomic, copy) NSString *guidelines;   ///<答题须知
@property (nonatomic, copy) NSString *extension;    ///<拓展
@end

// 发送验证码
@interface VHExamSendVerifyCodeModel : VHallRawBaseModel
@property (nonatomic, assign) BOOL status;          ///<1成功/0失败
@end

// 验证手机验证码
@interface VHExamVerifyCodeModel : VHallRawBaseModel
@property (nonatomic, assign) BOOL status;          ///<1成功/0失败
@end

// 试卷列表
@interface VHExamGetPushedPaperListModel : VHallRawBaseModel
@property (nonatomic, copy) NSString *paper_id;                 ///<试卷id
@property (nonatomic, copy) NSString *title;                    ///<试卷标题
@property (nonatomic, copy) NSString *push_time;                ///<推送时间
@property (nonatomic, assign) BOOL limit_time_switch;           ///<限时开关
@property (nonatomic, assign) BOOL status;                      ///<是否作答 0.否 1.是
@property (nonatomic, assign) BOOL is_end;                      ///<答题是否结束 0.否 1.是
@property (nonatomic, assign) CGFloat right_rate;               ///<正确率
@property (nonatomic, assign) NSInteger limit_time;             ///<限时
@property (nonatomic, assign) NSInteger total_score;            ///<试卷总分
@property (nonatomic, assign) NSInteger question_num;           ///<题目数
@property (nonatomic, strong) NSURL *paperUrl;                  ///<试卷观看地址
@end

// 试卷详情
@interface VHExamGetPaperInfoForWatchModel : VHallRawBaseModel
@property (nonatomic, copy) NSString *title;                    ///<试卷标题
@property (nonatomic, copy) NSString *push_time;                ///<推送时间
@property (nonatomic, copy) NSString *question_detail;          ///<详情
@property (nonatomic, assign) BOOL limit_time_switch;           ///<限时开关
@property (nonatomic, assign) NSInteger limit_time;             ///<限时
@end

// 断点续答
@interface VHExamGetUserAnswerPaperHistoryModel : VHallRawBaseModel
@property (nonatomic, copy) NSString *question_id;              ///<题目id
@property (nonatomic, copy) NSString *answer;                   ///<答案
@end

// 榜单信息
@interface VHExamGetSimpleRankListModel : VHallRawBaseModel
@property (nonatomic, copy) NSString *name;                     ///<用户名
@property (nonatomic, copy) NSString *head_img;                 ///<头像
@property (nonatomic, copy) NSString *score;                    ///<得分
@property (nonatomic, copy) NSString *rank_no;                  ///<排名
@property (nonatomic, copy) NSString *right_rate;               ///<正确率
@property (nonatomic, copy) NSString *account_id;               ///<参会id
@property (nonatomic, assign) BOOL status;                      ///<是否有效 0.否 1.是
@property (nonatomic, assign) BOOL is_initiative;               ///<是否主动交卷 0.否 1.是
@property (nonatomic, assign) NSInteger use_time;               ///<用时 秒
@end

// 个人成绩
@interface VHExamPersonScoreInfoModel : VHallRawBaseModel
@property (nonatomic, copy) NSString *account_id;               ///<账户id
@property (nonatomic, copy) NSString *title;                    ///<试卷标题
@property (nonatomic, copy) NSString *user_info;                ///<用户填写信息
@property (nonatomic, copy) NSString *head_img;                 ///<头像地址
@property (nonatomic, copy) NSString *user_form;                ///<表单信息
@property (nonatomic, copy) NSString *question_detail;          ///<用户答题数据
@property (nonatomic, assign) BOOL is_initiative;               ///<是否主动交卷 0.否 1.是
@property (nonatomic, assign) NSInteger right_rate;             ///<正确率
@property (nonatomic, assign) NSInteger error_num;              ///<错误数
@property (nonatomic, assign) NSInteger rank;                   ///<个人排名 ，0 为无成绩
@property (nonatomic, assign) NSInteger unanswer_num;           ///<未作答数
@property (nonatomic, assign) NSInteger use_time;               ///<用时秒
@property (nonatomic, assign) NSInteger score;                  ///<得分
@property (nonatomic, assign) NSInteger right_num;              ///<正确数
@end

@protocol VHExamObjectDelegate <NSObject>
/// 推送-快问快答
/// - Parameters:
///   - message: 消息详情
///   - examWebUrl: 快问快答的嵌入页地址
- (void)paperSendMessage:(VHMessage *)message examWebUrl:(NSURL *)examWebUrl;
///快问快答-收卷
- (void)paperEndMessage:(VHMessage *)message examWebUrl:(NSURL *)examWebUrl;
///公布-快问快答-成绩
- (void)paperSendRankMessage:(VHMessage *)message examWebUrl:(NSURL *)examWebUrl;
///快问快答-自动收卷
- (void)paperAutoEndMessage:(VHMessage *)message examWebUrl:(NSURL *)examWebUrl;
///快问快答-自动公布成绩
- (void)paperAutoEendRankMessage:(VHMessage *)message examWebUrl:(NSURL *)examWebUrl;
@end

@interface VHExamObject : VHallBasePlugin

@property (nonatomic, weak) id <VHExamObjectDelegate> delegate; ///<代理

/// 观看端-答题前置条件检查
/// - Parameters:
///   - webinar_id: 活动ID
///   - user_name: 用户名
///   - head_img: 头像
///   - mobile: 手机号
///   - complete: 完成回调
- (void)examUserFormCheckWithWebinar_id:(NSString *)webinar_id user_name:(NSString *)user_name head_img:(NSString *)head_img mobile:(NSString *)mobile complete:(void (^)(VHExamUserFormCheckModel *examUserFormCheckModel, NSError *error))complete;

/// 观看端-初始化用户表单
/// - Parameters:
///   - webinar_id: 活动ID
///   - paper_id: 试卷ID
///   - complete: 完成回调
- (void)examGetUserFormInfoWithWebinar_id:(NSString *)webinar_id paper_id:(NSString *)paper_id complete:(void (^)(VHExamGetUserFormInfoModel *examGetUserFormInfoModel, NSError *error))complete;

/// 观看端-发送验证码
/// - Parameters:
///   - webinar_id: 活动ID
///   - paper_id: 试卷ID
///   - phone: 手机号码
///   - country_code: 国家码 默认CN
///   - complete: 完成回调
- (void)examSendVerifyCodeWithWebinar_id:(NSString *)webinar_id paper_id:(NSString *)paper_id phone:(NSString *)phone country_code:(NSString *)country_code complete:(void (^)(VHExamSendVerifyCodeModel *examSendVerifyCodeModel, NSError *error))complete;

/// 观看端-验证手机验证码
/// - Parameters:
///   - webinar_id: 活动ID
///   - paper_id: 试卷ID
///   - phone: 手机号码
///   - verify_code: 验证码
///   - country_code: 国家码 默认CN
///   - complete: 完成回调
- (void)examVerifyCodeWithWebinar_id:(NSString *)webinar_id paper_id:(NSString *)paper_id phone:(NSString *)phone verify_code:(NSString *)verify_code country_code:(NSString *)country_code complete:(void (^)(VHExamVerifyCodeModel *examVerifyCodeModel, NSError *error))complete;

/// 观看端-保存用户表单信息
/// - Parameters:
///   - webinar_id: 活动ID
///   - user_detail: 用户提交 表单json {"16130":"分享","16131":"A","16132":"2020-03-25 10:36:18","16133":"河北省","16134":"A","16135":"B,C","16136":"春暖花开","16137":"1-1,2-2","16139":"1-1,1-2,2-1"}
///   - verify_code: 验证码
///   - complete: 完成回调
- (void)examSaveUserFormWithWebinar_id:(NSString *)webinar_id user_detail:(NSString *)user_detail verify_code:(NSString *)verify_code complete:(void (^)(NSDictionary *responseObject, NSError *error))complete;

/// 观看端-获取场次已推送试卷列表
/// - Parameters:
///   - webinar_id: 活动ID
///   - switch_id: 场次ID
///   - complete: 完成回调
- (void)examGetPushedPaperListWithWebinar_id:(NSString *)webinar_id switch_id:(NSString *)switch_id complete:(void (^)(NSArray <VHExamGetPushedPaperListModel *> *examGetPushedPaperList, NSError *error))complete;

/// 观看端-获取试卷详情
/// - Parameters:
///   - webinar_id: 活动ID
///   - paper_id: 试卷ID
///   - complete: 完成回调
- (void)examGetPaperInfoForWatchWithWebinar_id:(NSString *)webinar_id paper_id:(NSString *)paper_id complete:(void (^)(VHExamGetPaperInfoForWatchModel *examGetPaperInfoForWatchModel, NSError *error))complete;

/// 观看端-单题提交
/// - Parameters:
///   - webinar_id: 活动ID
///   - paper_id: 试卷ID
///   - question_id: 题目ID
///   - user_answer: 用户答案
///   - complete: 完成回调
- (void)examAnswerQuestionWithWebinar_id:(NSString *)webinar_id paper_id:(NSString *)paper_id question_id:(NSString *)question_id user_answer:(NSString *)user_answer complete:(void (^)(NSDictionary *responseObject, NSError *error))complete;

/// 观看端-主动交卷
/// - Parameters:
///   - webinar_id: 活动ID
///   - paper_id: 试卷ID
///   - complete: 完成回调
- (void)examInitiativeSubmitPaperWithWebinar_id:(NSString *)webinar_id paper_id:(NSString *)paper_id complete:(void (^)(NSDictionary *responseObject, NSError *error))complete;

/// 观看端-获取已答题记录断点续答
/// - Parameters:
///   - webinar_id: 活动ID
///   - paper_id: 试卷ID
///   - complete: 完成回调
- (void)examGetUserAnswerPaperHistoryWithWebinar_id:(NSString *)webinar_id paper_id:(NSString *)paper_id complete:(void (^)(NSArray <VHExamGetUserAnswerPaperHistoryModel *> *examGetUserAnswerPaperHistoryList, NSError *error))complete;

/// 观看端-获取榜单信息
/// - Parameters:
///   - webinar_id: 活动ID
///   - paper_id: 试卷ID
///   - pageNum: 第几页
///   - pageSize: 每页数量
///   - complete: 完成回调
- (void)examGetSimpleRankListWithWebinar_id:(NSString *)webinar_id paper_id:(NSString *)paper_id pageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize complete:(void (^)(NSArray <VHExamGetSimpleRankListModel *> *examGetSimpleRankList, NSError *error))complete;

/// 观看端-获取个人成绩
/// - Parameters:
///   - webinar_id: 活动ID
///   - paper_id: 试卷ID
///   - complete: 完成回调
- (void)examPersonScoreInfoWithWebinar_id:(NSString *)webinar_id paper_id:(NSString *)paper_id complete:(void (^)(VHExamPersonScoreInfoModel *examPersonScoreInfoModel, NSError *error))complete;

@end
