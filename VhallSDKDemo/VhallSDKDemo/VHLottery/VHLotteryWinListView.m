//
//  VHLotteryWinListView.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/3/20.
//

#import "VHLotteryWinListView.h"
#import "VHLotteryDecorateView.h"

@interface VHLotteryWinListCell ()
/// 第几个
@property (nonatomic, strong) UILabel * indexLab;
/// 头像
@property (nonatomic, strong) UIImageView * headerImg;
/// 昵称
@property (nonatomic, strong) UILabel * nameLab;
/// 奖品描述
@property (nonatomic, strong) UILabel * contentLab;
/// 分割线
@property (nonatomic, strong) UIView * lineView;
@end

@implementation VHLotteryWinListCell

+ (VHLotteryWinListCell *)createCellWithTableView:(UITableView *)tableView
{
    VHLotteryWinListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"VHLotteryWinListCell%ld"];
    if (!cell) {
        cell = [[VHLotteryWinListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"VHLotteryWinListCell%ld"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.indexLab];
        [self.contentView addSubview:self.headerImg];
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.contentLab];
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
    
    [self.indexLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(16);
        make.size.mas_equalTo(CGSizeMake(28, 19));
    }];
    
    [self.headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(self.indexLab.mas_right).offset(16);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];

    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headerImg.mas_right).offset(6);
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentLab.mas_left).offset(-6);
        make.height.mas_equalTo(19);
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(108);
        make.height.mas_greaterThanOrEqualTo(19);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.indexLab.mas_left);
        make.right.mas_equalTo(self.contentLab.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(.5);
        make.height.mas_equalTo(.5);
    }];

    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.headerImg.mas_bottom).offset(20).priorityHigh();
    }];
}

#pragma mark - 赋值
- (void)setItem:(VHallLotteryResultModel_ListItem *)item
{
    _item = item;
    
    self.indexLab.text = [NSString stringWithFormat:@"%@%ld",self.indexRow+1 < 10 ? @"0" : @"",self.indexRow+1];
    self.nameLab.text = item.lottery_user_nickname;
    self.contentLab.text = [NSString stringWithFormat:@"获得“%@”",item.lottery_award_name];
    
    [self.headerImg sd_setImageWithURL:[NSURL URLWithString:item.lottery_user_avatar] placeholderImage:[UIImage imageNamed:@"vh_no_head_icon"]];
    
    // 判断自己是否中奖
    self.indexLab.textColor = item.win ? VHMainColor : [UIColor colorWithHex:@"#595959"];
    self.nameLab.textColor = item.win ? VHMainColor : [UIColor colorWithHex:@"#262626"];
    self.contentLab.textColor = item.win ? VHMainColor : [UIColor colorWithHex:@"#262626"];
}

#pragma mark - 懒加载
- (UILabel *)indexLab {
    if (!_indexLab) {
        _indexLab = [[UILabel alloc] init];
        _indexLab.textColor = [UIColor colorWithHex:@"#595959"];
        _indexLab.font = FONT_Medium(13);
        _indexLab.textAlignment = NSTextAlignmentLeft;
    }
    return _indexLab;
}

- (UIImageView *)headerImg {
    if (!_headerImg) {
        _headerImg = [[UIImageView alloc] init];
        _headerImg.layer.masksToBounds = YES;
        _headerImg.layer.cornerRadius = 32/2;
    }
    return _headerImg;
}

- (UILabel *)nameLab {
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.textColor = [UIColor colorWithHex:@"#262626"];
        _nameLab.font = FONT(13);
        _nameLab.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLab;
}

- (UILabel *)contentLab {
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] init];
        _contentLab.textColor = [UIColor colorWithHex:@"#262626"];
        _contentLab.font = FONT(13);
        _contentLab.numberOfLines = 2;
        _contentLab.preferredMaxLayoutWidth = 108;
        _contentLab.textAlignment = NSTextAlignmentRight;
    }
    return _contentLab;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHex:@"#F0F0F0"];
    }
    return _lineView;
}

@end

