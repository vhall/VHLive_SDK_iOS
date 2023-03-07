//
//  VHSliderView.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/15.
//

#import "VHSliderView.h"

// 扩大按钮点击范围
#define thumbBound_x 0
#define thumbBound_y 0

@interface VHSliderView ()
{
    CGRect lastBounds;
}

@end

@implementation VHSliderView

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
{

    rect.origin.x = rect.origin.x;
    rect.size.width = rect.size.width ;
    CGRect result = [super thumbRectForBounds:bounds trackRect:rect value:value];
    
    lastBounds = result;
    return result;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    UIView *result = [super hitTest:point withEvent:event];
    if (point.x < 0 || point.x > self.bounds.size.width){
        return result;
    }

    if ((point.y >= -thumbBound_y) && (point.y < lastBounds.size.height + thumbBound_y)) {
        float value = 0.0;
        value = point.x - self.bounds.origin.x;
        value = value/self.bounds.size.width;
        
        value = value < 0? 0 : value;
        value = value > 1? 1: value;
        
        value = value * (self.maximumValue - self.minimumValue) + self.minimumValue;
        [self setValue:value animated:YES];
    }
    return result;
    
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    BOOL result = [super pointInside:point withEvent:event];
//    if (!result && point.y > -10) { 点击范围向下偏移10
    if (!result && point.y > 0) {

        if ((point.x >= lastBounds.origin.x - thumbBound_x) && (point.x <= (lastBounds.origin.x + lastBounds.size.width + thumbBound_x)) && (point.y < (lastBounds.size.height + thumbBound_y))) {
            result = YES;
        }
      
    }
      return result;
}

@end
