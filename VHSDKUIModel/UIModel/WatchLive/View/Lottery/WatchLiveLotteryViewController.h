//
//  WatchLiveLotteryViewController.h
//  VHallSDKDemo
//
//  Created by Ming on 16/10/14.
//  Copyright © 2016年 vhall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VHLiveSDK/VHallLottery.h>
#import <VHLiveSDK/VHallMsgModels.h>

@interface WatchLiveLotteryViewController : UIViewController

@property (nonatomic, strong) VHWebinarInfo *         webinarInfo;            ///<活动相关信息 （在收到"视频信息预加载回调"或"播放连接成功回调"后使用，v6.0新增，仅限新版控制台(v3及以上)创建的活动使用）
@property (nonatomic, strong) VHallLottery * lottery;
@property (nonatomic, strong) VHallStartLotteryModel * startLotteryModel;
@property (nonatomic, strong) VHallEndLotteryModel * endLotteryModel;

- (void)new_lottery_UI:(VHallEndLotteryModel *)endLotteryModel;
@end
