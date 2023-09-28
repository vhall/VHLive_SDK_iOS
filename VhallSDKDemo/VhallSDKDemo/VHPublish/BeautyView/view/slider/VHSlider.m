//
//  VHSlider.m
//  UIModel
//
//  Created by jinbang.li on 2022/2/23.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHSlider.h"
#import "UIColor+VUI.h"
@interface VHSlider()
//slider的thumbView
@property (nonatomic, strong) UIView *thumbView;
//显示value的label
@property (nonatomic, strong) UILabel *valueLabel;

@property (nonatomic,strong) UILabel *displayLabel;
@end
@implementation VHSlider

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self addTarget:self action:@selector(sliderTouchDown:) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addTarget:self action:@selector(sliderTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [self setUpDisplay];
    }
    return self;
}
- (void)setUpDisplay{
    _displayLabel = [[UILabel alloc] init];
    _displayLabel.textColor = [UIColor  colorWithHex:@"#262626"];
    _displayLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_displayLabel];
    [_displayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(40);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(35);
        make.centerY.offset(0);
    }];
}
#pragma mark - Overwrite functions


- (CGRect)trackRectForBounds:(CGRect)bounds {
    /*! @brief 重写方法-返回进度条的bounds-修改进度条的高度 */
    bounds = [super trackRectForBounds:bounds];
    return CGRectMake(bounds.origin.x, bounds.origin.y + (bounds.size.height - VHRateScale * 2) / 2, bounds.size.width, VHRateScale *2);
}
//-(CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value{
//
//    rect.origin.x=rect.origin.x-10;
//
//    rect.size.width=rect.size.width+20;
//
//    return CGRectInset([super thumbRectForBounds:bounds trackRect:rect value:value],10,10);
//}
- (void)setValue:(float)value animated:(BOOL)animated {
    
    [super setValue:value animated:animated];
    [self sliderValueChanged:self];
}

- (void)setValue:(float)value {
    
    [super setValue:value];
    [self sliderValueChanged:self];
}

#pragma mark - Setter functions

- (void)setValueText:(NSString *)valueText {
    
    if (![_valueText isEqualToString:valueText]) {
        _valueText = valueText;
        
        self.valueLabel.text = valueText;
        [self.valueLabel sizeToFit];
        self.valueLabel.center = CGPointMake(self.thumbView.bounds.size.width / 2, -self.valueLabel.bounds.size.height / 2);
        
        if (!self.valueLabel.superview) {
            [self.thumbView addSubview:self.valueLabel];
        }
        _displayLabel.text = valueText;
    }
}


#pragma mark - Getter functions
- (UIView *)thumbView {
    if (@available(iOS 14.0, *)) {
        if (!_thumbView && self.subviews.count > 2) {
        _thumbView = self.subviews[2];
        }
        else {
        UIView *view = self.subviews[0];
        _thumbView = view;
        }
    }else{
        if (!_thumbView && self.subviews.count > 2) {
            _thumbView = self.subviews[2];
        }
    }
    return _thumbView;
}

- (UILabel *)valueLabel {
    
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _valueLabel.textColor = _valueTextColor ?: self.thumbTintColor;
        _valueLabel.font = _valueFont ?: [UIFont systemFontOfSize:14.0];
        _valueLabel.hidden = YES;
        _valueLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _valueLabel;
}


#pragma mark - Action functions

- (void)sliderTouchDown:(VHSlider *)sender {
    
    if (_touchDown) {
        _touchDown(sender);
    }
}

- (void)sliderValueChanged:(VHSlider *)sender {
    
    if (_valueChanged) {
        _valueChanged(sender);
    } else {
        sender.valueText = [NSString stringWithFormat:@"%.0f", sender.value];
    }
}

- (void)sliderTouchUpInside:(VHSlider *)sender {
    
    if (_touchUpInside) {
        _touchUpInside(sender);
    }
}


#pragma mark -

- (void)dealloc {
    
    NSLog(@"%s", __FUNCTION__);
}


@end
