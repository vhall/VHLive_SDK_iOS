//
//  VHExamWebView.m
//  UIModel
//
//  Created by 郭超 on 2022/11/25.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHExamWebView.h"
#import <WebKit/WebKit.h>
#import <VHLiveSDK/VHallApi.h>

@interface VHExamWebView ()<WKScriptMessageHandler,WKUIDelegate,UIScrollViewDelegate>
/// 容器
@property (nonatomic, strong) UIView * contentView;
/// 标题
@property (nonatomic, strong) UILabel * titleLab;
/// 关闭
@property (nonatomic, strong) UIButton * closeBtn;
/// webView
@property (nonatomic, strong) WKWebView * webView;
/// 观看地址
@property (nonatomic, strong) NSURL * watchUrl;
@end

@implementation VHExamWebView

- (void)dealloc
{
    //移除webView“关闭”事件代理
    [self webViewRemoveScriptMessageHandlerForName:@"onWebEvent"];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissContentView)];
        [self addGestureRecognizer:tap];

        [self addSubview:self.contentView];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.closeBtn];
        [self.contentView addSubview:self.webView];

        // 初始化布局
        [self setUpMasonry];
        
        //添加webView”关闭“事件代理
        [self webViewAddScriptMessageHandlerWithname:@"onWebEvent"];

    }return self;
}

#pragma mark - 初始化布局
- (void)setUpMasonry
{
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(18);
        make.left.mas_equalTo(16);
    }];
    
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_titleLab.mas_centerY);
        make.right.mas_equalTo(-16);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self.mas_width);
    }];
}
#pragma mark - 显示
- (void)showWatchUrl:(NSURL *)watchUrl
{
    self.watchUrl = watchUrl;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:watchUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.f];
    [self.webView loadRequest:request];

    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {

    }];
}

#pragma mark - 隐藏
- (void)disMissContentView {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - 点击关闭
- (void)clickToCloseBtn
{
    [self disMissContentView];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if (message.body && [message.name isEqualToString:@"onWebEvent"])
    {
        NSDictionary *msg = [self jsonStringToDictionary:message.body];
        NSString *event = msg[@"event"];
        //网页关闭按钮事件
        if ([event isEqualToString:@"close"]) {
            [self disMissContentView];
        }
    }
}
- (id)jsonStringToDictionary:(NSString *)jsonString {
    if (!jsonString) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id obj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return obj;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webViewAddScriptMessageHandlerWithname:(NSString *)name {
    if(self.webView.configuration.userContentController == nil )
    {
        self.webView.configuration.userContentController = [[WKUserContentController alloc] init];
    }
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:name];
}
- (void)webViewRemoveScriptMessageHandlerForName:(NSString *)name
{
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:name];
}

#pragma mark - 懒加载
- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor colorWithHex:@"#FFF4F4"];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 8;
    }return _contentView;
}
- (UILabel *)titleLab
{
    if (!_titleLab){
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = @"快问快答";
        _titleLab.font = FONT_FZZZ(14);
        _titleLab.textColor = [UIColor colorWithHex:@"#262626"];
    }return _titleLab;
}
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setImage:BundleUIImage(@"关闭") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(clickToCloseBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (WKWebView *)webView
{
    if (!_webView)
    {
        WKWebViewConfiguration *wkConfig = [[WKWebViewConfiguration alloc] init];
        wkConfig.allowsInlineMediaPlayback = YES; //允许视频非全屏播放
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:wkConfig];
        _webView.UIDelegate = self;
        _webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        _webView.scrollView.scrollEnabled = NO;
        _webView.scrollView.delegate = self;
    }
    return _webView;
}

@end