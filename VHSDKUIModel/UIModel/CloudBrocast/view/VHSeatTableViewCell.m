//
//  VHSeatTableViewCell.m
//  VhallLive
//
//  Created by jinbang.li on 2022/4/6.
//  Copyright © 2022 vhall. All rights reserved.
//

#import "VHSeatTableViewCell.h"
@interface VHSeatTableViewCell()
//展示文本
@property (nonatomic,strong) UILabel *label;

@end
@implementation VHSeatTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
    }
    return self;
}
- (void)setUpUI{
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.font = [UIFont fontWithName:@"PingFangSC" size: 16];
    label.textColor = [UIColor colorWithHex:@"#222222"];
    self.label = label;
    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.left.right.offset(0);
        make.height.mas_equalTo(22);
    }];
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.mas_equalTo(1);
        make.top.offset(0);
    }];
}
///显示数据
- (void)display:(VHSheetModel *)model selectStatus:(BOOL)seatStatus{
    if (seatStatus) {
        self.label.text = model.name;
        self.label.textColor = [UIColor colorWithHex:@"#FB3A32"];
    }else{
        //机位可用与不可用
        if ([model.configValue isEqualToString:@"1"]) {
            //机位已占用
            self.label.text = [NSString stringWithFormat:@"%@：已占用",model.name];
            self.label.textColor = [UIColor colorWithHex:@"#999999"];
        }else{
            self.label.text = model.name;
            self.label.textColor = [UIColor colorWithHex:@"#222222"];
        }
    }
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
