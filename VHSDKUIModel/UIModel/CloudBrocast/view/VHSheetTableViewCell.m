//
//  VHSheetTableViewCell.m
//  VhallLive
//
//  Created by jinbang.li on 2022/4/6.
//  Copyright © 2022 vhall. All rights reserved.
//

#import "VHSheetTableViewCell.h"
@interface VHSheetTableViewCell()
//展示文本
@property (nonatomic,strong) UILabel *label;
///未开启云导播
@property (nonatomic,strong) UIImageView *disEnable;
@end
@implementation VHSheetTableViewCell

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
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:BundleUIImage(@"fill-off")];
    self.disEnable = imageView;
    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).offset(6);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(16);
        make.centerY.offset(0);
    }];
    self.disEnable.hidden = true;
   
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.mas_equalTo(1);
        make.bottom.offset(0);
    }];
}
///显示数据
- (void)display:(VHSheetModel *)model{
    self.label.text = model.name;
    NSInteger configValue = [model.configValue integerValue];
    //1是云导播已开启，2是云导播未开启
    switch (configValue) {
        case 1:{
            self.disEnable.hidden = YES;
        }
            break;
        case 2:{
            self.disEnable.hidden = NO;
            self.label.textColor = [UIColor colorWithHex:@"#999999"];
            [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(48);
                make.centerY.offset(0);
                make.width.mas_equalTo(240);
                
            }];
            [self.disEnable mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.label.mas_right).offset(6);
                make.width.mas_equalTo(45);
                make.height.mas_equalTo(16);
                make.centerY.offset(0);
            }];
        }
            break;
        default:
            break;
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
