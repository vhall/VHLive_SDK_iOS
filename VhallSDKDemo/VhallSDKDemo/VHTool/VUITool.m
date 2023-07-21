//
//  VUITool.m
//  VhallModuleUI_demo
//
//  Created by vhall on 2019/11/19.
//  Copyright © 2019 vhall. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import <mach/mach.h>
#import "VUITool.h"

@implementation VUITool

#pragma mark - 角色修改
NSString * VH_MB_HOST = @"主持人";
NSString *VH_MB_GUEST = @"嘉宾";
NSString *VH_MB_ASSIST = @"助理";

#pragma mark - UITextField/UItextView输入计数 countLab：字数lab
+ (void)caculateInputBox:(id)inputBox desplayCountLab:(UILabel *)countLab maxTextLength:(NSInteger)maxTextLength
{
    if ([inputBox isKindOfClass:[UITextField class]]) {
        UITextField *box = inputBox;
        NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; // 键盘输入模式

        if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
            UITextRange *selectedRange = [box markedTextRange];
            //获取高亮部分
            UITextPosition *position = [box positionFromPosition:selectedRange.start offset:0];

            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
                if (box.text.length > maxTextLength) {
                    box.text = [box.text substringToIndex:maxTextLength];
                } else {
                }

                //显示字数
                countLab.text = [NSString stringWithFormat:@"%zd/%zd", box.text.length, maxTextLength];
            }
            // 有高亮选择的字符串，则暂不对文字进行统计和限制
            else {
            }
        }
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        else {
            if (box.text.length > maxTextLength) {
                box.text = [box.text substringToIndex:maxTextLength];
                countLab.text = [NSString stringWithFormat:@"%zd/%zd", maxTextLength, maxTextLength];
            }

            //显示字数
            countLab.text = [NSString stringWithFormat:@"%zd/%zd", box.text.length, maxTextLength];
        }
    } else if ([inputBox isKindOfClass:[UITextView class]]) {
        UITextView *box = inputBox;
        NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; // 键盘输入模式

        if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
            UITextRange *selectedRange = [box markedTextRange];
            //获取高亮部分
            UITextPosition *position = [box positionFromPosition:selectedRange.start offset:0];

            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
                if (box.text.length > maxTextLength) {
                    box.text = [box.text substringToIndex:maxTextLength];
                } else {
                }

                //显示字数
                countLab.text = [NSString stringWithFormat:@"%zd/%zd", box.text.length, maxTextLength];
            }
            // 有高亮选择的字符串，则暂不对文字进行统计和限制
            else {
            }
        }
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        else {
            if (box.text.length > maxTextLength) {
                box.text = [box.text substringToIndex:maxTextLength];
                countLab.text = [NSString stringWithFormat:@"%zd/%zd", maxTextLength, maxTextLength];
            }

            //显示字数
            countLab.text = [NSString stringWithFormat:@"%zd/%zd", box.text.length, maxTextLength];
        }
    }
}

#pragma mark - 字符串空的话赋值@""
+ (NSString *)safeString:(NSString *)string {
    if ([string isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@", string];
    }

    if (!string || ![string isKindOfClass:[NSString class]] || [string isKindOfClass:[NSNull class]] || [string isEqualToString:@"null"] || [string isEqualToString:@"<null>"]) {
        return @"";
    }

    return string;
}

#pragma mark - 获取当前view的控制器
+ (UIViewController *)viewControllerWithView:(UIView *)view
{
    for (UIView *next = [view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];

        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }

    return nil;
}

#pragma mark - 秒转时分秒
+ (NSString *)timeFormatted:(NSInteger)totalSeconds isAuto:(BOOL)isAuto
{
    if (isAuto && totalSeconds / 3600 < 1) {
        return [NSString stringWithFormat:@"%02ld:%02ld", (totalSeconds % 3600) / 60, totalSeconds % 60];
    } else {
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", totalSeconds / 3600, (totalSeconds % 3600) / 60, totalSeconds % 60];
    }
}

#pragma mark - 指定某个/多个角圆角
+ (void)clipView:(UIView *)view corner:(UIRectCorner)corners anSize:(CGSize)size
{
    //指定角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];

    //设置大小
    maskLayer.frame = view.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

#pragma mark - 获取当前屏幕控制器
+ (UIViewController *)getCurrentScreenViewController
{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *topViewController = [window rootViewController];

    while (true) {
        if (topViewController.presentedViewController) {
            topViewController = topViewController.presentedViewController;
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController *)topViewController topViewController]) {
            topViewController = [(UINavigationController *)topViewController topViewController];
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
        } else {
            break;
        }
    }
    return topViewController;
}

+ (BOOL)isBlankString:(NSString *)aStr {
    if (!aStr) {
        return YES;
    }

    if ([aStr isKindOfClass:[NSNull class]]) {
        return YES;
    }

    if (![aStr isKindOfClass:[NSString class]]) {
        NSString *tempStr = [NSString stringWithFormat:@"%@", aStr];
        aStr = tempStr;
    }

    if (!aStr.length) {
        return YES;
    }

    return NO;
}

