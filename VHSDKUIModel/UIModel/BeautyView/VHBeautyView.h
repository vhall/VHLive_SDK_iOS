//
//  VHBeautyView.h
//  UIModel
//
//  Created by jinbang.li on 2022/2/16.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VHBeautyView : UIView
///显示底部的编辑美颜视图
- (void)showDisplayBeautyView:(UIView *)view;
///动画消除
- (void)disMissView;
@end

NS_ASSUME_NONNULL_END
