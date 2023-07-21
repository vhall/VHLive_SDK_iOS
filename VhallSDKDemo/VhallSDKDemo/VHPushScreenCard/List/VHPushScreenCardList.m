//
//  VHPushScreenCardList.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/7/3.
//

#import "VHPushScreenCardList.h"
#import "VHPushScreenCardAlert.h"

@implementation VHPushScreenCardListCell

+ (VHPushScreenCardListCell *)createCellWithTableView:(UITableView *)tableView
{
    VHPushScreenCardListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VHPushScreenCardListCell"];

    if (!cell) {
        cell = [[VHPushScreenCardListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"VHPushScreenCardListCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];

        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.titleLab];
        [self.bgView addSubview:self.timeLab];

        // 设置约束
        [self setMasonryUI];
    }

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setMasonryUI
{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];

    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(22);
        make.top.mas_equalTo(22);
        make.right.mas_equalTo(-22);
    }];

    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
    }];

    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(5);
        make.left.mas_equalTo(self.titleLab.mas_left);
        make.bottom.mas_equalTo(-12);
    }];

    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bgView.mas_bottom).priorityHigh();
    }];
}

- (void)setModel:(VHPushScreenCardItem *)model
{
    _model = model;
    
    self.titleLab.text = model.title;
    
    NSString *inputString = model.push_time;

    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [inputFormatter dateFromString:inputString];

    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"MM-dd HH:mm"];
    NSString *outputString = [outputFormatter stringFromDate:date];
    
    self.timeLab.text = outputString;
}

#pragma mark - 懒加载
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 8;
        _bgView.backgroundColor = [UIColor whiteColor];
    }

    return _bgView;
}

- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.numberOfLines = 2;
        _titleLab.preferredMaxLayoutWidth = Screen_Width - 22 - 12 - 12 - 22;
        _titleLab.font = FONT(14);
        _titleLab.textColor = [UIColor colorWithHex:@"#1A1A1A"];
    }

    return _titleLab;
}

- (UILabel *)timeLab
{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.font = FONT(12);
        _timeLab.textColor = [UIColor colorWithHex:@"#8C8C8C"];
    }

    return _timeLab;
}

@end

@interface VHPushScreenCardList ()<UITableViewDelegate, UITableViewDataSource, VHPushScreenCardObjectDelegate, UIGestureRecognizerDelegate>

/// 容器
@property (nonatomic, strong) UIView *contentView;
/// 图标
@property (nonatomic, strong) UIImageView *icon;
/// 列表
@property (nonatomic, strong) UITableView *tableView;
/// 关闭
@property (nonatomic, strong) UIButton *closeBtn;
/// 数据源
@property (nonatomic, strong) NSMutableArray *dataSource;
/// 页码
@property (nonatomic, assign) NSInteger pageNum;
/// 活动id
@property (nonatomic, copy) NSString *webinar_id;
/// 场次id
@property (nonatomic, copy) NSString *switch_id;

/// 推屏卡片类
@property (nonatomic, strong) VHPushScreenCardObject *pushScreenCardObject;
/// 参与抽奖弹窗
@property (nonatomic, strong) VHPushScreenCardAlert *pushScreenCardAlert;

@end

@implementation VHPushScreenCardList

- (instancetype)initWithFrame:(CGRect)frame object:(NSObject *)object
{
    if ([super initWithFrame:frame]) {
        self.alpha = 0;
        self.backgroundColor = [UIColor clearColor];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissContentView)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];

        // 推屏卡片
        if (!_pushScreenCardObject) {
            _pushScreenCardObject = [[VHPushScreenCardObject alloc] initWithObject:object];
            _pushScreenCardObject.delegate = self;
        }

        [self addSubview:self.contentView];
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.closeBtn];
        [self.contentView addSubview:self.tableView];

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
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(self.width, 338));
    }];

    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(125, 60));
    }];

    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(67);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self.mas_width);
    }];

    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
}

#pragma mark - 显示
- (void)loadDataWebinarId:(NSString *)webinar_id switch_id:(NSString *)switch_id isShow:(BOOL)isShow
{
    self.webinar_id = webinar_id;
    self.switch_id = switch_id;
    // 加载
    [self requestPushCardListWithWebinarId:webinar_id switch_id:switch_id pageNum:1 isShow:isShow];
}

#pragma mark - 显示
- (void)show
{
    if (self.dataSource.count <= 0) {
        [VHProgressHud showToast:@"暂无推屏列表"];
        return;
    }

    self.alpha = 0;
    [UIView animateWithDuration:0.3
                     animations:^{
        self.alpha = 1;
    }
                     completion:^(BOOL finished) {
    }];
}

#pragma mark - 隐藏
- (void)disMissContentView {
    [UIView animateWithDuration:0.3
                     animations:^{
        self.alpha = 0;
    }
                     completion:^(BOOL finished) {
    }];
}

