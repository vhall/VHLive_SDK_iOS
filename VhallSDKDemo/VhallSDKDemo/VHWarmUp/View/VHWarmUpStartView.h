//
//  VHWarmUpStartView.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/1/30.
//

#import <UIKit/UIKit.h>

typedef void (^ClickStartBtn)(void);

@interface VHWarmUpStartView : UIView

@property (nonatomic, copy) ClickStartBtn clickStartBtn;

/// 显示
- (void)show;

/// 隐藏
- (void)dismiss;

@end
