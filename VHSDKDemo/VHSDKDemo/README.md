# Saas SDK 更新记录
## 1 版本记录

| 版本号       | 更新时间 | 更新内容                                                     |
| ------------ | -------- | ------------------------------------------------------------ |
| v6.3.0       | 20220322 | 
1.美颜功能优化。新增红润、大眼、瘦脸、锐化、白牙、亮眼等美颜功能；
2.新增滤镜。支持接入自然款、粉嫩款、白亮款等6种滤镜；                          |
      
## 2.使用说明
### 2.1 导入的依赖库
pod  'VHLiveSDK' ,’6.3.0’
pod  'VHLiveSDK_Interactive', ‘6.3.0’
pod 'VHBeautifyKit','1.0.5',:subspecs => ['FURender']

### 2.2 工程预置(导入库头文件及声明美颜)
#import <VHBeautifyKit/VHBeautifyKit.h>
#import <VHBFURender/VHBFURender.h>
//声明美颜模块
@property (nonatomic,strong) VHBeautifyKit *beautKit;
### 2.3 生成美颜模块
self.beautKit = [VHBeautifyKit beautifyManagerWithModuleClass:[VHBFURender class]];
### 2.4 视频直播使用美颜
[[VHallLivePublish alloc] initWithBeautyConfig:config handleError:^(NSError *error) {
            NSLog(@"error===%@",error.localizedDescription);
            self.isBeauty = (error!=nil)?NO:YES;//是否可以使用美颜功能
        }];
        
### 2.5 互动使用美颜
注：互动直播需要设置方向参数，横屏直播方向参数2，竖屏直播方向参数3
[[self.beautKit currentModule] setCaptureImageOrientation:(self.interfaceOrientation ==  UIInterfaceOrientationLandscapeRight)?2:3];
    [_localRenderView useBeautifyModule:[self.beautKit currentModule] 
HandleError:^(NSError * _Nonnull error) {
                NSLog(@"error === %@",error.localizedDescription);
                self.isEnableBeauty = (error!=nil)?NO:YES;//是否可以使用美颜
          }];
### 2.6 使用美颜功能
注:美颜列表及效果范围见VHBeautifyEffectList.h
[self.beautKit setEffectKey:eff_key_FU_CheekThinning toValue:0.5];//设置瘦脸效果
### 2.7 使用滤镜功能
注:滤镜名称和效果及范围见VHBeautifyEffectList.h
[self.beautKit setEffectKey:eff_key_FU_FilterName toValue:eff_Filter_Value_FU_bailiang1];//设置滤镜名称
 [self.beautKit setEffectKey:eff_key_FU_FilterLevel toValue:0.5];//设置滤镜效果[0,1]
