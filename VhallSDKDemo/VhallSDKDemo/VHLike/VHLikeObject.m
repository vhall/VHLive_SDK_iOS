//
//  VHLikeObject.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/16.
//

#import "UIButton+VHBadge.h"
#import "VHLikeObject.h"
#import "VHLiveSaleAnimationTool.h"
#import "VHLiveWeakTimer.h"

@interface VHLikeObject ()<VHallLikeObjectDelegate>
/// 点赞类
@property (nonatomic, strong) VHallLikeObject *likeObject;
/// 点赞计时器
@property (nonatomic, strong) dispatch_source_t likeTimer;
/// 点赞图片数量
@property (nonatomic, assign) NSInteger likeImgNumbers;
/// 点赞图片数组
@property (nonatomic, strong) NSMutableArray *likeImageArray;
/// 点赞次数
@property (nonatomic, assign) NSInteger likeTapCount;
/// 计时器
@property (nonatomic, strong) NSTimer *timer;
/// 当前赞总数
@property (nonatomic, assign) NSInteger num;
/// roomID
@property (nonatomic, strong) VHWebinarInfoData *webinarInfoData;
@end

@implementation VHLikeObject

- (instancetype)init
{
    if ([super init]) {
        self = [VHLikeObject buttonWithType:UIButtonTypeCustom];

        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 35 / 2;
        [self setImage:[UIImage imageNamed:@"vh_fs_like_btn"] forState:UIControlStateNormal];
        [self addTarget:self action:@selector(clickLikeBtn) forControlEvents:UIControlEventTouchUpInside];
    }

    return self;
}

#pragma mark - 初始化
- (void)requestObject:(NSObject *)obj webinarInfoData:(VHWebinarInfoData *)webinarInfoData
{
    self.likeObject = [[VHallLikeObject alloc] initWithObject:obj];
    self.likeObject.delegate = self;

    self.webinarInfoData = webinarInfoData;

    [self requestGetRoomLikeWithRoomId];
}

#pragma mark - ---------------------点赞业务---------------------------
#pragma mark - 获取当前房间点赞总数
- (void)requestGetRoomLikeWithRoomId
{
    __weak __typeof(self) weakSelf = self;
    [VHallLikeObject getRoomLikeWithRoomId:self.webinarInfoData.interact.room_id
                                  complete:^(NSInteger total, NSError *error) {
        VHLog(@"当前房间点赞总数 === %ld", total);

        if (total) {
            [weakSelf vhPraiseTotalToNum:total];
        }

        if (error) {
            [VHProgressHud showToast:error.localizedDescription];
        }
    }];
}

#pragma mark - 更新点赞总数
- (void)vhPraiseTotalToNum:(NSInteger)num
{
    self.num = num;
    //数值
    self.badgeValue = num > 999 ? @"999+" : [NSString stringWithFormat:@"%ld", num];
    //边距尺寸
    self.badgePadding = 5;
    //尺寸
    self.badgeMinSize = 10;
    //背景颜色
    self.badgeBGColor = [UIColor redColor];
    //字体颜色
    self.badgeTextColor = [UIColor whiteColor];
    //x坐标值
    self.badgeOriginX = 17;
    //y坐标值
    self.badgeOriginY = -7;
}

#pragma mark - 点赞
- (void)clickLikeBtn
{
    [self destroyTimer];

    self.timer = [VHLiveWeakTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(recoverLikeImg) userInfo:nil repeats:NO];

    self.likeTapCount++;

    self.likeImgNumbers = round(random() % 4) + 1 + self.likeImgNumbers;

    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(requestRoomlikeToNum) object:nil];

    [self vhPraiseTotalToNum:self.num + 1];

    [self startLikeTimer:self.likeImgNumbers];
}

- (void)destroyTimer
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - 恢复点赞效果
- (void)recoverLikeImg
{
    [self destroyTimer];
}

#pragma mark - 连续点赞
- (void)startLikeTimer:(NSInteger)likeNumber {
    dispatch_queue_t queue = dispatch_get_main_queue();

    self.likeTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(.1 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.likeTimer, start, interval, 0);
    dispatch_source_set_event_handler(self.likeTimer, ^{
        static NSInteger liveTimeIdx = 0;
        liveTimeIdx += 1;

        if (self.likeImageArray.count) {
            uint32_t count = (uint32_t)self.likeImageArray.count;
            NSUInteger r = arc4random_uniform(count);
            NSString *imgUrl = self.likeImageArray[r];
            [VHLiveSaleAnimationTool praiseAnimation:imgUrl view:[VUITool viewControllerWithView:self].view];
        } else {
            [VHLiveSaleAnimationTool praiseAnimation:@"" view:[VUITool viewControllerWithView:self].view];
        }

        if (liveTimeIdx >= self.likeImgNumbers) {
            self.likeImgNumbers = 0;
            dispatch_source_cancel(self.likeTimer);
            liveTimeIdx = 0;

            [self performSelector:@selector(requestRoomlikeToNum) withObject:nil afterDelay:2];
        }
    });
    dispatch_resume(self.likeTimer);
}

- (void)badgeThumbsUpCount:(int)count
{
    if (count < 1) {
        return;
    }
}

#pragma mark - 点赞接口
- (void)requestRoomlikeToNum
{
    __weak __typeof(self) weakSelf = self;
    [VHallLikeObject createUserLikeWithRoomId:self.webinarInfoData.interact.room_id
                                          num:self.likeTapCount
                                     complete:^(NSDictionary *responseObject, NSError *error) {
        VHLog(@"点赞成功");
        weakSelf.likeTapCount = 0;
    }];
}

#pragma mark - 懒加载
- (NSMutableArray *)likeImageArray
{
    if (!_likeImageArray) {
        _likeImageArray = [NSMutableArray arrayWithObjects:@"vh_fs_like_btn_1", @"vh_fs_like_btn_2", @"vh_fs_like_btn_3", @"vh_fs_like_btn_4", @"vh_fs_like_btn_5", @"vh_fs_like_btn_6", @"vh_fs_like_btn_7", @"vh_fs_like_btn_8", @"vh_fs_like_btn_9", nil];
    }

    return _likeImageArray;
}

@end
