//
//  IVHBeautifyModule.h
//  VHLSS
//
//  Created by LiGuoliang on 2021/12/8.
//  Copyright © 2021 vhall. All rights reserved.
//
#ifndef IVHBeautifyModule_h
#define IVHBeautifyModule_h

#import <CoreMedia/CoreMedia.h>
#import <UIKit/UIKit.h>

typedef NSString *VHBEffectKey NS_TYPED_EXTENSIBLE_ENUM;
typedef NSString *VHBEffectFilterValue NS_TYPED_EXTENSIBLE_ENUM;

typedef void(^handleOutputWithProcess)(CMSampleBufferRef ref, uint64_t ts);

@protocol IVHBeautifyModule <NSObject>
@required

/// 初始化
+ (instancetype)BeautifyModule;

/// 针对sampleBuffer进行操作
/// @param sampleBuffer 采集后的sampleBuffer
/// @param ts 原时间(可直接传出)
/// @param handle 操作结束后传出的数据
- (void)processedSampleBuffer:(CMSampleBufferRef)sampleBuffer pts:(uint64_t)ts handle:(handleOutputWithProcess)handle;

/// 本地预览画面
- (UIView *)preView;

// module 是否开启
- (void)enableBeautify:(BOOL)enable;

// module 设置美颜效果
- (void)setEffectKey:(VHBEffectKey)key toValue:(id)value;

// module 设置画面方向
- (void)setCaptureImageOrientation:(NSUInteger)orientation;
@end

#endif /* IVHBeautifyModule_h */

