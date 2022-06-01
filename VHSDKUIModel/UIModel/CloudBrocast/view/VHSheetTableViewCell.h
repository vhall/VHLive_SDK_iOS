//
//  VHSheetTableViewCell.h
//  VhallLive
//
//  Created by jinbang.li on 2022/4/6.
//  Copyright © 2022 vhall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VHSheetModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface VHSheetTableViewCell : UITableViewCell
///显示数据
- (void)display:(VHSheetModel *)model;
@end

NS_ASSUME_NONNULL_END
