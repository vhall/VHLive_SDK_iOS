//
//  VHAnnouncementList.m
//  UIModel
//
//  Created by 郭超 on 2022/7/13.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHAnnouncementList.h"
#import "MJRefresh.h"

@implementation VHAnnouncementListCell

+ (VHAnnouncementListCell *)createCellWithTableView:(UITableView *)tableView
{
    VHAnnouncementListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"VHAnnouncementListCell"];
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
        
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.img];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.lineView];

        // 设置约束
        [self setMasonryUI];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self drawLineOfDashByCAShapeLayer:self.lineView lineLength:2 lineSpacing:2 lineColor:[UIColor colorWithHex:@"#FB3A32"] lineDirection:NO];
}
- (void)setMasonryUI
{
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];

    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(30);
        make.width.mas_equalTo(40);
    }];
    
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.timeLab.mas_centerY);
        make.left.mas_equalTo(self.timeLab.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(6, 6));
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(self.img.mas_right).offset(10);
        make.right.mas_equalTo(-15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.img.mas_bottom).offset(2);
        make.centerX.mas_equalTo(self.img.mas_centerX).offset(.5);
        make.width.mas_equalTo(2);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.titleLab.mas_bottom).offset(20).priorityHigh();
    }];    
}
#pragma mark - 画虚线
/**
 *  通过 CAShapeLayer 方式绘制虚线
 *
 *  param lineView:       需要绘制成虚线的view
 *  param lineLength:     虚线的宽度
 *  param lineSpacing:    虚线的间距
 *  param lineColor:      虚线的颜色
 *  param lineDirection   虚线的方向  YES 为水平方向， NO 为垂直方向
 **/
- (void)drawLineOfDashByCAShapeLayer:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor lineDirection:(BOOL)isHorizonal {

    CAShapeLayer *shapeLayer = [CAShapeLayer layer];

    [shapeLayer setBounds:lineView.bounds];

    if (isHorizonal) {

        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];

    } else{
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame)/2)];
    }

    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    if (isHorizonal) {
        [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    } else {

        [shapeLayer setLineWidth:CGRectGetWidth(lineView.frame)];
    }
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);

    if (isHorizonal) {
        CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    } else {
        CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(lineView.frame));
    }

    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

- (void)setModel:(VHallAnnouncementModel *)model
{
    _model = model;
    
    if (model.created_at.length > 18) {
        self.timeLab.text = [[model.created_at substringFromIndex:11] substringToIndex:5];
    }else{
        self.timeLab.text = model.created_at;
    }
    self.titleLab.text = model.content;
}
#pragma mark - 懒加载
- (UILabel *)timeLab
{
    if (!_timeLab){
        _timeLab = [[UILabel alloc] init];
        _timeLab.font = FONT_FZZZ(14);
        _timeLab.textColor = [UIColor colorWithHex:@"#1A1A1A"];
    }return _timeLab;
}
- (UIImageView *)img
{
    if (!_img) {
        _img = [UIImageView new];
        _img.image = BundleUIImage(@"vh_an_click");
    }return _img;
}
- (UILabel *)titleLab
{
    if (!_titleLab){
        _titleLab = [[UILabel alloc] init];
        _titleLab.numberOfLines = 0;
        _titleLab.preferredMaxLayoutWidth = VHScreenWidth - 90 - 15;
        _titleLab.font = FONT_FZZZ(14);
        _titleLab.textColor = [UIColor colorWithHex:@"#1A1A1A"];
    }return _titleLab;
}
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [UIView new];
    }return _lineView;
}
@end

@interface VHAnnouncementList ()<UITableViewDelegate,UITableViewDataSource>

/// 容器
@property (nonatomic, strong) UIView * contentView;
/// 图标
@property (nonatomic, strong) UIImageView * anIcon;
/// 列表
@property (nonatomic, strong) UITableView * tableView;
/// 关闭
@property (nonatomic, strong) UIButton * closeBtn;
/// 公告类
@property (nonatomic, strong) VHallAnnouncement * vhallAnnouncement;
/// 数据源
@property (nonatomic, strong) NSMutableArray * dataSource;
/// 页码
@property (nonatomic, assign) NSInteger pageNum;
/// 房间id
@property (nonatomic, copy) NSString * roomId;

@end

@implementation VHAnnouncementList

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissContentView)];
        [self addGestureRecognizer:tap];

        [self addSubview:self.contentView];
        [self addSubview:self.anIcon];
        [self.contentView addSubview:self.closeBtn];
        [self.contentView addSubview:self.tableView];

        // 初始化布局
        [self setUpMasonry];

    }return self;
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
        make.bottom.mas_equalTo(-338 + 97/2);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(108, 97));
    }];

    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(67);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self.mas_width);
    }];

    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.right.mas_equalTo(25);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}
#pragma mark - 显示
- (void)loadDataRoomId:(NSString *)roomId
{
    self.isShow = YES;
    
    self.roomId = roomId;
    
    [self requestGoodsListWithPageNum:1];
    
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {

    }];
}
#pragma mark - 隐藏
- (void)disMissContentView {
    self.isShow = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - 公告列表
- (void)requestGoodsListWithPageNum:(NSInteger)pageNum{
    
    self.pageNum = pageNum;
    @weakify(self);
    [self.vhallAnnouncement getAnnouncementListWithRoomId:self.roomId page_num:pageNum page_size:10 startTime:@"" success:^(NSArray<VHallAnnouncementModel *> * _Nonnull dataArr) {
        @strongify(self);
        if (pageNum == 1) {
            [self.dataSource removeAllObjects];
        }
        self.pageNum ++;
        [self.dataSource addObjectsFromArray:dataArr];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } fail:^(NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
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

#pragma mark - 懒加载
- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor colorWithHex:@"#FFF4F4"];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 8;
    }return _contentView;
}
- (UIImageView *)anIcon
{
    if (!_anIcon) {
        _anIcon = [UIImageView new];
        _anIcon.image = BundleUIImage(@"vh_an_laba");
    }return _anIcon;
}
- (VHallAnnouncement *)vhallAnnouncement
{
    if (!_vhallAnnouncement) {
        _vhallAnnouncement = [VHallAnnouncement new];
    }return _vhallAnnouncement;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, 338-67) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.estimatedRowHeight = 180;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        @weakify(self);
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self requestGoodsListWithPageNum:1];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self requestGoodsListWithPageNum:self.pageNum];
        }];
    }return _tableView;
}
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }return _dataSource;
}
@end
