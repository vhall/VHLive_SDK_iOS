//
//  VHPublishConfig.h
//  VHLssPublishSDK
//
//  Created by vhall on 2017/11/14.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

/**
 *  推流状态
 */
typedef NS_ENUM(NSInteger, VHallPublishStatus) {
    VHallPublishStatusNone = 0,					//
    VHallPublishStatusPushConnectSucceed = 1,	//直播连接成功
    VHallPublishStatusUploadSpeed = 2,			//直播上传速率
    VHallPublishStatusUploadNetworkException = 3, //发起端网络环境差
    VHallPublishStatusUploadNetworkOK = 4		//发起端网络环境恢复正常
};

/**
 *  推流错误码
 */
typedef NS_ENUM(NSInteger, VHallPublishError) {
    VHallPublishErrorNone,
    VHallPublishErrorPusherError,       //  推流相关错误@{code："10001" ,content: "xxxxx"}
    VHallPublishErrorAuthError,         //  接口\验证等相关错误
    VHallPublishErrorParamError,        //  参数相关错误
    VHallPublishErrorCaptureError,      //  采集相关错误
};

/**
 *  推流类型
 */
typedef NS_ENUM(int,VHStreamType){
    VHStreamTypeNone = 0,
    VHStreamTypeVideoAndAudio,
    VHStreamTypeOnlyVideo,//暂不支持
    VHStreamTypeOnlyAudio,
};

#pragma mark - VHallLivePublisherDelegate

/**
 *  推流代理
 */
@protocol VHallLivePublisherDelegate <NSObject>

@optional
/**
 *  采集到第一帧的回调 开始直播后第一帧，多次开始多次调用
 *  @param image 第一帧的图片
 */
-(void)firstCaptureImage:(UIImage*)image;

/**
 *  推流状态回调
 *  @param status   状态类型
 *  @param info     状态信息2
 */
- (void)onPublishStatus:(VHallPublishStatus)status info:(NSDictionary*)info;

/**
 *  错误回调
 *  @param error    错误类型
 *  @param info     错误信息
 */
- (void)onPublishError:(VHallPublishError)error info:(NSDictionary*)info;//@{code："" ,content: ""}

@end

#pragma mark - VHPublishConfig
/**
 *  config 模板
 */
typedef NS_ENUM(NSInteger,VHPublishConfigType)
{
    VHPublishConfigTypeDefault   = 0,// 分辨率:960x540  码率:800  帧率:15   默认
    VHPublishConfigTypeHD        = 1, // 分辨率:1280x720  码率:1300  帧率:15
    VHPublishConfigType1920x1080 = 2,// 分辨率:1920x1080  码率:1900  帧率:15
    VHPublishConfigType1920x1080_25 = 3,// 分辨率:1920x1080  码率:2200  帧率:25
    VHPublishConfigType1280x720_25 = 4, // 分辨率:1280x720  码率:1500  帧率:25
    VHPublishConfigType960x540_25 = 5, // 分辨率:960x540  码率:1000  帧率:25
    VHPublishConfigType640x480 = 6, // 分辨率:640x480  码率:500  帧率:15
    VHPublishConfigType640x480_25 = 7, // 分辨率:640x480  码率:650  帧率:25
};

/**
 * 推流视频分辨率
 */
typedef NS_ENUM(NSInteger,VHVideoResolution)
{
    /// VHVideoResolution 低分边率  352*288
    VHLowVideoResolution                = 0,    //低分边率  352*288
    /// VHVideoResolution 普通分辨率 640*480
    VHGeneralVideoResolution            = 1,    //普通分辨率 640*480
    /// VHVideoResolution 高分辨率  960*540
    VHHVideoResolution                  = 2,    //高分辨率  960*540
    /// VHVideoResolution 超高分辨率 1280*720
    VHHDVideoResolution                 = 3,    //超高分辨率 1280*720
    /// VHVideoResolution 1080p 1920*1080
    VH1080pVideoResolution              = 4,    //1080p    1920*1080
};

