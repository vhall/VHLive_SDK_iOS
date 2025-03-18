//
//  VSSRebroadcastPublisher.h
//  VHVss
//
//  Created by 郭超 on 2020/3/12.
//  Copyright © 2020 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VSSRebroadcastPublisher : NSObject
///开始转播
+ (void)vssStartRebroadcastSource_room_id:(NSString *)source_room_id
                                  Success:(void (^)(NSDictionary *response))success
                                  failure:(void (^)(NSError *error))failure;

///结束转播
+ (void)vssStopRebroadcastSource_room_id:(NSString *)source_room_id
                                 Success:(void (^)(NSDictionary *response))success
                                 failure:(void (^)(NSError *error))failure;
@end

NS_ASSUME_NONNULL_END
