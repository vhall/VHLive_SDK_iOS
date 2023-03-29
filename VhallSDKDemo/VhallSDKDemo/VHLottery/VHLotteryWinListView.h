//
//  VHLotteryWinListView.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/3/20.
//

#import "VHInavAlertView.h"

@interface VHLotteryWinListCell : UITableViewCell

/// 中奖名单模型
@property (nonatomic, strong) VHallLotteryResultModel_ListItem * item;
/// index
@property (nonatomic, assign) NSInteger indexRow;

+ (VHLotteryWinListCell *)createCellWithTableView:(UITableView *)tableView;

@end

@interface VHLotteryWinListView : VHInavAlertView

/// 显示弹窗
/// - Parameter vhLottery: 抽奖类
/// - Parameter endLotteryModel: 结束抽奖数据
- (void)showLotteryWinListWithVHLottery:(VHallLottery *)vhLottery endLotteryModel:(VHallEndLotteryModel *)endLotteryModel;

/// 隐藏
- (void)dismiss;

@end
