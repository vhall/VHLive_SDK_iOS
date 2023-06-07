//
//  VHTimer.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/12.
//

#import <NotificationCenter/NotificationCenter.h>
#import "VHTimer.h"

/**
   不失精度加减乘除计算

   - VHDecimalOprationTypeAdd: 加
   - VHDecimalOprationTypeSubtract: 减
   - VHDecimalOprationTypeMultiple: 乘
   - VHDecimalOprationTypeDivide: 除
 */
typedef NS_ENUM(NSUInteger, VHDecimalOprationType) {
    VHDecimalOprationTypeAdd,
    VHDecimalOprationTypeSubtract,
    VHDecimalOprationTypeMultiple,
    VHDecimalOprationTypeDivide
};

@implementation VHTime

@end

@interface VHTimer ()

/** 计时器*/
@property (nonatomic, strong) dispatch_source_t timer;
/** 是否使用init方式初始化*/
@property (nonatomic, assign, getter = isInitByDefault) BOOL initByDefault;
/** 结束时间 */
@property (nonatomic, assign) NSTimeInterval endTime;
/** 调度时间, 即计时器每秒减少/增加该数值*/
@property (nonatomic, assign) NSTimeInterval onceTime;
/** app进入后台时间 */
@property (nonatomic, assign) NSTimeInterval appDidEnterBackgroundTime;
/** app进入前台时间 */
@property (nonatomic, assign) NSTimeInterval appDidEnterForegroundTime;


@end

@implementation VHTimer

- (instancetype)initWithStartTimeinterval:(NSTimeInterval)timeinterval isAscend:(BOOL)isAscend progressBlock:(VHProgressBlock)progressBlock completionBlock:(VHTimerCompletion)completion {
    if (self = [super init]) {
        self.isAscend = isAscend;
        self.timerInterval = timeinterval;
        self.progressBlock = progressBlock;
        self.completion = completion;
        self.precision = 10;
        self.currentTime = 0;
        self.appDidEnterForegroundTime = 0;
        self.appDidEnterBackgroundTime = 0;
        [self configure];
    }

    return self;
}

- (void)setPrecision:(NSInteger)precision {
    _precision = precision;
    self.onceTime = [self value:(NSTimeInterval)precision byOpration:VHDecimalOprationTypeDivide percision:6 withValue:1000.0].doubleValue;
}

/** 通过init方法初始化*/
- (instancetype)init
{
    self = [super init];

    if (self) {
        self.initByDefault = YES;
        self.precision = 10;
        self.currentTime = 0;
        self.appDidEnterForegroundTime = 0;
        self.appDidEnterBackgroundTime = 0;
        [self addObserverAppStatus];
    }

    return self;
}

/** 添加app状态监听*/
- (void)addObserverAppStatus {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

/** app进入后台*/
- (void)appDidEnterBackground {
    [self suspend];
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss:SSS";
    self.appDidEnterBackgroundTime = [date timeIntervalSince1970];
}

/** app进入前台*/
- (void)appDidEnterForeground {
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];

    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    self.appDidEnterForegroundTime = [date timeIntervalSince1970];
    [self reCalculateMinder];
}

/** 因app进入后台后重新计算计时器的时间*/
- (void)reCalculateMinder {
    NSTimeInterval blank = [self value:self.appDidEnterForegroundTime byOpration:VHDecimalOprationTypeSubtract percision:6 withValue:self.appDidEnterBackgroundTime].doubleValue;

    if (self.isAscend) {
        NSTimeInterval theNewValue = [self value:self.currentTime byOpration:VHDecimalOprationTypeAdd percision:6 withValue:blank].doubleValue;

        if (theNewValue > self.endTime) {
            if (self.progressBlock) {
                VHTime *progress = [self timeProgress:theNewValue];
                self.progressBlock(progress);
            }

            if (self.completion) {
                self.completion();
                _complete = YES;
            }
        } else {
            self.currentTime = theNewValue;
            [self activate];
        }
    } else {
        NSTimeInterval theNewValue = [self value:self.currentTime byOpration:VHDecimalOprationTypeSubtract percision:6 withValue:blank].doubleValue;

        if (theNewValue <= 0) {
            if (self.progressBlock) {
                self.progressBlock([self timeProgress:0]);
            }

            if (self.completion) {
                self.completion();
                _complete = YES;
            }
        } else {
            self.currentTime = theNewValue;
            [self activate];
        }
    }
}

/** 计算时间进度*/
- (VHTime *)timeProgress:(NSTimeInterval)time
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];

    format.dateFormat = @"yyyy:MM:dd:HH:mm:ss:SSS";

    NSLocale *locale = [NSLocale currentLocale];
    NSString *localeStr = [locale localeIdentifier];
    format.timeZone = [[NSTimeZone alloc] initWithName:self.isLocale ? localeStr : @"GMT"];

    NSString *dateValue = [format stringFromDate:date];
    NSArray<NSString *> *timeArray = [dateValue componentsSeparatedByString:@":"];

    // 计算当前时间
    VHTime *progress = [[VHTime alloc] init];
    progress.year = timeArray[0];
    progress.month = timeArray[1];
    progress.day = timeArray[2];
    progress.hour = timeArray[3];
    progress.minute = timeArray[4];
    progress.second = timeArray[5];
    progress.millisecond = timeArray[6];

    // 计算剩余时间
    [self timeFormatted:time progress:progress];

    return progress;
}

