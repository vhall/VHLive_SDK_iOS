//
//  VHBFURender.h
//  VHBFURender
//
//  Created by LiGuoliang on 2022/1/10.
//

#import <Foundation/Foundation.h>
#import "VHBeautifyEffectList.h"

NS_ASSUME_NONNULL_BEGIN

@interface VHBFURender : NSObject<IVHBeautifyModule>

///单例
+ (instancetype)BeautifyModule;

/// 开启和关闭美颜
- (void)enableBeautify:(BOOL)enable;

///美型+WebRTC采集：采集图像正方向 上左下右 0~3
- (void)setCaptureImageOrientation:(NSUInteger)imageOrientation;

@end

@interface VHBFURender (ext_1_1_0)
/// 获取默认值
- (id)beautifyValueForKey:(VHBEffectKey)effKey;

/// 自定义初始值
- (void)beautifyCustomDefaultKeys:(NSArray<VHBEffectKey> *)effkeys Values:(NSArray<id> *)effValue;

/// 重置到初始值
- (void)beautifySetToDefault;
@end

NS_ASSUME_NONNULL_END
