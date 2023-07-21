//
//  VHPushScreenCardDeleteAlert.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/7/4.
//

#import "VHPushScreenCardDeleteAlert.h"

@interface VHPushScreenCardDeleteAlert ()
/// 图标
@property (nonatomic, strong) UIImageView *icon;
/// 描述
@property (nonatomic, strong) UILabel *titleLab;
/// 关闭
@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation VHPushScreenCardDeleteAlert

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        self.alpha = 0;
        self.backgroundColor = [UIColor clearColor];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissContentView)];
        [self addGestureRecognizer:tap];

        [self addSubview:self.contentView];
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.closeBtn];

        // 初始化布局
        [self setUpMasonry];
    }

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.contentView.backgroundColor = [UIColor bm_colorGradientChangeWithSize:self.contentView.size direction:IHGradientChangeDirectionLevel startColor:[UIColor colorWithHex:@"#FDF1ED"] endColor:[UIColor colorWithHex:@"#F3F2FF"]];
}

#pragma mark - 初始化布局
- (void)setUpMasonry
{
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(Screen_Width - 55, 210));
    }];
    
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(47);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];

    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_icon.mas_bottom).offset(12);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
    
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
}

#pragma mark - 显示
- (void)show
{
    [super show];
}

#pragma mark - 隐藏
- (void)disMissContentView
{
    [super disMissContentView];
}

#pragma mark - 点击关闭
- (void)clickToCloseBtn
{
    [self disMissContentView];
}

#pragma mark - 懒加载

- (UIImageView *)icon
{
    if (!_icon) {
        _icon = [UIImageView new];
        _icon.image = [UIImage imageNamed:@"vh_pushcard_delete"];
    }

    return _icon;
}
- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = FONT_Blod(16);
        _titleLab.text = @"抱歉，内容已被删除";
        _titleLab.textColor = [UIColor colorWithHex:@"#262626"];
    }

    return _titleLab;
}
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setImage:[UIImage imageNamed:@"vh_close_alert"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(clickToCloseBtn) forControlEvents:UIControlEventTouchUpInside];
    }

    return _closeBtn;
}

@end