#pragma mark - 手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isEqual:self]) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - 推屏列表列表
- (void)requestPushCardListWithWebinarId:(NSString *)webinar_id switch_id:(NSString *)switch_id pageNum:(NSInteger)pageNum isShow:(BOOL)isShow
{
    self.pageNum = pageNum;
    __weak __typeof(self) weakSelf = self;
    [VHPushScreenCardObject requestPushScreenCardListWithWebinarId:webinar_id switch_id:switch_id curr_page:pageNum page_size:10 complete:^(NSArray<VHPushScreenCardItem *> *list, NSInteger total, NSError *error) {
        __strong __typeof(weakSelf)self = weakSelf;
        
        if (list) {
            
            if (pageNum == 1) {
                [self.dataSource removeAllObjects];
            }
            
            [self.dataSource addObjectsFromArray:list];

            if (self.dataSource.count >= total) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
            
            // 显示弹窗
            if (isShow) {
                [self show];
            }
            
            self.pageNum++;
        }
        
        if (error) {
            [VHProgressHud showToast:error.domain];
            [self.tableView.mj_footer endRefreshing];
        }
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VHPushScreenCardListCell *cell = [VHPushScreenCardListCell createCellWithTableView:tableView];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 隐藏
    [self disMissContentView];
    
    // 点击展示
    VHPushScreenCardItem * item = self.dataSource[indexPath.row];
    [self.pushScreenCardAlert showPushScreenCard:item isChat:NO];
}

#pragma mark - 显示弹窗
- (void)showPushScreenCard:(VHPushScreenCardItem *)model
{
    [self.pushScreenCardAlert showPushScreenCard:model isChat:NO];
}

#pragma mark - VHPushScreenCardObject
#pragma mark 推屏卡片消息
- (void)pushScreenCardModel:(VHPushScreenCardItem *)model
{
    // 刷新列表 (如果没活动id,则代表没有打开过列表也就不需要执行刷新操作)
    if (![VUITool isBlankString:self.webinar_id]) {
        [self requestPushCardListWithWebinarId:self.webinar_id switch_id:self.switch_id pageNum:1 isShow:NO];
    }

    // 非全屏展示
    if (![VUITool isFullScreen]) {
        // 展示弹窗
        [self.pushScreenCardAlert showPushScreenCard:model isChat:YES];
    }
    
    // 判断代理是否实现了推送屏幕卡片的回调方法
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushScreenCardModel:)]) {
        [self.delegate pushScreenCardModel:model];
    }
    
    // 自动化测试,开始推屏卡片
    NSMutableDictionary *otherInfo = [NSMutableDictionary dictionary];
    [VUITool sendTestsNotificationCenterWithKey:VHTests_PushScreenCard otherInfo:otherInfo];
}

#pragma mark 更新推屏卡片
- (void)updateScreenCardModel:(VHPushScreenCardItem *)model
{
    // 刷新列表 (如果没活动id,则代表没有打开过列表也就不需要执行刷新操作)
    if (![VUITool isBlankString:self.webinar_id]) {
        [self requestPushCardListWithWebinarId:self.webinar_id switch_id:self.switch_id pageNum:1 isShow:NO];
    }
}

#pragma mark 删除推屏卡片
- (void)deleteScreenCardList:(NSArray *)list
{
    // 刷新列表 (如果没活动id,则代表没有打开过列表也就不需要执行刷新操作)
    if (![VUITool isBlankString:self.webinar_id]) {
        [self requestPushCardListWithWebinarId:self.webinar_id switch_id:self.switch_id pageNum:1 isShow:NO];
    }
}

#pragma mark - 点击关闭
- (void)clickToCloseBtn
{
    [self disMissContentView];
}

#pragma mark - 懒加载
- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor colorWithHex:@"#FFF4F4"];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 8;
    }

    return _contentView;
}

- (UIImageView *)icon
{
    if (!_icon) {
        _icon = [UIImageView new];
        _icon.image = [UIImage imageNamed:@"vh_pushcard_title_icon"];
    }

    return _icon;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setImage:[UIImage imageNamed:@"vh_close_alert"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(clickToCloseBtn) forControlEvents:UIControlEventTouchUpInside];
    }

    return _closeBtn;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, 400) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.estimatedRowHeight = 180;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        __weak __typeof(self) weakSelf = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf requestPushCardListWithWebinarId:self.webinar_id switch_id:self.switch_id pageNum:1 isShow:NO];
        }];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf requestPushCardListWithWebinarId:self.webinar_id switch_id:self.switch_id pageNum:self.pageNum isShow:NO];
        }];
    }

    return _tableView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }

    return _dataSource;
}

- (VHPushScreenCardAlert *)pushScreenCardAlert
{
    if (!_pushScreenCardAlert) {
        _pushScreenCardAlert = [[VHPushScreenCardAlert alloc] initWithFrame:[VUITool getCurrentScreenViewController].view.bounds];
    }
    return _pushScreenCardAlert;
}

#pragma mark - 释放
- (void)dealloc
{
    VHLog(@"%s释放", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String]);
}

@end
