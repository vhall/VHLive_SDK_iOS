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
    self.leftLabel.numberOfLines = 2;
    [self.contentView addSubview:self.leftLabel];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.top.offset(5);
    }];
    UIImageView *icon = [[UIImageView alloc] initWithImage:BundleUIImage(@"wenjuan_left")];
    [self.contentView addSubview:icon];
    // 5 + 12
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(12);
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(self.leftLabel.mas_right);
    }];
    
    UIImageView *line = [[UIImageView alloc] initWithImage:BundleUIImage(@"wenjuan_line")];
    [self.contentView addSubview:line];
    self.lineImagV = line;
    // 17+2+44 = 63
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(19);
        make.left.mas_equalTo(icon.mas_right);
    }];
    
    self.title = [UILabel creatWithFont:14 TextColor:@"#1A1A1A" Text:@""];
    self.title.textAlignment = NSTextAlignmentLeft;
    self.title.numberOfLines = 0;
    [self.title sizeToFit];
    [self.contentView addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line.mas_right);
        make.top.offset(0);
        make.right.offset(-60);
        make.height.mas_equalTo(40);
    }];
    self.queStatus = [UIButton creatWithTitle:@"填写" titleFont:14 titleColor:@"#3562FA" backgroundColor:@"#FFFFFF"];
    [self.queStatus addTarget:self action:@selector(queAct:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.queStatus];
    [self.queStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.right.mas_equalTo(-20);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
}
- (void)queAct:(UIButton *)sender{
    NSString *title = [sender titleForState:UIControlStateNormal];
    if ([title isEqualToString:@"已填"] ||[title isEqualToString:@"已中奖"] || [title isEqualToString:@"已领取"]||[title isEqualToString:@"未中奖"]) {
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
//抽奖单元格
- (void)updateLottery:(VHLotteryModel *)lotteryModel isLast:(BOOL)isLast{
    self.lineImagV.hidden = isLast?YES:NO;
    
    NSArray * created_at_ary = [lotteryModel.created_at componentsSeparatedByString:@" "];
    if (created_at_ary.count == 2) {
        self.leftLabel.text = [NSString stringWithFormat:@"%@\n%@",created_at_ary[0],created_at_ary[1]];
    }else{
        self.leftLabel.text = lotteryModel.created_at;
    }
    
    if ([lotteryModel.award_snapshoot isKindOfClass:[NSDictionary class]]) {
        self.title.text = lotteryModel.award_snapshoot[@"award_name"];
    }else{
        self.title.text = @"默认奖品";
    }
    ///奖品状态: 已中奖，已领取，领取
    if (lotteryModel.win) {
        // 已中奖且不需要领奖显示已中奖
        if (lotteryModel.need_take_award == NO) {
            //显示已中奖
            [self.queStatus setTitleColor:MakeColorRGB(0xFC9600) forState:UIControlStateNormal];
            [self.queStatus setTitle:@"已中奖" forState:UIControlStateNormal];
        }else{
            if (lotteryModel.take_award) {
                //显示已领取奖品,已领取
                [self.queStatus setTitle:@"已领取" forState:UIControlStateNormal];
                [self.queStatus setTitleColor:MakeColorRGB(0xFC9600) forState:UIControlStateNormal];
            }else{
                //显示领取按钮-action
                [self.queStatus setTitle:@"领取" forState:UIControlStateNormal];
                [self.queStatus setTitleColor:MakeColorRGB(0x0A7FF5) forState:UIControlStateNormal];
            }
        }
    }else{
        [self.queStatus setTitle:@"未中奖" forState:UIControlStateNormal];
        [self.queStatus setTitleColor:MakeColorRGB(0xFC9600) forState:UIControlStateNormal];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
