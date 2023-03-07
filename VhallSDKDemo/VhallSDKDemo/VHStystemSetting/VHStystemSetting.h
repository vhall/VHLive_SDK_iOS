//
//  VHStystemSetting.h
//
//
//  Created by vhall on 16/5/11.
//  Copyright (c) 2016年 www.vhall.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEMO_Setting [VHStystemSetting sharedSetting]

@interface VHStystemSetting : NSObject

+ (VHStystemSetting *)sharedSetting;

/// AppKey
@property (nonatomic, copy) NSString * appKey;
/// App SecretKey
@property (nonatomic, copy) NSString * appSecretKey;
/// rsaPrivateKey
@property (nonatomic, copy) NSString * rsaPrivateKey;
/// 发直播活动ID
@property (nonatomic, copy) NSString * activityID;
/// 账号
@property (nonatomic, copy) NSString * account;
/// 密码
@property (nonatomic, copy) NSString * password;
/// 三方登录账号
@property (nonatomic, copy) NSString * third_Id;
/// 三方登录密码
@property (nonatomic, copy) NSString * third_nickName;
/// 三方登录头像
@property (nonatomic, copy) NSString * third_avatar;

@end
