//
//  VHBeautyHeader.h
//  UIModel
//
//  Created by jinbang.li on 2022/3/1.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#ifndef VHBeautyHeader_h
#define VHBeautyHeader_h
typedef enum : NSUInteger {
    BeautyType_Beauty = 0, //美颜
    BeautyType_Filter = 1,  //滤镜
}BeautyType;
typedef enum : NSUInteger {
    AlertView_One = 0, //确定
    AlertView_Two = 1,  //取消，确实
}AlertViewType;

//以横屏为例 横屏292*375，竖屏375*206
#define kHRateSacle   (VHScreenHeight/375.0)//横屏
#define kVRateScale   (VHScreenWidth/375.0)//竖屏
//横竖屏比率
#define kAdaptScale (VH_KScreenIsLandscape?kHRateSacle:kVRateScale)
//头部高度45 + 10//55
#define kVHBeautyTopHeight  (kAdaptScale*45)
//滑动条高度 16 + 24//61
#define kVHSliderHeight  (kAdaptScale*20)
//美颜单元格高度 20+6+20+24
#define kVHCellBeautyHeight (kAdaptScale*46)
//美颜单元格宽度 44
#define kVHCellBeautyWidth (kAdaptScale*34)
//滤镜单元格高度
#define kVHCellFilterHeight (kAdaptScale*85)
//滤镜单元格宽度
#define kVHCellFilterWidth (kAdaptScale*48)
//弹框高度
#define kBeautyAlertViewHeight (kAdaptScale * 145.5)
//弹框宽度
#define kBeautyAlertViewWidth (kAdaptScale * 311)

//主色调
#define KMainColor [UIColor colorWithHexString:@"FB3A32"]

#define kServerNotAvaliable @"当前服务不可用，请联系客服"
#define kDefaultEffect @"确定恢复默认效果吗？"

#import "VHBeautyAlertView.h"
#import "VHSaveBeautyTool.h"
#import "VHAlertView.h"

#import "UIColor+VUI.h"
#import "UILabel+VHConvenient.h"
#import "UIButton+VHConvenient.h"

//反射管理模块
//#import "VHReflect.h"

#import <VHBeautifyKit/VHBeautifyKit.h>
#import <VHBFURender/VHBeautifyEffectList.h>
#import <VHBFURender/VHBFURender.h>
#endif /* VHBeautyHeader_h */
