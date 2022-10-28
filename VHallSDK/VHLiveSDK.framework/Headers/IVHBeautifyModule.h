//
//  IVHBeautifyModule.h
//  VHLSS
//
//  Created by LiGuoliang on 2021/12/8.
//  Copyright © 2021 vhall. All rights reserved.
//
#ifndef IVHBeautifyModule_h
#define IVHBeautifyModule_h

typedef void(^handleOutputWithProcess)(CMSampleBufferRef, uint64_t);

@protocol IVHBeautifyModule <NSObject>

/// 针对sampleBuffer进行加工
/// @param sampleBuffer 采集后的sampleBuffer
/// @param ts 原时间(可直接传出)
/// @param handle 操作结束后传出的数据
- (void)processedSampleBuffer:(CMSampleBufferRef)sampleBuffer pts:(uint64_t)ts handle:(handleOutputWithProcess)handle;


/// 本地预览画面
- (UIView *)preView;

@end

#endif /* IVHBeautifyModule_h */
