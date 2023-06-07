//
//  VHQAView.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/22.
//

#import "VHQAView.h"

@interface VHQAViewListCell ()

/// 背景
@property (nonatomic, strong) UIView *bgView;
/// 头像
@property (nonatomic, strong) UIImageView *headImg;
/// 昵称
@property (nonatomic, strong) UILabel *nickNameLab;
/// 身份
@property (nonatomic, strong) YYLabel *roleNameLab;
/// 时间
@property (nonatomic, strong) UILabel *timeLab;
/// 消息
@property (nonatomic, strong) UILabel *msg;
@end

@implementation VHQAViewListCell

+ (VHQAViewListCell *)createCellWithTableView:(UITableView *)tableView
{
    VHQAViewListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VHQAViewListCell"];

    if (!cell) {
        cell = [[VHQAViewListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"VHQAViewListCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];

        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.headImg];
        [self.bgView addSubview:self.nickNameLab];
        [self.bgView addSubview:self.roleNameLab];
        [self.bgView addSubview:self.msg];
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
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(0);
    }];

    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(5);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];

    [self.nickNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.headImg.mas_centerY);
        make.left.mas_equalTo(self.headImg.mas_right).offset(8);
    }];

    [self.roleNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.headImg.mas_centerY);
        make.left.mas_equalTo(self.nickNameLab.mas_right).offset(8);
    }];

    [self.msg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nickNameLab.mas_bottom).offset(6);
        make.left.mas_equalTo(self.nickNameLab.mas_left);
        make.right.mas_equalTo(self.timeLab.mas_right);
    }];

    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nickNameLab.mas_centerY);
        make.right.mas_equalTo(-8);
    }];

    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.msg.mas_bottom).offset(5);
    }];

    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bgView.mas_bottom).priorityHigh();
    }];
}

#pragma mark - 提问数据
- (void)setVhQuestionModel:(VHallQuestionModel *)vhQuestionModel
{
    _vhQuestionModel = vhQuestionModel;

    [self isQuestionModel:vhQuestionModel.isHaveAnswer ? YES : NO];

    [self.headImg sd_setImageWithURL:[NSURL URLWithString:vhQuestionModel.avatar] placeholderImage:[UIImage imageNamed:@"vh_no_head_icon"]];

    self.nickNameLab.text = [VUITool substringToIndex:8 text:vhQuestionModel.nick_name isReplenish:YES];

    self.timeLab.text = [VUITool substringFromIndex:11 text:vhQuestionModel.created_time isReplenish:NO];

    NSString *content = [NSString stringWithFormat:@"%@%@", vhQuestionModel.isHaveAnswer ? @"提问 " : @"", vhQuestionModel.content];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    attributedString.yy_font = FONT(14);
    attributedString.yy_color = [UIColor colorWithHex:@"#333333"];
    [attributedString yy_setColor:[UIColor colorWithHex:@"#F0BE1C"] range:[content rangeOfString:vhQuestionModel.isHaveAnswer ? @"提问 " : @""]];

    self.msg.attributedText = attributedString;
}

#pragma mark - 回答数据
- (void)setVhAnswerModel:(VHallAnswerModel *)vhAnswerModel
{
    _vhAnswerModel = vhAnswerModel;

    [self isQuestionModel:NO];

    [self.headImg sd_setImageWithURL:[NSURL URLWithString:vhAnswerModel.avatar] placeholderImage:[UIImage imageNamed:@"vh_no_head_icon"]];

    self.nickNameLab.text = [VUITool substringToIndex:8 text:vhAnswerModel.nick_name isReplenish:YES];

    self.timeLab.text = [VUITool substringFromIndex:11 text:vhAnswerModel.created_time isReplenish:NO];

    [self changeRoleName:vhAnswerModel.role_name];

    NSString *content = [NSString stringWithFormat:@"回答 %@", vhAnswerModel.content];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    attributedString.yy_font = FONT(14);
    attributedString.yy_color = [UIColor colorWithHex:@"#333333"];
    [attributedString yy_setColor:[UIColor colorWithHex:@"#F0BE1C"] range:[content rangeOfString:@"回答 "]];
    self.msg.attributedText = attributedString;
}

 #pragma mark - 更新UI
