//
//  VHSwitchCell.m
//  UIModel
//
//  Created by jinbang.li on 2022/2/24.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHSwitchCell.h"
@interface VHSwitchCell()
@property (nonatomic,strong) UILabel *effectName;

@end
@implementation VHSwitchCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupContentView];
    }
    return self;
}
- (void)setupContentView{
    UIView *bgView = [[UIView alloc] init];
    bgView.userInteractionEnabled = YES;
    
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);//28*16
        make.width.mas_equalTo(kAdaptScale*46);
        make.height.mas_equalTo(kAdaptScale*26);
    }];
    
    self.cellSwitch.transform = CGAffineTransformMakeScale(0.6, 0.6);
    
    [bgView addSubview:self.cellSwitch];
    [self.cellSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.left.offset(0);
    }];
}
- (UILabel *)effectName{
    if (!_effectName) {
        _effectName = [[UILabel alloc] init];
        _effectName.text = @"开关";
        _effectName.textAlignment = NSTextAlignmentCenter;
    }
    return _effectName;
}
- (UISwitch *)cellSwitch
{
    if (!_cellSwitch) {
        _cellSwitch = [[UISwitch alloc] init];
        _cellSwitch.on = YES;
        _cellSwitch.onTintColor = UIColor.redColor;
        _cellSwitch.tintColor = [UIColor greenColor];
        //添加动作事件
        [_cellSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _cellSwitch;
}
- (void)switchChange:(UISwitch *)sender{
    if (self.beautyEnable) {
        self.beautyEnable(sender.isOn);
    }
}
@end
