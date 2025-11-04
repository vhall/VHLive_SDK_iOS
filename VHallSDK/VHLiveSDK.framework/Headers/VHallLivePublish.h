//
//  VHallLivePublish.h
//  VHLivePlay
//
//  Created by liwenlong on 16/2/3.
//  Copyright © 2016年 vhall. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "VHallConst.h"
#import "VHPublishConfig.h"
#import "VHWebinarInfo.h"
@protocol VHallLivePublishDelegate;
@interface VHallLivePublish : NSObject

@property (nonatomic, weak) id <VHallLivePublishDelegate>       delegate;              ///<代理
@property (nonatomic, assign) BOOL cameraMute;                                         ///<静视频。回显以及观众看到的是黑屏，不影响音频相关内容
@property (nonatomic, assign) BOOL isMute;                                             ///<设置静音 (开始直播后设置有效)
@property (nonatomic, assign) BOOL isRehearsal;                                        ///<是否彩排 YES：彩排模式开播 NO：正常直播 (默认NO,开播前设置有效)
@property (nonatomic, strong, readonly) UIView *displayView;                           ///<用来显示摄像头拍摄内容的View
@property (nonatomic, assign, readonly) BOOL isPublishing;                             ///<获取当前推流状态
@property (nonatomic, assign, readonly) AVCaptureDevicePosition captureDevicePosition; ///<获取用户使用是前置还是后置摄像头

/// 初始化
/// @param config  config参数
- (instancetype)initWithConfig:(VHPublishConfig *)config;

/// 高级美颜
/// @param config config参数
/// @param handle 设置结果
- (instancetype)initWithBeautyConfig:(VHPublishConfig *)config
                         handleError:(void (^)(NSError *error))handle;

/// 开始视频采集 显示视频预览
- (BOOL)startVideoCapture;

/// 停止视频采集 关闭视频预览
- (BOOL)stopVideoCapture;

/// 开始直播
/// @param param
/// param[@"id"]           = 活动Id，必传
/// param[@"access_token"] = 发直播token （新版v3控制台创建的直播活动可不传此值，v6.0修改）
/// param[@"nickname"]     = 发起直播更改主播昵称，非必传（v6.0新增）
- (void)startLive:(NSDictionary *)param;

/// 结束直播 与startLive成对出现，如果调用startLive，则需要调用stopLive以释放相应资源
- (void)stopLive;

/// 断开推流的连接,注意app进入后台时要手动调用此方法 回到前台要reconnect重新直播
- (void)disconnect;

/// 重连流
- (void)reconnect;

/// 切换摄像头
/// @return 是否切换成功
- (BOOL)swapCameras:(AVCaptureDevicePosition)captureDevicePosition;

/// 手动对焦
/// @param newPoint 坐标
- (void)setFoucsFoint:(CGPoint)newPoint;

/// 变焦
/// @param zoomSize 变焦的比例
- (void)captureDeviceZoom:(CGFloat)zoomSize;

/// 设置闪关灯的模式，开始直播后设置有效
/// @param captureTorchMode 闪光灯模式
- (BOOL)setDeviceTorchModel:(AVCaptureTorchMode)captureTorchMode;

/// 设置音频增益大小，注意只有当开启噪音消除时可用，开始直播后设置有效
/// @param size 音频增益的大小 [0.0,1.0]
- (void)setVolumeAmplificateSize:(float)size;

/// 本地相机预览填充模式，开始直播后设置有效
/// @param contentMode 模式
- (void)setContentMode:(VHRTMPMovieScalingMode)contentMode;

/// 镜像摄像头
/// @param mirror YES:镜像 NO:不镜像
- (void)camVidMirror:(BOOL)mirror;

/// 美颜参数设置
/// @param beautify     磨皮 --- 默认 4.0f  取值范围[1.0, 10.0]  10.0 正常图片没有磨皮
/// @param brightness   亮度 --- 默认 1.150f 取值范围[0.0, 2.0]  1.0 正常亮度
/// @param saturation   饱和度 --- 默认 1.0f  取值范围[0.0, 2.0]  1.0 正常饱和度
/// @param sharpness    锐化 --- 默认 0.1f  取值范围[-4.0，4.0] 0.0 正常锐化
- (void)setBeautify:(CGFloat)beautify
         Brightness:(CGFloat)brightness
         Saturation:(CGFloat)saturation
          Sharpness:(CGFloat)sharpness;

/// 销毁初始化数据
- (void)destoryObject;

#pragma mark - --------------------云导播-------------------------

@property (nonatomic, strong, readonly) UIView *liveView;                           ///<回显云导播台画面

/// 以主持人身份发起直播
/// @param param
/// param[@"id"]           = 活动Id，必传
/// param[@"access_token"] = 发直播token （新版v3控制台创建的直播活动可不传此值，v6.0修改）
/// param[@"nickname"]     = 发起直播更改主播昵称，非必传（v6.0新增）
- (instancetype)initDirectorHostEnter:(NSDictionary *)param
                                 fail:(void (^)(NSError *))failure;

/// 云导播:机位推流到云导播台
/// @param param param
/// param[@"id"]           = 活动Id，必传
/// param[@"seat"] = 云导播机位id (v6.4新增)必传参数
/// param[@"access_token"] = 发直播token （新版v3控制台创建的直播活动可不传此值，v6.0修改）
/// param[@"nickname"]     = 发起直播更改主播昵称，非必传（v6.0新增）
/// @param checkHostLine 是否检查主机线路
- (void)startSeatPushDirectorLive:(NSDictionary *)param
                    checkHostLine:(BOOL)checkHostLine;

/// 开始云导播
- (void)startDirectorLive;
/// 结束云导播
- (void)stopDirectorLive;
/// 销毁云导播
- (void)destoryDirectorLive;

@end



@protocol VHallLivePublishDelegate <NSObject>

@optional

/// 发起直播时的状态
/// @param liveStatus 直播状态
/// @param info 详细信息，字典结构：{code：错误码，content：错误信息}
- (void)publishStatus:(VHLiveStatus)liveStatus
             withInfo:(NSDictionary *)info;

/// 采集到第一帧的回调
/// @param image 第一帧的图片
- (void)firstCaptureImage:(UIImage *)image;

/// 活动相关信息回调（注意：此接口为v6.0新增，仅限新版控制台(v3及以上)创建的活动使用，否则不会回调）
/// @param publishObject 推流对象
/// @param webinarInfo 活动相关信息
- (void)publish:(VHallLivePublish *)publishObject
    webinarInfo:(VHWebinarInfo *)webinarInfo;

#pragma mark - --------------------云导播-------------------------
/// 云导播-主持人进入 房间内是否流
- (void)directorStream:(BOOL)haveStream;

@end
