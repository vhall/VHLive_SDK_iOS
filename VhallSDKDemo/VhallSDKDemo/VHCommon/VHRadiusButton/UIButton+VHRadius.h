//
//  UIButton+VHRadius.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/8/14.
//

#import <UIKit/UIKit.h>

@interface UIButton (VHRadius)

//扩大按钮点击范围
- (void)setRadiusEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;

@end
