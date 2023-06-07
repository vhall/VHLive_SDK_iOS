//
//  VHLiveSaleAnimationTool.m
//  UIModel
//
//  Created by 郭超 on 2022/7/25.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHLiveSaleAnimationTool.h"

@implementation VHLiveSaleAnimationTool
+ (void)praiseAnimation:(NSString *)imageUrl view:(UIView *)view {
    CGRect frame = view.frame;

    UIImageView *imageView = [[UIImageView alloc] init];

    imageView.image = [UIImage imageNamed:imageUrl];

    CGFloat screenScale = [UIScreen mainScreen].scale;

    CGFloat width = CGImageGetWidth(imageView.image.CGImage) / screenScale;
    CGFloat height = CGImageGetHeight(imageView.image.CGImage) / screenScale;

    float x = frame.size.width - 40;
    float y = frame.size.height - SAFE_BOTTOM - 60;

    //  初始frame，即设置了动画的起点
    imageView.frame = CGRectMake(x, y, width, height);
    //  初始化imageView透明度为0
    imageView.alpha = 0;
    imageView.backgroundColor = [UIColor clearColor];
    imageView.clipsToBounds = YES;

    // 生成一个作为速度参数的随机数
    CGFloat speed = 1 / round(random() % 900) + 0.6;
    //  动画执行时间
    NSTimeInterval duration = 4 * speed;

    [UIView animateWithDuration:0.2
                     animations:^{
        imageView.alpha = 0.8;
        int maxY = round(random() % 100) + 30;
        imageView.frame = CGRectMake(x, y - maxY, width, height);
        CGAffineTransform transfrom = CGAffineTransformMakeScale(1.5, 1.5);
        imageView.transform = CGAffineTransformScale(transfrom, 1, 1);
    }];
    [view addSubview:imageView];
    //  随机产生一个动画结束点的X值
    CGFloat finishX = frame.size.width - round(random() % 120);
    //  动画结束点的Y值
    CGFloat finishY = Screen_Height - 280;
    //  imageView在运动过程中的缩放比例
    CGFloat scale = round(random() % 2) + 2;

    //  如果得到的时间是无穷大，就重新附一个值（这里要特别注意，请看下面的特别提醒）
    if (duration == INFINITY) {
        duration = 2.412346;
    }

    //  开始动画
    [UIView beginAnimations:nil context:(__bridge void *_Nullable)(imageView)];
    //  设置动画时间
    [UIView setAnimationDuration:duration];
    //  设置imageView的结束frame
    imageView.frame = CGRectMake(finishX, finishY, width * scale, height * scale);

    //  设置渐渐消失的效果，这里的时间最好和动画时间一致
    [UIView animateWithDuration:duration
                     animations:^{
        imageView.alpha = 0;
    }
                     completion:^(BOOL finished) {
        [imageView removeFromSuperview];
    }];

    //  结束动画，调用onAnimationComplete:finished:context:函数
    [UIView setAnimationDidStopSelector:@selector(onAnimationComplete:finished:context:)];
    //  设置动画代理
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

/// 动画完后销毁iamgeView
- (void)onAnimationComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    UIImageView *imageView = (__bridge UIImageView *)(context);

    [imageView removeFromSuperview];
    imageView = nil;
}

@end
