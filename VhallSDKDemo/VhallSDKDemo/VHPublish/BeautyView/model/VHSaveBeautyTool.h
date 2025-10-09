//
//  VHSaveBeautyTool.h
//  UIModel
//
//  Created by jinbang.li on 2022/2/24.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VHBeautyModel.h"
#import "VHBeautifyKit/VHBeautifyKit.h"
//美颜key
// 美肤效果
#define VH_Effect_ColorLevel @"美白"               // 基础美白
#define VH_Effect_RedLevel @"红润"                // 肤色红润度
#define VH_Effect_BlurLevel @"磨皮"                 // 表皮磨皮强度
#define VH_Effect_Sharpen @"锐化"                 // 细节锐化程度

// 美颜效果
#define VH_Effect_HeavyBlur @"朦胧磨皮"           // 磨皮模式选择
#define VH_Effect_BlurType @"清晰"             // 清晰/朦胧/精细/均匀磨皮
#define VH_Effect_EyeBright @"亮眼"                // 眼睛亮度提升
#define VH_Effect_ToothWhiten @"美牙"              // 牙齿美白程度
#define VH_Effect_RemovePouchStrength @"黑眼圈"   // 黑眼圈去除强度
#define VH_Effect_RemoveNasolabialFoldsStrength @"法令纹" // 法令纹去除强度
#define VH_Effect_BrowSpace  @"眉距"    // 眉毛距离
#define VH_Effect_BrowThick  @"粗细"    // 眉毛粗细
#define VH_Effect_BrowHeight @"上下"    // 眉毛上下
#define VH_Effect_EyeLid @"眼睑"    // 眼睑
#define VH_Effect_EyeHeight @"位置"    // 眼睛位置
#define VH_Effect_EyeCircle @"圆眼"    // 圆眼睛

// 美型效果
#define VH_Effect_FaceShapeLevel @"脸型调整强度"    // 整体脸型调整幅度
#define VH_Effect_FaceShape @"脸型变形模式"         // 女神/网红/自然/精细变形
#define VH_Effect_EyeEnlargingV2 @"大眼"             // 眼睛放大效果
#define VH_Effect_CheekThinning @"瘦脸"            // 下巴收窄强度
#define VH_Effect_CheekV @"V脸"                   // 颧骨立体感
#define VH_Effect_FaceThreed @"立体"              // 五官立体
#define VH_Effect_CheekNarrowV2 @"窄脸"            // 脸型宽度调整
#define VH_Effect_CheekShort @"短脸"               // 脸型长度调整
#define VH_Effect_CheekSmallV2 @"小脸"             // 整体脸型缩小
#define VH_Effect_IntensityNoseV2 @"瘦鼻"          // 鼻子缩小强度
#define VH_Effect_IntensityForeheadV2 @"额头"      // 额头饱满度调整
#define VH_Effect_IntensityMouthV2 @"嘴巴"        // 嘴部形状调整
#define VH_Effect_IntensityLipThick @"厚度"       // 嘴唇厚度
#define VH_Effect_IntensityChin @"下巴"            // 下巴长度调整
#define VH_Effect_IntensityPhiltrum @"人中"       // 人中深度调整
#define VH_Effect_IntensityLongNose @"长鼻"    // 鼻子长度调整
#define VH_Effect_IntensityEyeSpace @"眼距"        // 眼睛间距调整
#define VH_Effect_IntensityEyeRotate @"角度"   // 眼睛倾斜角度调整
#define VH_Effect_IntensitySmile @"微笑"      // 嘴角上扬程度
#define VH_Effect_IntensityCanthus @"开眼角"       // 眼角开大效果
#define VH_Effect_IntensityCheekbones @"瘦颧骨"     // 颧骨宽度调整
#define VH_Effect_IntensityLowerJaw @"下颚骨"    // 下颌角尖锐度调整

//滤镜key
// 滤镜效果
#define VH_Effect_FilterName @"滤镜名称"           // 滤镜类型选择
#define VH_Effect_FilterLevel @"滤镜强度"          // 滤镜效果浓度

#define VH_Filter_Origin @"原图"
#define VH_Filter_zhiran1 @"自然"
#define VH_Filter_xiaoqingxin1 @"小清新"
#define VH_Filter_nuansediao1 @"暖色调"
#define VH_Filter_bailiang1 @"白亮"
#define VH_Filter_fennen1 @"粉嫩"
#define VH_Filter_lengsediao1 @"冷色调"
#define VH_Filter_fennen8 @"红润调"
#define VH_Filter_gexing3 @"温暖"
#define VH_Filter_gexing8 @"幸运"
#define VH_Filter_mitao1 @"蜜桃"
#define VH_Filter_zhiganhui1 @"质感灰"
#define VH_Filter_xiaoqingxin6 @"甜美"
#define VH_Filter_xiaoqingxin5 @"粉红"
#define VH_Filter_nuansediao3  @"森林"
#define VH_Filter_lengsediao10  @"樱花"
#define VH_Filter_fennen5 @"淡雅"
#define VH_Filter_lengsediao9 @"阳光"
#define VH_Filter_bailiang6 @"新白"
#define VH_Filter_lengsediao8 @"秋色"

//滤镜格式与level
#define VH_Filter_Name @"filterName"
#define VH_Filter_Level @"filterLevel"
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
