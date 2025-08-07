//
//  VHReflect.h
//  UIModel
//
//  Created by jinbang.li on 2022/3/9.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VHBeautifyKit/IVHBeautifyModule.h>
#import <VHBeautifyKit/IVHBeautifyModule.h>
NS_ASSUME_NONNULL_BEGIN

@interface VHReflect : NSObject
///初始化美颜模块
+ (Class)initBeautyEffectKit;
///设置美颜,滤镜效果
+ (void)setBeautyEffect:(Class)beautyKit effectName:(NSString *)effectName value:(id)value;
/// 获取当前 module
+ (id<IVHBeautifyModule>)currentModuleBeautyKit:(Class)beautyKit;
///调整采集图像正方向
////// 调整采集图像正方向(❗️RTC中必须使用)
/// 需要按照OpenGL采集方向设置，目前VH_RTC应使用3
/// @param orientation 画面方向:上0 左1 下2 右3
+ (void)beautyKit:(Class)beauty setCaptureImageOrientation:(NSUInteger)orientation;
///释放美颜模块
+ (void)destoryBeautyEffectKit;
@end

NS_ASSUME_NONNULL_END