- (void)timeFormatted:(int)totalSeconds progress:(VHTime *)progress
{
    progress.residueDay = (int)(totalSeconds / (3600 * 24));
    progress.residueHour = (int)((totalSeconds - progress.residueDay * 24 * 3600) / 3600);
    progress.residueMinute = (int)(totalSeconds - progress.residueDay * 24 * 3600 - progress.residueHour * 3600) / 60;
    progress.residueSecond = totalSeconds - progress.residueDay * 24 * 3600 - progress.residueHour * 3600 - progress.residueMinute * 60;
}

/** 值转换成NSDecmial*/
- (NSDecimalNumber *)numberValueWithString:(NSTimeInterval)time {
    NSString *stringValue = [NSString stringWithFormat:@"%f", time];

    return [NSDecimalNumber decimalNumberWithString:stringValue];
}

/** 不失精度加减乘除计算结果*/
- (NSDecimalNumber *)value:(NSTimeInterval)value byOpration:(VHDecimalOprationType)byOpration percision:(NSInteger)percision withValue:(NSTimeInterval)withValue {
    NSDecimalNumber *number = [self numberValueWithString:value];
    NSDecimalNumber *withNumber = [self numberValueWithString:withValue];
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:percision raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];

    switch (byOpration) {
        case VHDecimalOprationTypeAdd:
            return [number decimalNumberByAdding:withNumber withBehavior:handler];

            break;

        case VHDecimalOprationTypeSubtract:
            return [number decimalNumberBySubtracting:withNumber withBehavior:handler];

            break;

        case VHDecimalOprationTypeDivide:
            return [number decimalNumberByDividingBy:withNumber withBehavior:handler];

            break;

        case VHDecimalOprationTypeMultiple:
            return [number decimalNumberByMultiplyingBy:withNumber withBehavior:handler];

            break;

        default:
            return nil;

            break;
    }
}

/** 配置数据*/
- (void)configure {
    self.endTime = self.timerInterval;
    self.currentTime = self.isAscend ? (0.00) : (self.endTime);
    [self initTimerCompletion:^{
        if ((self.precision < 10) || (self.precision > 1000)) {
            @throw [NSException exceptionWithName:@"VHTimer-精度异常"
                                           reason:@"precision参数配置异常，大于1000毫秒的计时回调将无意义，以及小于10毫秒无实际意义"
                                         userInfo:nil];
        }

        if (!self.isAscend && self.timerInterval <= 0) {
            @throw [NSException exceptionWithName:@"VHTimer-参数：timerInterval配置失败"
                                           reason:@"倒计时模式下开始时时间不能为小于或等于0"
                                         userInfo:nil];
        }

        VHTime *progress = [self timeProgress:self.currentTime];

        if (self.isAscend) {
            self.currentTime = [self value:self.currentTime
                                byOpration:VHDecimalOprationTypeAdd
                                 percision:6
                                 withValue:self.onceTime].doubleValue;

            if (self.currentTime > self.endTime) {
                /// 纠正数据
                if (self.progressBlock) {
                    self.progressBlock([self timeProgress:self.endTime]);
                }

                if (self.completion) {
                    self.completion();
                    [self stop];
                    return;
                }
            } else {
                if (self.progressBlock) {
                    self.progressBlock(progress);
                }
            }
        } else {
            self.currentTime = [self value:self.currentTime
                                byOpration:VHDecimalOprationTypeSubtract
                                 percision:6
                                 withValue:self.onceTime].doubleValue;

            if (self.currentTime <= 0) {
                /// 纠正数据
                if (self.progressBlock) {
                    self.progressBlock([self timeProgress:0]);
                }

                if (self.completion) {
                    self.completion();
                    [self stop];
                    return;
                }
            } else {
                if (self.progressBlock) {
                    self.progressBlock(progress);
                }
            }
        }
    }];
}

/** 重置计时器并开始计时*/
- (void)restart {
    [self resumeTimerByRestart:YES];
}

/** 初始化timer*/
- (void)initTimerCompletion:(void (^)(void))completion {
    /** 获取一个全局的线程来运行计时器*/
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    /** 创建一个计时器*/
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);

    /** 设置计时器*/
    dispatch_source_set_timer(timer, dispatch_walltime(nil, 0), self.precision * NSEC_PER_MSEC, 0);
    /** 设置计时器的里操作事件*/
    dispatch_source_set_event_handler(timer, ^{
        if (completion) {
            completion();
        }
    });
    self.timer = timer;
}

/** 释放时打印消息*/
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [self stop];
    NSLog(@"❤️THE VHTIMER WAS DEALLOC!");
}

/** 开始计时*/
- (void)resume {
    if (_run || _suspend) {
        return;
    }

    _run = YES;
    [self resumeTimerByRestart:NO];
}

/** 计时器开始计时，若为重置计时器则配置计时器后开始计时 */
- (void)resumeTimerByRestart:(BOOL)isRestart {
    if (self.isInitByDefault) {
        [self configure];
        dispatch_resume(self.timer);
    } else {
        if (isRestart) {
            [self configure];
            dispatch_resume(self.timer);
        } else {
            dispatch_resume(self.timer);
        }
    }
}

/** 暂停计时*/
- (void)suspend {
    if (_suspend) {
        return;
    }

    if (self.timer) {
        dispatch_suspend(self.timer);
        _suspend = YES;
    }
}

/** 激活暂停的任务，继续任务*/
- (void)activate {
    if (!_suspend) {
        return;
    }

    if (self.timer) {
        dispatch_resume(self.timer);
        _suspend = NO;
    }
}

/** 结束计时*/
- (void)stop {
    _complete = YES;

    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
}

@end
