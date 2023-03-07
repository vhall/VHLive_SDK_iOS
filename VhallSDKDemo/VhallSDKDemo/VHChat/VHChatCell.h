//
//  VHChatCell.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/13.
//  聊天cell

#import <UIKit/UIKit.h>

@interface VHChatPhotoCollectionCell : UICollectionViewCell

@property(nonatomic, copy) NSString * image_url;

@property(nonatomic, assign) BOOL isLeft;

@end

@interface VHChatCell : UITableViewCell

/// 初始化
+ (VHChatCell *)createCellWithTableView:(UITableView *)tableView;

/// 模型
@property(nonatomic, strong) VHallChatModel * model;

@end
