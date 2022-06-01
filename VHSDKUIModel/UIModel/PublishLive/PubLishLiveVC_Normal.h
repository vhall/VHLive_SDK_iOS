//
//  DemoViewController.h
//  PublishDemo
//
//  Created by liwenlong on 15/10/9.
//  Copyright (c) 2015年 vhall. All rights reserved.
//
//发常规直播
#import "VHBaseViewController.h"
/*
 视频直播
 **/
typedef NS_ENUM(NSInteger,VHLiveVideoType)
{
    VHLiveVideoNormal                = 0,//普通视频直播
    VHLiveVideoDirectorHostEnter     = 1,//以主持人身份进入云导播
    VHLiveVideoDirectorSeatPushStream = 2,//机位推流到云导播
};
@class VHSeatModel;
@interface PubLishLiveVC_Normal : VHBaseViewController
@property(nonatomic,copy)   NSString        *roomId; //房间id
@property(nonatomic,copy)   NSString        *token;
@property(nonatomic,copy)   NSString        *nick_name; //昵称
@property(nonatomic,assign) NSInteger       videoBitRate; //视频码率
@property(nonatomic,assign) NSInteger       audioBitRate;  //音频码率
@property(nonatomic,assign) NSInteger       videoCaptureFPS;   //推流帧率
@property(nonatomic,assign) BOOL            isOpenNoiseSuppresion; //噪声消除
@property(nonatomic,assign) BOOL            beautifyFilterEnable; //美颜开关
@property(nonatomic,assign) NSInteger            videoResolution; //推流分辨率 0：352*288 1：640*480 2：960*540 3：1280*720
/*
 新增云导播直播类型，以主持人发起进入云导播+机位推流进入
 默认为普通视频直播
 **/
@property (nonatomic,assign)VHLiveVideoType liveVideoType;
//机位id
@property (nonatomic,strong) VHSeatModel *seatModel;

//云导播台是否开启
@property (nonatomic) BOOL  directorOpen;
@end
