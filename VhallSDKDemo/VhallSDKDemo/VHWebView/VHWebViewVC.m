//
//  VHWebViewVC.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/2/15.
//

#import <WebKit/WebKit.h>
#import "VHWebViewVC.h"

#define VHWebViewVC_URL_TIMEOUT 30
#define VHWebViewVC_SCHEME @"yyy.xxx.com"
#define VHWebViewVC_REFERER @"xxx.com"
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

    NSString *urlStr = @"";

    if ([VUITool isBlankString:DEMO_Setting.webView]) {
        DEMO_Setting.webhost = [VUITool isBlankString:DEMO_Setting.webhost] ? @"https://live.vhall.com/v3" : DEMO_Setting.webhost;
        urlStr = [NSString stringWithFormat:@"%@/lives/embedclientfull/watch/%@", DEMO_Setting.webhost, self.webinar_id];
    } else {
        urlStr = DEMO_Setting.webView;
    }

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setValue:[NSString stringWithFormat:@"%@://",VHWebViewVC_REFERER] forHTTPHeaderField:@"Referer"];
    [self.webView loadRequest:request];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"发送请求-----》%@", navigationAction.request.URL.absoluteString);

    NSURLRequest *request           = navigationAction.request;
    NSURL *url                      = request.URL;
    NSString *scheme                = [navigationAction.request.URL scheme];
    UIApplication *application      = [UIApplication sharedApplication];
    NSString *absoluteString        = navigationAction.request.URL.absoluteString;
    
    // decode for all URL to avoid url contains some special character so that it wasn't load.
    
    static NSString *endPayRedirectURL = nil;

    //跳转到Safari去下载
    if ([absoluteString containsString:@"document_download"]) {
        [application  openURL:url
                      options:@{}
            completionHandler:^(BOOL success) {
            NSLog(@"%@", success ? @"完成下载" : @"错误");
        }];
        // 不允许web内跳转
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    //三方购买
    if ([scheme isEqualToString:VHWebViewVC_SCHEME]) {
        // 打开客户端
        [application  openURL:url
                      options:@{}
            completionHandler:^(BOOL success) {
            NSLog(@"客户端跳转%@", success ? @"完成" : @"失败");
        }];
        
        // 取消当前请求
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }

    // 解决跳转到本地支付宝App不返回的问题
    // 判断URL是否以alipays://或者alipay://开头
    if ([absoluteString hasPrefix:@"alipays://"] || [absoluteString hasPrefix:@"alipay://"]) {
        // 定义支付宝URL的前缀
        NSString *prefixString = @"alipay://alipayclient/?";
        
        // 将URL中的alipays替换为应用的scheme
        NSString *urlString = [[VUITool vh_URLDecodedString:absoluteString] stringByReplacingOccurrencesOfString:@"alipays" withString:VHWebViewVC_SCHEME];

        // 如果URL以前缀字符串开头，则对URL进行特殊处理
        if ([urlString hasPrefix:prefixString]) {
            // 获取前缀字符串的范围
            NSRange rang = [urlString rangeOfString:prefixString];
            // 获取前缀字符串后面的部分
            NSString *subString = [urlString substringFromIndex:rang.length];
            // 将前缀和后面的部分拼接起来，并对拼接后的字符串进行URL编码
            NSString *encodedString = [prefixString stringByAppendingString:[VUITool vh_URLEncodedString:subString]];
            // 将编码后的字符串转换为NSURL对象
            url = [NSURL URLWithString:encodedString];
        }
        
        // 打开支付宝客户端
        [application  openURL:url
                      options:@{}
            completionHandler:^(BOOL success) {
            NSLog(@"支付宝跳转%@", success ? @"完成" : @"失败");
        }];
        
        // 取消当前请求
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }

    //解决微信支付后为返回当前应用的问题
    // 判断是否需要重定向
    if ([absoluteString hasPrefix:@"https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb"] && ![absoluteString hasSuffix:[NSString stringWithFormat:@"redirect_url=%@://",VHWebViewVC_REFERER]]) {
        // 取消当前请求
        decisionHandler(WKNavigationActionPolicyCancel);
            
        NSString *redirectUrl = nil;
        // 判断URL中是否包含redirect_url参数
        if ([absoluteString containsString:@"redirect_url="]) {
            NSRange redirectRange = [absoluteString rangeOfString:@"redirect_url"];
            // 获取redirect_url参数后面的值
            endPayRedirectURL =  [absoluteString substringFromIndex:redirectRange.location+redirectRange.length+1];
            // 将redirect_url参数的值替换为当前应用程序的URL Scheme，并重新构造URL
            redirectUrl = [[absoluteString substringToIndex:redirectRange.location] stringByAppendingString:[NSString stringWithFormat:@"redirect_url=%@://",VHWebViewVC_REFERER]];
        }else {
            // 在URL末尾添加redirect_url参数，并将其值设置为当前应用程序的URL Scheme
            redirectUrl = [absoluteString stringByAppendingString:[NSString stringWithFormat:@"&redirect_url=%@://",VHWebViewVC_REFERER]];
        }
            
        // 构建新的请求
        NSMutableURLRequest *newRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:redirectUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:VHWebViewVC_URL_TIMEOUT];
        newRequest.allHTTPHeaderFields = request.allHTTPHeaderFields;
        [newRequest setValue:[NSString stringWithFormat:@"%@://",VHWebViewVC_REFERER] forHTTPHeaderField:@"Referer"];
        newRequest.URL = [NSURL URLWithString:redirectUrl];
        // 使用新请求加载页面
        [webView loadRequest:newRequest];
        return;
    }

    // 判断scheme是否为http或者https
    if (![scheme isEqualToString:@"https"] && ![scheme isEqualToString:@"http"]) {
        // 取消当前请求
        decisionHandler(WKNavigationActionPolicyCancel);
        // 判断scheme是否为weixin
        if ([scheme isEqualToString:@"weixin"]) {
            // 如果endPayRedirectURL不为空，使用其加载新页面
            if (endPayRedirectURL) {
                [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:endPayRedirectURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:VHWebViewVC_URL_TIMEOUT]];
            }
        }else if ([scheme isEqualToString:[NSString stringWithFormat:@"%@",VHWebViewVC_SCHEME]]) {
            // 对于其他scheme，可以进行特殊处理
        }
        // 如果URL中包含weixin://，打开微信客户端
        if ([navigationAction.request.URL.absoluteString hasPrefix:@"weixin://"]) {
            [application  openURL:url
                          options:@{}
                completionHandler:^(BOOL success) {
                NSLog(@"微信跳转%@", success ? @"完成" : @"失败");
            }];
        }
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
//        config.websiteDataStore = [WKWebsiteDataStore nonPersistentDataStore];

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
//        WKWebsiteDataStore *dataStore = WKWebsiteDataStore.defaultDataStore;
//        NSSet *websiteDataTypes = [NSSet setWithArray:@[
//            WKWebsiteDataTypeDiskCache,
//            WKWebsiteDataTypeMemoryCache,
//            WKWebsiteDataTypeOfflineWebApplicationCache,
//            WKWebsiteDataTypeCookies,
//            WKWebsiteDataTypeSessionStorage,
//            WKWebsiteDataTypeLocalStorage,
//            WKWebsiteDataTypeWebSQLDatabases,
//            WKWebsiteDataTypeIndexedDBDatabases
//        ]];
//        [dataStore removeDataOfTypes:websiteDataTypes forDataRecords:[NSArray array] completionHandler:^{
//            VHLog(@"缓存数据已删除");
//        }];
        [self.view addSubview:_webView];
    }

    return _webView;
}

@end
