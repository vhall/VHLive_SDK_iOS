//
//  VHAirPlayViewController.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/2/6.
//

#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "VHAirPlayViewController.h"

@interface VHAirPlayViewController ()<AVRoutePickerViewDelegate>
@property (nonatomic, strong) UIView *playerView;
@property (nonatomic, strong) AVPlayer *avPlayer;
@property (nonatomic, strong) AVPlayerItem *avPlayerItem;
@property (nonatomic, strong) AVPlayerLayer *avPlayerLayer;
@property (nonatomic, strong) AVRoutePickerView *routePickerView;
@property (nonatomic, strong) MPVolumeView *volumeView;

@end

@implementation VHAirPlayViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    NSURL *playUrl = [NSURL URLWithString:@"http://v3.cztv.com/cztv/vod/2018/06/28/7c45987529ea410dad7c088ba3b53dac/h264_1500k_mp4.mp4"];

    // 初始化view
    self.playerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Width * 9 / 16)];
    [self.view addSubview:self.playerView];

    // 初始化播放器
    self.avPlayerItem = [AVPlayerItem playerItemWithURL:playUrl];
    self.avPlayer = [AVPlayer playerWithPlayerItem:self.avPlayerItem];
    self.avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];

    // 设置布局
    [self.avPlayerLayer setFrame:self.playerView.bounds];
    [self.playerView.layer addSublayer:self.avPlayerLayer];

    // 播放
    [self.avPlayer play];

    // 初始化AirPlay按钮
    if (@available(iOS 11.0, *)) {
        AVRoutePickerView *routePickerView = [[AVRoutePickerView alloc]initWithFrame:CGRectMake(0, Screen_Width * 9 / 16 + 10, 30, 30)];
        // 活跃状态颜色
        routePickerView.activeTintColor = [UIColor redColor];
        // 设置代理
        routePickerView.delegate = self;
        [self.view addSubview:routePickerView];
    } else {
        MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(0, Screen_Width * 9 / 16 + 10, 30, 30)];
        volumeView.showsVolumeSlider = NO;
        volumeView.backgroundColor = UIColor.blueColor;
        [self.view addSubview:volumeView];
    }
}

#pragma mark - AirPlay界面弹出时回调
- (void)routePickerViewWillBeginPresentingRoutes:(AVRoutePickerView *)routePickerView API_AVAILABLE(ios(11.0)) {
}

#pragma mark - AirPlay界面结束时回调
- (void)routePickerViewDidEndPresentingRoutes:(AVRoutePickerView *)routePickerView API_AVAILABLE(ios(11.0)) {
}


@end
