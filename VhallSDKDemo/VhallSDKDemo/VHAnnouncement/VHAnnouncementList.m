//
//  VHAnnouncementList.m
//  UIModel
//
//  Created by 郭超 on 2022/7/13.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "MJRefresh.h"
#import "VHAnnouncementList.h"

@implementation VHAnnouncementListCell

+ (VHAnnouncementListCell *)createCellWithTableView:(UITableView *)tableView
{
    VHAnnouncementListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VHAnnouncementListCell"];

    if (!cell) {
        cell = [[VHAnnouncementListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"VHAnnouncementListCell"];
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

- (void)setModel:(VHallAnnouncementModel *)model
{
    _model = model;

    self.timeLab.text = model.created_at;

    self.titleLab.text = model.content;
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

@end

@interface VHAnnouncementList ()<UITableViewDelegate, UITableViewDataSource>

/// 容器
@property (nonatomic, strong) UIView *contentView;
/// 图标
@property (nonatomic, strong) UIImageView *anIcon;
/// 列表
@property (nonatomic, strong) UITableView *tableView;
/// 关闭
@property (nonatomic, strong) UIButton *closeBtn;
/// 公告类
@property (nonatomic, strong) VHallAnnouncement *vhallAnnouncement;
/// 数据源
@property (nonatomic, strong) NSMutableArray *dataSource;
/// 页码
@property (nonatomic, assign) NSInteger pageNum;
/// 房间id
@property (nonatomic, copy) NSString *roomId;

@end

@implementation VHAnnouncementList

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        self.alpha = 0;
        self.backgroundColor = [UIColor clearColor];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissContentView)];
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
        make.size.mas_equalTo(CGSizeMake(self.width, 338));
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
- (void)loadDataRoomId:(NSString *)roomId isShow:(BOOL)isShow
{
    self.roomId = roomId;

    [self requestGoodsListWithPageNum:1 isShow:isShow];
}

#pragma mark - 显示
- (void)show
{
    if (self.dataSource.count <= 0) {
        [VHProgressHud showToast:@"暂无公告"];
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

#pragma mark - 公告列表
- (void)requestGoodsListWithPageNum:(NSInteger)pageNum isShow:(BOOL)isShow
{
    self.pageNum = pageNum;
    __weak __typeof(self) weakSelf = self;
    [self.vhallAnnouncement getAnnouncementListWithRoomId:self.roomId
                                                 page_num:pageNum
                                                page_size:10
                                                startTime:@""
                                                  success:^(NSArray<VHallAnnouncementModel *> *_Nonnull dataArr) {
        if (pageNum == 1) {
            [weakSelf.dataSource removeAllObjects];
        }

        weakSelf.pageNum++;
        [weakSelf.dataSource addObjectsFromArray:dataArr];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];

        if ((pageNum == 1 && weakSelf.dataSource.count < 10) || (pageNum > 1 && weakSelf.dataSource.count <= 10)) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }

        // 显示弹窗
        if (isShow) {
            [weakSelf show];
        }
    }
                                                     fail:^(NSError *_Nonnull error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VHAnnouncementListCell *cell = [VHAnnouncementListCell createCellWithTableView:tableView];

    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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

- (UIImageView *)anIcon
{
    if (!_anIcon) {
        _anIcon = [UIImageView new];
        _anIcon.image = [UIImage imageNamed:@"vh_an_title_icon"];
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

- (VHallAnnouncement *)vhallAnnouncement
{
    if (!_vhallAnnouncement) {
        _vhallAnnouncement = [VHallAnnouncement new];
    }

    return _vhallAnnouncement;
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
            [weakSelf requestGoodsListWithPageNum:1
                                           isShow:NO];
        }];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf requestGoodsListWithPageNum:self.pageNum
                                           isShow:NO];
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
