//
//  VHSaveBeautyTool.h
//  UIModel
//
//  Created by jinbang.li on 2022/2/24.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VHBeautyModel.h"

//美颜key
#define VH_Effect_ColorLevel @"美白"
#define VH_Effect_RedLevel @"红润"
#define VH_Effect_BlurLevel @"磨皮"
#define VH_Effect_Sharpen @"锐化"
#define VH_Effect_EyeEnlargingV2 @"大眼"
#define VH_Effect_CheekThinning @"瘦脸"
#define VH_Effect_IntensityForeheadV2 @"额头"
#define VH_Effect_IntensityNoseV2 @"鼻子"
#define VH_Effect_IntensityMouthV2 @"嘴巴"
#define VH_Effect_EyeBright @"亮眼"
#define VH_Effect_ToothWhiten @"白牙"
//滤镜key
#define VH_Filter_Origin @"原图"
#define VH_Filter_zhiran1 @"自然"
#define VH_Filter_xiaoqingxin1 @"小清新"
#define VH_Filter_nuansediao1 @"暖色调"
#define VH_Filter_bailiang1 @"白亮"
#define VH_Filter_fennen1 @"粉嫩"
#define VH_Filter_lengsediao1 @"冷色调"
//读取数据
typedef enum : NSUInteger {
    Effect_OpenBeauty = 0, //开启美颜
    Effect_CloseBeauty = 1,  //关闭美颜
    Effect_Filter,//滤镜特效
}EffectType;
NS_ASSUME_NONNULL_BEGIN

@interface VHSaveBeautyTool : NSObject
///美颜配置的KV
+ (NSMutableDictionary <NSString *,VHBeautyModel *>*)beautyConfigModel;
///列表显示的模型
+ (NSArray <NSArray <VHBeautyModel *> *>*)beautyViewModelArray;
///归档美颜的配置值
+ (void)writeCurrentBeautyEffectConfig:(NSMutableDictionary <NSString *,VHBeautyModel *>*)model;
///解归档当前的配置值
+ (NSMutableDictionary <NSString *,VHBeautyModel *>*)readLastBeautyEffectConfig;
///恢复默认值
+ (NSMutableDictionary <NSString *,VHBeautyModel *>*)resetConfig:(NSMutableDictionary <NSString *,VHBeautyModel *>*)beautifig;
//关闭美颜置为最小值置为minValue
+ (void)closeBeauty:(NSArray <VHBeautyModel *>*)beautyModels beautifyKit:(VHBeautifyKit *)beautyKit closeBeautyEffect:(BOOL)close;
///应用美颜的缓存值
+ (void)applyFilterCacheBeautifyKit:(VHBeautifyKit *)beautyKit;
///存储美颜和滤镜的开关状态
+ (void)saveBeautyStatus:(BOOL)beautyEffectStatus filterIndex:(NSUInteger)filterIndex;
///读取美颜配置
+ (BOOL)readBeautyEnableStatus;
///读取滤镜配置
+ (NSUInteger)readFilterIndex;
///读取缓存配置
+ (BOOL)readSaveCacheStatus;
@end

NS_ASSUME_NONNULL_END

