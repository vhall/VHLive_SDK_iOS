//
//  VHChatPushScreenCardCell.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/7/3.
//

#import <UIKit/UIKit.h>

typedef void (^ClickPushScreenCardCell)(VHPushScreenCardItem *pushScreenCardListItem);

@interface VHChatPushScreenCardCell : UITableViewCell

@property (nonatomic, strong) VHPushScreenCardItem *pushScreenCardListItem;

@property (nonatomic, copy) ClickPushScreenCardCell clickPushScreenCardCell;

/// 初始化
+ (VHChatPushScreenCardCell *)createCellWithTableView:(UITableView *)tableView;

@end
