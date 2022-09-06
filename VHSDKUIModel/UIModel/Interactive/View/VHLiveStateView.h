//
//  VHLiveStateView.h
//  UIModel
//
//  Created by leiheng on 2021/4/16.
//  Copyright © 2021 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VHLiveStateView;

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    VideoBoardCastType_Normal = 0, //普通视频直播
    VideoBoardCastType_CloudBrocastPush = 1,  //云导播纯推流
    VideoBoardCastType_HostEnter = 2,//主持人进入
    VideoBoardCastType_LiveBeforePullFailed = 3,//云导播主持人进入直播前拉流失败
    VideoBoardCastType_LivingPullFailed = 4,//云导播主持人进入直播中拉流异常
    VideoBoardCastType_LivingPullSucceed = 5,//云导播主持人进入直播中拉流正常
    VideoBoardCastType_start = 6,//云导播初始化(隐藏开始直播等按钮)
}VideoBoardCastType;


@protocol VHLiveStateViewDelegate <NSObject>

/// 开始彩排
- (void)clickRehersalToBlock;

///直播状态页按钮事件
- (void)liveStateView:(VHLiveStateView *)liveStateView actionType:(VHLiveState)type;

@end


@interface VHLiveStateView : UIView

/** 代理 */
@property (nonatomic, weak) id<VHLiveStateViewDelegate> delegate;
/** 直播状态 */
@property (nonatomic, assign ,readonly) VHLiveState liveState;
/*
 新增云导播直播类型，以主持人发起进入云导播+机位推流进入
 默认为普通视频直播
 **/
@property (nonatomic,assign)VHLiveVideoType liveVideoType;

- (void)upDateLiveState:(VHLiveState)liveState btnTitle:(NSString *)btnTitle;

/** 新增云导播(仅推流)+(以主持人进入的各种状态) */
- (void)cloudBoardCastStatus:(VideoBoardCastType)boardType btnTitle:(NSString *)btnTitle;

@end

NS_ASSUME_NONNULL_END
