//
//  VHQueTableViewCell.h
//  UIModel
//
//  Created by jinbang.li on 2022/5/15.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VHLiveSDK/VHallApi.h>
typedef void (^OpenLink)(void);
NS_ASSUME_NONNULL_BEGIN

@interface VHQueTableViewCell : UITableViewCell
- (void)updateModel:(VHSurveyModel *)surveyModel isLast:(BOOL)isLast;
@property (nonatomic,copy) OpenLink openLink;
//刷新抽奖列表单元格
- (void)updateLottery:(VHLotteryModel *)lotteryModel isLast:(BOOL)isLast;
@end

NS_ASSUME_NONNULL_END
