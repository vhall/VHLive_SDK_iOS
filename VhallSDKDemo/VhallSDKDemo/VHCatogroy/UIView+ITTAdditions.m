//
//  UIView+ITTAdditions.m
//  iTotemFrame
//
//  Created by jack 廉洁 on 3/15/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "UIView+ITTAdditions.h"

UIInterfaceOrientation ITTInterfaceOrientation() {
    UIInterfaceOrientation orient = [UIApplication sharedApplication].statusBarOrientation;

    return orient;
}

CGRect ITTScreenBounds() {
    CGRect bounds = [UIScreen mainScreen].bounds;

    if (UIInterfaceOrientationIsLandscape(ITTInterfaceOrientation())) {
        CGFloat width = bounds.size.width;
        bounds.size.width = bounds.size.height;
        bounds.size.height = width;
    }

    return bounds;
}

@implementation UIView (ITTAdditions)

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)left {
    return self.frame.origin.x;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;

    frame.origin.x = x;
    self.frame = frame;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)top {
    return self.frame.origin.y;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;

    frame.origin.y = y;
    self.frame = frame;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;

    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;

    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerX {
    return self.center.x;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerY {
    return self.center.y;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)width {
    return self.frame.size.width;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;

    frame.size.width = width;
    self.frame = frame;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)height {
    return self.frame.size.height;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;

    frame.size.height = height;
    self.frame = frame;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ttScreenX {
    CGFloat x = 0;

    for (UIView *view = self; view; view = view.superview) {
        x += view.left;
    }

    return x;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ttScreenY {
    CGFloat y = 0;

    for (UIView *view = self; view; view = view.superview) {
        y += view.top;
    }

    return y;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)screenViewX {
    CGFloat x = 0;

    for (UIView *view = self; view; view = view.superview) {
        x += view.left;

        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)view;
            x -= scrollView.contentOffset.x;
        }
    }

    return x;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)screenViewY {
    CGFloat y = 0;

    for (UIView *view = self; view; view = view.superview) {
        y += view.top;

        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)view;
            y -= scrollView.contentOffset.y;
        }
    }

    return y;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGRect)screenFrame {
    return CGRectMake(self.screenViewX, self.screenViewY, self.width, self.height);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)origin {
    return self.frame.origin;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;

    frame.origin = origin;
    self.frame = frame;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)size {
    return self.frame.size;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;

    frame.size = size;
    self.frame = frame;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)orientationWidth {
    return UIInterfaceOrientationIsLandscape(ITTInterfaceOrientation())
    ? self.height : self.width;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)orientationHeight {
    return UIInterfaceOrientationIsLandscape(ITTInterfaceOrientation())
    ? self.width : self.height;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *)descendantOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls]) {
        return self;
    }

    for (UIView *child in self.subviews) {
        UIView *it = [child descendantOrSelfWithClass:cls];

        if (it) {
            return it;
        }
    }

    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *)ancestorOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls]) {
        return self;
    } else if (self.superview) {
        return [self.superview ancestorOrSelfWithClass:cls];
    } else {
        return nil;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView *child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)offsetFromView:(UIView *)otherView {
    CGFloat x = 0, y = 0;

    for (UIView *view = self; view && view != otherView; view = view.superview) {
        x += view.left;
        y += view.top;
    }

    return CGPointMake(x, y);
}

- (UIViewController *)viewController
{
    UIResponder *next = self.nextResponder;

    while (next != nil) {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }

        next = next.nextResponder;
    }
    return nil;
}

- (void)radiusTool:(CGFloat)cornerRadius borderWidth:(CGFloat)width borderColor:(UIColor *)borderColor {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius; //设置那个圆角的有多圆
    self.layer.borderWidth = width;         //设置边框的宽度，
    self.layer.borderColor = [borderColor CGColor];
}

@end
