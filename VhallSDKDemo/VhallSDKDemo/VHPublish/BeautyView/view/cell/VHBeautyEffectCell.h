//
//  VHBeautyEffectCell.h
//  UIModel
//
//  Created by jinbang.li on 2022/2/17.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VHBeautyModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface VHBeautyEffectCell : UICollectionViewCell
- (void)beautyModel:(VHBeautyModel *)beauty  isSelect:(BOOL)isSelect;
@end

NS_ASSUME_NONNULL_END
