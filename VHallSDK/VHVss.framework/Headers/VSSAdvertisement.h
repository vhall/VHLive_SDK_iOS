//
//  VSSAdvertisement.h
//  VhallModuleUI_demo
//
//  Created by xiongchao on 2019/11/25.
//  Copyright © 2019 vhall. All rights reserved.
//
//广告
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VSSAdvertisementInfo : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *img_src; ///<广告图片
@property (nonatomic, copy) NSString *room_id; ///<房间id
@property (nonatomic, copy) NSString *status; ///<是否展示 1 展示 0 不展示
@property (nonatomic, copy) NSString *alert_type; ///<是否自动弹出 1 弹出  0 不弹出
@property (nonatomic, copy) NSString *created_at; ///< 2019-11-28 16:09:32
@property (nonatomic, copy) NSString *updated_at; ///< 2019-11-28 16:09:32
@property (nonatomic, copy) NSString *deleted_at; ///< 0000-00-00 00:00:00

@end


@interface VSSAdvertisement : NSObject
//上传广告图片
+ (void)uploadAdvImageData:(NSData *)imageData showStatus:(NSString *)status alertType:(NSString *)type progress:(nullable void (^)(NSProgress * progress))uploadProgress success:(void(^)(NSDictionary *response))success failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
