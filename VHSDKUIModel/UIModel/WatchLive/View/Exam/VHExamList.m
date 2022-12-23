//
//  VHExamList.m
//  UIModel
//
//  Created by 郭超 on 2022/11/25.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHExamList.h"
#import "MJRefresh.h"

@implementation VHExamListCell

+ (VHExamListCell *)createCellWithTableView:(UITableView *)tableView
{
    VHExamListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"VHExamListCell"];
    if (!cell) {
        cell = [[VHExamListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"VHExamListCell"];
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
        [self.bgView addSubview:self.contentLab];
        [self.bgView addSubview:self.statusLab];
        [self.bgView addSubview:self.rightRateLab];
        [self.bgView addSubview:self.totalScoreLab];

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
        make.left.right.top.bottom.mas_equalTo(self);
    }];

    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(16);
        make.right.bottom.mas_equalTo(-16);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(16);
        make.right.mas_equalTo(-80);
    }];

    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(6);
        make.left.mas_equalTo(self.titleLab.mas_left);
    }];
    
    [self.statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLab.mas_centerY);
        make.right.mas_equalTo(-16);
        make.size.mas_equalTo(CGSizeMake(56, 28));
    }];
    
    [self.rightRateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLab.mas_centerY);
        make.right.mas_equalTo(-16);
    }];
    
    [self.totalScoreLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLab.mas_centerY);
        make.right.mas_equalTo(-16);
    }];

    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentLab.mas_bottom).offset(16).priorityHigh();
    }];

    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(16).priorityHigh();
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

- (void)setExamGetPushedPaperListModel:(VHExamGetPushedPaperListModel *)examGetPushedPaperListModel
{
    _examGetPushedPaperListModel = examGetPushedPaperListModel;
    
    self.titleLab.text = examGetPushedPaperListModel.title;

    self.statusLab.hidden = YES;
    self.rightRateLab.hidden = YES;
    self.totalScoreLab.hidden = YES;

    if (examGetPushedPaperListModel.is_end && !examGetPushedPaperListModel.status) {
        self.statusLab.hidden = NO;
        self.statusLab.backgroundColor = [UIColor colorWithHex:@"#FFFFFF"];
        self.statusLab.textColor = [UIColor colorWithHex:@"#000000"];
        self.statusLab.font = FONT_FZZZ(14);
        self.statusLab.text = @"已结束";
    }else if (examGetPushedPaperListModel.status){
        if (examGetPushedPaperListModel.total_score == 0) {
            self.rightRateLab.hidden = NO;
            
            NSString * content = [NSString stringWithFormat:@"%.1f%%",examGetPushedPaperListModel.right_rate];
            
            NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:content];
            attText.yy_color = [UIColor colorWithHexString:@"#FB2626"];
            attText.yy_font = FONT_FZZZ(10);
            [attText yy_setFont:FONT_FZZZ(20) range:[content rangeOfString:[NSString stringWithFormat:@"%.1f",examGetPushedPaperListModel.right_rate]]];
            self.rightRateLab.attributedText = attText;
        }else{
            self.totalScoreLab.hidden = NO;
            
            NSString * total_score = @"";
            if (examGetPushedPaperListModel.right_rate == 0){
                total_score = @"0";
            }else if (examGetPushedPaperListModel.right_rate == 100){
                total_score = @"满分";
            }else {
                total_score = [NSString stringWithFormat:@"%.0f",examGetPushedPaperListModel.right_rate * examGetPushedPaperListModel.total_score / 100];
            }
                        
            NSString * content = [NSString stringWithFormat:@"%@%@",total_score,[total_score isEqualToString:@"满分"] ? @"" : @"分"];
            
            NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:content];
            attText.yy_color = [UIColor colorWithHexString:@"#FB2626"];
            attText.yy_font = FONT_FZZZ(10);
            [attText yy_setFont:FONT_FZZZ(20) range:[content rangeOfString:total_score]];
            self.totalScoreLab.attributedText = attText;
        }
    }else{
        self.statusLab.hidden = NO;
        self.statusLab.backgroundColor = [UIColor colorWithHex:@"#FB2626"];
        self.statusLab.textColor = [UIColor colorWithHex:@"#FFFFFF"];
        self.statusLab.font = FONT_FZZZ(12);
        self.statusLab.text = @"答题";
    }
    
    // 推送时间：20:10   限时：05:00   总分: 100    题数: 10
    NSString * content = @"";
    // 判断限时
    if (examGetPushedPaperListModel.limit_time_switch) {
        content = [NSString stringWithFormat:@"推送时间：%@   限时：%@   总分: %ld    题数: %ld",examGetPushedPaperListModel.push_time,[self getMMSSFromSS:examGetPushedPaperListModel.limit_time],examGetPushedPaperListModel.total_score,examGetPushedPaperListModel.question_num];
    }else{
        content = [NSString stringWithFormat:@"推送时间：%@   总分: %ld    题数: %ld",examGetPushedPaperListModel.push_time,examGetPushedPaperListModel.total_score,examGetPushedPaperListModel.question_num];
    }
    
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:content];
    attText.yy_color = [UIColor colorWithHexString:@"#000000" alpha:.85];
    attText.yy_font = FONT_FZZZ(10);
    [attText yy_setColor:[UIColor colorWithHex:@"#FB2626"] range:[content rangeOfString:[NSString stringWithFormat:@"总分: %ld",examGetPushedPaperListModel.total_score]]];
    self.contentLab.attributedText = attText;

}
#pragma mark - 传入 秒  得到  xx分钟xx秒
- (NSString *)getMMSSFromSS:(NSInteger)seconds{
 
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%ld",seconds];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:00",seconds < 10 ? [NSString stringWithFormat:@"0%@",str_minute] : str_minute];
    
    return format_time;
}

