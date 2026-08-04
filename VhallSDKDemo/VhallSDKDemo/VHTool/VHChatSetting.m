//
//  VHChatSetting.m
//  VhallSDKDemo
//
//  Created by Vhall on 2026/7/28.
//

#import "VHChatSetting.h"

@interface VHChatSetting ()
// 所有私有UI控件写这里！
@property (nonatomic, strong) UITextView *textViewOnlyWatchHost;
@property (nonatomic, strong) UITextView *textViewOnlyWatchContext;
@property (nonatomic, strong) UITextView *textViewHideEffect;
@property (nonatomic, strong) UISwitch *switchControlOnlyWatchHost;
@property (nonatomic, strong) UISwitch *switchControlOnlyWatchContext;
@property (nonatomic, strong) UISwitch *switchControlHideEffect;
@property (nonatomic, strong) UIView *bgMaskView; // 黑色遮罩
@property (nonatomic, assign) BOOL onlyWatchHost; // 仅看主讲人

@property (nonatomic, assign) BOOL showOnlyWatchHost; // 仅看主讲人
@property (nonatomic, assign) BOOL showOnlyChatWatch; // 仅看聊天内容
@property (nonatomic, assign) BOOL showEffet; // 隐藏特效


@property (nonatomic, strong)    UIView *watchHostView;
@property (nonatomic, strong)    UIView *hideEffectView;
@property (nonatomic, strong)    UIView *watchContextView;


@end

@implementation VHChatSetting

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
// 两个初始化方法，必须加上
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}



- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}


/// 自定义初始化，传入初始状态
- (instancetype)initWithOnlyWatchHost:(BOOL)isOnlyWatchHost showOnlyHost:(BOOL)showOnlyHost showChat:(BOOL)showChat effect:(BOOL)effect{
    self = [super init];
    if (self) {
        [self setupUI];
        _onlyWatchHost = isOnlyWatchHost;
        self.switchControlOnlyWatchHost.on =_onlyWatchHost;
        
        if(!showOnlyHost){
            _watchHostView.hidden = YES;
        }
        if(!effect){
            _hideEffectView.hidden = YES;
        }
        if(!showChat){
            _watchContextView.hidden = YES;
        }
    }
    return self;
}

// 搭建UI
- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    _watchHostView = [[UIView alloc] init];
    [self addSubview:_watchHostView];
    [_watchHostView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(10); // 距离弹窗顶部10pt
        make.height.mas_equalTo(50);
    }];
    _watchContextView = [[UIView alloc] init];
    [self addSubview:_watchContextView];
    [_watchContextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(_watchHostView.mas_bottom).offset(0);
        make.height.mas_equalTo(50);
    }];
    _hideEffectView = [[UIView alloc] init];
    [self addSubview:_hideEffectView];
    [_hideEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(_watchContextView.mas_bottom).offset(0);
        make.height.mas_equalTo(50);
    }];
    
    [_watchHostView addSubview:self.textViewOnlyWatchHost];
    [_watchHostView addSubview:self.switchControlOnlyWatchHost];
    
    [_watchContextView addSubview:self.textViewOnlyWatchContext];
    [_watchContextView addSubview:self.switchControlOnlyWatchContext];
    
    [_hideEffectView addSubview:self.textViewHideEffect];
    [_hideEffectView addSubview:self.switchControlHideEffect];
    
    // 水平布局约束
    [self.textViewOnlyWatchHost mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_watchHostView).offset(16);
        make.centerY.equalTo(_watchHostView);
        make.right.equalTo(self.switchControlOnlyWatchHost.mas_left).offset(-12);
    }];

    [self.switchControlOnlyWatchHost mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_watchHostView).offset(-16);
        make.centerY.equalTo(_watchHostView);
        make.width.mas_equalTo(50); // switch固定宽度
    }];
    
    [self.textViewOnlyWatchContext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_watchContextView).offset(16);
        make.centerY.equalTo(_watchContextView);
        make.right.equalTo(self.switchControlOnlyWatchContext.mas_left).offset(-12);
    }];

    [self.switchControlOnlyWatchContext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_watchContextView).offset(-16);
        make.centerY.equalTo(_watchContextView);
        make.width.mas_equalTo(50); // switch固定宽度
    }];


    [self.textViewHideEffect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_hideEffectView).offset(16);
        make.centerY.equalTo(_hideEffectView);
        make.right.equalTo(self.switchControlHideEffect.mas_left).offset(-12);
    }];

    [self.switchControlHideEffect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_hideEffectView).offset(-16);
        make.centerY.equalTo(_hideEffectView);
        make.width.mas_equalTo(50); // switch固定宽度
    }];
}



