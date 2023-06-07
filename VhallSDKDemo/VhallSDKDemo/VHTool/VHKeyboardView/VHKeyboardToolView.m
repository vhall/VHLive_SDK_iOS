//
//  VHKeyboardToolView.m
//  VHVSS
//
//  Created by vhall on 2019/9/16.
//  Copyright © 2019 vhall. All rights reserved.
//
#define InputViewHeight 47 //输入栏高度

#import <NSAttributedString+YYText.h>
#import "VHKeyboardToolView.h"

@interface VHKeyboardToolView ()<UITextViewDelegate>
@property (nonatomic, strong) UIButton *keyboardBackView; ///<背景（点击收起键盘）
@end


@implementation VHKeyboardToolView

- (void)dealloc
{
    [self removeKeyboardMonitor];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.maxLength = 0;
        [self setUpViews];
        [self configFrame];
        self.frame = CGRectMake(0, Screen_Height, Screen_Width, InputViewHeight);
    }

    return self;
}

- (void)setUpViews {
    self.hidden = YES;
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.textView];
    [self addSubview:self.sendBtn];
}

- (void)configFrame {
    [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.mas_equalTo(-16);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(32);
    }];

    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(VH_KScreenIsLandscape ? @40 : @10);
        make.centerY.equalTo(self);
        make.height.equalTo(@(32));
        make.right.equalTo(self.sendBtn.mas_left).offset(-12);
    }];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;

    self.textView.placeholder = self.placeholder;
}

