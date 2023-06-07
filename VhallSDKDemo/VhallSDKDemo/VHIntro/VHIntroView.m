//
//  VHIntroView.m
//  VHLiveSDK
//
//  Created by 郭超 on 2022/12/16.
//  Copyright © 2022 vhall. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "VHEmptyView.h"
#import "VHIntroView.h"

@interface VHIntroView ()<WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UILabel *webinarTitleLab;                 ///<活动标题
@property (nonatomic, strong) UILabel *startTimeLab;                    ///<开播时间
@property (nonatomic, strong) WKWebView *webView;                       ///<详情
@property (nonatomic, strong) VHEmptyView *emptyView;                   ///<空页面
@end

@implementation VHIntroView

#pragma mark - 初始化
- (void)setWebinarInfoData:(VHWebinarInfoData *)webinarInfoData
{
    _webinarInfoData = webinarInfoData;

    // 初始化UI
    self.emptyView.hidden = !([VUITool isBlankString:webinarInfoData.webinar.introduction] || [webinarInfoData.webinar.introduction isEqualToString:@"<p></p>"]);
    self.webView.hidden = ([VUITool isBlankString:webinarInfoData.webinar.introduction] || [webinarInfoData.webinar.introduction isEqualToString:@"<p></p>"]);

    self.webinarTitleLab.text = [VUITool substringToIndex:8 text:webinarInfoData.webinar.subject isReplenish:YES];

    self.startTimeLab.text = webinarInfoData.webinar.start_time;

    [self.webView loadHTMLString:webinarInfoData.webinar.introduction baseURL:nil];
}

- (instancetype)init
{
    if ([super init]) {
        self.backgroundColor = [UIColor whiteColor];

        [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];

        [self.webinarTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
        }];

        [self.startTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(self.webinarTitleLab.mas_bottom).offset(8);
        }];

        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(self.startTimeLab.mas_bottom).offset(16);
            make.bottom.mas_equalTo(0);
        }];
    }

    return self;
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [VHProgressHud showToast:error.domain];
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
}

#pragma mark - 懒加载
- (UILabel *)webinarTitleLab {
    if (!_webinarTitleLab) {
        _webinarTitleLab = [[UILabel alloc] init];
        _webinarTitleLab.textColor = [UIColor colorWithHex:@"#262626"];
        _webinarTitleLab.font = FONT_Medium(16);
        _webinarTitleLab.preferredMaxLayoutWidth = Screen_Width - 24;
        _webinarTitleLab.numberOfLines = 0;
        [self addSubview:_webinarTitleLab];
    }

    return _webinarTitleLab;
}

- (UILabel *)startTimeLab {
    if (!_startTimeLab) {
        _startTimeLab = [[UILabel alloc] init];
        _startTimeLab.textColor = [UIColor colorWithHex:@"#595959"];
        _startTimeLab.font = FONT(14);
        [self addSubview:_startTimeLab];
    }

    return _startTimeLab;
}

- (WKWebView *)webView {
    if (!_webView) {
        NSString *injectionJSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content','width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        WKUserScript *injectionJSStringScript = [[WKUserScript alloc] initWithSource:injectionJSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];

        WKUserContentController *userController = [WKUserContentController new];
        [userController addUserScript:injectionJSStringScript];

        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.preferences = [WKPreferences new];
        config.preferences.minimumFontSize = 10;
        config.preferences.javaScriptEnabled = YES;
        config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        config.userContentController = userController;

        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height) configuration:config];

        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }

        _webView.navigationDelegate = self;
        _webView.scrollView.delegate = self;
        _webView.UIDelegate = self;
        [self addSubview:_webView];
    }

    return _webView;
}

- (VHEmptyView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[VHEmptyView alloc] init];
        [self addSubview:_emptyView];
    }

    return _emptyView;
}

#pragma mark - 分页
- (UIView *)listView {
    return self;
}

@end
