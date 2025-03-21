//
//  UIColor+VUI.m
//  VHVSS
//
//  Created by vhall on 2019/8/26.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "UIColor+VUI.h"

const NSInteger MAX_RGB_COLOR_VALUE = 0xff;
const NSInteger MAX_RGB_COLOR_VALUE_FLOAT = 255.0f;

@implementation UIColor (VUI)
+ (instancetype)bm_colorGradientChangeWithSize:(CGSize)size
                                     direction:(IHGradientChangeDirection)direction
                                    startColor:(UIColor *)startcolor
                                      endColor:(UIColor *)endColor {
    if (CGSizeEqualToSize(size, CGSizeZero) || !startcolor || !endColor) {
        return nil;
    }

    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);

    CGPoint startPoint = CGPointZero;

    if (direction == IHGradientChangeDirectionDownDiagonalLine) {
        startPoint = CGPointMake(0.0, 1.0);
    }

    gradientLayer.startPoint = startPoint;

    CGPoint endPoint = CGPointZero;
    switch (direction) {
        case IHGradientChangeDirectionLevel:
            endPoint = CGPointMake(1.0, 0.0);
            break;

        case IHGradientChangeDirectionVertical:
            endPoint = CGPointMake(0.0, 1.0);
            break;

        case IHGradientChangeDirectionUpwardDiagonalLine:
            endPoint = CGPointMake(1.0, 1.0);
            break;

        case IHGradientChangeDirectionDownDiagonalLine:
            endPoint = CGPointMake(1.0, 0.0);
            break;

        default:
            break;
    }
    gradientLayer.endPoint = endPoint;

    gradientLayer.colors = @[(__bridge id)startcolor.CGColor, (__bridge id)endColor.CGColor];
    UIGraphicsBeginImageContext(size);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [UIColor colorWithPatternImage:image];
}

/**
 * @brief 字符串中得到颜色值
 *
 * @param stringToConvert 字符串的值 e.g:@"#FF4500"
 *
 * @return 返回颜色对象
 */
+ (UIColor *)colorFromString_Ext:(NSString *)stringToConvert {
    return [self colorWithHex:stringToConvert];
}

+ (UIColor *)colorWithRGBA_Ext:(uint)hex {
    return [UIColor colorWithRed:(CGFloat)((hex >> 24) & MAX_RGB_COLOR_VALUE) / MAX_RGB_COLOR_VALUE_FLOAT
                           green:(CGFloat)((hex >> 16) & MAX_RGB_COLOR_VALUE) / MAX_RGB_COLOR_VALUE_FLOAT
                            blue:(CGFloat)((hex >> 8) & MAX_RGB_COLOR_VALUE) / MAX_RGB_COLOR_VALUE_FLOAT
                           alpha:(CGFloat)((hex) & MAX_RGB_COLOR_VALUE) / MAX_RGB_COLOR_VALUE_FLOAT];
}

+ (UIColor *)colorWithARGB_Ext:(uint)hex {
    return [UIColor colorWithRed:(CGFloat)((hex >> 16) & MAX_RGB_COLOR_VALUE) / MAX_RGB_COLOR_VALUE_FLOAT
                           green:(CGFloat)((hex >> 8) & MAX_RGB_COLOR_VALUE) / MAX_RGB_COLOR_VALUE_FLOAT
                            blue:(CGFloat)(hex & MAX_RGB_COLOR_VALUE) / MAX_RGB_COLOR_VALUE_FLOAT
                           alpha:(CGFloat)((hex >> 24) & MAX_RGB_COLOR_VALUE) / MAX_RGB_COLOR_VALUE_FLOAT];
}

