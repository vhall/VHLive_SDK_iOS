//
//  VHSaaSShareApi.h
//  VHVss
//
//  Created by 熊超 on 2020/11/25.
//  Copyright © 2020 vhall. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, VHPlatformType) {
    VHPlatformType_App = 0, //app
    VHPlatformType_SDK = 4, //SDK
};

//平台参数 0：iOS App 4：iOS SDK  详见：http://wiki.vhallops.com/pages/viewpage.action?pageId=151552622

#import "VHSSRoomInfo.h"
#define VHSSNewVerion !([VHSaaSShareApi sharedInstance].disableHuadie)     //化蝶接口是否可用
#define VHSSNewSaaSH5 (![VHSaaSShareApi sharedInstance].currentWebinar_isOld && ![VHSaaSShareApi sharedInstance].disableHuadie)   // 新版H5活动 && 化蝶接口可用 (微吼直播app会使用该宏)

NS_ASSUME_NONNULL_BEGIN

@interface VHSaaSShareApi : NSObject
@property (nonatomic, assign) BOOL disableHuadie;     ///<是否禁用化蝶接口，默认NO
@property (nonatomic, assign) BOOL currentWebinar_isOld;     ///<当前活动是否是老活动，是则需要调用旧版接口，默认为NO（即新活动），每次操作一个活动时，需要给此属性赋值

@property (nonatomic, copy) NSString *RSAPrivateKey;     ///<RSA私钥 (若控制台选择RSA加密方式，则需要此值)
@property (nonatomic, assign, readonly) VHPlatformType platform; ///<平台
@property (nonatomic, copy, readonly) NSString *biz_id; ///<业务线id，2化蝶，4知客
@property (nonatomic, copy, readonly) NSString *saasApiHost;  ///<接口域名
@property (nonatomic, copy, readonly) NSString *saasAppKey;  ///<SaaS appKey
@property (nonatomic, copy, readonly) NSString *saasSecretKey;  ///<SaaS SecretKey
@property (nonatomic, copy) NSString *bundleId;   ///<集成sdk的项目包名
@property (nonatomic, copy) NSString *saasSDKVersion;  ///<SaaS SDK版本号

@property (nonatomic, copy, nullable) NSString *token;  ///<请求头token（登录后返回，app保存本地，SDK保存内存）
@property (nonatomic, copy, nullable) NSString *visitor_id;     ///<访客唯一标识（口令登录验证接口使用，app保存本地，SDK保存内存）
@property (nonatomic, copy, nullable) NSString *userId;     ///<登录用户id（登录后返回，app保存本地，SDK保存内存）

//保存内存参数
@property (nonatomic, copy, nullable) NSString *live_token;     ///<参会token (口令登录验证接口返回，嘉宾发起端初始化接口使用）
@property (nonatomic, copy, nullable) NSString *interact_token;     ///<请求头互动token（初始化接口返回）
@property (nonatomic, copy, nullable) NSString *gray_id;     ///<请求头灰度id，赋值详情见：http://wiki.vhallops.com/pages/viewpage.action?pageId=166887496

@property (nonatomic, assign) NSInteger roll_back;     ///<化蝶接口是否回滚
@property (nonatomic, copy) NSString *logReportUrl;     ///<进入直播、观看上报业务日志地址
@property (nonatomic, assign) NSInteger sign_type;     ///<加密方式 0：md5 1：rsa 2：sha256 3：sm3
@property (nonatomic, assign) BOOL is_jump_hd;     ///<是否跳转化蝶（迁移用户），默认设置YES，获取用户信息后更新此值（app创建直播时，需要使用此参数来判断，YES，走化蝶  NO，走老接口）


@property (nonatomic, strong, nullable) VHSSRoomInfo *roomInfo;  ///<房间信息（需要自己设置）


+ (instancetype)sharedInstance;


/// app配置 （默认业务线bizId = 2）
/// @param apiHost 接口请求域名
+ (void)appRegisterApihost:(NSString *)apiHost;


/// app配置，指定业务线id
/// @param apiHost 接口请求域名
/// @param bizId 业务线id：2化蝶，4知客
+ (void)appRegisterApihost:(NSString *)apiHost bizId:(NSString *)bizId;


/// SDK配置
/// @param appkey SaaS appKey
/// @param secretKey SaaS secretKey
/// @param apiHost 接口请求域名
+ (void)sdkRegisterWithAppKey:(NSString *)appkey secretKey:(NSString *)secretKey apihost:(NSString *)apiHost rsaPrivateKey:(NSString *)rsaPrivateKey;

//清除房间信息以及当前房间关联的信息
- (void)clearRoomInfo;

/// 清除本地已存的信息，包含用户token
/// @link 虽然不知道之前为什么会在SDK存用户信息，但App切换用户的时候需要清除本地token
- (void)localValuesClean;
@end


NS_ASSUME_NONNULL_END
