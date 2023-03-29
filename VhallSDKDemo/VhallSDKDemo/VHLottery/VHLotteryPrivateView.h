//
//  VHLotteryPrivateView.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/3/17.
//

#import "VHInavAlertView.h"

@interface VHLotteryPrivateView : VHInavAlertView

/// 显示弹窗
/// - Parameter vhLottery: 抽奖类
/// - Parameter endLotteryModel: 结束抽奖数据
/// - Parameter submitList: 填写地址信息的数据
- (void)showLotteryPrivateWithVHLottery:(VHallLottery *)vhLottery endLotteryModel:(VHallEndLotteryModel *)endLotteryModel submitList:(NSArray <VHallLotterySubmitConfig *> *)submitList;

/// 隐藏
- (void)dismiss;

@end