+ (UIColor *)colorWithRGB_Ext:(uint)hex {
    return [UIColor colorWithRed:(CGFloat)((hex >> 16) & MAX_RGB_COLOR_VALUE) / MAX_RGB_COLOR_VALUE_FLOAT
                           green:(CGFloat)((hex >> 8) & MAX_RGB_COLOR_VALUE) / MAX_RGB_COLOR_VALUE_FLOAT
                            blue:(CGFloat)(hex & MAX_RGB_COLOR_VALUE) / MAX_RGB_COLOR_VALUE_FLOAT
                           alpha:1.0];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString
{
    return [UIColor colorWithHex:hexString];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha
{
    int a = (int)(alpha * 255);

    return [UIColor colorWithHex:[hexString stringByAppendingFormat:@"%02lx", (long)a]];
}

+ (UIColor *)colorWithHex:(NSString *)hexString {
    if (hexString.length == 0) {
        return nil;
    }

    unsigned long hex;

    // chop off hash
    if ([hexString characterAtIndex:0] == '#') {
        hexString = [hexString substringFromIndex:1];
    }

    // depending on character count, generate a color
    NSInteger hexStringLength = hexString.length;

    if (hexStringLength == 3) {
        // RGB, once character each (each should be repeated)
        hexString = [NSString stringWithFormat:@"%c%c%c%c%c%c", [hexString characterAtIndex:0], [hexString characterAtIndex:0], [hexString characterAtIndex:1], [hexString characterAtIndex:1], [hexString characterAtIndex:2], [hexString characterAtIndex:2]];
        hex = strtoul(hexString.UTF8String, NULL, 16);

        return [self colorWithRGB_Ext:(uint)hex];
    } else if (hexStringLength == 4) {
        // RGBA, once character each (each should be repeated)
        hexString = [NSString stringWithFormat:@"%c%c%c%c%c%c%c%c", [hexString characterAtIndex:0], [hexString characterAtIndex:0], [hexString characterAtIndex:1], [hexString characterAtIndex:1], [hexString characterAtIndex:2], [hexString characterAtIndex:2], [hexString characterAtIndex:3], [hexString characterAtIndex:3]];
        hex = strtoul(hexString.UTF8String, NULL, 16);

        return [self colorWithRGBA_Ext:(uint)hex];
    } else if (hexStringLength == 6) {
        // RGB
        hex = strtoul(hexString.UTF8String, NULL, 16);

        return [self colorWithRGB_Ext:(uint)hex];
    } else if (hexStringLength == 8) {
        // RGBA
        hex = strtoul(hexString.UTF8String, NULL, 16);

        return [self colorWithRGBA_Ext:(uint)hex];
    }

    // illegal
    [NSException raise:@"Invalid Hex String" format:@"Hex string invalid: %@", hexString];

    return nil;
}

- (NSString *)hexString_Ext {
    const CGFloat *components = CGColorGetComponents(self.CGColor);

    NSInteger red = (int)(components[0] * MAX_RGB_COLOR_VALUE);
    NSInteger green = (int)(components[1] * MAX_RGB_COLOR_VALUE);
    NSInteger blue = (int)(components[2] * MAX_RGB_COLOR_VALUE);
    NSInteger alpha = (int)(components[3] * MAX_RGB_COLOR_VALUE);

    if (alpha < 255) {
        return [NSString stringWithFormat:@"#%02lx%02lx%02lx%02lx", (long)red, (long)green, (long)blue, (long)alpha];
    }

    return [NSString stringWithFormat:@"#%02lx%02lx%02lx", (long)red, (long)green, (long)blue];
}

- (CGFloat)r_Ext {
    const CGFloat *rgba = CGColorGetComponents(self.CGColor);

    return rgba[0];
}

- (CGFloat)g_Ext {
    const CGFloat *rgba = CGColorGetComponents(self.CGColor);

    return rgba[1];
}

- (CGFloat)b_Ext {
    const CGFloat *rgba = CGColorGetComponents(self.CGColor);

    return rgba[2];
}

- (CGFloat)a_Ext {
    const CGFloat *rgba = CGColorGetComponents(self.CGColor);

    return rgba[3];
}

@end
