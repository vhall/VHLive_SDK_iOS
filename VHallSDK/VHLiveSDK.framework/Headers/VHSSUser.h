//
//  VHSSUser.h
//  VHVss
//
//  Created by xiongchao on 2020/11/13.
//  Copyright © 2020 vhall. All rights reserved.
//

//用户服务
#import <Foundation/Foundation.h>
#import "VHSSUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VHSSUser : NSObject


/// 注销账户
/// @param success 成功
/// @param failure 失败
+ (void)AccountDeleteWithHandleSuccess:(void (^)(void))success Failed:(void (^)(NSError *error))failure;

/// 注销账户前的检查
/// @param pass 通过，可以注销
/// @param filed 失败
+ (void)AccountDeleteCheckPass:(void (^)(NSDictionary *_Nonnull responseObject))pass Failed:(void (^)(NSError *error))filed;


/// 注销账户前的文案
/// @param type 类型 notice:注销须知  warn:注销提醒
/// @param success 成功
/// @param failure 失败
+ (void)AccountDeleteNoticeWithType:(NSString *)type Success:(void (^)(NSDictionary *_Nonnull responseObject))success Failed:(void (^)(NSError *error))failure;

/// 校验验证码
/// @param verificationCode 验证码
/// @param phone 手机号
/// @param success 成功
/// @param failure 失败
+ (void)CheckVerificationCodeAvailable:(NSString *)verificationCode PhoneNum:(NSString *)phone Success:(void (^)(NSDictionary *_Nonnull responseObject))success Failed:(void (^)(NSError *error))failure;

/// 获取验证码
/// @param account 账号：手机号/邮箱
/// @param accountType 账号类型，1手机号 2邮箱
/// @param scene_id 场景ID：1账户信息-修改密码  2账户信息-修改密保手机 3账户信息-修改关联邮箱 4忘记密码-邮箱方式找回 5忘记密码-短信方式找回 6提现绑定时手机号验证 7快捷方式登录 8注册-验证码
/// @param sucessBlock 成功回调
/// @param failureBlock 失败回调
+ (void)getAuthCodeWithAccount:(NSString *)account type:(NSInteger)accountType sendId:(NSString *)scene_id sucess:(void (^)(void))sucessBlock failure:(void (^)(NSError *error))failureBlock;

/// 获取验证码
/// @param account 账号：手机号/邮箱
/// @param accountType 账号类型，1手机号 2邮箱
/// @param scene_id 场景ID：1账户信息-修改密码  2账户信息-修改密保手机 3账户信息-修改关联邮箱 4忘记密码-邮箱方式找回 5忘记密码-短信方式找回 6提现绑定时手机号验证 7快捷方式登录 8注册-验证码 11账号注销
/// @param bizId 区分业务线：2=SaaS直播，4=知客，8=其他
/// @param sucessBlock 成功回调
/// @param failureBlock 失败回调
+ (void)getAuthCodeWithAccount:(NSString *)account type:(NSInteger)accountType sendId:(NSString *)scene_id bizId:(NSString *)bizId sucess:(void (^)(void))sucessBlock failure:(void (^)(NSError *error))failureBlock;

/// 账号密码登录
/// @param account 账号：手机号/邮箱
/// @param psw 密码
/// @param sucessBlock 成功回调
/// @param failureBlock 失败回调
+ (void)login:(NSString *)account passWord:(NSString *)psw sucess:(void (^)(VHSSUserModel *userInfo))sucessBlock failure:(void (^)(NSError *error))failureBlock;

/// 账号密码登录/账号验证码登录
/// @param account 账号：手机号/邮箱
/// @param psw 密码/验证码
/// @param loginType 登录方式，0账号密码 1账号验证码
/// @param sucessBlock 成功回调
/// @param failureBlock 失败回调
+ (void)loginWithAccount:(NSString *)account passWord:(NSString *)psw type:(NSInteger)loginType sucess:(void (^)(VHSSUserModel *userInfo))sucessBlock failure:(void (^)(NSError *error))failureBlock;


/// 第三方账号登录
/// @param thirdId 第三方账号id
/// @param nick_name 用户昵称  (非必传)
/// @param headUrlStr 用户头像 (非必传)
/// @param sucessBlock 成功回调
/// @param failureBlock 失败回调
+ (void)loginWithThirdId:(NSString *)thirdId nickName:(NSString *_Nullable)nick_name head:(NSString *_Nullable)headUrlStr sucess:(void (^)(VHSSUserModel *_Nonnull))sucessBlock failure:(void (^)(NSError *_Nonnull))failureBlock;

/// 退出登录
/// @param sucessBlock 成功回调
/// @param failureBlock 失败回调
+ (void)loginOutSucess:(void (^)(void))sucessBlock failure:(void (^)(NSError *error))failureBlock;


/// 获取用户信息
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
+ (void)getUserInfo:(void (^)(VHSSUserModel *userInfo))successBlock failure:(void (^)(NSError *error))failureBlock;


/// 刷新token
+ (void)refreshToken;
@end

NS_ASSUME_NONNULL_END