+ (NSString *)getString:(NSString *)aStr {
    if ([self isBlankString:aStr]) {
        return @"";
    }

    return [NSString stringWithFormat:@"%@", aStr];
}

+ (CGFloat)getWidthWithText:(NSString *)text width:(CGFloat)width height:(CGFloat)height font:(UIFont *)font
{
    //内容宽度自适应
    CGSize size = CGSizeMake(width, height);
    NSDictionary *dic = @{
            NSFontAttributeName: font
    };
    CGRect rect = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];

    if (height == 0) {
        return rect.size.height;
    } else {
        return rect.size.width;
    }
}

+ (NSString *)substringToIndex:(NSInteger)index text:(NSString *)text isReplenish:(BOOL)isReplenish
{
    NSString *changeText = text;

    if (changeText.length > index) {
        changeText = [changeText substringToIndex:index];

        if (isReplenish) {
            changeText = [NSString stringWithFormat:@"%@...", changeText];
        }
    }

    return changeText;
}

+ (NSString *)substringFromIndex:(NSInteger)index text:(NSString *)text isReplenish:(BOOL)isReplenish
{
    NSString *changeText = text;

    if (changeText.length >= index) {
        changeText = [changeText substringFromIndex:index];

        if (isReplenish) {
            changeText = [NSString stringWithFormat:@"%@...", changeText];
        }
    }

    return changeText;
}

+ (UIWindow *)mainWindow
{
    id appDelegate = [UIApplication sharedApplication].delegate;

    if (appDelegate && [appDelegate respondsToSelector:@selector(window)]) {
        return [appDelegate window];
    }

    NSArray *windows = [UIApplication sharedApplication].windows;

    if ([windows count] == 1) {
        return [windows firstObject];
    } else {
        for (UIWindow *window in windows) {
            if (window.windowLevel == UIWindowLevelNormal) {
                return window;
            }
        }
    }

    return nil;
}

+ (NSInteger)getTimeDifferenceWithTime:(NSString *)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    NSDate *startTimeData = [dateFormatter dateFromString:time];

    NSTimeInterval startTimeSp = [startTimeData timeIntervalSince1970];

    NSTimeInterval endTimeSp = [[NSDate date] timeIntervalSince1970];

    NSInteger difference = (startTimeSp - endTimeSp);

    return difference;
}

+ (UIView *)getSubViewWithClassName:(NSString *)className inView:(UIView *)inView
{
    //判空处理
    if (!inView || !inView.subviews.count || !className || !className.length || [className isKindOfClass:NSNull.class]) {
        return nil;
    }

    //最终找到的view，找不到的话，就直接返回一个nil
    UIView *foundView = nil;

    //循环递归进行查找
    for (UIView *view in inView.subviews) {
        //如果view是当前要查找的view，就直接赋值并终止循环递归，最终返回
        if ([view isKindOfClass:NSClassFromString(className)]) {
            foundView = view;
            break;
        }

        //如果当前view不是要查找的view的话，就在递归查找当前view的subviews
        foundView = [self getSubViewWithClassName:className inView:view];

        //如果找到了，则终止循环递归，最终返回
        if (foundView) {
            break;
        }
    }

    return foundView;
}

+ (BOOL)isInputRuleNotBlank:(NSString *)str {
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5\\d]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];

    return isMatch;
}

+ (BOOL)isInputRuleAndBlank:(NSString *)str {
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5\\d\\s]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];

    return isMatch;
}

+ (NSString *)getSubStr:(NSString *)str strLenth:(int)strLenth
{
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [str dataUsingEncoding:encoding];
    NSInteger length = [data length];

    if (length > strLenth) {
        NSData *data1 = [data subdataWithRange:NSMakeRange(0, strLenth)];
        NSString *content = [[NSString alloc] initWithData:data1 encoding:encoding];//注意：当截取kMaxLength长度字符时把中文字符截断返回的content会是nil

        if (!content || content.length == 0) {
            data1 = [data subdataWithRange:NSMakeRange(0, strLenth - 1)];
            content =  [[NSString alloc] initWithData:data1 encoding:encoding];
        }

        return content;
    }

    return nil;
}

+ (NSString *)disable_emoji:(NSString *)str
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:str
                                                               options:0
                                                                 range:NSMakeRange(0, [str length])
                                                          withTemplate:@""];

    return modifiedString;
}

+ (void)sendTestsNotificationCenterWithKey:(NSString *)key otherInfo:(NSDictionary *)otherInfo
{
    NSMutableDictionary * userInfo = [NSMutableDictionary dictionary];
    userInfo[@"key"] = key;
    userInfo[@"otherInfo"] = otherInfo;
    [[NSNotificationCenter defaultCenter] postNotificationName:VHTestsNotificationCenter
                                                        object:nil
                                                      userInfo:userInfo];
}

+ (BOOL)isFullScreen {
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    if (@available(iOS 13.0, *)) {
        return window.windowScene.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || window.windowScene.interfaceOrientation == UIInterfaceOrientationLandscapeRight;
    } else {
        return [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight;
    }
}
@end
