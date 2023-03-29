//
//  VHLotteryTurntableView.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/3/15.
//

#import "VHInavAlertView.h"

@interface VHLotteryTurntableView : VHInavAlertView

/// 显示弹窗
/// - Parameter vhLottery: 抽奖类
/// - Parameter startModel: 抽奖数据
- (void)showLotteryTurntableWithVHLottery:(VHallLottery *)vhLottery startModel:(VHallStartLotteryModel *)startModel;

/// 隐藏
- (void)dismiss;

@end
