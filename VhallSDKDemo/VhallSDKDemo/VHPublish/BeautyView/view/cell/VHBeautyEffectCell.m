//
//  VHBeautyEffectCell.m
//  UIModel
//
//  Created by jinbang.li on 2022/2/17.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHBeautyEffectCell.h"
#import "UILabel+VHConvenient.h"
#import "UIColor+VUI.h"
@interface VHBeautyEffectCell()
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *effectName;
@end
@implementation VHBeautyEffectCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupContentView];
    }
    return self;
}
- (void)setupContentView{
    // 返回每个item的大小 height 15+55+8+20  width 44
    self.imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(VHRateScale*0);
        make.width.mas_equalTo(VHRateScale*20);
        make.height.mas_equalTo(VHRateScale*20);
        make.centerX.offset(0);
    }];
    self.effectName = [UILabel creatWithFont:14 TextColor:@"#262626"];
    self.effectName.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.effectName];
    [self.effectName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(6*VHRateScale);
        make.width.mas_equalTo(VHRateScale*44);
        make.height.mas_equalTo(VHRateScale*20);
        make.centerX.offset(0);
    }];
}
- (void)beautyModel:(VHBeautyModel *)beauty  isSelect:(BOOL)isSelect{
    if (isSelect) {
        NSString *selectIcon = [NSString stringWithFormat:@"%@_select",beauty.icon];
        self.imageView.image = [UIImage imageNamed:selectIcon];
        self.effectName.text = beauty.name;
        self.effectName.textColor = [UIColor colorWithHex:@"#FB3A32"];
    }else{
        self.imageView.image = [UIImage imageNamed:beauty.icon];
        self.effectName.text = beauty.name;
        self.effectName.textColor = [UIColor colorWithHex:@"#262626"];
    }
}
@end
