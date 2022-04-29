//
//  VHViewProtocolView.m
//  UIModel
//
//  Created by jinbang.li on 2022/4/12.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHViewProtocolView.h"
#import "VHWebWatchLiveViewController.h"
#import <VHLiveSDK/VHWebinarInfo.h>
#import <WebKit/WebKit.h>
//确定是0,取消为1
typedef void(^OperationClick)(NSInteger index);
@interface VHViewProtocolView()<UITextViewDelegate>
//点击-确定是0,取消为1
@property (nonatomic,copy) OperationClick click;
@property (nonatomic) NSArray *infoArr;
@end
@implementation VHViewProtocolView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.frame = CGRectMake(0, 0, VH_KScreenIsLandscape?VHScreenHeight:VHScreenWidth, VH_KScreenIsLandscape?VHScreenWidth:VHScreenHeight);
    }
    return self;
}
- (instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0,VHScreenWidth, VHScreenHeight);
    }
    return self;
}
+ (void)showViewProtocolView:(NSString *)title content:(NSString *)content statement_status:(NSInteger)status rule:(NSInteger)rule  statement_content:(NSString *)statement_content info:(NSArray *)infoArr click:(void(^)(NSInteger index))operation{
    VHViewProtocolView *protocolView = [[VHViewProtocolView alloc] init];
    [protocolView alertContent:CGSizeMake(VHScreenWidth - 40, rule== 0?350:330) title:title content:content statement_status:status rule:rule statement_content:statement_content info:infoArr clickCall:operation];
}
- (void)alertContent:(CGSize)alertSize title:(NSString *)title content:(NSString *)content statement_status:(NSInteger)status rule:(NSInteger)rule statement_content:(NSString *)statement_content info:(NSArray *)info clickCall:(void(^)(NSInteger index))operation{
    // 12 8 50 10
    self.click = operation;
    self.infoArr = info;
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VHScreenWidth, VHScreenHeight)];
    bgview.backgroundColor = [UIColor blackColor];
    bgview.alpha = 0.3;
    bgview.userInteractionEnabled = YES;
    [self addSubview:bgview];
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 8;
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.width.mas_equalTo(alertSize.width);
        make.height.mas_equalTo(alertSize.height);
    }];
    //协议标题
    UILabel *label = [UILabel creatWithFont:16 TextColor:@"#1A1A1A" Text:title];
    [contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.top.offset(20);
        make.right.offset(-16);
        make.height.mas_equalTo(60);
    }];//36
    //右上角的关闭按钮
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    [close setImage:BundleUIImage(@"关闭") forState:UIControlStateNormal];
    close.tag = 100;
    [close addTarget:self action:@selector(operationAction:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:close];
    [close mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.right.offset(-20);
        make.width.height.mas_equalTo(14);
    }];
    //协议内容
