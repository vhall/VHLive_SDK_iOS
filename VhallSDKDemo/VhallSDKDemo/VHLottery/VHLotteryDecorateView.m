//
//  VHLotteryDecorateView.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/3/20.
//

#import "VHLotteryDecorateView.h"

@implementation VHLotteryDecorateView

/// 让当前view不接受事件
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    return nil;
}

@end
