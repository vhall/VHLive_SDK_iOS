//
//  VSSRequestManager.h
//  VSSDemo
//
//  Created by vhall on 2019/6/24.
//  Copyright © 2019 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VHCore/VHNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface VSSRequestManager : NSObject

+(void)uploadWithApi:(NSString*)URLString
               param:(nullable NSDictionary*)parameters
constructingBodyWithBlock:(void (^)(id <VHMultipartFormData> formData))block
            progress:(nullable void (^)(NSProgress * progress))uploadProgress
             success:(void (^)(NSDictionary *responseObject))successBlock
             failure:(void (^)(NSError *error))failureBlock;

+ (void)POST:(NSString *)URLString
parameters:(nullable id)parameters
   success:(nullable void (^)(NSDictionary *responseObject))successBlock
   failure:(nullable void (^)(NSError *error))failureBlock;

+ (void)POST:(NSString *)URLString
  parameters:(nullable id)parameters
    progress:(nullable void (^)(NSProgress *uploadProgress))uploadBlock
     success:(nullable void (^)(NSDictionary *responseObject))successBlock
     failure:(nullable void (^)(NSError *error))failureBlock;

+ (void)GET:(NSString *)URLString
parameters:(nullable id)parameters
   success:(nullable void (^)(NSDictionary *responseObject))successBlock
   failure:(nullable void (^)(NSError *error))failureBlock;

+ (void)GET:(NSString *)URLString
parameters:(nullable id)parameters
  progress:(nullable void (^)(NSProgress *uploadProgress))uploadBlock
   success:(nullable void (^)(NSDictionary *responseObject))successBlock
   failure:(nullable void (^)(NSError *error))failureBlock;
@end

NS_ASSUME_NONNULL_END
