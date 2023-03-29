//
//  VHVideoPointView.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/3/15.
//

#import "VHVideoPointView.h"

@interface VHVideoPointViewListCell ()
/// 标题
@property (nonatomic, strong) UILabel * titleLab;
/// 时间
@property (nonatomic, strong) UILabel * timeLab;
/// 分割线
@property (nonatomic, strong) UIView * lineView;
@end

@implementation VHVideoPointViewListCell

+ (VHVideoPointViewListCell *)createCellWithTableView:(UITableView *)tableView
{
    VHVideoPointViewListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"VHVideoPointViewListCell"];
    if (!cell) {
        cell = [[VHVideoPointViewListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"VHVideoPointViewListCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.lineView];
        
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

    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLab.mas_centerY);
        make.right.mas_equalTo(-15);
    }];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(15);
        make.left.mas_equalTo(self.titleLab.mas_left);
        make.right.mas_equalTo(self.timeLab.mas_right);
        make.height.mas_equalTo(.5);
    }];
    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.lineView.mas_bottom).priorityHigh();
    }];
}

#pragma mark - 赋值
- (void)setVidoePointModel:(VHVidoePointModel *)vidoePointModel
{
    _vidoePointModel = vidoePointModel;
    
    self.titleLab.text = [NSString stringWithFormat:@"%ld.%@",self.indexRow+1,vidoePointModel.msg];
    
    self.timeLab.text = [VUITool timeFormatted:(NSInteger)vidoePointModel.timePoint isAuto:NO];
}

#pragma mark - 懒加载
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = [UIColor colorWithHex:@"#262626"];
        _titleLab.font = FONT(13);
    }
    return _titleLab;
}
- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.textColor = [UIColor colorWithHex:@"#262626"];
        _timeLab.font = FONT(13);
    }
    return _timeLab;
}
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor colorWithHex:@"#F0F0F0"];
    }return _lineView;
}

@end

@interface VHVideoPointView ()<UITableViewDelegate,UITableViewDataSource>
/// 列表
@property (nonatomic, strong) UITableView * tableView;
/// 数据源
@property (nonatomic, strong) NSMutableArray * dataSource;
/// 活动详情
@property (nonatomic, strong) NSArray <VHVidoePointModel *> * pointArr;

@end

@implementation VHVideoPointView

#pragma mark - 初始化
- (instancetype)initVPWithFrame:(CGRect)frame videoPointArr:(NSArray <VHVidoePointModel *> *)pointArr
{
    if ([super initWithFrame:frame]){
        
        self.backgroundColor = [UIColor whiteColor];
        self.pointArr = pointArr;

        // 初始化布局
        [self setUpMasonry];
        
        // 加载视频打点数据
        [self getVideoPointList];

    } return self;
}

#pragma mark - 初始化布局
- (void)setUpMasonry
{
    [self addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

#pragma mark - 加载视频打点数据
- (void)getVideoPointList
{
    [self.dataSource setArray:self.pointArr];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VHVideoPointViewListCell *cell = [VHVideoPointViewListCell createCellWithTableView:tableView];
    cell.indexRow = indexPath.row;
    cell.vidoePointModel = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VHVidoePointModel * vidoePointModel = self.dataSource[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(clickVideoPointTime:)]){
        [self.delegate clickVideoPointTime:(NSInteger)vidoePointModel.timePoint];
    }
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
    }return _tableView;
}
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }return _dataSource;
}

#pragma mark - 分页
- (UIView *)listView {
    return self;
}


@end
