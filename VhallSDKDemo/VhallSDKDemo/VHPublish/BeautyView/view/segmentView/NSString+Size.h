//
//  NSString+Size.h
//  UIModel
//
//  Created by jinbang.li on 2022/2/28.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSString (Size)
/**
 *  @brief 计算文字的高度
 *
 *  @param font  字体(默认为系统字体)
 *  @param width 约束宽度
 */
- (CGFloat)heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;
/**
 *  @brief 计算文字的宽度
 *
 *  @param font   字体(默认为系统字体)
 *  @param height 约束高度
 */
- (CGFloat)widthWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height;

/**
 *  @brief 计算文字的大小
 *
 *  @param font  字体(默认为系统字体)
 *  @param width 约束宽度
 */
- (CGSize)sizeWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;
/**
 *  @brief 计算文字的大小
 *
 *  @param font   字体(默认为系统字体)
 *  @param height 约束高度
 */
- (CGSize)sizeWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height;

/**
 *  @brief  反转字符串
 *
 *  @param strSrc 被反转字符串
 *
 *  @return 反转后字符串
 */
+ (NSString *)reverseString:(NSString *)strSrc;
@end

NS_ASSUME_NONNULL_END
