//
//  VHallApi.h
//  VHallSDK
//
//  Created by vhall on 16/8/23.
//  Copyright © 2016年 vhall. All rights reserved.
//

#ifndef VHallApi_h
#define VHallApi_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "VHallConst.h"
#import "VHPrivacyManager.h"

#import "VHallAnnouncement.h"
#import "VHallBasePlugin.h"
#import "VHallChat.h"
#import "VHallComment.h"
#import "VHallGiftObject.h"
#import "VHallLikeObject.h"
#import "VHallLottery.h"
#import "VHallMsgModels.h"
#import "VHallQAndA.h"
#import "VHallRehearsalObject.h"
#import "VHallSign.h"
#import "VHallSurvey.h"
#import "VHallTimerObject.h"
#import "VHChaptersObject.h"
#import "VHCommonObject.h"
#import "VHExamObject.h"
#import "VHVideoRoundObject.h"
#import "VHWarmInfoObject.h"
#import "VHFileDownloadObject.h"
#import "VHPushScreenCardObject.h"
#import "VHMarqueeOptionModel.h"

@protocol VHallApiDelegate <NSObject>

@optional
/*！
 * token错误回调，监听到此回调后需重新登录
 * error   error
 */
- (void)vHallApiTokenDidError:(NSError *)error;

@end

@interface VHallApi : NSObject

/*！
 * 用来获得当前sdk的版本号
 * return 返回sdk版本号
 */
+ (NSString *)sdkVersion;
+ (NSString *)sdkVersionEX;

/*！
 *  注册app
 *  需要在 application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 中调用
 *  @param appKey       vhall后台注册生成的appkey
 *  @param secretKey    vhall后台注册生成的appsecretKey
 *
 */
+ (void)registerApp:(NSString *)appKey SecretKey:(NSString *)secretKey;


/*！
 *  注册app
 *  需要在 application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 中调用
 *  @param appKey       vhall后台注册生成的appkey
 *  @param secretKey    vhall后台注册生成的appsecretKey
 *  @param host         微吼服务所在域名，可传nil默认使用微吼域名
 */
+ (void)registerApp:(NSString *)appKey SecretKey:(NSString *)secretKey host:(NSString *)host;


/*！
 *  注册app
 *  需要在 application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 中调用
 *  @param appKey       vhall后台注册生成的appkey
 *  @param secretKey    vhall后台注册生成的appsecretKey
 *  @param host         微吼服务所在域名，可传nil默认使用微吼域名
 *  @param rsaPrivateKey    RSA私钥，若控制台设置使用RSA加密方式，则需要传此值
 */
+ (void)registerApp:(NSString *)appKey SecretKey:(NSString *)secretKey host:(NSString *)host rsaPrivateKey:(NSString *)rsaPrivateKey;


/*！
 *  设置日志类型
 *  @param type 日志类型
 */
+ (void)setLogType:(VHLogType)type;


/// 注册代理
/// @param delegate 代理
+ (void)registerDelegate:(id <VHallApiDelegate>)delegate;

#pragma mark - 使用用户系统相关功能需登录SDK
/*!
 *  账号密码登录
 *  @param aAccount         账号  需服务器调用微吼注册API 注册该用户账号密码
 *  @param aPassword        密码
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 */
+ (void)loginWithAccount:(NSString *)aAccount
                password:(NSString *)aPassword
                 success:(void (^)(void))aSuccessBlock
                 failure:(void (^)(NSError *error))aFailureBlock;

/*!
 *  三方ID登录，即不需要服务端调用微吼注册API，可直接使用您自身账号体系下的用户id进行登录 （v6.0新增）
 *  @param thirdUserId 三方id
 *  @param nickName 昵称 (非必传)
 *  @param avatar 头像地址 (非必传)
 *  @param successBlock 成功
 *  @param failureBlock 失败
 */
+ (void)loginWithThirdUserId:(NSString *)thirdUserId
                    nickName:(NSString *)nickName
                      avatar:(NSString *)avatar
                     success:(void (^)(void))successBlock
                     failure:(void (^)(NSError *error))failureBlock;

/*!
 *  退出登录
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 */
+ (void)logout:(void (^)(void))aSuccessBlock
       failure:(void (^)(NSError *error))aFailureBlock;

/*!
 *  获取当前登录状态
 *  @result 当前是否已登录
 */
+ (BOOL)isLoggedIn;

/*!
 *  获取当前登录用户账号
 *  @result 前登录用户账号
 */
+ (NSString *)currentAccount;

/*!
 *  获取当前登录用户id
 *  @result 前登录用户id
 */
+ (NSString *)currentUserID;

/*!
 *  获取当前登录用户头像
 *  @result 当前登陆用户头像地址
 */
+ (NSString *)currentUserHeadUrl;

/*!
 *  获取当前登录用户昵称
 *  @result 当前登陆用户昵称
 */
+ (NSString *)currentUserNickName;

/*!
 *  查询错误码对应错误内容
 *  @result 错误内容
 */
+ (NSString *)errorMsgWithCode:(NSInteger)errorCode;

@end

@interface VHallApi (VHDeprecated)

/*!
 *  三方ID登录，即不需要服务端调用微吼注册API，可直接使用您自身账号体系下的用户id进行登录 （v6.0新增）
 *  @param thirdUserId 三方id
 *  @param nickName 昵称 (非必传)
 *  @param avatar 头像地址 (非必传)
 *  @param successBlock 成功
 *  @param failureBlock 失败
 */
+ (void)loaginWithThirdUserId:(NSString *)thirdUserId
                     nickName:(NSString *)nickName
                       avatar:(NSString *)avatar
                      success:(void (^)(void))successBlock
                      failure:(void (^)(NSError * error)) failureBlock __deprecated_msg("此api命名不规范,推荐使用loginWithThirdUserId:nickName:avatar:success:failure:");

@end


#endif /* VHApi_h */
