//
//  VHChatGiftCell.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/26.
//

#import <UIKit/UIKit.h>

@interface VHChatGiftCell : UITableViewCell

@property (nonatomic, strong) VHallGiftModel *giftModel;

/// 初始化
+ (VHChatGiftCell *)createCellWithTableView:(UITableView *)tableView;

@end
