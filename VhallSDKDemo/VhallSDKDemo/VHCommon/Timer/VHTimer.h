//
//  VHTimer.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/12.
//

#import <Foundation/Foundation.h>

@interface VHTime : NSObject

/** 剩余 天-时-分-秒*/
@property (nonatomic, assign) int residueDay;
@property (nonatomic, assign) int residueHour;
@property (nonatomic, assign) int residueMinute;
@property (nonatomic, assign) int residueSecond;

/** 年-月-日-时-分-秒-毫秒*/
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *month;
@property (nonatomic, copy) NSString *day;
@property (nonatomic, copy) NSString *hour;
@property (nonatomic, copy) NSString *minute;
@property (nonatomic, copy) NSString *second;
@property (nonatomic, copy) NSString *millisecond;


@end

/** 进度闭包回调*/
typedef void (^VHProgressBlock)(VHTime *progress);
/** 完成闭包回调*/
typedef void (^VHTimerCompletion)(void);

@interface VHTimer : NSObject

/** 计时器是否为增加模式*/
@property (nonatomic, assign) BOOL isAscend;
/** 时区调整? */
@property (nonatomic, assign) BOOL isLocale;
/** 当前时间*/
@property (nonatomic, assign) NSTimeInterval currentTime;
/** 计时器的计时时间*/
@property (nonatomic, assign) NSTimeInterval timerInterval;
/** 计时器触发的精度，默认为100ms触发一次回调，取值区间为100-1000 */
@property (nonatomic, assign) NSInteger precision;
/** 计时器的回调*/
@property (nonatomic, strong) VHProgressBlock progressBlock;
/** 计时器完成的回调*/
@property (nonatomic, strong) VHTimerCompletion completion;
/** 是否为暂停状态*/
@property (nonatomic, assign, readonly, getter = isSupsending) BOOL suspend;
/** 是否为运行状态*/
@property (nonatomic, assign, readonly, getter = isRuning) BOOL run;
/** 是否为完成状态*/
@property (nonatomic, assign, readonly, getter = isComplete) BOOL complete;


/**
   初始化计时器

   @param timeinterval 计时的时间
   @param isAscend 是否为增加计时
   @param progressBlock 进度回调
   @param completion 倒计时结束回调
   @return 计时器
 */
- (instancetype)initWithStartTimeinterval:(NSTimeInterval)timeinterval isAscend:(BOOL)isAscend progressBlock:(VHProgressBlock)progressBlock completionBlock:(VHTimerCompletion)completion;

/** 开始计时*/
- (void)resume;

/** 暂停计时*/
- (void)suspend;

/** 继续暂停的任务*/
- (void)activate;

/** 停止计时*/
- (void)stop;

/** 重置计时器并开始计时*/
- (void)restart;

@end
