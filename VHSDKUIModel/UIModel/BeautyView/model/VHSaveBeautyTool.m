//
//  VHSaveBeautyTool.m
//  UIModel
//
//  Created by jinbang.li on 2022/2/24.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHSaveBeautyTool.h"
#import "VHBeautyModel.h"
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
        VH_Effect_ColorLevel:[self beautyModel:eff_key_FU_ColorLevel default:0.52 current:0.52 minValue:0.0 maxValue:1.0],//美白
        VH_Effect_RedLevel:[self beautyModel:eff_key_FU_RedLevel default:0.5 current:0.5 minValue:0.0 maxValue:1.0],//红润
        VH_Effect_BlurLevel:[self beautyModel:eff_key_FU_BlurLevel default:1.98 current:1.98 minValue:0.0 maxValue:6.0],//磨皮0.0-6.0
        VH_Effect_Sharpen:[self beautyModel:eff_key_FU_Sharpen default:0.7 current:0.7 minValue:0.0 maxValue:1.0],//锐化
        VH_Effect_EyeEnlargingV2:[self beautyModel:eff_key_FU_EyeEnlargingV2 default:0.25 current:0.25 minValue:0.0 maxValue:1.0],//大眼
        VH_Effect_CheekThinning:[self beautyModel:eff_key_FU_CheekThinning default:0.4 current:0.4 minValue:0.0 maxValue:1.0],//瘦脸
        VH_Effect_IntensityForeheadV2:[self beautyModel:eff_key_FU_IntensityForeheadV2 default:0.5 current:0.5 minValue:0.0 maxValue:1.0],//额头[0,1] 显示数值[-100,100],min = 0.0 - 100;max = 1 *100;cur = 200 * 0.5
        VH_Effect_IntensityNoseV2:[self beautyModel:eff_key_FU_IntensityNoseV2 default:0.5 current:0.5 minValue:0.0 maxValue:1.0],//鼻子[0,1] 显示数值[-100,100]
        VH_Effect_IntensityMouthV2:[self beautyModel:eff_key_FU_IntensityMouthV2 default:0.5 current:0.5 minValue:0.0 maxValue:1.0],//嘴巴[0,1] 显示数值[-100,100]
        VH_Effect_EyeBright:[self beautyModel:eff_key_FU_EyeBright default:0.4 current:0.4 minValue:0.0 maxValue:1.0],//亮眼
        VH_Effect_ToothWhiten:[self beautyModel:eff_key_FU_ToothWhiten default:0.4 current:0.4 minValue:0.0 maxValue:1.0],//美牙 以上美颜，以下滤镜,互斥
        VH_Filter_Origin:[self beautyModel:eff_Filter_Value_FU_origin default:0.0 current:0.0 minValue:0.0 maxValue:1.0],//原图
        VH_Filter_zhiran1:[self beautyModel:eff_Filter_Value_FU_ziran1 default:0.4 current:0.4 minValue:0.0 maxValue:1.0],//自然1
        VH_Filter_fennen1:[self beautyModel:eff_Filter_Value_FU_fennen1 default:0.4 current:0.4 minValue:0.0 maxValue:1.0],//粉嫩1
        VH_Filter_bailiang1:[self beautyModel:eff_Filter_Value_FU_bailiang1 default:0.4 current:0.4 minValue:0.0 maxValue:1.0],//白亮1
        
        VH_Filter_xiaoqingxin1:[self beautyModel:eff_Filter_Value_FU_xiaoqingxin1 default:0.4 current:0.4 minValue:0.0 maxValue:1.0],//小清新1
        VH_Filter_lengsediao1:[self beautyModel:eff_Filter_Value_FU_lengsediao1 default:0.4 current:0.4 minValue:0.0 maxValue:1.0],//冷色调1
        VH_Filter_nuansediao1:[self beautyModel:eff_Filter_Value_FU_nuansediao1 default:0.4 current:0.4 minValue:0.0 maxValue:1.0],//暖色调
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
            [self beautyModel:VH_Effect_BlurLevel icon:@"exfoliating"],//磨皮
            [self beautyModel:VH_Effect_ColorLevel icon:@"whitening"],//美白
            [self beautyModel:VH_Effect_RedLevel icon:@"ruddy"],//红润
            [self beautyModel:VH_Effect_EyeEnlargingV2 icon:@"Bigeye"],//大眼
            [self beautyModel:VH_Effect_CheekThinning icon:@"Thinface"],//瘦脸
            [self beautyModel:VH_Effect_Sharpen icon:@"sharpen"],//锐化
            [self beautyModel:VH_Effect_ToothWhiten icon:@"Beautytooth"],//白牙
            [self beautyModel:VH_Effect_EyeBright icon:@"Brighteye"],//亮眼
            [self beautyModel:VH_Effect_IntensityForeheadV2 icon:@"forehead"],//额头
            [self beautyModel:VH_Effect_IntensityNoseV2 icon:@"nose"],//鼻子
            [self beautyModel:VH_Effect_IntensityMouthV2 icon:@"mouth"],//嘴巴
           
           
        ],
        @[
            [self beautyModel:VH_Filter_Origin icon:@"originalimage"],//原图
            [self beautyModel:VH_Filter_zhiran1 icon:@"zhiran"],//自然
            [self beautyModel:VH_Filter_fennen1 icon:@"fennei"],//粉嫩
            [self beautyModel:VH_Filter_bailiang1 icon:@"bailiang"],//白亮
            [self beautyModel:VH_Filter_xiaoqingxin1 icon:@"xiaoqingxin"],//小清新
            [self beautyModel:VH_Filter_lengsediao1 icon:@"lengsediao"],//冷色调
            [self beautyModel:VH_Filter_nuansediao1 icon:@"nuansediao"],//暖色调
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
//保存当前美颜直播值
+ (void)writeCurrentBeautyEffectConfig:(NSMutableDictionary <NSString *,VHBeautyModel *>*)model {
    //归档
    [NSKeyedArchiver archiveRootObject:model toFile:BeautyEffectConfigPath];
}

//读取上次美颜的配置值
+ (NSMutableDictionary <NSString *,VHBeautyModel *>*)readLastBeautyEffectConfig {
    //解档
    NSMutableDictionary *configModel = [NSKeyedUnarchiver unarchiveObjectWithFile:BeautyEffectConfigPath];
    if(configModel == nil) {
        NSLog(@"接归档为空");
        configModel = [self beautyConfigModel];
    }
    return configModel;
}
//恢复默认值
+ (NSMutableDictionary <NSString *,VHBeautyModel *>*)resetConfig:(NSMutableDictionary <NSString *,VHBeautyModel *>*)beautifig{
    NSArray *keyArr = [beautifig allKeys];
    for (NSString *effectName in keyArr) {
        //美颜与滤镜回到默认值
       VHBeautyModel *model  = beautifig[effectName];
        model.currentValue = model.defaultValue;
    }
    return beautifig;
}
//关闭美颜置为最小值置为minValue
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
///应用滤镜值
+ (void)applyFilterCacheBeautifyKit:(VHBeautifyKit *)beautyKit{
   NSUInteger index = [self readFilterIndex];
   VHBeautyModel *filterKey = [[self beautyViewModelArray] lastObject][index];
   VHBeautyModel *filterModel = [self beautyConfigModel][filterKey.name];
    [beautyKit setEffectKey:eff_key_FU_FilterName toValue:filterModel.effectName];
    [beautyKit setEffectKey:eff_key_FU_FilterLevel toValue:@(filterModel.currentValue)];
}
///存取最后的美颜开关状态及滤镜索引
+ (void)saveBeautyStatus:(BOOL)beautyEffectStatus filterIndex:(NSUInteger)filterIndex{
    [[NSUserDefaults standardUserDefaults] setBool:beautyEffectStatus forKey:kVHBeautyStatus];
    //就是索引
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",filterIndex] forKey:kVHFilterStatus];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kVHSaveCacheStatus];//写缓存标记
    [[NSUserDefaults standardUserDefaults] synchronize];
}
///读取美颜权限
+ (BOOL)readBeautyEnableStatus{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kVHBeautyStatus];
}
+ (NSUInteger)readFilterIndex{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kVHFilterStatus] integerValue];
}
+ (BOOL)readSaveCacheStatus{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kVHSaveCacheStatus];
}
///应用效果变化 美颜开或者关，滤镜互斥开启的默认效果
+ (void)applyEffect:(BeautyType)beautyType beautifyKit:(VHBeautifyKit *)beautyKit closeBeautyEffect:(EffectType)type{
    switch (beautyType) {
        case BeautyType_Beauty:{
            //分美颜开关
          BOOL isEnable = [[NSUserDefaults standardUserDefaults] boolForKey:kVHBeautyStatus];
            //读取当前值,最小值
            [self closeBeauty:[[self beautyViewModelArray] firstObject] beautifyKit:beautyKit closeBeautyEffect:isEnable];
        }
            break;
        case BeautyType_Filter:{
            //读取滤镜配置 取Index位置
//            NSString *filterIndex = [[NSUserDefaults standardUserDefaults] stringForKey:kVHFilterIndex];
//            VHBeautyModel *model = self.beautyConfig[self.beautyEffectArray[self.beautyType][self.filter_Index].name];
//            model.currentValue = value/100;//更新模型里面的值
////            VH_Filter_Name
//            [self.beautyModule setEffectKey:VH_Filter_Name toValue:model.effectName];
//            [self.beautyModule setEffectKey:VH_Filter_Level toValue:@(value/100)];
        }
            break;
        default:
            break;
    }
    
}

@end

