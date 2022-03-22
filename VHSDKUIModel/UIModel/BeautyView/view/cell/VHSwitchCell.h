//
//  VHSwitchCell.h
//  UIModel
//
//  Created by jinbang.li on 2022/2/24.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BeautyEnable)(BOOL isEnable);
NS_ASSUME_NONNULL_BEGIN

@interface VHSwitchCell : UICollectionViewCell
@property (nonatomic,copy) BeautyEnable beautyEnable;
@property (nonatomic,strong) UISwitch *cellSwitch;
@end

NS_ASSUME_NONNULL_END
