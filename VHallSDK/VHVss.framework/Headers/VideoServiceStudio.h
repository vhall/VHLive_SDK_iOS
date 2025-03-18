//
//  VideoServiceStudio.h
//  VSSDemo
//
//  Created by vhall on 2019/6/27.
//  Copyright © 2019 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VSSRoomInfo.h"
#import <VHCore/VHMessage.h>

@class VHImSDK;
@protocol VideoServiceStudioDelegate;
@protocol VideoServiceStudioIMDelegate;

NS_ASSUME_NONNULL_BEGIN


///VSS房间管理类
@interface VideoServiceStudio : NSObject

//App 接口域名 用于 App层接口 如 登录接口 列表接口 问卷host
@property (nonatomic,copy) NSString* apphost;

//Vss 接口域名 带版本信息 默认值为 @"https://vss.vhall.com/v1" 注意要带版本 如：/v1
@property (nonatomic,copy) NSString* vsshost;
//pass app id
@property (nonatomic, copy, readonly) NSString *appId;

//vss 房间id
@property (nonatomic, copy, readonly) NSString *roomId;

//vss token
@property (nonatomic, copy, readonly) NSString *vss_token;

//自己在房间中的id
@property (nonatomic, copy, readonly) NSString *joinId;

//房间拥有者参会id
@property (nonatomic, copy, readonly) NSString *hostId;
//频道id
@property (nonatomic, copy ,readonly) NSString *channel_id; 
//房间信息
@property (nonatomic, strong) VSSRoomInfo *roomInfo;

//代理指针
@property (nonatomic, weak) id <VideoServiceStudioDelegate> delegate;

//IM
@property (nonatomic, strong, nullable) VHImSDK *vhIM;
//当前用户角色权限列表
@property (nonatomic, strong, readonly) NSArray <NSNumber *> *rolePermissions;


//初始化
+ (instancetype)sharedStudio;

/*
 @param appId        对应微吼云AppID
 @param vsshost      VSS域名  非定制用户可填nil  默认值为 @"https://vss.vhall.com/v1" 注意要带版本 如：/v1
 @param appHost      App域名  必须填写
*/
+ (void)registerWithAppId:(NSString *)appId vssHost:(NSString*)vssHost apphost:(NSString*)appHost;
/*
 @param appId        对应微吼云AppID
 @param vsshost      VSS域名  非定制用户可填nil  默认值为 @"https://vss.vhall.com/v1" 注意要带版本 如：/v1
 @param appHost      App域名  必须填写
 @param bundleId     应用 bundleId
 @param vhallyunHost 微吼云域名 非定制用户可填nil  默认值为 @"api.vhallyun.com"
*/
+ (void)registerWithAppId:(NSString *)appId vssHost:(NSString*)vsshost apphost:(NSString*)appHost bundleId:(NSString *)bundleId vhallyunHost:(NSString*)vhallyunHost;

/**
 *  设置日志等级
 *  @param level  日志等级
 */
+ (void) setLogLevel:(int)level;


//登录后进行绑定三方用户@{@"nick_name":@"昵称",@"avatar":@"头像地址"}
- (void)setThirdPartyUserInfo:(NSDictionary *)info;

//直接绑定已登录三方用户@{@"nick_name":@"昵称",@"avatar":@"头像地址"}
- (void)setThirdPartyUserContext:(NSDictionary *)info;

//进入VSS
- (void)enterStudioWithRoomId:(NSString *)roomId
                     vssToken:(NSString *)vss_token
                      success:(nullable void (^)(VSSRoomInfo *info))success
                      failure:(nullable void (^)(NSError *error))failure;

//获取直播间pv
- (void)getRoomPv;

//离开VSS，并清空房间信息，并停止IM监听
- (void)leaveStudio;

//消息纷发
- (void)addIMdelegate:(id<VideoServiceStudioIMDelegate>)delegate;
- (void)removeIMdelegate:(id<VideoServiceStudioIMDelegate>)delegate;


//检查用户权限  NO：无权限 YES：有权限   permisson为VSSRolePermissonType枚举类型
+ (BOOL)checkPermission:(NSInteger)permisson;

/**
 *  获得当前SDK版本号
 */
+ (NSString *) getSDKVersion;

///旧活动获取AccessToken
- (void)oldWebinarRoomId:(NSString *)roomId vssToken:(NSString *)vssToken passToken:(void(^)(NSString *))tokenCallBack;
@end


@protocol VideoServiceStudioDelegate <NSObject>

@optional
//进入VSS回调
- (void)studio:(VideoServiceStudio *)studio enterWithError:(nullable NSError *)error roomInfo:(nullable VSSRoomInfo *)info;

@end



@protocol VideoServiceStudioIMDelegate <NSObject>

@optional
//上下线消息回调
- (void)studio:(VideoServiceStudio *)studio onlineMessage:(VHMessage*)message;
//聊天消息回调
- (void)studio:(VideoServiceStudio *)studio receiveMessage:(VHMessage*)message;
//房间消息回调
- (void)studio:(VideoServiceStudio *)studio receiveRoomMessage:(VHMessage*)message;
//自定义消息回调
- (void)studio:(VideoServiceStudio *)studio customMessage:(VHMessage*)message;
//错误回调
- (void)studio:(VideoServiceStudio *)studio error:(NSError *)error;
//所有消息回调
- (void)studio:(VideoServiceStudio *)studio receiveAllMessage:(VHMessage*)message;

@end

NS_ASSUME_NONNULL_END
