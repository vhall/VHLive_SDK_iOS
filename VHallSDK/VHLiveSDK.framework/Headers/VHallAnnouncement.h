//
//  VHallAnnouncement.h
//  VHallSDK
//
//  Created by 郭超 on 2022/7/13.
//  Copyright © 2022 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VHallBasePlugin.h"

NS_ASSUME_NONNULL_BEGIN

@interface VHallAnnouncementModel : NSObject

@property (nonatomic, copy) NSString *content;  ///<公告内容
@property (nonatomic, copy) NSString *created_at;  ///<创建时间
@property (nonatomic, assign) NSInteger duration;  ///<显示时长 单位：秒  最小传入10   0:默认一直显示

@end

@protocol VHallAnnouncementDelegate <NSObject>

/// 收到公告
/// @param content 公告内容
/// @param pushTime 发布时间
/// @param duration 公告显示时长 0代表永久显示
- (void)announcementContentDidChange:(NSString *)content
                            pushTime:(NSString *)pushTime
                            duration:(NSInteger)duration;

@end

@interface VHallAnnouncement : VHallBasePlugin

@property (nonatomic, weak) id <VHallAnnouncementDelegate> delegate; ///<代理

/// 公告列表接口
/// @param room_id 房间id lss_xxxxxx
/// @param page_num 第几页
/// @param page_size 一页获取几个
/// @param startTime 开始时间 2020-11-25 21:11:22 可传@""
/// @param success 成功
/// @param fail 失败
- (void)getAnnouncementListWithRoomId:(NSString *)room_id
                             page_num:(NSInteger)page_num
                            page_size:(NSInteger)page_size
                            startTime:(NSString *)startTime
                              success:(void (^)(NSArray <VHallAnnouncementModel *> *dataArr))success
                                 fail:(void (^)(NSError *error))fail;

@end

NS_ASSUME_NONNULL_END
