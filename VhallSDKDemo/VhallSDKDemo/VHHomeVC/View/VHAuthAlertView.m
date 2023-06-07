//
//  VHAuthAlertView.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/2/22.
//

#import "VHAuthAlertView.h"

@interface VHAuthAlertView ()
/// 标题
@property (nonatomic, strong) UILabel *titleLab;
/// 观看地址
@property (nonatomic, strong) UITextField *verifyValueTextF;
/// 分割线
@property (nonatomic, strong) UIView *lineView;
/// 新版本进入
@property (nonatomic, strong) UIButton *newEnterRoomBtn;
/// 关闭按钮
@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation VHAuthAlertView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.2];

        [self addSubview:self.contentView];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.verifyValueTextF];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.newEnterRoomBtn];
        [self.contentView addSubview:self.closeBtn];

        // 初始化布局
        [self setUpMasonry];
    }

    return self;
}

#pragma mark - 初始化布局
- (void)setUpMasonry
{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.height.mas_equalTo(260);
    }];

    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(45);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];

    [self.verifyValueTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(280, 30));
    }];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.verifyValueTextF.mas_bottom);
        make.left.right.mas_equalTo(self.verifyValueTextF);
        make.height.mas_equalTo(.5);
    }];

    [self.newEnterRoomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.bottom.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(100, 45));
    }];

    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(18);
        make.right.mas_equalTo(-16);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - 弹窗
- (void)showAuthWithType:(NSString *)type
{
    self.verifyValueTextF.text = @"";

    if ([type isEqualToString:@"1"]) {
        self.titleLab.text = @"观看限制密码验证";
        self.verifyValueTextF.placeholder = @"请输入密码";
    } else if ([type isEqualToString:@"2"]) {
        self.titleLab.text = @"观看限制白名单验证";
        self.verifyValueTextF.placeholder = @"请输入白名单验证号码";
    }

    [[VUITool getCurrentScreenViewController].view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];

    [super show];
}

#pragma mark - 隐藏
- (void)disMissContentView
{
    [self.verifyValueTextF resignFirstResponder];
}

#pragma mark - 进入房间
- (void)newEnterRoomBtnAction:(UIButton *)sender
{
    [self disMissContentView];

    [super disMissContentView];

    if ([self.delegate respondsToSelector:@selector(changeTextWithVerifyValue:)]) {
        [self.delegate changeTextWithVerifyValue:self.verifyValueTextF.text];
    }
}

#pragma mark - 点击关闭
- (void)clickCloseBtn
{
    [super disMissContentView];
}

#pragma mark - 懒加载
- (UITextField *)verifyValueTextF {
    if (!_verifyValueTextF) {
        _verifyValueTextF = [[UITextField alloc] init];
        _verifyValueTextF.textColor = [UIColor blackColor];
        _verifyValueTextF.font = FONT(12);
    }

    return _verifyValueTextF;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.3];
    }

    return _lineView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = [UIColor colorWithHex:@"#1A1A1A"];
        _titleLab.font = FONT(14);
    }

    return _titleLab;
}

- (UIButton *)newEnterRoomBtn {
    if (!_newEnterRoomBtn) {
        _newEnterRoomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _newEnterRoomBtn.backgroundColor = [UIColor colorWithHex:@"#FB2626"];
        _newEnterRoomBtn.titleLabel.font = FONT(16);
        _newEnterRoomBtn.layer.cornerRadius = 45 / 2;
        [_newEnterRoomBtn setTitle:@"进入房间" forState:UIControlStateNormal];
        [_newEnterRoomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_newEnterRoomBtn addTarget:self action:@selector(newEnterRoomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }

    return _newEnterRoomBtn;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
        [_closeBtn setImage:[UIImage imageNamed:@"vh_close_alert"] forState:UIControlStateNormal];
    }

    return _closeBtn;
}

@end
