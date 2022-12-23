//
//  VHNAVTopView.m
//  UIModel
//
//  Created by 郭超 on 2022/11/22.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHNAVTopView.h"

@interface VHNAVTopView ()

@end

@implementation VHNAVTopView

- (instancetype)init
{
    if ([super init]) {
        
        [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.left.mas_equalTo(22);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.backBtn.mas_centerY);
            make.width.mas_lessThanOrEqualTo(150);
        }];
        
    }return self;
}

#pragma mark - 退出房间
- (void)backBtnClick
{
    if (self.clickBackBlock){
        self.clickBackBlock();
    }
}

#pragma mark - 懒加载
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        [_backBtn setImage:BundleUIImage(@"关闭") forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backBtn];
    }
    return _backBtn;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = [UIColor colorWithHex:@"#222222"];
        _titleLab.font = FONT_Medium(16);
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLab];
    }
    return _titleLab;
}

@end
