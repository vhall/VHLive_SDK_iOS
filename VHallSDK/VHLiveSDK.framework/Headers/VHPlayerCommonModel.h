//
//  VHPlayerCommonModel.h
//  VHLssVod
//
//  Created by xiongchao on 2020/10/30.
//  Copyright © 2020 vhall. All rights reserved.
//

//播放器 公共模型
#import <Foundation/Foundation.h>

#define VideoSubTitleErrorDomain @"VideoSubTitleError"
//字幕相关错误码
typedef enum : NSUInteger {
    VideoSubTitleError_UnOpen = 20000,          //字幕未开启
    VideoSubTitleError_SelectNotBeNil = 20001,  //选择字幕为空
    VideoSubTitleError_DownloadError = 20002,   //字幕下载失败
    VideoSubTitleError_AnalysisError = 20003,   //字幕解析失败
} VideoSubTitleError;


NS_ASSUME_NONNULL_BEGIN

@interface VHPlayerCommonModel : NSObject

@end

#pragma mark - 打点
//视频打点数据模型
@interface VHVidoePointModel : NSObject
/** 打点位置的时间，单位：秒 */
@property (nonatomic, assign) NSTimeInterval timePoint;
/** 打点位置的文字描述 */
@property (nonatomic, copy) NSString *msg;
/** 打点位置的图片url地址 */
@property (nonatomic, copy) NSString *picurl;
/** 视频总时长，单位：秒 */
@property (nonatomic, assign) NSTimeInterval videoDuration;
/** 打点位置时间占视频总时长的百分比，如：0.35 */
@property (nonatomic, assign) float pointPersent;
@end


#pragma mark - 字幕

//每段字幕详情
@interface VHVidoeSubtitleItemModel : NSObject
/** 该段字幕的开始时间点，单位：秒 */
@property (nonatomic, assign) float beginTime;
/** 该段字幕的结束时间点，单位：秒 */
@property (nonatomic, assign) float endTime;
/** 开始时间-结束时间这段所对应的字幕文字 */
@property (nonatomic, copy) NSString *subtitleText;
@end


//视频字幕模型
@interface VHVidoeSubtitleModel : NSObject
/** 字幕语言 */
@property (nonatomic, copy) NSString *lang;
/** 字幕描述（在控制台上传时设置） */
@property (nonatomic, copy) NSString *remark;
/** 字幕下载地址 */
@property (nonatomic, copy) NSString *url;
/** 是否为默认字幕 */
@property (nonatomic, assign) NSInteger is_default;
/** 字幕展示标题（默认由remark-lang拼接组成） */
@property (nonatomic, copy) NSString *showName;
@end





NS_ASSUME_NONNULL_END
