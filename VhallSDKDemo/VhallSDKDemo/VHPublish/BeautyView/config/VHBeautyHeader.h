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


#define kServerNotAvaliable @"当前服务不可用，请联系客服"
#define kDefaultEffect @"确定恢复默认效果吗？"

#import <FURenderKit/FURenderKit.h>
#import <VHBeautifyKit/VHBeautifyKit.h>
#import <VHBFURender/VHBFURender.h>
#import <VHBFURender/VHBeautifyEffectList.h>

#import "VHBeautyAlertView.h"
#import "VHSaveBeautyTool.h"
#import "VHAlertView.h"

#import "UIColor+VUI.h"
#import "UILabel+VHConvenient.h"
#import "UIButton+VHConvenient.h"

#endif /* VHBeautyHeader_h */
