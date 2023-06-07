//
//  VHWarmInfoObject.h
//  VHLiveSDK
//
//  Created by 郭超 on 2022/10/25.
//  Copyright © 2022 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VHallBasePlugin.h"
#import "VHallConst.h"
#import "VHallRawBaseModel.h"
#import "VHWebinarInfoData.h"

/// 视频详情
@interface VHWarmInfoRecordListItem : NSObject

@property (nonatomic, copy) NSString *paas_record_id;                           ///<暖场视频paas_id
@property (nonatomic, copy) NSString *record_name;                              ///<暖场视频名称
@property (nonatomic, copy) NSString *created_at;                               ///<关联成为暖场视频时间
@property (nonatomic, copy) NSString *storage;                                  ///<大小
@property (nonatomic, assign) float duration;                                   ///<时长

@end

/// 暖场视频详情
@interface VHWarmInfoModel : VHallRawBaseModel

@property (nonatomic, assign) NSInteger player_type;                            ///<1:单次播放 2:循环播放
@property (nonatomic, assign) NSInteger is_open_warm_video;                     ///<暖场视频是否开启：0关闭  1开启
@property (nonatomic, copy) NSString *img_url;                                  ///<暖场视频图片
@property (nonatomic, copy) NSString *warm_id;                                  ///<暖场视频id
@property (nonatomic, copy) NSString *webinar_id;                               ///<活动id
@property (nonatomic, copy) NSArray <VHWarmInfoRecordListItem *> *record_list;  ///<视频详情

@end

@protocol VHWarmInfoObjectDelegate <NSObject>

/// 初始化完成 (warmInfomodel 都有值代表初始化成功,error 有值代表初始化失败)
/// - Parameters:
///   - warmInfomodel: 暖场视频详情
///   - error: 错误提示
- (void)initializationCompletionWithWarmInfoModel:(VHWarmInfoModel *)warmInfoModel error:(NSError *)error;

/// 播放器状态
/// - Parameter state: 播放器状态
- (void)statusDidChange:(VHPlayerState)state;

/// 播放错误
/// - Parameter error: 错误提示
- (void)stoppedWithError:(NSError *)error;

/// 开始直播消息
- (void)warmInfoLiveStart;

/// 结束直播消息
- (void)warmInfoLiveOver;

/// 房间消息
/// - Parameter messageData: 消息详情
- (void)warmInfoReceiveRoomMessageData:(NSDictionary *)messageData;

@end

@interface VHWarmInfoObject : VHallBasePlugin

@property (nonatomic, weak)   id <VHWarmInfoObjectDelegate> delegate;           ///<代理

@property (nonatomic, strong) UIView *moviePlayerView;                          ///<播放器

/// 初始化
/// - Parameter webinarInfoData: 活动详情
/// - Parameter delegate: 代理
- (instancetype)initWithWebinarInfoData:(VHWebinarInfoData *)webinarInfoData delegate:(id <VHWarmInfoObjectDelegate>)delegate;

/// 开始播放
/// - Parameter item: 视频详情 取自获取暖场视频详情接口回调数据 VHWarmInfoRecordListItem
- (void)startPlay:(VHWarmInfoRecordListItem *)item;

/// 暂停播放
- (void)pausePlay;

/// 结束播放
- (void)stopPlay;

/// 恢复播放
- (void)resumePlay;

/// 销毁播放
- (void)destroyPlayer;

/// 指定播放
/// - Parameter duration: 时长
- (void)seekPlay:(float)duration;

@end