-(UITextView*)textViewOnlyWatchHost{
    if(!_textViewOnlyWatchHost){
        _textViewOnlyWatchHost = [[UITextView alloc] init];
        _textViewOnlyWatchHost.font = [UIFont systemFontOfSize:15];
        _textViewOnlyWatchHost.translatesAutoresizingMaskIntoConstraints = NO;
        _textViewOnlyWatchHost.textColor = [UIColor blackColor];
        _textViewOnlyWatchHost.text = @"只看主办方";
        _textViewOnlyWatchHost.scrollEnabled = NO;
        _textViewOnlyWatchHost.editable = NO;
    }
    return _textViewOnlyWatchHost;
}


-(UITextView*)textViewOnlyWatchContext{
    if(!_textViewOnlyWatchContext){
        _textViewOnlyWatchContext = [[UITextView alloc] init];
        _textViewOnlyWatchContext.font = [UIFont systemFontOfSize:15];
        _textViewOnlyWatchContext.translatesAutoresizingMaskIntoConstraints = NO;
        _textViewOnlyWatchContext.textColor = [UIColor blackColor];
        _textViewOnlyWatchContext.text = @"仅查看聊天内容";
        _textViewOnlyWatchContext.scrollEnabled = NO;
        _textViewOnlyWatchContext.editable = NO;
    }
    return _textViewOnlyWatchContext;
}



-(UITextView*)textViewHideEffect{
    if(!_textViewHideEffect){
        _textViewHideEffect = [[UITextView alloc] init];
        _textViewHideEffect.font = [UIFont systemFontOfSize:15];
        _textViewHideEffect.translatesAutoresizingMaskIntoConstraints = NO;
        _textViewHideEffect.textColor = [UIColor blackColor];
        _textViewHideEffect.text = @"隐藏特效";
        _textViewHideEffect.scrollEnabled = NO;
        _textViewHideEffect.editable = NO;
    }
    return _textViewHideEffect;
}


-(UISwitch*)switchControlOnlyWatchHost{
    if(!_switchControlOnlyWatchHost){
        _switchControlOnlyWatchHost = [[UISwitch alloc] init];
        _switchControlOnlyWatchHost.on = _onlyWatchHost;
        _switchControlOnlyWatchHost.onTintColor = VHMainColor;
        [_switchControlOnlyWatchHost addTarget:self action:@selector(switchDidChange:) forControlEvents:UIControlEventValueChanged];
        _switchControlOnlyWatchHost.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _switchControlOnlyWatchHost;
}

-(UISwitch*)switchControlOnlyWatchContext{
    if(!_switchControlOnlyWatchContext){
        _switchControlOnlyWatchContext = [[UISwitch alloc] init];
        _switchControlOnlyWatchContext.on = NO;
        _switchControlOnlyWatchContext.onTintColor = VHMainColor;
        [_switchControlOnlyWatchContext addTarget:self action:@selector(switchDidChange:) forControlEvents:UIControlEventValueChanged];
        _switchControlOnlyWatchContext.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _switchControlOnlyWatchContext;
}

-(UISwitch*)switchControlHideEffect{
    if(!_switchControlHideEffect){
        _switchControlHideEffect = [[UISwitch alloc] init];
        _switchControlHideEffect.on = NO;
        _switchControlHideEffect.onTintColor = VHMainColor;
        [_switchControlHideEffect addTarget:self action:@selector(switchDidChange:) forControlEvents:UIControlEventValueChanged];
        _switchControlHideEffect.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _switchControlHideEffect;
}

// switch 点击回调
- (void)switchDidChange:(UISwitch *)sender {
    NSLog(@"开关状态：%d", sender.isOn);
}



#pragma mark - 弹窗显示、隐藏
- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    // 遮罩
    self.bgMaskView = [[UIView alloc] init];
    self.bgMaskView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.4];
    self.bgMaskView.frame = window.bounds;
    [window addSubview:self.bgMaskView];
    
    // 添加点击手势，点击遮罩关闭弹窗
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    // 防止点击弹窗内部也触发关闭
    tap.cancelsTouchesInView = NO;
    [self.bgMaskView addGestureRecognizer:tap];
    
    // 把弹窗添加到遮罩上
    [self.bgMaskView addSubview:self];
    
    // 弹窗宽度铺满左右，高度160，初始位置在屏幕底部外面（动画向上弹出）
    CGFloat width = window.bounds.size.width;
    CGFloat height = 200;
    self.frame = CGRectMake(0, window.bounds.size.height, width, height);
    self.layer.cornerRadius = 12;
    // 左上角、右上角圆角（底部不要圆角）
    self.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    
    [UIView animateWithDuration:0.25 animations:^{
        // 向上移动，贴底部显示
        self.frame = CGRectMake(0, window.bounds.size.height - height, width, height);
    }];
}

// 新增dismiss方法
- (void)dismiss {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, window.bounds.size.height, window.bounds.size.width, 160);
    } completion:^(BOOL finished) {
        if (self.callback) {
           self.callback(self.switchControlOnlyWatchHost.isOn,
                        self.switchControlOnlyWatchContext.isOn,
                         self.switchControlHideEffect.isOn);
        }
        
        [self removeFromSuperview];
        [self.bgMaskView removeFromSuperview];
    }];
}


@end
