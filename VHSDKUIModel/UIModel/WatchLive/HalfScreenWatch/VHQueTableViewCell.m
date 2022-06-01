//
//  VHQueTableViewCell.m
//  UIModel
//
//  Created by jinbang.li on 2022/5/15.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHQueTableViewCell.h"

@interface VHQueTableViewCell()
@property (nonatomic) UILabel *leftLabel;
@property (nonatomic) UILabel *title;
@property (nonatomic) UIButton *queStatus;
@property (nonatomic) UIImageView *lineImagV;
@end
@implementation VHQueTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    
    self.leftLabel = [UILabel creatWithFont:14 TextColor:@"#262626" Text:@""];
    [self.leftLabel sizeToFit];
    [self.contentView addSubview:self.leftLabel];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.top.offset(5);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(20);
    }];
    UIImageView *icon = [[UIImageView alloc] initWithImage:BundleUIImage(@"wenjuan_left")];
    [self.contentView addSubview:icon];
    // 5 + 12
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(12);
        make.top.offset(5);
        make.left.offset(64);
    }];
    
    UIImageView *line = [[UIImageView alloc] initWithImage:BundleUIImage(@"wenjuan_line")];
    [self.contentView addSubview:line];
    self.lineImagV = line;
    // 17+2+44 = 63
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(44);
        make.top.offset(19);
        make.left.offset(68.5);
    }];
    
    self.title = [UILabel creatWithFont:14 TextColor:@"#1A1A1A" Text:@""];
    self.title.textAlignment = NSTextAlignmentLeft;
    self.title.numberOfLines = 0;
    [self.title sizeToFit];
    [self.contentView addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(83);
        make.top.offset(0);
        make.right.offset(-60);
        make.height.mas_equalTo(40);
    }];
    self.queStatus = [UIButton creatWithTitle:@"填写" titleFont:14 titleColor:@"#3562FA" backgroundColor:@"#FFFFFF"];
    [self.queStatus addTarget:self action:@selector(queAct:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.queStatus];
    [self.queStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.right.offset(-20);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(20);
    }];
}
- (void)queAct:(UIButton *)sender{
    NSString *title = [sender titleForState:UIControlStateNormal];
    if ([title isEqualToString:@"已填"]) {
        return;
    }else{
        if (self.openLink) {
            self.openLink();
        }
    }
}
- (void)updateModel:(VHSurveyModel *)surveyModel isLast:(BOOL)isLast{
    self.lineImagV.hidden = isLast?YES:NO;
    NSString *time = [surveyModel.created_at substringFromIndex:surveyModel.created_at.length-8];
    self.leftLabel.text = [time substringWithRange:NSMakeRange(0, 5)];
    self.title.text = surveyModel.title;
    [self.queStatus setTitle:surveyModel.is_answered == YES ?@"已填":@"填写" forState:UIControlStateNormal];
    self.title.textColor = surveyModel.is_answered?[UIColor colorWithHex:@"#666666"]:[UIColor colorWithHex:@"#1A1A1A"];
    [self.queStatus setTitleColor:surveyModel.is_answered?[UIColor colorWithHex:@"#666666"]:[UIColor colorWithHex:@"#3562FA"] forState:UIControlStateNormal];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
