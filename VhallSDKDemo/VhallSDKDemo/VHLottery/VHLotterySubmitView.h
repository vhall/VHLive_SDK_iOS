//
//  VHLotterySubmitView.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/3/16.
//

#import "VHInavAlertView.h"

@interface VHLotterySubmitListCell : UITableViewCell

/// 领奖页提交中奖用户信息填写选项的配置
@property (nonatomic, strong) VHallLotterySubmitConfig *submitConfig;

@property (nonatomic, strong) UITextField *contentTF;

+ (VHLotterySubmitListCell *)createCellWithTableView:(UITableView *)tableView index:(NSInteger)index;

@end

@interface VHLotterySubmitView : VHInavAlertView

/// 显示弹窗
/// - Parameter vhLottery: 抽奖类
/// - Parameter endLotteryModel: 结束抽奖数据
/// - Parameter submitList: 填写地址信息的数据
- (void)showLotterySubmitWithVHLottery:(VHallLottery *)vhLottery endLotteryModel:(VHallEndLotteryModel *)endLotteryModel submitList:(NSArray <VHallLotterySubmitConfig *> *)submitList;

/// 隐藏
- (void)dismiss;

@end
