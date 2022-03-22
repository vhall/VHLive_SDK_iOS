//
//  UIButton+VHConvenient.m
//  UIModel
//
//  Created by jinbang.li on 2022/2/28.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "UIButton+VHConvenient.h"
#import "UIColor+VUI.h"
#import <objc/runtime.h>
static char *overViewKey;
@implementation UIButton (VHConvenient)
- (instancetype)init {
    if (self = [super init]) {
        [self setAdjustsImageWhenHighlighted:NO]; //去掉高亮效果
    }
    return self;
}

- (void)handleClickEvent:(UIControlEvents)aEvent withClickBlock:(ActionBlock)buttonClickBlock {
    objc_setAssociatedObject(self, &overViewKey, buttonClickBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(buttonClick) forControlEvents:aEvent];
}

- (void)buttonClick {
    ActionBlock blockClick = objc_getAssociatedObject(self, &overViewKey);

    if (blockClick != nil) {
        blockClick();
    }
}
+ (UIButton *)creatWithTitle:(NSString *)title titleFont:(CGFloat)font titleColor:(NSString *)colorStr backgroundColor:(NSString *)bgColorStr {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:colorStr] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithHexString:bgColorStr];
    return button;
}
+ (UIButton *)creatWithTitle:(NSString *)title titleFont:(CGFloat)font titleColor:(NSString *)colorStr backgroundColor:(NSString *)bgColorStr target:(id)target clickAction:(SEL)clickAction {
    UIButton *button = [self creatWithTitle:title titleFont:font titleColor:colorStr backgroundColor:bgColorStr];
    if (clickAction) {
        [button addTarget:target
                      action:clickAction
            forControlEvents:UIControlEventTouchUpInside];
    }
    return button;
}

- (void)setImageUpTitleDownWithSpacing:(CGFloat)spacing {
    // lower the text and push it left so it appears centered
    //  below the image
    CGSize imageSize = [self imageForState:UIControlStateNormal].size;
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + spacing), 0.0);

    // raise the image and push it right so it appears centered
    //  above the text
    NSString *titleStr = [self titleForState:UIControlStateNormal] ? [self titleForState:UIControlStateNormal] : [self attributedTitleForState:UIControlStateNormal].string;
    //这里 富文本不能处理    因为font 可能不一致
    CGSize titleSize = SS_SINGLELINE_TEXTSIZE(titleStr, self.titleLabel.font);
    self.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 0.0, 0.0, -titleSize.width);
}

- (void)setImageRightTitleLeftWithSpacing:(CGFloat)spacing {
    CGSize imageSize = [self imageForState:UIControlStateNormal].size;
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageSize.width + spacing), 0, imageSize.width);

    CGSize titleSize = SS_SINGLELINE_TEXTSIZE([self titleForState:UIControlStateNormal], self.titleLabel.font);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, titleSize.width, 0, -(titleSize.width + spacing));
}

- (void)setDefaultImageTitleStyleWithSpacing:(CGFloat)spacing {
    CGFloat delta = spacing / 2.f;
    self.imageEdgeInsets = UIEdgeInsetsMake(0, -delta, 0, delta);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, delta, 0, -delta);
}

- (void)setEdgeInsetsWithType:(SSEdgeInsetsType)edgeInsetsType marginType:(SSMarginType)marginType margin:(CGFloat)margin {
    CGSize itemSize = CGSizeZero;
    if (edgeInsetsType == SSEdgeInsetsTypeTitle) {
        itemSize = SS_SINGLELINE_TEXTSIZE([self titleForState:UIControlStateNormal], self.titleLabel.font);
    } else {
        itemSize = [self imageForState:UIControlStateNormal].size;
    }

    CGFloat horizontalDelta = (CGRectGetWidth(self.frame) - itemSize.width) / 2.f - margin;
    CGFloat vertivalDelta = (CGRectGetHeight(self.frame) - itemSize.height) / 2.f - margin;

    NSInteger horizontalSignFlag = 1;
    NSInteger verticalSignFlag = 1;

    switch (marginType) {
        case SSMarginTypeTop: {
            horizontalSignFlag = 0;
            verticalSignFlag = -1;
        } break;
        case SSMarginTypeLeft: {
            horizontalSignFlag = -1;
            verticalSignFlag = 0;
        } break;
        case SSMarginTypeBottom: {
            horizontalSignFlag = 0;
            verticalSignFlag = 1;
        } break;
        case SSMarginTypeRight: {
            horizontalSignFlag = 1;
            verticalSignFlag = 0;
        } break;
        case SSMarginTypeLeftTop: {
            horizontalSignFlag = -1;
            verticalSignFlag = -1;
        } break;
        case SSMarginTypeLeftBottom: {
            horizontalSignFlag = -1;
            verticalSignFlag = 1;
        } break;
        case SSMarginTypeRightTop: {
            horizontalSignFlag = 1;
            verticalSignFlag = -1;
        } break;
        case SSMarginTypeRightBottom: {
            horizontalSignFlag = 1;
            verticalSignFlag = 1;
        } break;

        default:
            break;
    }
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(vertivalDelta * verticalSignFlag, horizontalDelta * horizontalSignFlag, -vertivalDelta * verticalSignFlag, -horizontalDelta * horizontalSignFlag);
    if (edgeInsetsType == SSEdgeInsetsTypeTitle) {
        self.titleEdgeInsets = edgeInsets;
    } else {
        self.imageEdgeInsets = edgeInsets;
    }
}

@end
