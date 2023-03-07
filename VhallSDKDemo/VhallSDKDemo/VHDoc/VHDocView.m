//
//  VHDocView.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/14.
//

#import "VHDocView.h"
#include <objc/runtime.h>

@interface VHDocView ()
@property (nonatomic, strong) UIView * documentView;
@property (nonatomic, strong) UIButton * fullBtn;
@property (nonatomic, strong) UIView * uiwebPPTView;
@end

@implementation VHDocView


#pragma mark - 初始化
- (instancetype)init
{
    if ([super init]) {
        
        self.backgroundColor = [UIColor colorWithHex:@"#E5E5E5"];

    }return self;
}
- (void)layoutSubviews
{
    [self.documentView setFrame:self.bounds];
    
    if (!self.uiwebPPTView) {
        UIView * VHDocumentViewWK = [VUITool getSubViewWithClassName:@"VHDocumentViewWK" inView:self.documentView];
        self.uiwebPPTView = [VUITool getSubViewWithClassName:@"WKWebView" inView:VHDocumentViewWK];
        self.uiwebPPTView.backgroundColor = [UIColor whiteColor];
    }
}
#pragma mark - 添加文档
- (void)addToDocumentView:(UIView *)documentView
{
    self.documentView = documentView;
    
    [self addSubview:documentView];
    [self.documentView setFrame:self.bounds];

    [self addSubview:self.fullBtn];
    [self.fullBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50);
        make.right.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
}
#pragma mark - 退出全屏
- (void)quitFull
{
    self.fullBtn.selected = NO;
    if ([self.delegate respondsToSelector:@selector(fullWithSelect:)]) {
        [self.delegate fullWithSelect:self.fullBtn.selected];
    }
}
#pragma mark - 点击全屏按钮
- (void)fullBtnAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(fullWithSelect:)]) {
        [self.delegate fullWithSelect:sender.selected];
    }
}
#pragma mark - 懒加载
- (UIButton *)fullBtn {
    if (!_fullBtn) {
        _fullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullBtn setImage:[UIImage imageNamed:@"vh_doc_full"] forState:UIControlStateNormal];
        [_fullBtn setImage:[UIImage imageNamed:@"vh_doc_outFull"] forState:UIControlStateSelected];
        [_fullBtn addTarget:self action:@selector(fullBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    } return _fullBtn;
}

#pragma mark - 分页
- (UIView *)listView {
    return self;
}
@end
