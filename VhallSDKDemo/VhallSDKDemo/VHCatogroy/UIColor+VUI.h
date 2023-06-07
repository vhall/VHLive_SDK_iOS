//
//  UIColor+VUI.h
//  VHVSS
//
//  Created by vhall on 2019/8/26.
//  Copyright © 2019 vhall. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
   渐变方式

   - IHGradientChangeDirectionLevel:              水平渐变
   - IHGradientChangeDirectionVertical:           竖直渐变
   - IHGradientChangeDirectionUpwardDiagonalLine: 向下对角线渐变
   - IHGradientChangeDirectionDownDiagonalLine:   向上对角线渐变
 */
typedef NS_ENUM(NSInteger, IHGradientChangeDirection) {
    IHGradientChangeDirectionLevel,
    IHGradientChangeDirectionVertical,
    IHGradientChangeDirectionUpwardDiagonalLine,
    IHGradientChangeDirectionDownDiagonalLine,
};

@interface UIColor (VUI)
/**
   创建渐变颜色

   @param size       渐变的size
   @param direction  渐变方式
   @param startcolor 开始颜色
   @param endColor   结束颜色

   @return 创建的渐变颜色
 */
+ (instancetype)bm_colorGradientChangeWithSize:(CGSize)size
                                     direction:(IHGradientChangeDirection)direction
                                    startColor:(UIColor *)startcolor
                                      endColor:(UIColor *)endColor;

/**
 * @brief 根据字符串返回UIColor
 * UIColor *solidColor = [UIColor colorWithWeb:@"#FF0000"];
 * UIColor *solidColor = [UIColor colorWithWeb:@"FF0000"];
 *
 * @param hexString 字符串的值，e.g:@"#FF0000" @"FF0000"
 *
 * @return 颜色对象
 */
+ (UIColor *)colorWithHex:(NSString *)hexString;
+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

/**
 * @brief 字符串中得到颜色值
 *
 * @param stringToConvert 字符串的值 e.g:@"#FF4500"
 *
 * @return 返回颜色对象
 */
+ (UIColor *)colorFromString_Ext:(NSString *)stringToConvert;


/**
 * @brief RGBA风格获取颜色，
 * UIColor *solidColor = [UIColor colorWithRGBA_Ext:0xFF0000FF];
 *
 * @param hex 是16进止rgba值
 *
 * @return 颜色对象
 */
+ (UIColor *)colorWithRGBA_Ext:(uint)hex;


/**
 * @brief ARGB风格获取颜色
 * UIColor *alphaColor = [UIColor colorWithHex:0x99FF0000];
 *
 * @param hex argb的值
 *
 * @return 颜色对象
 */
+ (UIColor *)colorWithARGB_Ext:(uint)hex;


/**
 * @brief RGB风格获取颜色值
 * UIColor *solidColor = [UIColor colorWithHex:0xFF0000];
 *
 * @param hex rgb的值
 *
 * @return 颜色对象
 */
+ (UIColor *)colorWithRGB_Ext:(uint)hex;

/*usage
   safe to omit # sign as well
   UIColor *solidColor = [UIColor colorWithWeb:@"FF0000"];
 */


/**
 * @brief 颜色对象返回字符串
 *
 * @return 颜色字符串
 */
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *hexString_Ext;

/**
 * @brief 得到颜色R值
 *
 * @return 返回R值
 */
@property (NS_NONATOMIC_IOSONLY, readonly) CGFloat r_Ext;

/**
 * @brief 得到颜色的G值
 *
 * @return 返回颜色的G值
 */
@property (NS_NONATOMIC_IOSONLY, readonly) CGFloat g_Ext;

/**
 * @brief 得到颜色的B值
 *
 * @return 返回颜色的B值
 */
@property (NS_NONATOMIC_IOSONLY, readonly) CGFloat b_Ext;

/**
 * @brief 得到颜色的A值
 *
 * @return 返回颜色的A值
 */
@property (NS_NONATOMIC_IOSONLY, readonly) CGFloat a_Ext;


@end

NS_ASSUME_NONNULL_END
