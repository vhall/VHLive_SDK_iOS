//
//  VSSTool.h
//  VHallSDK
//
//  Created by vhall on 2019/7/5.
//  Copyright © 2019 vhall. All rights reserved.
//

#import <VHCore/VHTools.h>

NS_ASSUME_NONNULL_BEGIN

@interface VSSTool : VHTools

+ (NSString *)safeString:(NSString *)str;

+ (NSString *)safeAvatar:(NSString *)avatar;

//判断字符串是否为空
+ (BOOL)isEmptyStr:(NSString *)str;

//获取时间字符串 yyyy/MM/dd/时间戳
+ (NSString *)currentDateString;

+ (id)jsonObjectWithData:(NSData *)data;
@end

NS_ASSUME_NONNULL_END
