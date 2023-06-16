//
//  VHWebViewVC.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/2/15.
//

#import <WebKit/WebKit.h>
#import "VHWebViewVC.h"

@interface VHWebViewVC ()<WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate>
///详情
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation VHWebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    DEMO_Setting.webhost = [VUITool isBlankString:DEMO_Setting.webhost] ? @"https://live.vhall.com/v3" : DEMO_Setting.webhost;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/lives/embedclientfull/watch/%@",DEMO_Setting.webhost,self.webinar_id]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.f];
    [self.webView loadRequest:request];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"发送请求-----》%@", navigationAction.request.URL.absoluteString);

    NSURL *url = navigationAction.request.URL;

    UIApplication *application = [UIApplication sharedApplication];

    NSString *string = navigationAction.request.URL.absoluteString;

    //跳转到Safari去下载
    if ([string containsString:@"document_download"]) {
        [application  openURL:url
                      options:@{}
            completionHandler:^(BOOL success) {
            NSLog(@"%@", success ? @"完成下载" : @"错误");
        }];
        // 不允许web内跳转
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }

    decisionHandler(WKNavigationActionPolicyAllow);
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }

    return nil;
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
//        if (@available(iOS 11.0, *)) {
//            NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
//            WKHTTPCookieStore *cookieStore = [WKWebsiteDataStore defaultDataStore].httpCookieStore;
//            if (cookies.count > 0) {
//                for (NSHTTPCookie *cookie in cookies) {
//                    [cookieStore setCookie:cookie completionHandler:^{
//
//                    }];
//                }
//            }
//        }
        [self.view addSubview:_webView];
    }

    return _webView;
}

@end
