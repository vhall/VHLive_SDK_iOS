//
//  VHBeautifyKit.h
//  VHBeautifyKit
//
//  Created by LiGuoliang on 2021/12/8.
//

#import <Foundation/Foundation.h>
#import "IVHBeautifyModule.h"

@interface VHBeautifyKit : NSObject

/// 美颜开关
@property (nonatomic) BOOL enable;

/// 初始化美颜 (❗️请记得销毁)
+ (instancetype)beautifyManagerWithModuleClass:(Class<IVHBeautifyModule>)moduleClass;

/// 销毁
+ (void)destroy;

/// 获取当前 module
- (id<IVHBeautifyModule>)currentModule;

/// 调整采集图像正方向(❗️RTC中必须使用)
/// 需要按照OpenGL采集方向设置，目前VH_RTC应使用3
/// @param orientation 画面方向:上0 左1 下2 右3
- (void)setCaptureImageOrientation:(NSUInteger)orientation;

/// 设置美颜效果
/// @param key 美颜效果控制项
/// @param value 美颜效果值
- (void)setEffectKey:(VHBEffectKey)key toValue:(id)value;

- (instancetype)init NS_UNAVAILABLE;

@end