- (void)isQuestionModel:(BOOL)isQuestionModel
{
    self.bgView.backgroundColor = isQuestionModel ? [UIColor clearColor] : [UIColor colorWithHex:@"#F8F8F8"];
    self.timeLab.hidden = isQuestionModel;
    self.roleNameLab.hidden = isQuestionModel;

    if (isQuestionModel) {
        [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15 + 32 + 8);
        }];

        self.headImg.layer.cornerRadius = 24 / 2;
        [self.headImg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(24, 24));
        }];

        self.msg.preferredMaxLayoutWidth = Screen_Width - (15 + 32 + 8 + 24 + 8 + 8);
    } else {
        [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
        }];

        self.headImg.layer.cornerRadius = 32 / 2;
        [self.headImg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(32, 32));
        }];

        self.msg.preferredMaxLayoutWidth = Screen_Width - (15 + 32 + 8 + 8);
    }
}

#pragma mark - 身份转换
- (void)changeRoleName:(NSString *)role_name
{
    // host：主持人 guest：嘉宾 assistant：助手 user：观众
    self.roleNameLab.hidden = YES;

    if ([role_name isEqualToString:@"host"]) {
        self.roleNameLab.hidden = NO;
        [self roleNameWithText:@"主持人" textColor:@"#FB2626" backgroundColor:@"#FFD1C9"];
    }

    if ([role_name isEqualToString:@"guest"]) {
        self.roleNameLab.hidden = NO;
        [self roleNameWithText:@"嘉宾" textColor:@"#0A7FF5" backgroundColor:@"#ADE1FF"];
    }

    if ([role_name isEqualToString:@"assistant"]) {
        [self roleNameWithText:@"助手" textColor:@"" backgroundColor:@""];
    }

    if ([role_name isEqualToString:@"user"]) {
        [self roleNameWithText:@"观众" textColor:@"" backgroundColor:@""];
    }
}

- (void)roleNameWithText:(NSString *)text textColor:(NSString *)textColor backgroundColor:(NSString *)backgroundColor
{
    self.roleNameLab.text = text;
    self.roleNameLab.textColor = [UIColor colorWithHex:textColor];
    self.roleNameLab.backgroundColor = [UIColor colorWithHex:backgroundColor];
}

#pragma mark - 懒加载
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 8;
    }

    return _bgView;
}

- (UIImageView *)headImg
{
    if (!_headImg) {
        _headImg = [UIImageView new];
        _headImg.layer.masksToBounds = YES;
        _headImg.layer.cornerRadius = 32 / 2;
    }

    return _headImg;
}

- (UILabel *)nickNameLab {
    if (!_nickNameLab) {
        _nickNameLab = [[UILabel alloc] init];
        _nickNameLab.textColor = [UIColor blackColor];
        _nickNameLab.font = FONT(14);
    }

    return _nickNameLab;
}

- (YYLabel *)roleNameLab
{
    if (!_roleNameLab) {
        _roleNameLab = [YYLabel new];
        _roleNameLab.layer.masksToBounds = YES;
        _roleNameLab.layer.cornerRadius = 15 / 2;
        _roleNameLab.font = FONT(11);
        _roleNameLab.textContainerInset = UIEdgeInsetsMake(2, 4, 2, 4);
    }

    return _roleNameLab;
}

- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.textColor = [UIColor colorWithHex:@"#999999"];
        _timeLab.font = FONT(12);
    }

    return _timeLab;
}

- (UILabel *)msg {
    if (!_msg) {
        _msg = [[UILabel alloc] init];
        _msg.numberOfLines = 0;
        _msg.preferredMaxLayoutWidth = Screen_Width - (15 + 32 + 8 + 8);
    }

    return _msg;
}

@end

@interface VHQAView ()<VHallQAndADelegate, UITableViewDelegate, UITableViewDataSource>

/// 列表
@property (nonatomic, strong) UITableView *tableView;
/// 数据源
@property (nonatomic, strong) NSMutableArray *dataSource;
/// 活动详情
@property (nonatomic, strong) VHWebinarInfoData *webinarInfoData;
/// 注册对象
@property (nonatomic, weak) NSObject *obj;

@end

@implementation VHQAView