#pragma mark - 懒加载
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 8;
    }return _bgView;
}
- (UILabel *)contentLab
{
    if (!_contentLab){
        _contentLab = [[UILabel alloc] init];
        _contentLab.font = FONT_FZZZ(14);
        _contentLab.textColor = [UIColor colorWithHex:@"#1A1A1A"];
        _contentLab.preferredMaxLayoutWidth = VHScreenWidth - 128;
    }return _contentLab;
}
- (UILabel *)titleLab
{
    if (!_titleLab){
        _titleLab = [[UILabel alloc] init];
        _titleLab.numberOfLines = 0;
        _titleLab.preferredMaxLayoutWidth = VHScreenWidth - 80 - 16*3;
        _titleLab.font = FONT_FZZZ(14);
        _titleLab.textColor = [UIColor colorWithHex:@"#1A1A1A"];
    }return _titleLab;
}
- (UILabel *)statusLab {
    if (!_statusLab) {
        _statusLab = [[UILabel alloc] init];
        _statusLab.layer.masksToBounds = YES;
        _statusLab.layer.cornerRadius = 28/2;
        _statusLab.textAlignment = NSTextAlignmentCenter;
        _statusLab.hidden = YES;
    }
    return _statusLab;
}
- (UILabel *)rightRateLab {
    if (!_rightRateLab) {
        _rightRateLab = [[UILabel alloc] init];
        _rightRateLab.textColor = [UIColor colorWithHex:@"#FB2626"];
        _rightRateLab.font = FONT_FZZZ(20);
        _rightRateLab.hidden = YES;
    }
    return _rightRateLab;
}
- (UILabel *)totalScoreLab {
    if (!_totalScoreLab) {
        _totalScoreLab = [[UILabel alloc] init];
        _totalScoreLab.textColor = [UIColor colorWithHex:@"#FB2626"];
        _totalScoreLab.font = FONT_FZZZ(20);
        _totalScoreLab.hidden = YES;
    }
    return _totalScoreLab;
}


@end

@interface VHExamList ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

/// 容器
@property (nonatomic, strong) UIView * contentView;
/// 标题
@property (nonatomic, strong) UILabel *titleLab;
/// 关闭
@property (nonatomic, strong) UIButton * closeBtn;
/// 列表
@property (nonatomic, strong) UITableView * tableView;
/// 数据源
@property (nonatomic, strong) NSMutableArray * dataSource;
/// 活动详情
@property (nonatomic, strong) VHWebinarInfoData * webinarInfoData;

@end

@implementation VHExamList

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        self.alpha = 0;

        self.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissContentView)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];

        [self addSubview:self.contentView];
        [self.contentView addSubview:self.titleLab];
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
        make.size.mas_equalTo(CGSizeMake(self.width, 422));
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(18);
        make.left.mas_equalTo(16);
    }];
    
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_titleLab.mas_centerY);
        make.right.mas_equalTo(-16);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self.mas_width);
    }];
}
#pragma mark - 显示
- (void)examGetPushedPaperListWithWebinarInfoData:(VHWebinarInfoData *)webinarInfoData
{
    // 赋值
    self.webinarInfoData = webinarInfoData;

    // 加载列表数据
    [self requestExamList];
    
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {

    }];
}
#pragma mark - 隐藏
- (void)disMissContentView {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - 快问快答列表
- (void)requestExamList{
    
    @weakify(self);
    [self.examObject examGetPushedPaperListWithWebinar_id:self.webinarInfoData.webinar.data_id switch_id:self.webinarInfoData.data_switch.switch_id complete:^(NSArray<VHExamGetPushedPaperListModel *> *examGetPushedPaperList, NSError *error) {
        
        @strongify(self);

        // 暂时每次清理
        [self.dataSource removeAllObjects];
        
        // 添加数据
        [self.dataSource addObjectsFromArray:examGetPushedPaperList];
        
        // 刷新数据
        [self.tableView reloadData];
    }];
    
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VHExamListCell *cell = [VHExamListCell createCellWithTableView:tableView];
    cell.examGetPushedPaperListModel = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self disMissContentView];

    VHExamGetPushedPaperListModel * examGetPushedPaperListModel = self.dataSource[indexPath.row];

    if (examGetPushedPaperListModel.is_end && examGetPushedPaperListModel.status == 0) {
        VH_ShowToast(@"很遗憾，您已错过本次答题机会！");
        return;
    }
    if (self.clickExamDetailWebView) {
        self.clickExamDetailWebView(examGetPushedPaperListModel.paperUrl);
    }
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isEqual:self]) {
        return YES;
    }else{
        return NO;
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
    }return _contentView;
}
- (UILabel *)titleLab
{
    if (!_titleLab){
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = @"快问快答列表";
        _titleLab.font = FONT_FZZZ(14);
        _titleLab.textColor = [UIColor colorWithHex:@"#262626"];
    }return _titleLab;
}
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setImage:BundleUIImage(@"关闭") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(clickToCloseBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
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
    }return _tableView;
}
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }return _dataSource;
}

@end
