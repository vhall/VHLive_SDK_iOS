//
//  VHLotteryLosingView.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/3/16.
//

#import "VHInavAlertView.h"

@protocol VHLotteryLosingViewDelegate <NSObject>

/// 点击查看中奖名单
/// - Parameter endLotteryModel: 结束抽奖数据源
- (void)clickCheckWinListWithEndLotteryModel:(VHallEndLotteryModel *)endLotteryModel;

@end

@interface VHLotteryLosingView : VHInavAlertView

@property (nonatomic, weak) id <VHLotteryLosingViewDelegate> delegate;

/// 显示弹窗
/// - Parameter vhLottery: 抽奖类
/// - Parameter endLotteryModel: 结束抽奖数据
- (void)showLotteryLosingWithVHLottery:(VHallLottery *)vhLottery endLotteryModel:(VHallEndLotteryModel *)endLotteryModel;

/// 隐藏
- (void)dismiss;

@end
