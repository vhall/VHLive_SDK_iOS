//
//  AES.h
//  VHMiniLive
//
//  Created by vhall on 2020/4/6.
//  Copyright © 2020 www.vhall.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AES : NSObject
+ (NSString *)AES128Encrypt:(NSString *)plainText key:(NSString *)key;
+ (NSString *)AES128Decrypt:(NSString *)encryptText key:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
