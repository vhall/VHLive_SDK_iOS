//
//  VHSeatTableViewCell.h
//  VhallLive
//
//  Created by jinbang.li on 2022/4/6.
//  Copyright © 2022 vhall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VHSheetModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface VHSeatTableViewCell : UITableViewCell
///显示数据+选择机位的状态
- (void)display:(VHSheetModel *)model selectStatus:(BOOL)seatStatus;
@end

NS_ASSUME_NONNULL_END
