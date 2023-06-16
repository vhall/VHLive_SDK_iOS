//
//  VHFileDownloadCell.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/6/9.
//

#import "VHFileDownloadCell.h"

@interface VHFileDownloadCell ()

/// 标题
@property (nonatomic, strong) UILabel *titleLab;
/// 创建时间
@property (nonatomic, strong) UILabel *tagLab;
/// 分割线
@property (nonatomic, strong) UIView *lineView;

@end

@implementation VHFileDownloadCell

+ (VHFileDownloadCell *)createCellWithTableView:(UITableView *)tableView
{
    VHFileDownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VHFileDownloadCell"];

    if (!cell) {
        cell = [[VHFileDownloadCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"VHFileDownloadCell"];
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
        make.centerY.mas_equalTo(self.titleLab.mas_centerY);
        make.right.mas_equalTo(-15);
    }];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(15);
        make.left.mas_equalTo(self.titleLab.mas_left);
        make.right.mas_equalTo(self.tagLab.mas_right);
        make.height.mas_equalTo(.5);
    }];

    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.lineView.mas_bottom).priorityHigh();
    }];
}

#pragma mark - 赋值
- (void)setFileDownloadListModel:(VHFileDownloadListModel *)fileDownloadListModel
{
    _fileDownloadListModel = fileDownloadListModel;

    self.titleLab.text = [VUITool substringToIndex:8 text:fileDownloadListModel.file_name isReplenish:YES];
    self.tagLab.text = [NSString stringWithFormat:@"%@/%@",fileDownloadListModel.file_size,fileDownloadListModel.file_ext];
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
        _tagLab.textColor = [UIColor colorWithHex:@"#262626"];
        _tagLab.font = FONT(13);
    }

    return _tagLab;
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
