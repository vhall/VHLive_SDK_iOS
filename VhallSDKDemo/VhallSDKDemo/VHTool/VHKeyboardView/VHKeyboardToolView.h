//
//  VHKeyboardToolView.h
//  VHVSS
//
//  Created by vhall on 2019/9/16.
//  Copyright © 2019 vhall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VHTextView.h"

@class VHKeyboardToolView;

@protocol VHKeyboardToolViewDelegate <NSObject>

/* 发送按钮事件回调*/
- (void)keyboardToolView:(VHKeyboardToolView *)view sendText:(NSString *)text;

@end


@interface VHKeyboardToolView : UIView

/*! 发送按钮*/
@property (nonatomic, strong) UIButton *sendBtn;
/*! 输入框*/
@property (nonatomic, strong) VHTextView *textView;
/*! 输入的最大长度 默认 0不限制 */
@property (nonatomic,assign) NSInteger maxLength;
/*!  提示文案 */
@property (nonatomic, copy) NSString * placeholder;
/*! 是否正在编辑*/
@property (nonatomic , assign , readonly) BOOL isEditing;
/*! 代理指针*/
@property (nonatomic, weak) id <VHKeyboardToolViewDelegate> delegate;

/*! 收起键盘*/
- (void)resignFirstResponder;
/*! 打开键盘*/
- (void)becomeFirstResponder;

/*! 清空内容*/
- (void)clearText;

@end
