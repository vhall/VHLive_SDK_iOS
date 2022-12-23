//
//  VHExamChatCell.m
//  UIModel
//
//  Created by 郭超 on 2022/12/12.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHExamChatCell.h"

@implementation VHExamChatModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}
@end

@interface VHExamChatCell ()

@property (nonatomic, strong) UILabel * titleLab;   ///<标题
@property (nonatomic, strong) UIButton * lookBtn;   ///<查看>
@end

@implementation VHExamChatCell

+ (VHExamChatCell *)createCellWithTableView:(UITableView *)tableView
{
    VHExamChatCell * cell = [tableView dequeueReusableCellWithIdentifier:@"VHExamChatCell"];
    if (!cell) {
        cell = [[VHExamChatCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"VHExamChatCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
                
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.lookBtn];

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
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(16);
    }];
    
    [self.lookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(self.titleLab.mas_centerY);
    }];

    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.titleLab.mas_bottom).offset(16).priorityHigh();
    }];
}
- (void)setModel:(VHExamChatModel *)model
{
    _model = model;
    
    self.titleLab.text = model.stuatus;
    
    if ([model.stuatus isEqualToString:@"推送-快问快答"] || [model.stuatus containsString:@"收卷"]){
        [_lookBtn setTitle:@"查看详情" forState:UIControlStateNormal];
    }else{
        [_lookBtn setTitle:@"成绩排行榜" forState:UIControlStateNormal];
    }
}
- (void)lookBtnAction
{
    if (self.clickLookBtnWithExamDetailWebView){
        self.clickLookBtnWithExamDetailWebView(self.model.examWebUrl);
    }
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = [UIColor colorWithHex:@"#000000"];
        _titleLab.font = FONT_Medium(15);
    }
    return _titleLab;
}
- (UIButton *)lookBtn {
    if (!_lookBtn) {
        _lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _lookBtn.titleLabel.font = FONT_Medium(15);
        [_lookBtn setTitle:@"查看详情" forState:UIControlStateNormal];
        [_lookBtn setTitleColor:[UIColor colorWithHex:@"#0A7FF5"] forState:UIControlStateNormal];
        [_lookBtn addTarget:self action:@selector(lookBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lookBtn;
}

@end
