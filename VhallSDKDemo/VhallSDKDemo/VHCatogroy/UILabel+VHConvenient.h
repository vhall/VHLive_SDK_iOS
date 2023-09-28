//
//  UILabel+VHConvenient.h
//  UIModel
//
//  Created by jinbang.li on 2022/3/1.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (VHConvenient)
// 已知区域重新调整
- (CGSize)contentSize;

// 不知区域，通过其设置区域
- (CGSize)textSizeIn:(CGSize)size;

+ (UILabel *)creatWithFont:(CGFloat)font TextColor:(NSString *)color;

+ (UILabel *)creatWithFont:(CGFloat)font TextColor:(NSString *)color Text:(NSString *)text;
/**
 分割线

 @return label实例
 */
+ (UILabel *)speratorLineColor:(NSString *)hexString;
@end

NS_ASSUME_NONNULL_END
