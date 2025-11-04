//
//  VHMarqueeOptionModel.h
//  VHLive
//
//  Created by 郭超 on 2024/3/4.
//  Copyright © 2024 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/// 选填，跑马灯配置
@interface VHMarqueeOptionModel : NSObject

/// 是否开启 默认不开启
@property (nonatomic, assign) BOOL enable;

/// 跑马灯的文字 必填
@property (nonatomic, copy) NSString *text;

/// 展示方式：0滚动 1闪动 默认0
@property (nonatomic, assign) NSInteger displayType;

///  文字颜色
@property (nonatomic, strong) UIColor *color;

/// 下次跑马灯开始与本次开始的时间间隔，秒为单位
@property (nonatomic, assign) NSTimeInterval interval;

/// 跑马灯移动速度 单位毫秒 3000快 6000中 10000慢（滚动时传入，闪动时不需要）
@property (nonatomic, assign) NSTimeInterval speed;

/// 跑马灯位置，1 随机 2上 3中 4下
@property (nonatomic, assign) NSInteger position;

/// 透明度 值为0-1 默认0.5隐藏
@property (nonatomic, assign) CGFloat alpha;

/// 文字大小
@property (nonatomic, assign) CGFloat size;

@end
