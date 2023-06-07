//
//  VHStystemSetting.m
//
//
//  Created by vhall on 16/5/11.
//  Copyright (c) 2016年 www.vhall.com. All rights reserved.
//

#define VHDefaultAvatar @"https://cnstatic01.e.vhall.com/upload/users/face-imgs/24/b6/24b6f81b1a4985d7dcbbeccc707cd7b8.png"

#import "VHStystemSetting.h"

@implementation VHStystemSetting

static VHStystemSetting *_sharedSetting = nil;

+ (VHStystemSetting *)sharedSetting {
    return [[self alloc]init];
}

+ (id)allocWithZone:(NSZone *)zone {
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        _sharedSetting = [super allocWithZone:zone];
    });
    return _sharedSetting;
}

- (id)copyWithZone:(NSZone *)zone {
    return _sharedSetting;
}

- (id)init
{
    self = [super init];

    if (self) {
        
    }

    return self;
}

#pragma mark - ak
- (void)setAppKey:(NSString *)appKey
{
    [[NSUserDefaults standardUserDefaults] setObject:appKey forKey:@"VHappKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)appKey
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"VHappKey"];
}

#pragma mark - ask
- (void)setAppSecretKey:(NSString *)appSecretKey
{
    [[NSUserDefaults standardUserDefaults] setObject:appSecretKey forKey:@"VHappSecretKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)appSecretKey
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"VHappSecretKey"];
}

#pragma mark - rsaPrivateKey
- (void)setRsaPrivateKey:(NSString *)rsaPrivateKey {
    [[NSUserDefaults standardUserDefaults] setValue:rsaPrivateKey forKey:@"VHrsaPrivateKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)rsaPrivateKey {
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"VHrsaPrivateKey"];
}

#pragma mark - 发起活动id
- (void)setActivityID:(NSString *)activityID {
    [[NSUserDefaults standardUserDefaults] setValue:activityID forKey:@"VHactivityID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)activityID {
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"VHactivityID"];
}

#pragma mark - 账号
- (void)setAccount:(NSString *)account
{
    [[NSUserDefaults standardUserDefaults] setObject:account forKey:@"VHaccount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)account
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"VHaccount"];
}

#pragma mark - 密码
- (void)setPassword:(NSString *)password
{
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"VHpassword"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)password
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"VHpassword"];
}

#pragma mark - 三方id
- (void)setThird_Id:(NSString *)third_Id {
    [[NSUserDefaults standardUserDefaults] setValue:third_Id forKey:@"third_Id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)third_Id {
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"third_Id"];
}

#pragma mark - 三方昵称
- (void)setThird_nickName:(NSString *)third_nickName {
    [[NSUserDefaults standardUserDefaults] setValue:third_nickName forKey:@"third_nickName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)third_nickName {
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"third_nickName"];
}

#pragma mark - 三方头像
- (void)setThird_avatar:(NSString *)third_avatar {
    [[NSUserDefaults standardUserDefaults] setValue:third_avatar forKey:@"third_avatar"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)third_avatar {
    NSString *avatar = [[NSUserDefaults standardUserDefaults] valueForKey:@"third_avatar"];

    if (!avatar) {
        avatar = VHDefaultAvatar;
    }

    return avatar;
}

@end
