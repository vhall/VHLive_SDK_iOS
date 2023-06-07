//
//  VHCommonObject.h
//  VHLiveSDK
//
//  Created by 郭超 on 2022/11/1.
//  Copyright © 2022 vhall. All rights reserved.
//


#import "VHallBasePlugin.h"

@interface VHCommonObject : VHallBasePlugin

/// 微信授权场景提交手机号
/// @param webinar_id 活动ID
/// @param phone 手机号
/// @param visitor_id 游客id（未登录逻辑会使用此参数）
/// @param code 验证码 (通过getAuthCodeWithAccount接口获取)
/// @param complete 完成回调
+ (void)noticeWechatSubmit:(NSString *)webinar_id phone:(NSString *)phone visitor_id:(NSString *)visitor_id code:(NSString *)code complete:(void (^)(NSDictionary *data, NSError *error))complete;

/// 获取验证码
/// @param account 账号：手机号/邮箱
/// @param accountType 账号类型，1手机号 2邮箱
/// @param scene_id 场景ID：1账户信息-修改密码  2账户信息-修改密保手机 3账户信息-修改关联邮箱 4忘记密码-邮箱方式找回 5忘记密码-短信方式找回 6提现绑定时手机号验证 7快捷方式登录 8注册-验证码
/// @param complete 完成回调
+ (void)sendCode:(NSString *)account type:(NSInteger)accountType sendId:(NSInteger)scene_id complete:(void (^)(NSString *msg, NSError *error))complete;

@end
