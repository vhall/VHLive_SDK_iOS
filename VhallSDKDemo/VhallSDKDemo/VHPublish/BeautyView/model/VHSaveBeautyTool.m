//
//  VHSaveBeautyTool.m
//  UIModel
//
//  Created by jinbang.li on 2022/2/24.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHSaveBeautyTool.h"
#import "VHBeautyModel.h"
#import "VHBFURender/VHBeautifyEffectList.h"
#define BeautyEffectConfigPath ([[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"BeautyEffectConfigPath"])
//首选项存储值
#define kVHBeautyStatus @"kVHBeautyStatus"
#define kVHFilterStatus  @"kVHFilterStatus"
#define kVHSaveCacheStatus @"kVHSaveCacheStatus"
/*
 磨皮：33、美白：52、红润：50、大眼：25、瘦脸：40、锐化：70、白牙：40、亮眼：40
 额头、鼻子、嘴巴初始数值为：0
 10.滤镜默认为开启，默认选中自然款滤镜，数值为：40
 
基础：美白、红润、磨皮、锐化
高级：大眼、瘦脸、额头调整、鼻子调整、亮眼、美牙、嘴巴调整
 
 基础:
 美白 52  eff_key_FU_ColorLevel;    ///< 美白 [范围 0.0-1.0] [默认值0.2]
 红润：50 eff_key_FU_RedLevel;      ///< 红润 [范围 0.0-1.0] [默认值0.5]
 磨皮：33 eff_key_FU_BlurLevel;   ///< 磨皮 [范围0.0-6.0] [默认6.0]
 锐化：70 eff_key_FU_Sharpen;       ///< 锐化 [范围0.0-1.0] [默认0.2]
 
 高级:
 大眼：25 eff_key_FU_EyeEnlargingV2;    ///< 大眼 [范围0.0-1.0] [默认0.0]
 瘦脸：40 eff_key_FU_CheekThinning;     ///< 瘦脸 [范围0.0-1.0] [默认0.0]
 额头  0  eff_key_FU_IntensityForeheadV2;   ///< 额头调整 [范围0.0-1.0]
 鼻子  0  eff_key_FU_IntensityNoseV2;   ///< 瘦鼻 [范围0.0-1.0] [默认0.0]
 嘴巴  0  eff_key_FU_IntensityMouthV2;  ///< 嘴巴调整 [范围0.0-1.0] [默认0.5]
 亮眼  40 eff_key_FU_EyeBright;     ///< 亮眼 [范围0.0-1.0] [默认值1.0]
 白牙：40 eff_key_FU_ToothWhiten;   ///< 美牙 [范围 0.0-1.0] [默认值1.0]
 
 滤镜 默认为自然滤镜
 数值为40
 //实时生成预览画面，滤镜为互斥的
 **/
