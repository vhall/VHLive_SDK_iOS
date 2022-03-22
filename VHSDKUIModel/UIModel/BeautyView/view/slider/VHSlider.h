//
//  VHSlider.h
//  UIModel
//
//  Created by jinbang.li on 2022/2/23.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VHSlider : UISlider
//文本
@property (nonatomic, copy) NSString *valueText;
//字体
@property (nonatomic, strong) UIFont *valueFont;
//字体颜色
@property (nonatomic, strong) UIColor *valueTextColor;
//按下slider时的回调block
@property (nonatomic, copy) void(^touchDown)(VHSlider *);
//发生变化block
@property (nonatomic, copy) void(^valueChanged)(VHSlider *);
//松开回调block
@property (nonatomic, copy) void(^touchUpInside)(VHSlider *);
@end

NS_ASSUME_NONNULL_END
