//
//  VHBeautyView.m
//  UIModel
//
//  Created by jinbang.li on 2022/2/16.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHBeautyView.h"
#define VHBeautyViewHeight  200
@interface VHBeautyView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UIView *contentView; //美颜内容视图
@property (nonatomic,strong) UIProgressView *progressView;//调整进度条视图
@property (nonatomic,strong) UIView *sliderView;//滑动块视图
@property (nonatomic, strong) UICollectionView * collectionView;//美颜，滤镜选择
@end
@implementation VHBeautyView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupContent];
    }
    return self;
}
- (void)setupContent{
    self.frame = CGRectMake(0, 0, VHScreenWidth, VHScreenHeight);
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)]];
    
    //添加内容视图 头部SegementControl + 重置 中间可滑动的collectionview + 美颜效果下的可滑动进度条
    [self setupBeautyTopView];
    //设置滑动调节视图
    [self setupSliderView];
    //设置collectionView视图
    [self setupCollectionView];
}
- (void)setupCollectionView{
    
}
- (void)setupSliderView{
    [self.contentView addSubview:self.sliderView];
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(VHScreenWidth/2 - 75, 0, 150, 20)];
    slider.minimumValue = 0;// 设置最小值
    slider.maximumValue = 100;// 设置最大值
    slider.value = (slider.minimumValue + slider.maximumValue) / 2;// 设置初始值
    slider.continuous = YES;// 设置可连续变化
//    slider.minimumTrackTintColor = [UIColor greenColor]; //滑轮左边颜色，如果设置了左边的图片就不会显示
//    slider.maximumTrackTintColor = [UIColor redColor]; //滑轮右边颜色，如果设置了右边的图片就不会显示
//    slider.thumbTintColor = [UIColor redColor];//设置了滑轮的颜色，如果设置了滑轮的样式图片就不会显示
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];// 针对值变化添加响应方法
    [self.sliderView addSubview:slider];
}
- (void)sliderValueChanged:(UISlider *)slider{
    NSLog(@"value====%f",slider.value);
}
- (void)setupBeautyTopView{
    UISegmentedControl *displayModeControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:NSLocalizedString(@"美颜", nil), NSLocalizedString(@"滤镜", nil), nil]];
    displayModeControl.selectedSegmentIndex = 0;
    [displayModeControl addTarget:self action:@selector(handleSwitchOfDisplayMode:) forControlEvents:UIControlEventValueChanged];
    displayModeControl.frame = CGRectMake(0, 0, 120, 30);
    [self.contentView addSubview:displayModeControl];
    
    UIButton *reset = [[UIButton alloc] initWithFrame:CGRectMake(VHScreenWidth - 80, 0, 30, 30)];
    [reset setTitle:@"重置" forState:UIControlStateNormal];
    [reset addTarget:self action:@selector(reset:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:reset];
}
- (void)reset:(UIButton *)reset{
    NSLog(@"重置");
}
- (void)handleSwitchOfDisplayMode:(UISegmentedControl *)sender;
{
    NSInteger index = sender.selectedSegmentIndex;
    switch (index) {
        case 0:
            //美颜
            
            break;
        case 1:
            //滤镜
            
            break;
        default:
            break;
    }
}
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, VHScreenHeight - VHBeautyViewHeight, VHScreenWidth, VHBeautyViewHeight)];
        _contentView.userInteractionEnabled = YES;
        _contentView.backgroundColor = UIColor.grayColor;
        [self addSubview:_contentView];
    }
    return _contentView;
}
///显示从底部向上弹出的UIView(包含遮罩)
- (void)showDisplayBeautyView:(UIView *)view{
    if (!view) {
        return;
    }
    [view addSubview:self];
    [view addSubview:self.contentView];
    [self.contentView setFrame:CGRectMake(0, VHScreenHeight, VHScreenWidth, VHBeautyViewHeight)];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
        [self.contentView setFrame:CGRectMake(0, VHScreenHeight - VHBeautyViewHeight, VHScreenWidth, VHBeautyViewHeight)];
    } completion:nil];
}
- (void)disMissView{
    [self.contentView setFrame:CGRectMake(0, VHScreenHeight - VHBeautyViewHeight, VHScreenWidth, VHBeautyViewHeight)];
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0.0;
        [_contentView setFrame:CGRectMake(0, VHScreenHeight, VHScreenWidth, VHBeautyViewHeight)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [_contentView removeFromSuperview];
    }];
}
- (UIView *)sliderView{
    if (!_sliderView) {
        _sliderView = [[UIView alloc] initWithFrame:CGRectMake(0,40, VHScreenWidth, 40)];
        _sliderView.backgroundColor = [UIColor redColor];
        _sliderView.userInteractionEnabled = YES;
    }
    return _sliderView;
}

- (void)setupProgressView{
    [self addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(VHScreenHeight - VHBeautyViewHeight - 40);
        make.height.mas_equalTo(20);
    }];
}
- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.trackTintColor = [UIColor colorWithRed:199/255.0 green:198/255.0 blue:198/255.0 alpha:1];
        _progressView.layer.masksToBounds = YES;
        _progressView.layer.cornerRadius = 1;
        _progressView.progress = 0.5;
    }
    return _progressView;
}
@end
