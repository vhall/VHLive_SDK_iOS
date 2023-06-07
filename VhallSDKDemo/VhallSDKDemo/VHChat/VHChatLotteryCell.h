//
//  VHChatLotteryCell.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/3/20.
//

#import <UIKit/UIKit.h>

typedef void (^ClickChekWinList)(VHallEndLotteryModel *endLotteryModel);

@interface VHChatLotteryCell : UITableViewCell
/// 抽奖开始
@property (nonatomic, strong) VHallStartLotteryModel *startModel;
/// 抽奖结束
@property (nonatomic, strong) VHallEndLotteryModel *endModel;
/// 点击查看中奖名单
@property (nonatomic, copy) ClickChekWinList clickChekWinList;
/// 初始化
+ (VHChatLotteryCell *)createCellWithTableView:(UITableView *)tableView;

@end