@interface VHLotteryWinListView ()<UITableViewDelegate,UITableViewDataSource>
/// 标题图片
@property (nonatomic, strong) UIImageView * titleImg;
/// 关闭按钮
@property (nonatomic, strong) UIButton * closeBtn;
/// 装饰
@property (nonatomic, strong) VHLotteryDecorateView * decorateImg;
/// 查看中奖名单按钮
@property (nonatomic, strong) UITableView * tableView;
/// 抽奖类
@property (nonatomic, strong) VHallLottery * vhLottery;
/// 结束抽奖数据
@property (nonatomic, strong) VHallEndLotteryModel * endLotteryModel;
/// 数据源
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation VHLotteryWinListView
#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]){
        
        self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.5];
                        
        [self addSubview:self.contentView];
        [self addSubview:self.titleImg];
        [self.contentView addSubview:self.closeBtn];
        [self.contentView addSubview:self.tableView];
        [self.contentView addSubview:self.decorateImg];

        // 初始化布局
        [self setUpMasonry];

    }return self;

}
#pragma mark - 初始化布局
- (void)setUpMasonry
{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(355);
    }];
    
    [self.titleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.contentView.mas_top).offset(-6.5);
        make.size.mas_equalTo(CGSizeMake(240, 40));
    }];

    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14);
        make.right.mas_equalTo(-16);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.decorateImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.top.mas_equalTo(self.titleImg.mas_bottom).offset(8);
        make.bottom.mas_equalTo(-8);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(self.titleImg.mas_bottom).offset(16);
        make.bottom.mas_equalTo(-16);
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
        
    [self.contentView setBackgroundColor:[UIColor bm_colorGradientChangeWithSize:self.contentView.size direction:IHGradientChangeDirectionLevel startColor:[UIColor colorWithHex:@"#FFFBE8"] endColor:[UIColor colorWithHex:@"#FBF0E6"]]];
}

#pragma mark - 弹窗
- (void)showLotteryWinListWithVHLottery:(VHallLottery *)vhLottery endLotteryModel:(VHallEndLotteryModel *)endLotteryModel
{
    self.vhLottery = vhLottery;
    self.endLotteryModel = endLotteryModel;
    
    [[VUITool getCurrentScreenViewController].view addSubview:self];

    __weak __typeof(self)weakSelf = self;
    [self.vhLottery getLotteryWinListWithLotteryId:self.endLotteryModel.huadieInfo.lottery_id success:^(VHallLotteryResultModel *lotteryResult) {
        [weakSelf.dataSource setArray:lotteryResult.list];
        [weakSelf.tableView reloadData];
    } failed:^(NSDictionary *failedData) {
        NSString * msg = [NSString stringWithFormat:@"%@",failedData[@"content"]];
        [VHProgressHud showToast:msg];
    }];
    
    [super show];
}
#pragma mark - 隐藏
- (void)disMissContentView{}
#pragma mark - 隐藏
- (void)dismiss
{
    [super disMissContentView];
    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VHLotteryWinListCell *cell = [VHLotteryWinListCell createCellWithTableView:tableView];
    cell.indexRow = indexPath.row;
    cell.item = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark - 点击关闭
- (void)clickCloseBtn
{
    [self dismiss];
}
#pragma mark - 懒加载
- (UIImageView *)titleImg
{
    if (!_titleImg) {
        _titleImg = [[UIImageView alloc] init];
        _titleImg.image = [UIImage imageNamed:@"vh_lottery_alert_win_title"];
    }
    return _titleImg;
}
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
        [_closeBtn setImage:[UIImage imageNamed:@"vh_lottery_alert_submit_close"] forState:UIControlStateNormal];
    }
    return _closeBtn;
}
- (VHLotteryDecorateView *)decorateImg {
    if (!_decorateImg) {
        _decorateImg = [[VHLotteryDecorateView alloc] init];
        _decorateImg.backgroundColor = [UIColor clearColor];
        _decorateImg.image = [UIImage imageNamed:@"vh_lottery_alert_decorate"];
    }
    return _decorateImg;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.cornerRadius = 6;
        _tableView.estimatedRowHeight = 300;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
