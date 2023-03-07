//
//  VHSurveyWebView.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/16.
//

#import "VHSurveyWebView.h"
#import <WebKit/WebKit.h>

@interface VHSurveyWebView ()<WKScriptMessageHandler,WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate>
/// 容器
@property (nonatomic, strong) UIView * contentView;
/// webView
@property (nonatomic, strong) WKWebView * webView;
/// 观看地址
@property (nonatomic, strong) NSURL * surveyUrl;
@end

@implementation VHSurveyWebView

- (void)dealloc
{
    //移除webView“关闭”事件代理
    [self webViewRemoveScriptMessageHandlerForName:@"onWebEvent"];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        self.alpha = 0;
        self.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissContentView)];
        [self addGestureRecognizer:tap];

        [self addSubview:self.contentView];
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
    
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self.mas_width);
    }];
}
#pragma mark - 显示
- (void)showSurveyUrl:(NSURL *)surveyUrl
{
    self.surveyUrl = surveyUrl;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:surveyUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.f];
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
        //网页关闭按钮事件
        if ([event isEqualToString:@"submit"]) {
            [VHProgressHud showToast:@"问卷提交成功"];
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

- (WKWebView *)webView
{
    if (!_webView)
    {
        WKWebViewConfiguration *wkConfig = [[WKWebViewConfiguration alloc] init];
        wkConfig.allowsInlineMediaPlayback = YES; //允许视频非全屏播放
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:wkConfig];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        _webView.scrollView.scrollEnabled = NO;
        _webView.scrollView.delegate = self;
    }
    return _webView;
}
@end
