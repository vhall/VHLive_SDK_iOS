//
//  VHAnnouncementList.h
//  UIModel
//
//  Created by 郭超 on 2022/7/13.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VHAnnouncementListCell : UITableViewCell

@property (nonatomic, strong) UIView *bgView;       ///<背景
@property (nonatomic, strong) UILabel *timeLab;     ///<时间
@property (nonatomic, strong) UILabel *titleLab;    ///<标题

@property (nonatomic, strong) VHallAnnouncementModel *model;

+ (VHAnnouncementListCell *)createCellWithTableView:(UITableView *)tableView;

@end

@interface VHAnnouncementList : UIView

/// 公告列表
- (void)loadDataRoomId:(NSString *)roomId isShow:(BOOL)isShow;

@end