@implementation VHSaveBeautyTool
+ (NSMutableDictionary <NSString *,VHBeautyModel *>*)beautyConfigModel{
    //额头，鼻子，嘴巴默认为0，范围是-100到100
    NSMutableDictionary *beautyConfig = [NSMutableDictionary dictionaryWithDictionary:@{
        VH_Effect_BlurLevel:[self beautyModel:eff_key_FU_BlurLevel default:2.0 current:2.0 minValue:0.0 maxValue:6.0],//磨皮0.0-6.0
        VH_Effect_ColorLevel:[self beautyModel:eff_key_FU_ColorLevel default:1.04 current:1.04 minValue:0.0 maxValue:2.0],//美白
        VH_Effect_RedLevel:[self beautyModel:eff_key_FU_RedLevel default:1.0 current:1.0 minValue:0.0 maxValue:2.0],//红润
        VH_Effect_ToothWhiten:[self beautyModel:eff_key_FU_ToothWhiten default:0.4 current:0.4 minValue:0.0 maxValue:1.0],//美牙
        VH_Effect_Sharpen:[self beautyModel:eff_key_FU_Sharpen default:0 current:0 minValue:0.0 maxValue:1.0],//锐化
        VH_Effect_IntensityNoseV2:[self beautyModel:eff_key_FU_IntensityNoseV2 default:0.5 current:0.5 minValue:0.0 maxValue:1.0],//鼻子[0,1]
        VH_Effect_IntensityLongNose:[self beautyModel:eff_key_FU_IntensityLongNose default:0.5 current:0.5 minValue:0.0 maxValue:1.0],//鼻子长度
        VH_Effect_IntensityMouthV2:[self beautyModel:eff_key_FU_IntensityMouthV2 default:0.5 current:0.5 minValue:0.0 maxValue:1.0],//嘴巴[0,1] 显示数值[-100,100]
        VH_Effect_IntensityLipThick:[self beautyModel:eff_key_FU_IntensityLipThick default:0.5 current:0.5 minValue:0.0 maxValue:1.0],//嘴巴厚度
        VH_Effect_IntensityPhiltrum:[self beautyModel:eff_key_FU_IntensityPhiltrum default:0.5 current:0.5 minValue:0.0 maxValue:1.0],//人中
        VH_Effect_IntensitySmile:[self beautyModel:eff_key_FU_IntensitySmile default:0 current:0 minValue:0.0 maxValue:1.0],//微笑
        VH_Effect_IntensityChin:[self beautyModel:eff_key_FU_IntensityChin default:0.5 current:0.5 minValue:0.0 maxValue:1.0],//下巴
        VH_Effect_BlurType:[self beautyModel:eff_key_FU_BlurType default:0 current:0 minValue:0.0 maxValue:1.0],//清晰
        VH_Effect_CheekThinning:[self beautyModel:eff_key_FU_CheekThinning default:0.4 current:0.4 minValue:0.0 maxValue:1.0],//瘦脸
        VH_Effect_CheekV:[self beautyModel:eff_key_FU_CheekV default:0 current:0 minValue:0.0 maxValue:1.0],//V脸
        VH_Effect_FaceThreed:[self beautyModel:eff_key_FU_IntensityFaceThreed default:0.5 current:0.5 minValue:0.0 maxValue:1.0],//立体
        VH_Effect_CheekNarrowV2:[self beautyModel:eff_key_FU_CheekNarrowV2 default:0 current:0 minValue:0.0 maxValue:1.0],//窄脸
        VH_Effect_CheekShort:[self beautyModel:eff_key_FU_CheekShort default:0 current:0 minValue:0.0 maxValue:1.0],//短脸
        VH_Effect_CheekSmallV2:[self beautyModel:eff_key_FU_CheekSmallV2 default:0 current:0 minValue:0.0 maxValue:1.0],//小脸
        VH_Effect_IntensityForeheadV2:[self beautyModel:eff_key_FU_IntensityForeheadV2 default:0.5 current:0.5 minValue:0.0 maxValue:1.0],//额头
        VH_Effect_IntensityLowerJaw:[self beautyModel:eff_key_FU_IntensityLowerJaw default:0 current:0 minValue:0.0 maxValue:1.0],//瘦下颌骨
        VH_Effect_IntensityCheekbones:[self beautyModel:eff_key_FU_IntensityCheekbones default:0 current:0 minValue:0.0 maxValue:1.0],//颧骨
        VH_Effect_RemoveNasolabialFoldsStrength:[self beautyModel:eff_key_FU_RemoveNasolabialFoldsStrength default:0 current:0 minValue:0.0 maxValue:1.0],//法令纹
        VH_Effect_BrowSpace:[self beautyModel:eff_key_FU_IntensityBrowSpace default:0.5 current:0.5 minValue:0.0 maxValue:1.0],//眉距
        VH_Effect_BrowThick:[self beautyModel:eff_key_FU_IntensityBrowThick default:0.5 current:0.5 minValue:0.0 maxValue:1.0],//粗细
        VH_Effect_BrowHeight:[self beautyModel:eff_key_FU_IntensityBrowHeight default:0.5 current:0.5 minValue:0.0 maxValue:1.0],//上下
        VH_Effect_EyeBright:[self beautyModel:eff_key_FU_EyeBright default:0.4 current:0.4 minValue:0.0 maxValue:1.0],//亮眼
        VH_Effect_EyeLid:[self beautyModel:eff_key_FU_IntensityEyeLid default:0 current:0 minValue:0.0 maxValue:1.0],//眼睑
        VH_Effect_EyeHeight:[self beautyModel:eff_key_FU_IntensityEyeHeight default:0.5 current:0.5 minValue:0.0 maxValue:1.0],//眼睛位置
        VH_Effect_EyeCircle:[self beautyModel:eff_key_FU_IntensityEyeCircle default:0 current:0 minValue:0.0 maxValue:1.0],//圆眼
        VH_Effect_IntensityEyeSpace:[self beautyModel:eff_key_FU_IntensityEyeSpace default:0.5 current:0.5 minValue:0.0 maxValue:1.0],//眼距离
        VH_Effect_EyeEnlargingV2:[self beautyModel:eff_key_FU_EyeEnlargingV2 default:0.25 current:0.25 minValue:0.0 maxValue:1.0],//大眼
        VH_Effect_RemovePouchStrength:[self beautyModel:eff_key_FU_RemovePouchStrength default:0 current:0 minValue:0.0 maxValue:1.0],//黑眼圈
        VH_Effect_IntensityCanthus:[self beautyModel:eff_key_FU_IntensityCanthus default:0 current:0 minValue:0.0 maxValue:1.0],//开眼角
        VH_Effect_IntensityEyeRotate:[self beautyModel:eff_key_FU_IntensityEyeRotate default:0.5 current:0.5 minValue:0.0 maxValue:1.0],//眼睛角度
        
        VH_Filter_zhiran1:[self beautyModel:eff_Filter_Value_FU_ziran1 default:0.4 current:0.4 minValue:0.0 maxValue:1.0],//自然
        VH_Filter_fennen1:[self beautyModel:eff_Filter_Value_FU_fennen1 default:0.4 current:0.4 minValue:0.0 maxValue:1.0],//粉嫩1
        VH_Filter_bailiang1:[self beautyModel:eff_Filter_Value_FU_bailiang1 default:0.4 current:0.4 minValue:0.0 maxValue:1.0],//白亮1
        VH_Filter_xiaoqingxin1:[self beautyModel:eff_Filter_Value_FU_xiaoqingxin1 default:0.4 current:0.4 minValue:0.0 maxValue:1.0],//小清新1
        VH_Filter_lengsediao1:[self beautyModel:eff_Filter_Value_FU_lengsediao1 default:0.4 current:0.4 minValue:0.0 maxValue:1.0],//冷色调1
        VH_Filter_nuansediao1:[self beautyModel:eff_Filter_Value_FU_nuansediao1 default:0.4 current:0.4 minValue:0.0 maxValue:1.0],//暖色调
        VH_Filter_fennen8:[self beautyModel:eff_Filter_Value_FU_fennen8 default:0.4 current:0.4 minValue:0.0 maxValue:1.0],//红润
        VH_Filter_gexing3:[self beautyModel:eff_Filter_Value_FU_gexing3 default:0.4 current:0.4 minValue:0.0 maxValue:1.0],//温暖
        VH_Filter_gexing8:[self beautyModel:eff_Filter_Value_FU_gexing8 default:0.4 current:0.4 minValue:0.0 maxValue:1.0],//幸运
        VH_Filter_mitao1:[self beautyModel:eff_Filter_Value_FU_mitao1 default:0.4 current:0.4 minValue:0.0 maxValue:1.0],//蜜桃
        VH_Filter_zhiganhui1:[self beautyModel:eff_Filter_Value_FU_zhiganhui1 default:0.4 current:0.4 minValue:0.0 maxValue:1.0],//质感灰
        VH_Filter_xiaoqingxin6:[self beautyModel:eff_Filter_Value_FU_xiaoqingxin6 default:0.4 current:0.4 minValue:0.0 maxValue:1.0],//甜美
        VH_Filter_xiaoqingxin5:[self beautyModel:eff_Filter_Value_FU_xiaoqingxin5 default:0.4 current:0.4 minValue:0.0 maxValue:1.0],//粉红
        VH_Filter_nuansediao3:[self beautyModel:eff_Filter_Value_FU_nuansediao3 default:0.4 current:0.4 minValue:0.0 maxValue:1.0],//森林
        VH_Filter_lengsediao10:[self beautyModel:eff_Filter_Value_FU_lengsediao10 default:0.4 current:0.4 minValue:0.0 maxValue:1.0],//樱花
        VH_Filter_fennen5:[self beautyModel:eff_Filter_Value_FU_fennen5 default:0.4 current:0.4 minValue:0.0 maxValue:1.0],//淡雅
        VH_Filter_lengsediao9:[self beautyModel:eff_Filter_Value_FU_lengsediao9 default:0.4 current:0.4 minValue:0.0 maxValue:1.0],//阳光
        VH_Filter_bailiang6:[self beautyModel:eff_Filter_Value_FU_bailiang6 default:0.4 current:0.4 minValue:0.0 maxValue:1.0],//新白
        VH_Filter_lengsediao8:[self beautyModel:eff_Filter_Value_FU_lengsediao8 default:0.4 current:0.4 minValue:0.0 maxValue:1.0],//秋色
    }];
    return beautyConfig;
}
+ (VHBeautyModel *)beautyModel:(NSString *)effectName default:(float)defaultValue current:(float)currentValue minValue:(float)minValue maxValue:(float)maxValue{
    VHBeautyModel *model = [[VHBeautyModel alloc] init];
    model.effectName = effectName;
    model.defaultValue = defaultValue;
    model.currentValue = currentValue;
    model.maxValue = maxValue;
    model.minValue = minValue;
    return model;
}
+ (NSArray <NSArray <VHBeautyModel *> *>*)beautyViewModelArray{
    //包含美颜,滤镜两个数组
    NSArray *beautyModel = @[
        @[
            [self beautyModel:@"" icon:@""],//填充位
            [self beautyModel:VH_Effect_BlurLevel icon:@"line_exfoliating"],        // 磨皮 (0.0-6.0)
            [self beautyModel:VH_Effect_ColorLevel icon:@"line_whitening"],       // 美白 (0.0-1.0)
            [self beautyModel:VH_Effect_RedLevel icon:@"line-ruddy"],         // 红润 (0.0-1.0)
            [self beautyModel:VH_Effect_ToothWhiten icon:@"line-beautytooth"],     // 美牙 (0.0-1.0)
            [self beautyModel:VH_Effect_Sharpen icon:@"line_sharpen"],         // 锐化 (0.0-1.0)
            [self beautyModel:VH_Effect_IntensityNoseV2 icon:@"line_nose"],   // 鼻子 [0,1] → [-100,100]
            [self beautyModel:VH_Effect_IntensityLongNose icon:@"line_lengthnose"],  // 鼻子长度 [0,1] → [-100,100]
            [self beautyModel:VH_Effect_IntensityMouthV2 icon:@"line_mouth"], // 嘴巴 [0,1] → [-100,100]
            [self beautyModel:VH_Effect_IntensityLipThick icon:@"line_lipsthickness"], // 嘴巴厚度 [0,1]
            [self beautyModel:VH_Effect_IntensityPhiltrum icon:@"line_philtrum"],// 人中 [0,1] → [-100,100]
            [self beautyModel:VH_Effect_IntensitySmile icon:@"line_mouthsmile"],   // 微笑 [0,1]
            [self beautyModel:VH_Effect_IntensityChin icon:@"line_chin"],   // 下巴 [0,1] → [-100,100]
            [self beautyModel:VH_Effect_BlurType icon:@"line_clear"],         // 清晰 (0.0-1.0)
            [self beautyModel:VH_Effect_CheekThinning icon:@"line_mandible"],     // 瘦脸 (0.0-1.0)
            [self beautyModel:VH_Effect_CheekV icon:@"line_vface"],           // V脸 (0.0-1.0)
            [self beautyModel:VH_Effect_FaceThreed icon:@"line_features"],      // 3D立体感 [0.0-1.0]
            [self beautyModel:VH_Effect_CheekNarrowV2 icon:@"line_narrowface"],   // 窄脸 (0.0-1.0)
            [self beautyModel:VH_Effect_CheekShort icon:@"line_short"],       // 短脸 (0.0-1.0)
            [self beautyModel:VH_Effect_CheekSmallV2 icon:@"line_smallface"],     // 小脸 (0.0-1.0)
            [self beautyModel:VH_Effect_IntensityForeheadV2 icon:@"line_forehead"],// 额头 [0,1]
            [self beautyModel:VH_Effect_IntensityLowerJaw icon:@"line_thinface"], // 下颌骨 [0,1]
            [self beautyModel:VH_Effect_IntensityCheekbones icon:@"line_cheekbone"], // 颧骨 [0,1]
            [self beautyModel:VH_Effect_RemoveNasolabialFoldsStrength icon:@"line_nasolabial"],// 法令纹 [0,1]
            [self beautyModel:VH_Effect_BrowSpace icon:@"line_eyebrowdistance"],     // 眉距 [0.5]
            [self beautyModel:VH_Effect_BrowThick icon:@"line_eyebrowthickness"],      // 眉毛粗细 [0.5]
            [self beautyModel:VH_Effect_BrowHeight icon:@"line_eyebrowposition"],     // 眉毛高度 [0.5]
            [self beautyModel:VH_Effect_EyeBright icon:@"line_brighteye"],       // 亮眼 (0.0-1.0)
            [self beautyModel:VH_Effect_EyeLid icon:@"line_eyelid"],         // 眼睑 [0,1]
            [self beautyModel:VH_Effect_EyeHeight icon:@"line_eyeposition"],      // 眼睛位置 [0.5]
            [self beautyModel:VH_Effect_EyeCircle icon:@"line_roundeyes"],      // 圆眼 [0.25]
            [self beautyModel:VH_Effect_IntensityEyeSpace icon:@"line_eyeposition"],        //眼距离 [0.5]
            [self beautyModel:VH_Effect_EyeEnlargingV2 icon:@"line_eyedistance"],   // 大眼 [0.25]
            [self beautyModel:VH_Effect_RemovePouchStrength icon:@"line_darkcircles"],// 黑眼圈 [0.5]
            [self beautyModel:VH_Effect_IntensityCanthus icon:@"line_canthus"], // 开眼角 [0.4]
            [self beautyModel:VH_Effect_IntensityEyeRotate icon:@"line_bigeye"], // 眼睛角度 [0.5]
        ],
        @[
            [self beautyModel:VH_Filter_Origin icon:@"original"], // 原图
            [self beautyModel:VH_Filter_zhiran1 icon:@"filter_ziran"], // 自然
            [self beautyModel:VH_Filter_fennen1 icon:@"filter_fennen"], // 粉嫩1
            [self beautyModel:VH_Filter_bailiang1 icon:@"filter_liangbai"], // 白亮1
            [self beautyModel:VH_Filter_xiaoqingxin1 icon:@"filter_xiaoqingxin"], // 小清新1
            [self beautyModel:VH_Filter_lengsediao1 icon:@"filter_lengsediao"], // 冷色调1
            [self beautyModel:VH_Filter_nuansediao1 icon:@"filter_nuansediao"], // 暖色调
            [self beautyModel:VH_Filter_fennen8 icon:@"filter_hongrun"], // 红润
            [self beautyModel:VH_Filter_gexing3 icon:@"filter_wennuan"], // 温暖
            [self beautyModel:VH_Filter_gexing8 icon:@"filter_xingyun"], // 幸运
            [self beautyModel:VH_Filter_mitao1 icon:@"filter_mitao"], // 蜜桃
            [self beautyModel:VH_Filter_zhiganhui1 icon:@"filter_zhiganhui"], // 质感灰
            [self beautyModel:VH_Filter_xiaoqingxin6 icon:@"filter_tianmei"], // 甜美
            [self beautyModel:VH_Filter_xiaoqingxin5 icon:@"filter_fenhong"], // 粉红
            [self beautyModel:VH_Filter_nuansediao3 icon:@"filter_senlin"], // 森林
            [self beautyModel:VH_Filter_lengsediao10 icon:@"filter_yinghua"], // 樱花
            [self beautyModel:VH_Filter_fennen5 icon:@"filter_danya"], // 淡雅
            [self beautyModel:VH_Filter_lengsediao9 icon:@"filter_yangguang"], // 阳光
            [self beautyModel:VH_Filter_bailiang6 icon:@"filter_xinbai"], // 新白
            [self beautyModel:VH_Filter_lengsediao8 icon:@"filter_qiuse"], // 秋色
        ],
    ];
    return beautyModel;
}
+ (VHBeautyModel *)beautyModel:(NSString *)name icon:(NSString *)icon{
    VHBeautyModel *model = [[VHBeautyModel alloc] init];
    model.name = name;
    model.icon = icon;
    return model;
}
// 保存当前美颜直播值
+ (void)writeCurrentBeautyEffectConfig:(NSMutableDictionary <NSString *,VHBeautyModel *>*)model {
    //归档
    [NSKeyedArchiver archiveRootObject:model toFile:BeautyEffectConfigPath];
}

