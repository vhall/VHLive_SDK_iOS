//
//  VHReflect.m
//  UIModel
//
//  Created by jinbang.li on 2022/3/9.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHReflect.h"
#import <objc/message.h>
@implementation VHReflect
+ (Class)initBeautyEffectKit{
    ///反射机制
    Class fuKit = NSClassFromString(@"VHBFURender");
    Class beautyKit = NSClassFromString(@"VHBeautifyKit");
    Class beautyEffect;
    if ([beautyKit respondsToSelector:@selector(beautifyManagerWithModuleClass:)] ) {
        beautyEffect = [beautyKit performSelector:@selector(beautifyManagerWithModuleClass:) withObject:[fuKit class]];
    }else{
        beautyEffect = nil;
        NSLog(@"没有导入美颜库");
    }
    return beautyEffect;
}
+ (void)setBeautyEffect:(Class)beautyKit effectName:(NSString *)effectName value:(id)value{
    if ([beautyKit respondsToSelector:@selector(setEffectKey:toValue:)]) {
        SEL sel = NSSelectorFromString(@"setEffectKey:toValue:");
        ((void (*) (id, SEL, NSString *, id)) objc_msgSend) (beautyKit, sel, effectName, value);
    }else{
        NSLog(@"没有导入美颜库");
    }
}
/// 获取当前 module
+(id<IVHBeautifyModule>)currentModuleBeautyKit:(Class)beautyKit{
    id module;
    if ([beautyKit respondsToSelector:@selector(currentModule)] ) {
       module = [beautyKit performSelector:@selector(currentModule)];
    }else{
        module = nil;
        NSLog(@"没有导入美颜库");
    }
    return module;
}
///调整采集图像正方向
////// 调整采集图像正方向(❗️RTC中必须使用)
/// 需要按照OpenGL采集方向设置，目前VH_RTC应使用3
/// @param orientation 画面方向:上0 左1 下2 右3
+ (void)beautyKit:(Class)beauty setCaptureImageOrientation:(NSUInteger)orientation{
    SEL sel = NSSelectorFromString(@"setCaptureImageOrientation:");
    if ([beauty respondsToSelector:sel]) {
        ((void (*) (id, SEL, NSUInteger)) objc_msgSend) (self, sel, orientation);
    }else{
        NSLog(@"没有导入美颜库");
    }
}
+ (void)destoryBeautyEffectKit{
    Class beautyKit = NSClassFromString(@"VHBeautifyKit");
    if ([beautyKit respondsToSelector:@selector(destroy)]) {
        [beautyKit performSelector:@selector(destroy)];
    }
}
@end
