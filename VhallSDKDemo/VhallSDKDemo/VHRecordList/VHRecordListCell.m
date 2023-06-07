//
//  VHRecordListCell.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/5/26.
//

#import "VHRecordListCell.h"

@interface VHRecordListCell ()
/// 标题
@property (nonatomic, strong) UILabel *titleLab;
/// 创建时间
@property (nonatomic, strong) UILabel *tagLab;
/// 时间
@property (nonatomic, strong) UILabel *timeLab;
/// 分割线
@property (nonatomic, strong) UIView *lineView;

@end

@implementation VHRecordListCell


+ (VHRecordListCell *)createCellWithTableView:(UITableView *)tableView
{
    VHRecordListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VHRecordListCell"];

    if (!cell) {
        cell = [[VHRecordListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"VHRecordListCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];

        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.tagLab];
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

    [self.tagLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLab.mas_left);
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(6);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(-15);
    }];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tagLab.mas_bottom).offset(15);
        make.left.mas_equalTo(self.titleLab.mas_left);
        make.right.mas_equalTo(self.timeLab.mas_right);
        make.height.mas_equalTo(.5);
    }];

    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.lineView.mas_bottom).priorityHigh();
    }];
}

#pragma mark - 赋值
- (void)setRecordListModel:(VHRecordListModel *)recordListModel
{
    _recordListModel = recordListModel;

    self.titleLab.text = [VUITool substringToIndex:8 text:recordListModel.name isReplenish:YES];

    self.tagLab.text = [recordListModel.record_id isEqualToString:self.record_id] ? @"正在播放" : @"";

    self.timeLab.text = recordListModel.duration;
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

- (UILabel *)tagLab {
    if (!_tagLab) {
        _tagLab = [[UILabel alloc] init];
        _tagLab.textColor = VHMainColor;
        _tagLab.font = FONT(13);
    }

    return _tagLab;
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
    }

    return _lineView;
}

@end
