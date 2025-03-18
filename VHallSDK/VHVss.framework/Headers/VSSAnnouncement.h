//
//  VSSAnnouncement.h
//  VhallModuleUI_demo
//
//  Created by xiongchao on 2019/11/27.
//  Copyright © 2019 vhall. All rights reserved.
//
//公告（文字跑马灯）
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VSSAnnouncementInfo : NSObject

@property (nonatomic, copy) NSNumber *ID;
@property (nonatomic, copy) NSString *room_id;
@property (nonatomic, copy) NSNumber *scrolling_open; ///>是否开启滚动 0:关闭 1:开启
@property (nonatomic, copy) NSString *text; ///>文本内容
@property (nonatomic, copy) NSNumber *text_type; ///>文本类型 1：固定文本 2：固定文本 + 观看者id昵称
@property (nonatomic, copy) NSNumber *alpha; ///>不透明度
@property (nonatomic, copy) NSNumber *size; ///>文字大小
@property (nonatomic, copy) NSString *color; ///>文字颜色
@property (nonatomic, copy) NSNumber *interval; ///>显示间隔时间 时长/秒
@property (nonatomic, copy) NSNumber *speed; ///>文字移动速度：10000：慢，6000：中，3000：快
@property (nonatomic, copy) NSNumber *position; ///>位置 1:随机 2:高 3:中 4:低
@property (nonatomic, copy) NSNumber *status; ///>是否开启 1:开启 0:关闭
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, copy) NSString *deleted_at;

@end

@interface VSSAnnouncement : NSObject

//获取跑马灯数据
+ (void)getAnnouncementInfo:(void(^)(VSSAnnouncementInfo *info))success failure:(nullable void (^)( NSError *error))failure;

///发布公告
+ (void)sendNoticeToImageBase64:(NSString *)imageBase64
                        Content:(NSString *)content
                         Sucess:(void(^)(NSDictionary *responseObject))successBlock
                        failure:(void(^)(NSError *error))failureBlock;

///获取公告列表
+ (void)getNoticeListsPage:(NSInteger)page
                  pageSize:(NSInteger)pageSize
                    sucess:(void(^)(NSDictionary *responseObject))successBlock
                    failure:(void(^)(NSError *error))failureBlock;
///删除公告
+ (void)delNoticeToNotice_id:(NSString *)notice_id
                      Sucess:(void(^)(NSDictionary *responseObject))successBlock
                     failure:(void(^)(NSError *error))failureBlock;
@end

NS_ASSUME_NONNULL_END
