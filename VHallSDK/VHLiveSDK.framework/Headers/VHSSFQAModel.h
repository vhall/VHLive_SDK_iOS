//
//  VHSSFQAModel.h
//  SaaSShareApi
//
//  Created by 郭超 on 2022/11/16.
//

#import <Foundation/Foundation.h>

@interface VHSSFQAModel : NSObject

/// 观看端-答题前置条件检查
/// - Parameters:
///   - webinar_id: 活动ID
///   - user_name: 用户名
///   - head_img: 头像
///   - mobile: 手机号
///   - complete: 完成回调
+ (void)examUserFormCheckWithWebinar_id:(NSString *)webinar_id user_name:(NSString *)user_name head_img:(NSString *)head_img mobile:(NSString *)mobile complete:(void (^)(NSDictionary *responseObject, NSError *error))complete;

/// 观看端-初始化用户表单
/// - Parameters:
///   - webinar_id: 活动ID
///   - paper_id: 试卷ID
///   - complete: 完成回调
+ (void)examGetUserFormInfoWithWebinar_id:(NSString *)webinar_id paper_id:(NSString *)paper_id complete:(void (^)(NSDictionary *responseObject, NSError *error))complete;

/// 观看端-发送验证码
/// - Parameters:
///   - webinar_id: 活动ID
///   - paper_id: 试卷ID
///   - phone: 手机号码
///   - country_code: 国家码 默认CN
///   - complete: 完成回调
+ (void)examSendVerifyCodeWithWebinar_id:(NSString *)webinar_id paper_id:(NSString *)paper_id phone:(NSString *)phone country_code:(NSString *)country_code complete:(void (^)(NSDictionary *responseObject, NSError *error))complete;

/// 观看端-验证手机验证码
/// - Parameters:
///   - webinar_id: 活动ID
///   - paper_id: 试卷ID
///   - phone: 手机号码
///   - verify_code: 验证码
///   - country_code: 国家码 默认CN
///   - complete: 完成回调
+ (void)examVerifyCodeWithWebinar_id:(NSString *)webinar_id paper_id:(NSString *)paper_id phone:(NSString *)phone verify_code:(NSString *)verify_code country_code:(NSString *)country_code complete:(void (^)(NSDictionary *responseObject, NSError *error))complete;

/// 观看端-保存用户表单信息
/// - Parameters:
///   - webinar_id: 活动ID
///   - user_detail: 用户提交 表单json {"16130":"分享","16131":"A","16132":"2020-03-25 10:36:18","16133":"河北省","16134":"A","16135":"B,C","16136":"春暖花开","16137":"1-1,2-2","16139":"1-1,1-2,2-1"}
///   - verify_code: 验证码
///   - complete: 完成回调
+ (void)examSaveUserFormWithWebinar_id:(NSString *)webinar_id user_detail:(NSString *)user_detail verify_code:(NSString *)verify_code complete:(void (^)(NSDictionary *responseObject, NSError *error))complete;

/// 观看端-获取场次已推送试卷列表
/// - Parameters:
///   - webinar_id: 活动ID
///   - switch_id: 场次ID
///   - complete: 完成回调
+ (void)examGetPushedPaperListWithWebinar_id:(NSString *)webinar_id switch_id:(NSString *)switch_id complete:(void (^)(NSDictionary *responseObject, NSError *error))complete;

/// 观看端-获取试卷详情
/// - Parameters:
///   - webinar_id: 活动ID
///   - paper_id: 试卷ID
///   - complete: 完成回调
+ (void)examGetPaperInfoForWatchWithWebinar_id:(NSString *)webinar_id paper_id:(NSString *)paper_id complete:(void (^)(NSDictionary *responseObject, NSError *error))complete;

/// 观看端-单题提交
/// - Parameters:
///   - webinar_id: 活动ID
///   - paper_id: 试卷ID
///   - question_id: 题目ID
///   - user_answer: 用户答案
///   - complete: 完成回调
+ (void)examAnswerQuestionWithWebinar_id:(NSString *)webinar_id paper_id:(NSString *)paper_id question_id:(NSString *)question_id user_answer:(NSString *)user_answer complete:(void (^)(NSDictionary *responseObject, NSError *error))complete;

/// 观看端-主动交卷
/// - Parameters:
///   - webinar_id: 活动ID
///   - paper_id: 试卷ID
///   - complete: 完成回调
+ (void)examInitiativeSubmitPaperWithWebinar_id:(NSString *)webinar_id paper_id:(NSString *)paper_id complete:(void (^)(NSDictionary *responseObject, NSError *error))complete;

/// 观看端-获取已答题记录断点续答
/// - Parameters:
///   - webinar_id: 活动ID
///   - paper_id: 试卷ID
///   - complete: 完成回调
+ (void)examGetUserAnswerPaperHistoryWithWebinar_id:(NSString *)webinar_id paper_id:(NSString *)paper_id complete:(void (^)(NSDictionary *responseObject, NSError *error))complete;

/// 观看端-获取榜单信息
/// - Parameters:
///   - webinar_id: 活动ID
///   - paper_id: 试卷ID
///   - pos: 分页数据起始位置
///   - limit: 每页数量
///   - complete: 完成回调
+ (void)examGetSimpleRankListWithWebinar_id:(NSString *)webinar_id paper_id:(NSString *)paper_id pos:(NSInteger)pos limit:(NSInteger)limit complete:(void (^)(NSDictionary *responseObject, NSError *error))complete;

/// 观看端-获取个人成绩
/// - Parameters:
///   - webinar_id: 活动ID
///   - paper_id: 试卷ID
///   - complete: 完成回调
+ (void)examPersonScoreInfoWithWebinar_id:(NSString *)webinar_id paper_id:(NSString *)paper_id complete:(void (^)(NSDictionary *responseObject, NSError *error))complete;

@end