#pragma mark - 键盘监听
- (void)addKeyboardMonitor {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeKeyboardMonitor {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

//键盘弹出
- (void)keyboardShow:(NSNotification *)notification
{
    self.hidden = NO;
    self.keyboardBackView.frame = [UIApplication sharedApplication].delegate.window.bounds;
    [self.superview insertSubview:self.keyboardBackView belowSubview:self];
    CGFloat keyboradHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;

    UIWindow *keyboardWindow = [[[UIApplication sharedApplication] windows] lastObject];
    Class class = NSClassFromString(@"UIInputSetHostView");

    for (UIView *subview in keyboardWindow.rootViewController.view.subviews) {
        if ([subview isKindOfClass:class]) {
            if (keyboradHeight != subview.frame.size.height) {
                keyboradHeight = subview.frame.size.height;
            }
        }
    }

    CGFloat duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]; //动画时间
    [UIView animateWithDuration:duration
                     animations:^{
        self.frame = CGRectMake(0, Screen_Height - keyboradHeight - InputViewHeight, Screen_Width, InputViewHeight);
    }
                     completion:^(BOOL finished) {
        [self.superview bringSubviewToFront:self];
    }];
}

//键盘收起
- (void)keyboardHidden:(NSNotification *)notification
{
    [self.keyboardBackView removeFromSuperview];
    self.hidden = YES;
    self.frame = CGRectMake(0, Screen_Height, Screen_Width, InputViewHeight);
}

//点击背景关闭
- (void)keyboardToolViewBackViewClick {
    [self resignFirstResponder];
}

- (void)becomeFirstResponder {
    [self addKeyboardMonitor];
    [self.textView becomeFirstResponder];
}

- (void)resignFirstResponder {
    [self.textView resignFirstResponder];
    [self removeKeyboardMonitor];
}

- (void)clearText {
    self.textView.text = nil;
}

#pragma mark - UI事件
//发送
- (void)sendBtnClick:(UIButton *)sender {
    NSString *text = self.textView.text;

    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除首尾空格和换行
    NSString *tempSelf = text;

    while ([tempSelf containsString:@"\r\r"] || [tempSelf containsString:@"\n\n"] || [tempSelf containsString:@"\n\r"] || [tempSelf containsString:@"\r\n"]) {//去除连续两个换行
        tempSelf = [tempSelf stringByReplacingOccurrencesOfString:@"\r\r" withString:@"\r"];
        tempSelf = [tempSelf stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"];
        tempSelf = [tempSelf stringByReplacingOccurrencesOfString:@"\n\r" withString:@"\n"];
        tempSelf = [tempSelf stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\r"];
    }
    text = tempSelf; //替换连续两个换行为一个

    if (text.length < 1) {
        [VHProgressHud showToast:@"内容不能为空"];
        return;
    }

    if (text && [self.delegate respondsToSelector:@selector(keyboardToolView:sendText:)]) {
        [self.delegate keyboardToolView:self sendText:text];
        self.textView.text = @"";
        //收起键盘
        [self keyboardToolViewBackViewClick];
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > self.maxLength && self.maxLength) {
        textView.text = [textView.text substringToIndex:self.maxLength];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _isEditing = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    _isEditing = NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self sendBtnClick:self.sendBtn];
        return NO;
    }

    //长度限制操作
    NSString *str = [NSString stringWithFormat:@"%@%@", textView.text, text];

    if (str.length > self.maxLength && self.maxLength) {
        NSRange rangeIndex = [str rangeOfComposedCharacterSequenceAtIndex:self.maxLength];

        if (rangeIndex.length == 1) {//字数超限
            textView.text = [str substringToIndex:self.maxLength];
        } else {
            NSRange rangeRange = [str rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.maxLength)];
            textView.text = [str substringWithRange:rangeRange];
        }

        return NO;
    }

    return YES;
}

#pragma mark - VHFaceDelegate
- (void)selectedFacialView:(NSString *)str isDelete:(BOOL)isDelete {
    if (![self textView:self.textView shouldChangeTextInRange:NSMakeRange(self.textView.text.length, str.length) replacementText:str]) {
        return;
    }

    NSString *chatText = self.textView.text;

    if (!isDelete && str.length > 0) {
        self.textView.text = [NSString stringWithFormat:@"%@%@", chatText, str];
    } else {
        if (chatText.length >= 2) {
            NSInteger toIndex = 0;
            BOOL findStartFace = NO;
            BOOL findEndFace = NO;

            NSString *temp = [chatText substringWithRange:NSMakeRange([chatText length] - 1, 1)];

            if ([temp isEqualToString:@"]"]) {
                findStartFace = YES;
            }

            for (NSInteger i = [chatText length] - 1; i >= 0; i--) {
                NSString *temp = [chatText substringWithRange:NSMakeRange(i, 1)];

                if ([temp isEqualToString:@"["]) {
                    toIndex = i;
                    findEndFace = YES;
                    break;
                }
            }

            if (findStartFace && findEndFace) {
                _textView.text = [chatText substringToIndex:toIndex];
                return;
            }
        }

        if (chatText.length > 0) {
            _textView.text = [chatText substringToIndex:chatText.length - 1];
        }
    }

    [self textViewDidChange:_textView];
}

- (UIButton *)keyboardBackView {
    if (!_keyboardBackView) {
        _keyboardBackView = [UIButton buttonWithType:UIButtonTypeCustom];
        _keyboardBackView.backgroundColor = [UIColor clearColor];
        [_keyboardBackView addTarget:self action:@selector(keyboardToolViewBackViewClick) forControlEvents:UIControlEventTouchUpInside];
    }

    return _keyboardBackView;
}

- (UIButton *)sendBtn
{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setImage:[UIImage imageNamed:@"vh_chat_send_icon"] forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }

    return _sendBtn;
}

- (VHTextView *)textView
{
    if (!_textView) {
        _textView = [[VHTextView alloc] init];
        _textView.textColor = [UIColor colorWithHex:@"#222222"];
        _textView.font = FONT(14);
        _textView.placeholder = self.placeholder;
        _textView.placeholderTextColor = [UIColor colorWithHex:@"#999999"];
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.layer.cornerRadius = 18;
        _textView.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
        _textView.textContainerInset = UIEdgeInsetsMake(8, 12, 8, 12);
    }

    return _textView;
}

@end
