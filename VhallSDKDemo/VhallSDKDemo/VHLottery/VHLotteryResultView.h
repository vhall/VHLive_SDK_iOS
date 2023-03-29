//
//  VHLotteryResultView.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/3/16.
//

#import "VHInavAlertView.h"

@protocol VHLotteryResultViewDelegate <NSObject>

/// 点击立即领奖
/// - Parameter endLotteryModel: 结束抽奖数据
- (void)clickNowPrizeEndLotteryModel:(VHallEndLotteryModel *)endLotteryModel;

/// 点击查看中奖名单
/// - Parameter endLotteryModel: 结束抽奖数据源
- (void)clickResultCheckWinListWithEndLotteryModel:(VHallEndLotteryModel *)endLotteryModel;

@end

@interface VHLotteryResultView : VHInavAlertView

@property (nonatomic, weak) id <VHLotteryResultViewDelegate> delegate;

/// 显示弹窗
/// - Parameter vhLottery: 抽奖类
/// - Parameter endLotteryModel: 结束抽奖数据
- (void)showLotteryResultWithVHLottery:(VHallLottery *)vhLottery endLotteryModel:(VHallEndLotteryModel *)endLotteryModel;

/// 隐藏
- (void)dismiss;

@end