#pragma mark - 初始化
- (instancetype)initQAWithFrame:(CGRect)frame obj:(NSObject *)obj webinarInfoData:(VHWebinarInfoData *)webinarInfoData
{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];

        self.obj = obj;
        self.webinarInfoData = webinarInfoData;

        self.vhQA = [[VHallQAndA alloc] initWithObject:obj];
        self.vhQA.delegate = self;

        [self addSubview:self.tableView];

        // 初始化布局
        [self setUpMasonry];

        // 加载问答数据
        [self getQAndAHistory];
    }

    return self;
}

#pragma mark - 初始化布局
- (void)setUpMasonry
{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

#pragma mark - 发送提问 （在收到播放器"播放连接成功回调"或"视频信息预加载成功回调"以后使用）
- (void)sendQAMsg:(NSString *)msg
{
    [self.vhQA sendMsg:msg
               success:^{
        [VHProgressHud showToast:@"发送成功"];
    }
                failed:^(NSDictionary *failedData) {
        NSString *msg = [NSString stringWithFormat:@"%@", failedData[@"content"]];
        [VHProgressHud showToast:msg];
    }];
}

#pragma mark - 获取问答历史记录 （在收到播放器"播放连接成功回调"或"视频信息预加载成功回调"以后使用）
- (void)getQAndAHistory
{
    __weak __typeof(self) weakSelf = self;
    [self.vhQA getQAndAHistoryWithType:YES
                               success:^(NSArray<VHallQAModel *> *msgs) {
        [weakSelf.dataSource removeAllObjects];

        // 刷新数据
        [weakSelf reloadQAMsg:msgs];

        // 收起刷新控件
        [weakSelf.tableView.mj_header endRefreshing];
    }
                                failed:^(NSDictionary *failedData) {
//        NSString* msg = [NSString stringWithFormat:@"%@",failedData[@"content"]];
//        [VHProgressHud showToast:msg];
        // 收起刷新控件
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)reloadQAMsg:(NSArray <VHallQAModel *> *)msgs
{
    for (VHallQAModel *qaModel in msgs) {
        BOOL isOpen = NO;

        if (qaModel.answerModels.count > 0) {
            for (VHallAnswerModel *answerModels in qaModel.answerModels) {
                isOpen = answerModels.is_open;

                // 是公开 或者 我的提问
                if (isOpen || [qaModel.questionModel.join_id isEqualToString:((VHallMoviePlayer *)self.obj).webinarInfo.join_id]) {
                    [self.dataSource addObject:answerModels];
                }
            }
        }

        // 是公开 或者 我的提问
        if (isOpen || [qaModel.questionModel.join_id isEqualToString:((VHallMoviePlayer *)self.obj).webinarInfo.join_id]) {
            [self.dataSource addObject:qaModel.questionModel];
        }
    }

    [self reloadChat];
}

#pragma mark - 刷新
- (void)reloadChat
{
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];

        if (weakSelf.dataSource.count > 0 && weakSelf.tableView.contentSize.height > 0) {
            [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    });
}

#pragma mark - VHallQAndADelegate
#pragma mark - 主播开启问答
- (void)vhallQAndADidOpened:(VHallQAndA *)QA
{
    if ([self.delegate respondsToSelector:@selector(vhQAIsOpen:)]) {
        [self.delegate vhQAIsOpen:YES];
    }
}

#pragma mark - 主播关闭问答
- (void)vhallQAndADidClosed:(VHallQAndA *)QA
{
    if ([self.delegate respondsToSelector:@selector(vhQAIsOpen:)]) {
        [self.delegate vhQAIsOpen:NO];
    }
}

#pragma mark - 问答消息
- (void)reciveQAMsg:(NSArray <VHallQAModel *> *)msgs
{
    // 刷新数据
    [self reloadQAMsg:msgs];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VHQAViewListCell *cell = [VHQAViewListCell createCellWithTableView:tableView];
    id model = self.dataSource[indexPath.row];

    if ([model isKindOfClass:[VHallQuestionModel class]]) {
        cell.vhQuestionModel = model;
    }

    if ([model isKindOfClass:[VHallAnswerModel class]]) {
        cell.vhAnswerModel = model;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.estimatedRowHeight = 300;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        __weak __typeof(self) weakSelf = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf getQAndAHistory];
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

#pragma mark - 分页
- (UIView *)listView {
    return self;
}

@end
