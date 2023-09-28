//
//  UILabel+VHConvenient.m
//  UIModel
//
//  Created by jinbang.li on 2022/3/1.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "UILabel+VHConvenient.h"
#import "UIColor+VUI.h"
@implementation UILabel (VHConvenient)
- (CGSize)contentSize {
    return [self textSizeIn:self.bounds.size];
}

- (CGSize)textSizeIn:(CGSize)size {
    NSLineBreakMode breakMode = self.lineBreakMode;
    UIFont *font = self.font;
    CGSize contentSize = CGSizeZero;
    //    if ([IOSDeviceConfig sharedConfig].isIOS7)
    //    {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = breakMode;
    paragraphStyle.alignment = self.textAlignment;
    NSDictionary *attributes = @{NSFontAttributeName : font,
                                 NSParagraphStyleAttributeName : paragraphStyle};
    contentSize = [self.text boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attributes context:nil].size;
    //    }
    //    else
    //    {
    //        contentSize = [self.text sizeWithFont:font constrainedToSize:size lineBreakMode:breakMode];
    //    }
    contentSize = CGSizeMake((int)contentSize.width + 1, (int)contentSize.height + 1);
    return contentSize;
}

+ (UILabel *)creatWithFont:(CGFloat)font TextColor:(NSString *)color {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = [UIColor colorWithHexString:color];
    label.numberOfLines = 0;
    return label;
}

+ (UILabel *)creatWithFont:(CGFloat)font TextColor:(NSString *)color Text:(NSString *)text {
    UILabel *label = [self creatWithFont:font TextColor:color];
    label.numberOfLines = 0;
    label.text = text;
    return label;
}
+ (UILabel *)speratorLineColor:(NSString *)hexString {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor colorWithHexString:hexString];
    return label;
}
@end
