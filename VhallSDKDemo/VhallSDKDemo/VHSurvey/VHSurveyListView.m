//
//  VHSurveyListView.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/16.
//

#import "VHSurveyListView.h"
#import "VHSurveyWebView.h"

@implementation VHSurveyListCell

+ (VHSurveyListCell *)createCellWithTableView:(UITableView *)tableView
{
    VHSurveyListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VHSurveyListCell"];

    if (!cell) {
        cell = [[VHSurveyListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"VHSurveyListCell"];
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
        [self.bgView addSubview:self.checkLab];

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

    [self.checkLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(5);
        make.right.mas_equalTo(self.titleLab.mas_right);
        make.bottom.mas_equalTo(-12);
    }];

    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bgView.mas_bottom).priorityHigh();
    }];
}

- (void)setModel:(VHSurveyModel *)model
{
    _model = model;

    self.titleLab.text = model.title;

    self.timeLab.text = model.created_at;

    self.checkLab.text = model.is_answered ? @"已填写" : @"填写";
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
        _titleLab.numberOfLines = 0;
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

- (UILabel *)checkLab
{
    if (!_checkLab) {
        _checkLab = [[UILabel alloc] init];
        _checkLab.font = FONT(12);
        _checkLab.textColor = [UIColor colorWithHex:@"#3562FA"];
    }

    return _checkLab;
}

@end

@interface VHSurveyListView ()<UITableViewDelegate, UITableViewDataSource, VHallSurveyDelegate, UIGestureRecognizerDelegate>

/// 问卷嵌入页
@property (nonatomic, strong) VHSurveyWebView *surveyWebView;
/// 容器
@property (nonatomic, strong) UIView *contentView;
/// 图标
@property (nonatomic, strong) UIImageView *anIcon;
/// 列表
@property (nonatomic, strong) UITableView *tableView;
/// 关闭
@property (nonatomic, strong) UIButton *closeBtn;
/// 问卷类
@property (nonatomic, strong) VHallSurvey *vhSurvey;
/// 数据源
@property (nonatomic, strong) NSMutableArray *dataSource;
/// 页码
@property (nonatomic, assign) NSInteger pageNum;
/// 房间详情
@property (nonatomic, strong) VHWebinarInfoData *webinarInfoData;

@end

@implementation VHSurveyListView


- (instancetype)initSurveyWithObject:(NSObject *)obj webinarInfoData:(VHWebinarInfoData *)webinarInfoData; {
    if ([super init]) {
        self.alpha = 0;
        self.backgroundColor = [UIColor clearColor];

        self.webinarInfoData = webinarInfoData;

        self.vhSurvey = [[VHallSurvey alloc] initWithObject:obj];
        self.vhSurvey.delegate = self;

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissContentView)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];

        [self addSubview:self.contentView];
        [self.contentView addSubview:self.anIcon];
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
        make.width.mas_equalTo(self.mas_width);
        make.height.mas_equalTo(338);
    }];

    [_anIcon mas_makeConstraints:^(MASConstraintMaker *make) {
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
- (void)showSurveyIsShow:(BOOL)isShow
{
    [self requestSurveyIsShow:isShow];
}

#pragma mark - 显示
- (void)show
{
    if (self.dataSource.count <= 0) {
        [VHProgressHud showToast:@"暂无问卷"];
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
- (void)disMissContentView
{
    [UIView animateWithDuration:0.3
                     animations:^{
        self.alpha = 0;
    }
                     completion:^(BOOL finished) {
    }];
}

#pragma mark - 显示问卷
- (void)requestSurveyIsShow:(BOOL)isShow
{
    [self.dataSource removeAllObjects];
    __weak __typeof(self) weakSelf = self;
    [self.vhSurvey fetchSurveyListWebinarId:self.webinarInfoData.webinar.data_id
                                     roomId:self.webinarInfoData.interact.room_id
                                   switchId:self.webinarInfoData.data_switch.switch_id
                                    success:^(VHSurveyListModel *listModel) {
        if (listModel.listModel.count > 0) {
            [weakSelf.dataSource addObjectsFromArray:listModel.listModel];
        }

        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];

        // 显示弹窗
        if (isShow) {
            [weakSelf show];
        }
    }
                                       fail:^(NSError *error) {
        [VHProgressHud showToast:error.domain];
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VHSurveyListCell *cell = [VHSurveyListCell createCellWithTableView:tableView];

    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VHSurveyModel *model = self.dataSource[indexPath.row];

    if (model.is_answered) {
        return;
    }

    [self.surveyWebView showSurveyUrl:model.openLink];
    [self disMissContentView];
}

#pragma mark - 显示问卷
- (void)clickSurveyToId:(NSString *)surveyId surveyURL:(NSURL *)surveyURL
{
    [self.dataSource removeAllObjects];
    __weak __typeof(self) weakSelf = self;
    [self.vhSurvey fetchSurveyListWebinarId:self.webinarInfoData.webinar.data_id
                                     roomId:self.webinarInfoData.interact.room_id
                                   switchId:self.webinarInfoData.data_switch.switch_id
                                    success:^(VHSurveyListModel *listModel) {
        if (listModel.listModel.count > 0) {
            [weakSelf.dataSource addObjectsFromArray:listModel.listModel];
        }

        for (VHSurveyModel *model in weakSelf.dataSource) {
            if ([surveyId isEqualToString:[VUITool safeString:model.question_id]]) {
                if (model.is_answered) {
                    [VHProgressHud showToast:@"此问卷已填写"]; return;
                }

                [weakSelf.surveyWebView showSurveyUrl:model.openLink];
                [weakSelf disMissContentView];
                return;
            }
        }
    }
                                       fail:^(NSError *error) {
        if (error.code == 516003) {
            [weakSelf.surveyWebView showSurveyUrl:surveyURL];
        } else {
            [VHProgressHud showToast:error.domain];
        }
    }];
}

#pragma mark - VHallSurveyDelegate
/// 收到问卷 v4.0.0新增
/// @param surveyURL 问卷地址
- (void)receivedSurveyWithURL:(NSURL *)surveyURL surveyId:(NSString *)surveyId
{
    if ([self.delegate respondsToSelector:@selector(receivedSurveyWithURL:surveyId:)]) {
        [self.delegate receivedSurveyWithURL:surveyURL surveyId:surveyId];
    }
}

/// 收到问卷 v6.4新增
/// @param surveyURL 问卷地址
/// @param surveyName 问卷名称
- (void)receivedSurveyWithURL:(NSURL *)surveyURL
                   surveyName:(NSString *)surveyName
                     surveyId:(NSString *)surveyId
{
    if ([self.delegate respondsToSelector:@selector(receivedSurveyWithURL:surveyId:)]) {
        [self.delegate receivedSurveyWithURL:surveyURL surveyId:surveyId];
    }
}

/// 提交问卷成功 v6.4新增
/// @param surveyid 问卷id
/// @param accountid 提交人id
- (void)receivedSucceed:(NSString *)surveyid
        surveyAccountId:(NSString *)accountid
{
//    [VHProgressHud showToast:@"提交问卷成功"];
}

#pragma mark - 手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isEqual:self]) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - 点击关闭
- (void)clickToCloseBtn
{
    [self disMissContentView];
}

#pragma mark - 懒加载
- (VHSurveyWebView *)surveyWebView
{
    if (!_surveyWebView) {
        _surveyWebView = [[VHSurveyWebView alloc] initWithFrame:[VUITool getCurrentScreenViewController].view.frame];
        [[VUITool getCurrentScreenViewController].view addSubview:_surveyWebView];
        [_surveyWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(0);
        }];
    }

    return _surveyWebView;
}

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

- (UIImageView *)anIcon
{
    if (!_anIcon) {
        _anIcon = [UIImageView new];
        _anIcon.image = [UIImage imageNamed:@"vh_survey_title_icon"];
    }

    return _anIcon;
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
            [weakSelf requestSurveyIsShow:NO];
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

@end