// 读取上次美颜的配置值
+ (NSMutableDictionary <NSString *,VHBeautyModel *>*)readLastBeautyEffectConfig {
//    //解档
//    NSMutableDictionary *configModel = [NSKeyedUnarchiver unarchiveObjectWithFile:BeautyEffectConfigPath];
//    if(configModel == nil) {
//        NSLog(@"接归档为空");
//        configModel = [self beautyConfigModel];
//    }
//
//    // 每次都读取最新的,不知道为什么之前要存储,app更新的话可能拉不到新的诶
//    configModel = [self beautyConfigModel];

    // 改为每次都读取最新的,不知道为什么之前要存储,app更新的话可能拉不到新的诶
    return [self beautyConfigModel];
}
// 恢复默认值
+ (NSMutableDictionary <NSString *,VHBeautyModel *>*)resetConfig:(NSMutableDictionary <NSString *,VHBeautyModel *>*)beautifig{
    NSArray *keyArr = [beautifig allKeys];
    for (NSString *effectName in keyArr) {
        //美颜与滤镜回到默认值
       VHBeautyModel *model  = beautifig[effectName];
        model.currentValue = model.defaultValue;
    }
    return beautifig;
}
// 关闭美颜置为最小值置为minValue
+ (void)closeBeauty:(NSArray <VHBeautyModel *>*)beautyModels beautifyKit:(VHBeautifyKit *)beautyKit closeBeautyEffect:(BOOL)close{
    for (VHBeautyModel *beautyModel in beautyModels) {
        //美颜的模型
       VHBeautyModel *m1 =[self beautyConfigModel][beautyModel.name];
        if (close) {
            [beautyKit setEffectKey:m1.effectName toValue:@(m1.minValue)];
        }else{
            [beautyKit setEffectKey:m1.effectName toValue:@(m1.currentValue)];
        }
    }
}
// 应用滤镜值
+ (void)applyFilterCacheBeautifyKit:(VHBeautifyKit *)beautyKit{
   NSUInteger index = [self readFilterIndex];
   VHBeautyModel *filterKey = [[self beautyViewModelArray] lastObject][index];
   VHBeautyModel *filterModel = [self beautyConfigModel][filterKey.name];
    [beautyKit setEffectKey:eff_key_FU_FilterName toValue:filterModel.effectName];
    [beautyKit setEffectKey:eff_key_FU_FilterLevel toValue:@(filterModel.currentValue)];
}
// 存取最后的美颜开关状态及滤镜索引
+ (void)saveBeautyStatus:(BOOL)beautyEffectStatus filterIndex:(NSUInteger)filterIndex{
    [[NSUserDefaults standardUserDefaults] setBool:beautyEffectStatus forKey:kVHBeautyStatus];
    //就是索引
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",filterIndex] forKey:kVHFilterStatus];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kVHSaveCacheStatus];//写缓存标记
    [[NSUserDefaults standardUserDefaults] synchronize];
}
// 读取美颜权限
+ (BOOL)readBeautyEnableStatus{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kVHBeautyStatus];
}
+ (NSUInteger)readFilterIndex{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kVHFilterStatus] integerValue];
}
+ (BOOL)readSaveCacheStatus{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kVHSaveCacheStatus];
}
// 应用效果变化 美颜开或者关，滤镜互斥开启的默认效果
+ (void)applyEffect:(BeautyType)beautyType beautifyKit:(VHBeautifyKit *)beautyKit closeBeautyEffect:(EffectType)type{
    switch (beautyType) {
        case BeautyType_Beauty:{
            // 分美颜开关
          BOOL isEnable = [[NSUserDefaults standardUserDefaults] boolForKey:kVHBeautyStatus];
            // 读取当前值,最小值
            [self closeBeauty:[[self beautyViewModelArray] firstObject] beautifyKit:beautyKit closeBeautyEffect:isEnable];
        }
            break;
        case BeautyType_Filter:{
            
        }
            break;
        default:
            break;
    }
    
}

@end
