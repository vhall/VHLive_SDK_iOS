//
//  VHFashionStyleChatView.h
//  UIModel
//
//  Created by 郭超 on 2022/7/21.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VHCChatTableViewCell : UITableViewCell

+ (VHCChatTableViewCell *)createCellWithTableView:(UITableView *)tableView;

@property(nonatomic, strong) VHallChatModel * model;

@property(nonatomic, strong) VHallGiftModel * giftModel;

@end

@interface VHFashionStyleChatView : UIView

/// 活动详情
@property (nonatomic, strong) VHWebinarInfo * webinarInfo;

/// 聊天记录页码，默认1
@property (nonatomic, assign) NSInteger chatListPage;

/// 获取历史聊天记录
- (void)loadHistoryWithChat:(VHallChat *)chat page:(NSInteger)page;

/// 刷新数据
- (void)reloadDataWithMsgs:(NSArray *)msgs;

/// 收到礼物
- (void)vhGifttoModel:(VHallGiftModel *)model;

@end

NS_ASSUME_NONNULL_END
