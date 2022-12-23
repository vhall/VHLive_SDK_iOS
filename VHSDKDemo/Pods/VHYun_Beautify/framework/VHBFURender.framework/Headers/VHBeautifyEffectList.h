//
//  VHBeautifyEffectList.h
//  VHBeautifyKit
//
//  Created by LiGuoliang on 2021/12/10.
//
#import <Foundation/Foundation.h>
#import "IVHBeautifyModule.h"

#pragma mark- FaceUnity
/** 美肤 */

FOUNDATION_EXTERN VHBEffectKey const eff_key_FU_ColorLevel;    ///< 美白 [范围 0.0-1.0] [默认值0.2]
FOUNDATION_EXTERN VHBEffectKey const eff_key_FU_RedLevel;      ///< 红润 [范围 0.0-1.0] [默认值0.5]
FOUNDATION_EXTERN VHBEffectKey const eff_key_FU_BlurLevel;   ///< 磨皮 [范围0.0-6.0] [默认6.0]
FOUNDATION_EXTERN VHBEffectKey const eff_key_FU_Sharpen;       ///< 锐化 [范围0.0-1.0] [默认0.2]

/** 滤镜 */
FOUNDATION_EXTERN VHBEffectKey const eff_key_FU_FilterName;     ///< 滤镜名称 [范围 字符串]
FOUNDATION_EXTERN VHBEffectKey const eff_key_FU_FilterLevel;    ///< 滤镜效果 [范围 0.0～1.0] [默认1.0]

/** 美颜 */
FOUNDATION_EXTERN VHBEffectKey const eff_key_FU_HeavyBlur;       ///< 朦胧磨皮 [0为清晰磨皮，1为朦胧磨皮]
FOUNDATION_EXTERN VHBEffectKey const eff_key_FU_BlurType;        ///< [0 清晰磨皮 1 朦胧磨皮 2精细磨皮 3均匀磨皮][条件heavy_blur:0]

/** !! ---- 高级美颜功能，需要相应证书权限才能使用---- !! */
FOUNDATION_EXTERN VHBEffectKey const eff_key_FU_EyeBright;     ///< 亮眼 [范围0.0-1.0] [默认值1.0]
FOUNDATION_EXTERN VHBEffectKey const eff_key_FU_ToothWhiten;   ///< 美牙 [范围 0.0-1.0] [默认值1.0]
FOUNDATION_EXTERN VHBEffectKey const eff_key_FU_RemovePouchStrength;   ///< 去黑眼圈 [范围0.0~1.0] [默认0.0]
FOUNDATION_EXTERN VHBEffectKey const eff_key_FU_RemoveNasolabialFoldsStrength; ///< 去法令纹 [范围0.0~1.0] [默认0.0]

/** 美型 */
FOUNDATION_EXTERN VHBEffectKey const eff_key_FU_FaceShapeLevel;    ///< [范围 0.0-1.0] [默认值1.0]
FOUNDATION_EXTERN VHBEffectKey const eff_key_FU_FaceShape;           ///< 变形 [0:女神变形 1:网红变形 2:自然变形 3:默认变形 4:精细变形] [默认4]
FOUNDATION_EXTERN VHBEffectKey const eff_key_FU_EyeEnlargingV2;    ///< 大眼 [范围0.0-1.0] [默认0.0]
FOUNDATION_EXTERN VHBEffectKey const eff_key_FU_CheekThinning;     ///< 瘦脸 [范围0.0-1.0] [默认0.0]
FOUNDATION_EXTERN VHBEffectKey const eff_key_FU_CheekV;            ///< v脸 [范围0.0-1.0] [默认0.0]
FOUNDATION_EXTERN VHBEffectKey const eff_key_FU_CheekNarrowV2;       ///< 窄脸 [范围0.0-1.0] [默认0.0]
FOUNDATION_EXTERN VHBEffectKey const eff_key_FU_CheekShort;          ///< 短脸 [范围0.0-1.0] [默认0.0]
FOUNDATION_EXTERN VHBEffectKey const eff_key_FU_CheekSmallV2;        ///< 小脸 [范围0.0-1.0] [默认0.0]
FOUNDATION_EXTERN VHBEffectKey const eff_key_FU_IntensityNoseV2;   ///< 瘦鼻 [范围0.0-1.0] [默认0.0]
FOUNDATION_EXTERN VHBEffectKey const eff_key_FU_IntensityForeheadV2;   ///< 额头调整 [范围0.0-1.0] [默认0.5]
FOUNDATION_EXTERN VHBEffectKey const eff_key_FU_IntensityMouthV2;  ///< 嘴巴调整 [范围0.0-1.0] [默认0.5]
FOUNDATION_EXTERN VHBEffectKey const eff_key_FU_IntensityChin;     ///< 下巴调整 [范围0.0-1.0] [默认0.5]
FOUNDATION_EXTERN VHBEffectKey const eff_key_FU_IntensityPhiltrum; ///< 人中调节 [范围0.0~1.0] [默认0.5]
FOUNDATION_EXTERN VHBEffectKey const eff_key_FU_IntensityLongNose; ///< 鼻子长度 调节[范围0.0~1.0] [默认0.5]
FOUNDATION_EXTERN VHBEffectKey const eff_key_FU_IntensityEyeSpace; ///< 眼距调节 [范围0.0~1.0] [默认0.5]
FOUNDATION_EXTERN VHBEffectKey const eff_key_FU_IntensityEyeRotate;    ///< 眼睛角度 调节[范围0.0~1.0] [默认0.5]
FOUNDATION_EXTERN VHBEffectKey const eff_key_FU_IntensitySmile;    ///< 微笑嘴角 [范围0.0~1.0] [默认0.0]
FOUNDATION_EXTERN VHBEffectKey const eff_key_FU_IntensityCanthus;  ///< 开眼角 [范围0.0~1.0] [默认0.0]
FOUNDATION_EXTERN VHBEffectKey const eff_key_FU_IntensityCheekbones; ///< 瘦颧骨 [范围0.0~1.0] [默认0.0]
FOUNDATION_EXTERN VHBEffectKey const eff_key_FU_IntensityLowerJaw;  ///< 瘦下颌骨 [范围0.0~1.0] [默认0.0]
// FOUNDATION_EXTERN VHBEffectKey const eff_key_FU_IntensityEyeCircle;    ///< ??

