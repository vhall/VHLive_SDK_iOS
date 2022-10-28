//
//  VHDocWatermarkModel.h
//  VHDocument
//
//  Created by LiGuoliang on 2022/5/16.
//  Copyright © 2022 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class VHDocWatermarkModel;

@protocol VHDocWatermarkModelDelegate <NSObject>
@optional
/// 水印属性设置错误
- (void)watermarkSettingOptionError:(NSError *)error;
@end

@interface VHDocWatermarkModel : NSObject
///水印内容 (count 1~20)
@property (nonatomic) NSString *context;
/// 颜色 (default #000000)
@property (nonatomic) NSString *color;
/// 角度 (default 15度)
@property (nonatomic) CGFloat angle;
/// 不透明度 (不透明 100~0 透明)
@property (nonatomic) CGFloat opacity;
/// 字号 (min 12~48 max)
@property (nonatomic) NSInteger fontSize;

/// 初始化方法
/// @param context 水印内容
+ (instancetype)watermarkWithContext:(NSString *)context delegate:(id<VHDocWatermarkModelDelegate>)delegate;

/// 输出内容
- (NSString *)jsonString;

- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