// 美颜设置 (未来有效)
typedef enum : NSUInteger {
    VHBeautifyTypeNone      = 0 ,
    VHBeautifyTypeSimple    = 1<<0 ,
    VHBeautifyTypeAdvanced  = 1<<1 ,
} VHBeautifyType;

@interface VHPublishConfig : NSObject

/// 创建Config
/// @param type 清晰度
+ (VHPublishConfig*)configWithType:(VHPublishConfigType)type;

/**
 *  采集画面方向 默认AVCaptureVideoOrientationPortrait
 */
@property (nonatomic,assign)AVCaptureVideoOrientation orientation;

/**
 *  mic 音频采样率 44100(默认)、32000
 */
@property (nonatomic,assign)NSInteger sampleRate;

/**
 *  mic 音频采样通道  默认 2 双通道（采样点位数 16 位）
 */
@property (nonatomic,assign)NSInteger channelNum;

/**
 *  推流连接的超时时间，单位为秒 默认5
 */
@property (nonatomic,assign)NSInteger publishConnectTimeout;

/**
 *  推流断开重连的次数 默认为 5
 */
@property (nonatomic,assign)NSInteger publishConnectTimes;

/**
 *  推流帧率 范围［10～30］小于摄像头采集帧率  默认15
 */
@property (nonatomic,assign)NSInteger videoCaptureFPS;

/**
 *  视频分辨率 默认值是VHHVideoResolution 960*540
 */
@property (nonatomic,assign)VHVideoResolution videoResolution;

/**
 *  视频码率设置 取值范围 [100 - 1024] 单位 kbps
 */
@property (nonatomic,assign)NSInteger videoBitRate;

/**
 *  音频码率设置 取值范围 [32,48,64,96,128]  单位 kbps  默认64
 */
@property (nonatomic,assign)NSInteger audioBitRate;

/**
 * 是否开启噪声消除，默认不开启
 */
@property(assign,nonatomic)BOOL isOpenNoiseSuppresion;

/**
 * 音频增益 [0.0-1.0] 默认0.0
 */
@property(assign,nonatomic)float volumeAmplificateSize;

/**
 *  摄像头方向 默认 AVCaptureDevicePositionBack 代表后置摄像头 AVCaptureDevicePositionFront 代表前置摄像头
 */
@property (nonatomic,assign)AVCaptureDevicePosition captureDevicePosition;

/// 美颜类型 [默认:VHBeautfiyNone][beta(未来有效)]
@property (nonatomic) VHBeautifyType beautifyType;

/**
 * 美颜滤镜开关
 * 默认关闭 NO
 * 开启器美颜 帧率最好调整为15帧
 */
@property (nonatomic, assign)BOOL beautifyFilterEnable;

/// 高级美颜功能[自动开启，无需设置]
@property (nonatomic, assign) BOOL advancedBeautifyEnable;

/**
 * 是否使用软件编码
 * 默认关闭 NO，使用硬件编码，进入后台推流时，需要设置此值为YES。
 */
@property (nonatomic,assign)BOOL enableForBacgroundEncode;

/**
 * 推流类型 默认VHStreamTypeVideoAndAudio
 */
@property (nonatomic,assign)VHStreamType pushType;

/**
 * 是否打印详细推流日志
 * 默认不打印 NO
 */
@property (nonatomic,assign)BOOL isPrintLog;


/**
 * 高级功能 用于自定义采集模块
 * 自定义视频宽高,默认为 0 ，若设置此项后 videoResolution 属性自动失效
 */
@property(nonatomic,assign)int customVideoWidth;
@property(nonatomic,assign)int customVideoHeight;

/// 返回当前尺寸，如果 customVideoWidth/Height 未设置则使用 Resolution 换算Size，所以必然不为 0
@property (nonatomic, readonly) CGSize customVideoSize;

/**
 * 高级功能 用于自定义采集模块
 * 自定义参数 用于自定义采集模块
 */
@property (nonatomic,strong)NSDictionary* customParam;

@end
