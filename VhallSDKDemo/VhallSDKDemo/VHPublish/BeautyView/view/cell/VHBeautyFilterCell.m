//
//  VHBeautyFilterCell.m
//  UIModel
//
//  Created by jinbang.li on 2022/3/3.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHBeautyFilterCell.h"
@interface VHBeautyFilterCell()
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *effectName;
@property (nonatomic,strong) UIView *sideView;
@property (nonatomic,strong) UIImageView *iconImageView;
@end
@implementation VHBeautyFilterCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupContentView];
    }
    return self;
}

- (void)setupContentView{
    // 返回每个item的大小 height 15+55+8+20  width 44
    self.sideView = [[UIView alloc] init];
    self.sideView.hidden = YES;
    self.sideView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.sideView];
    [self.sideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(kAdaptScale*0);
        make.width.mas_equalTo(kAdaptScale*48);
        make.height.mas_equalTo(kAdaptScale*59);
        make.centerX.offset(0);
    }];
    self.imageView = [[UIImageView alloc] init];
    [self.imageView radiusTool:4 borderWidth:1 borderColor:[UIColor colorWithHex:@"#FFFFFF"]];
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(kAdaptScale*2);
        make.width.mas_equalTo(kAdaptScale*44);
        make.height.mas_equalTo(kAdaptScale*55);
        make.centerX.offset(0);
    }];
    self.effectName = [UILabel creatWithFont:14 TextColor:@"#262626"];
    self.effectName.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.effectName];
    [self.effectName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(6*kAdaptScale);
        make.width.mas_equalTo(kAdaptScale*44);
        make.height.mas_equalTo(kAdaptScale*20);
        make.centerX.offset(0);
    }];
    //创建一个中间视图originalimage_select
    self.iconImageView = [[UIImageView alloc] init];
    [self.imageView addSubview:self.iconImageView];
    self.iconImageView.hidden = YES;
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kAdaptScale*20);
        make.height.mas_equalTo(kAdaptScale*20);
        make.center.offset(0);
    }];
}

- (void)beautyModel:(VHBeautyModel *)beauty  isSelect:(BOOL)isSelect index:(NSInteger)index{
    if (index == 0) {
        self.imageView.image = [UIImage imageNamed:@""];
        self.iconImageView.hidden = NO;
        self.imageView.backgroundColor = [UIColor colorWithHex:@"#E6E6E6"];
        self.imageView.layer.cornerRadius = 2;
        [self selectOperation:isSelect];
        if (isSelect) {
            NSString *selectIcon = [NSString stringWithFormat:@"%@_select",beauty.icon];
            self.iconImageView.image = [UIImage imageNamed:selectIcon];
            self.effectName.text = beauty.name;
        }else{
            NSString *disableIcon = [NSString stringWithFormat:@"%@_disable",beauty.icon];
            self.iconImageView.image = [UIImage imageNamed:disableIcon];
            self.effectName.text = beauty.name;
        }
    }else{
        [self selectOperation:isSelect];
        self.iconImageView.hidden = YES;
        self.imageView.image = [UIImage imageNamed:beauty.icon];
        self.effectName.text = beauty.name;
    }
}

- (void)selectOperation:(BOOL)selected{
    if (selected) {
        self.sideView.hidden = NO;
        [self.sideView radiusTool:4 borderWidth:1 borderColor:[UIColor colorWithHex:@"#FC5659"]];
        self.sideView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.4].CGColor;
        self.effectName.textColor = [UIColor colorWithHex:@"#FB3A32"];
    }else{
        self.sideView.hidden = YES;
        [self.sideView radiusTool:0 borderWidth:0 borderColor:[UIColor colorWithHex:@"#FFFFFF"]];
        self.sideView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
        self.effectName.textColor = [UIColor colorWithHex:@"#262626"];
    }
}
@end

