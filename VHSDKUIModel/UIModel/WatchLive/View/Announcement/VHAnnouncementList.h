//
//  VHAnnouncementList.h
//  UIModel
//
//  Created by 郭超 on 2022/7/13.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VHLiveSDK/VHallApi.h>

NS_ASSUME_NONNULL_BEGIN

@interface VHAnnouncementListCell : UITableViewCell

@property (nonatomic, strong) UILabel * timeLab;   ///<时间
@property (nonatomic, strong) UIImageView * img;    ///<图片
@property (nonatomic, strong) UILabel * titleLab;   ///<标题
@property (nonatomic, strong) UIView * lineView;    ///<虚线

@property (nonatomic, strong) VHallAnnouncementModel *model;

+ (VHAnnouncementListCell *)createCellWithTableView:(UITableView *)tableView;

@end

@interface VHAnnouncementList : UIView

/// 是否展开中
@property (nonatomic, assign) BOOL  isShow;

/// 公告列表
- (void)loadDataRoomId:(NSString *)roomId;

@end

NS_ASSUME_NONNULL_END
