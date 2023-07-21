//
//  VHLottery.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/3/15.
//

#import "VHLottery.h"
#import "VHLotteryLosingView.h"
#import "VHLotteryPrivateView.h"
#import "VHLotteryResultView.h"
#import "VHLotterySubmitView.h"
#import "VHLotteryTurntableView.h"
#import "VHLotteryWinListView.h"

@interface VHLottery ()<VHallLotteryDelegate, VHLotteryResultViewDelegate, VHLotteryLosingViewDelegate>
/// 抽奖类
@property (nonatomic, strong) VHallLottery *vhLottery;
/// 活动详情
@property (nonatomic, strong) VHWebinarInfoData *webinarInfoData;
/// 参与抽奖弹窗
@property (nonatomic, strong) VHLotteryTurntableView *lotteryTurntableView;
/// 抽奖结果弹窗
@property (nonatomic, strong) VHLotteryResultView *lotteryResultView;
/// 未中奖
@property (nonatomic, strong) VHLotteryLosingView *lotteryLosingView;
/// 寄送领奖
@property (nonatomic, strong) VHLotterySubmitView *lotterySubmitView;
/// 私信领奖
@property (nonatomic, strong) VHLotteryPrivateView *lotteryPrivateView;
/// 中奖名单
@property (nonatomic, strong) VHLotteryWinListView *lotteryWinListView;
@end

@implementation VHLottery

#pragma mark - 初始化
- (instancetype)initLotteryWithObj:(NSObject *)obj webinarInfoData:(VHWebinarInfoData *)webinarInfoData
{
    if ([super init]) {
        self.webinarInfoData = webinarInfoData;

        self.vhLottery = [[VHallLottery alloc] initWithObject:obj];
        self.vhLottery.delegate = self;
    }

    return self;
}

#pragma mark - 抽奖开始
- (void)startLottery:(VHallStartLotteryModel *)msg
{
    [self dismiss];

    if ([self.delegate respondsToSelector:@selector(startLottery:)]) {
        [self.delegate startLottery:msg];
    }

    // 非全屏展示
    if (![VUITool isFullScreen]) {
        [self.lotteryTurntableView showLotteryTurntableWithVHLottery:self.vhLottery startModel:msg];
    }
}

#pragma mark - 抽奖结束
- (void)endLottery:(VHallEndLotteryModel *)msg
{
    [self dismiss];

    if ([self.delegate respondsToSelector:@selector(endLottery:)]) {
        [self.delegate endLottery:msg];
    }

    // 非全屏展示
    if (![VUITool isFullScreen]) {
        // 判断自己是否中奖
        if (msg.isWin) {
            // 中奖
            [self.lotteryResultView showLotteryResultWithVHLottery:self.vhLottery endLotteryModel:msg];
        } else {
            // 未中奖
            [self.lotteryLosingView showLotteryLosingWithVHLottery:self.vhLottery endLotteryModel:msg];
        }
    }
}

#pragma mark - 点击立即领奖
- (void)clickNowPrizeEndLotteryModel:(VHallEndLotteryModel *)endLotteryModel
{
    [self dismiss];

    __weak __typeof(self) weakSelf = self;
    [self.vhLottery getSubmitConfigWithWebinarId:self.webinarInfoData.webinar.data_id
                                      lottery_id:endLotteryModel.huadieInfo.lottery_id
                                         success:^(NSArray<VHallLotterySubmitConfig *> *submitList, NSInteger receive_award_way) {
        // 非全屏展示
        if (![VUITool isFullScreen]) {
            // 判断领奖方式 1寄送奖品,2私信兑奖,3无需领奖
            if (receive_award_way == 1) {
                // 寄送界面 填写信息弹窗
                [weakSelf.lotterySubmitView showLotterySubmitWithVHLottery:weakSelf.vhLottery
                                                           endLotteryModel:endLotteryModel
                                                                submitList:submitList];
                }

            if (receive_award_way == 2) {
                // 私信领奖
                [weakSelf.lotteryPrivateView showLotteryPrivateWithVHLottery:weakSelf.vhLottery
                                                             endLotteryModel:endLotteryModel
                                                                  submitList:submitList];
            }
        }
    }
                                          failed:^(NSDictionary *failedData) {
        NSString *msg = [NSString stringWithFormat:@"%@", failedData[@"content"]];
        [VHProgressHud showToast:msg];
    }];
}

#pragma mark - 点击查看中奖名单
- (void)clickResultCheckWinListWithEndLotteryModel:(VHallEndLotteryModel *)endLotteryModel
{
    [self dismiss];

    // 非全屏展示
    if (![VUITool isFullScreen]) {
        [self.lotteryWinListView showLotteryWinListWithVHLottery:self.vhLottery endLotteryModel:endLotteryModel];
    }
}

#pragma mark - 点击查看中奖名单
- (void)clickCheckWinListWithEndLotteryModel:(VHallEndLotteryModel *)endLotteryModel
{
    [self dismiss];

    // 非全屏展示
    if (![VUITool isFullScreen]) {
        [self.lotteryWinListView showLotteryWinListWithVHLottery:self.vhLottery endLotteryModel:endLotteryModel];
    }
}

#pragma mark - 隐藏弹窗
- (void)dismiss
{
    [_lotteryTurntableView dismiss];
    [_lotteryResultView dismiss];
    [_lotteryLosingView dismiss];
    [_lotterySubmitView dismiss];
    [_lotteryPrivateView dismiss];
    [_lotteryWinListView dismiss];
}

#pragma mark - 懒加载
- (VHLotteryTurntableView *)lotteryTurntableView
{
    if (!_lotteryTurntableView) {
        _lotteryTurntableView = [[VHLotteryTurntableView alloc] initWithFrame:[VUITool getCurrentScreenViewController].view.bounds];
    }

    return _lotteryTurntableView;
}

- (VHLotteryResultView *)lotteryResultView
{
    if (!_lotteryResultView) {
        _lotteryResultView = [[VHLotteryResultView alloc] initWithFrame:[VUITool getCurrentScreenViewController].view.bounds];
        _lotteryResultView.delegate = self;
    }

    return _lotteryResultView;
}

- (VHLotteryLosingView *)lotteryLosingView
{
    if (!_lotteryLosingView) {
        _lotteryLosingView = [[VHLotteryLosingView alloc] initWithFrame:[VUITool getCurrentScreenViewController].view.bounds];
        _lotteryLosingView.delegate = self;
    }

    return _lotteryLosingView;
}

- (VHLotterySubmitView *)lotterySubmitView
{
    if (!_lotterySubmitView) {
        _lotterySubmitView = [[VHLotterySubmitView alloc] initWithFrame:[VUITool getCurrentScreenViewController].view.bounds];
    }

    return _lotterySubmitView;
}

- (VHLotteryPrivateView *)lotteryPrivateView
{
    if (!_lotteryPrivateView) {
        _lotteryPrivateView = [[VHLotteryPrivateView alloc] initWithFrame:[VUITool getCurrentScreenViewController].view.bounds];
    }

    return _lotteryPrivateView;
}

- (VHLotteryWinListView *)lotteryWinListView
{
    if (!_lotteryWinListView) {
        _lotteryWinListView = [[VHLotteryWinListView alloc] initWithFrame:[VUITool getCurrentScreenViewController].view.bounds];
    }

    return _lotteryWinListView;
}

@end