//    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
//    config.preferences = [WKPreferences new];
//    config.preferences.minimumFontSize = 16;
//    config.preferences.javaScriptEnabled = YES;
//    config.preferences.javaScriptCanOpenWindowsAutomatically = YES;//下方代码，禁止缩放
//    WKUserContentController *userController = [WKUserContentController new];
//    NSString *js = @" $('meta[name=description]').remove(); $('head').append( '' );";
//    WKUserScript *script = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
//    NSMutableString *javascript = [NSMutableString string]; [javascript appendString:@"document.documentElement.style.webkitTouchCallout='none';"];//禁止长按
//    [javascript appendString:@"document.documentElement.style.webkitUserSelect='none';"];//禁止选择
//    WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
//    [userController addUserScript:script];
//    [userController addUserScript:noneSelectScript];[userController addScriptMessageHandler:self name:@"openInfo"];
//    config.userContentController = userController;
//    WKWebView *textView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
//    textView.scrollView.bounces = false;//禁止滑动
//    [textView loadHTMLString:content baseURL:nil];
//    [contentView addSubview:textView];
//    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(16);
//        make.top.mas_equalTo(label.mas_bottom).offset(12);
//        make.right.offset(-20);
//        make.height.mas_equalTo(100);
//    }];
    //协议内容
    UITextView *textView = [[UITextView alloc] init];
    textView.font = [UIFont systemFontOfSize:14];
    textView.text = content;
    textView.editable=NO;
    textView.scrollEnabled=YES;
    textView.showsVerticalScrollIndicator = FALSE;
    textView.showsHorizontalScrollIndicator = FALSE;
    [contentView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.top.mas_equalTo(label.mas_bottom).offset(12);
        make.right.offset(-20);
        status == 1?make.height.mas_equalTo(100):make.height.mas_equalTo(160);
    }];//98
    if (status == 1) {
        //协议可点击框
        UITextView *agreementTextView = [[UITextView alloc] init];
        [contentView addSubview:agreementTextView];
        agreementTextView.font = [UIFont systemFontOfSize:14];
        agreementTextView.text = statement_content;
        agreementTextView.backgroundColor = [UIColor clearColor];
        agreementTextView.delegate=self;
        //必须禁止输入，否则点击将弹出输入键
        agreementTextView.editable=NO;
        agreementTextView.scrollEnabled=NO;
            
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing= 1;
        NSDictionary*attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:7],
                                    NSParagraphStyleAttributeName:paragraphStyle};
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:agreementTextView.text attributes:attributes];
        
        for (int i = 0; i < info.count; i++) {
            [attributedString addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"guankanxieyi%d://",i] range:[agreementTextView.text rangeOfString:[info[i] title]]];
        }
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"#666666"] range:NSMakeRange(0,agreementTextView.text.length)];
        agreementTextView.attributedText= attributedString;
        //设置被点击字体颜色
        agreementTextView.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor blueColor]};
        [agreementTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(16);
            make.bottom.offset(-70);
            make.right.offset(-20);
            make.height.mas_equalTo(60);
        }];//126
    }
   

    //同意按钮+退出按钮
    UIButton *agree = [UIButton creatWithTitle:rule == 1 ? @"同意并继续":@"同意并继续" titleFont:14 titleColor:@"#FFFFFF" backgroundColor:@"#FB3A32"];
    agree.tag = 101;
    [agree addTarget:self action:@selector(operationAction:) forControlEvents:UIControlEventTouchUpInside];
    agree.layer.cornerRadius = 10;
    [contentView addSubview:agree];
    [agree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-20);
        make.centerX.offset(0);
        make.width.mas_equalTo(76*2);
        make.height.mas_equalTo(20*2);
    }];
    
//    if (rule == 0) {
//        UIButton *refuse = [UIButton creatWithTitle:@"拒绝" titleFont:7 titleColor:@"#1A1A1A" backgroundColor:@"#FFFFFF"];
//        refuse.tag = 102;
//        [refuse addTarget:self action:@selector(operationAction:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [contentView addSubview:refuse];
//        [refuse mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(agree.mas_bottom).offset(10);
//            make.centerX.offset(0);
//            make.width.mas_equalTo(76);
//            make.height.mas_equalTo(20);
//        }];
//        
//    }
    //[[UIApplication sharedApplication].keyWindow addSubview:self];
    [[[UIApplication sharedApplication].keyWindow.rootViewController presentedViewController].view addSubview:self];
}
#pragma mark 富文本点击事件
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    NSString *lastString = [[URL scheme] substringFromIndex:[URL scheme].length-1];
    NSInteger index = [lastString integerValue];
    ///去除对应的link进行跳转
    NSString *jumpUrl = [self.infoArr[index] link];
    NSLog(@"跳转的url:%@",jumpUrl);
    VHWebWatchLiveViewController *watchVC = [[VHWebWatchLiveViewController alloc] init];
    watchVC.webWathType = VHWebWatchType_Protocol;
    watchVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [watchVC webViewProtocol:jumpUrl];
    [[[UIApplication sharedApplication].keyWindow.rootViewController presentedViewController] presentViewController:watchVC animated:YES completion:nil];
    return YES;
}
- (void)operationAction:(UIButton *)sender{
    [self removeFromSuperview];
    NSInteger index = sender.tag;
    if (self.click) {
        self.click(index - 100);
    }
}
@end
