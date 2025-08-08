//
//  VHChatGoodsCell.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/8/14.
//

#import <UIKit/UIKit.h>

typedef void (^ClickGoodsCell)(VHGoodsPushMessageItem *messageItem);

@interface VHChatGoodsCell : UITableViewCell

@property (nonatomic, strong) VHGoodsPushMessageItem *messageItem;

@property (nonatomic, copy) ClickGoodsCell clickGoodsCell;

/// 初始化
+ (VHChatGoodsCell *)createCellWithTableView:(UITableView *)tableView;

@end
