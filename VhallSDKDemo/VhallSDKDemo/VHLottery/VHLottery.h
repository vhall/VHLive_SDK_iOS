//
//  VHLottery.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/3/15.
//

#import <Foundation/Foundation.h>

@protocol VHLotteryDelegate <NSObject>

/// 抽奖开始
- (void)startLottery:(VHallStartLotteryModel *)msg;

/// 抽奖结束
- (void)endLottery:(VHallEndLotteryModel *)msg;

@end

@interface VHLottery : NSObject

@property (nonatomic, weak) id <VHLotteryDelegate> delegate;

/// 初始化
/// - Parameter obj: 播放器
/// - Parameter webinarInfoData: 活动详情
- (instancetype)initLotteryWithObj:(NSObject *)obj webinarInfoData:(VHWebinarInfoData *)webinarInfoData;

/// 点击查看中奖名单
/// - Parameter endLotteryModel: 结束抽奖数据源
- (void)clickCheckWinListWithEndLotteryModel:(VHallEndLotteryModel *)endLotteryModel;

/// 隐藏弹窗
- (void)dismiss;

@end
