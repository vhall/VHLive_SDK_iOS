//
//  VHBeautyFilterCell.h
//  UIModel
//
//  Created by jinbang.li on 2022/3/3.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabel+VHConvenient.h"
#import "UIColor+VUI.h"
#import "VHBeautyModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface VHBeautyFilterCell : UICollectionViewCell
- (void)beautyModel:(VHBeautyModel *)beauty  isSelect:(BOOL)isSelect index:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