/** FilterName */
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_origin;    // 原图",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_bailiang1;    // 白亮1",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_bailiang2;    // 白亮2",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_bailiang3;    // 白亮3",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_bailiang4;    // 白亮4",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_bailiang5;    // 白亮5",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_bailiang6;    // 白亮6",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_bailiang7;    // 白亮7",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_fennen1;    // 粉嫩1",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_fennen2;    // 粉嫩2",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_fennen3;    // 粉嫩3",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_fennen4;    // 粉嫩4",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_fennen5;    // 粉嫩5",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_fennen6;    // 粉嫩6",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_fennen7;    // 粉嫩7",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_fennen8;    // 粉嫩8",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_gexing1;    // 个性1",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_gexing2;    // 个性2",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_gexing3;    // 个性3",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_gexing4;    // 个性4",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_gexing5;    // 个性5",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_gexing6;    // 个性6",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_gexing7;    // 个性7",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_gexing8;    // 个性8",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_gexing9;    // 个性9",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_gexing10;    // 个性10",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_gexing11;    // 个性11",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_heibai1;    // 黑白1",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_heibai2;    // 黑白2",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_heibai3;    // 黑白3",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_heibai4;    // 黑白4",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_heibai5;    // 黑白5",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_lengsediao1;    // 冷色调1",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_lengsediao2;    // 冷色调2",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_lengsediao3;    // 冷色调3",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_lengsediao4;    // 冷色调4",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_lengsediao5;    // 冷色调5",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_lengsediao6;    // 冷色调6",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_lengsediao7;    // 冷色调7",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_lengsediao8;    // 冷色调8",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_lengsediao9;    // 冷色调9",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_lengsediao10;    // 冷色调10",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_lengsediao11;    // 冷色调11",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_nuansediao1;    // 暖色调1",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_nuansediao2;    // 暖色调2",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_nuansediao3;    // 暖色调3",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_xiaoqingxin1;    // 小清新1",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_xiaoqingxin2;    // 小清新2",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_xiaoqingxin3;    // 小清新3",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_xiaoqingxin4;    // 小清新4",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_xiaoqingxin5;    // 小清新5",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_xiaoqingxin6;    // 小清新6",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_ziran1;    // 自然1",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_ziran2;    // 自然2",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_ziran3;    // 自然3",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_ziran4;    // 自然4",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_ziran5;    // 自然5",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_ziran6;    // 自然6",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_ziran7;    // 自然7",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_ziran8;    // 自然8",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_mitao1;    // 蜜桃1",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_mitao2;    // 蜜桃2",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_mitao3;    // 蜜桃3",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_mitao4;    // 蜜桃4",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_mitao5;    // 蜜桃5",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_mitao6;    // 蜜桃6",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_mitao7;    // 蜜桃7",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_mitao8;    // 蜜桃8",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_zhiganhui1;    // 质感灰1",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_zhiganhui2;    // 质感灰2",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_zhiganhui3;    // 质感灰3",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_zhiganhui4;    // 质感灰4",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_zhiganhui5;    // 质感灰5",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_zhiganhui6;    // 质感灰6",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_zhiganhui7;    // 质感灰7",
FOUNDATION_EXTERN VHBEffectFilterValue const eff_Filter_Value_FU_zhiganhui8;    // 质感灰8"

@interface VHBeautifyEffectList : NSObject

/// 滤镜列表(FaceUnity)
+ (NSArray<NSString *> *)filterListWithFU;
@end
