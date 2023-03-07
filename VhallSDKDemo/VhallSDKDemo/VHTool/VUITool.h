//
//  VUITool.h
//  VhallModuleUI_demo
//
//  Created by vhall on 2019/11/19.
//  Copyright © 2019 vhall. All rights reserved.
//  工具类

#import <Foundation/Foundation.h>

@interface VUITool : NSObject
/// 角色修改
extern NSString * VH_MB_HOST;
extern NSString * VH_MB_GUEST;
extern NSString * VH_MB_ASSIST;

/// UITextField/UItextView输入计数
/// - Parameters:
///   - inputBox: 对象
///   - countLab: 计数文本
///   - maxTextLength: 最大长度
+ (void)caculateInputBox:(id)inputBox desplayCountLab:(UILabel *)countLab maxTextLength:(NSInteger)maxTextLength;

/// 字符串空的话赋值@""
/// - Parameter string: 字符串
+ (NSString *)safeString:(NSString *)string;

/// 获取当前view的控制器
/// - Parameter view: view
+ (UIViewController *)viewControllerWithView:(UIView *)view;

/// 秒转时分秒
/// - Parameter totalSeconds: 秒
/// - Parameter isAuto: 是否自动计算宽度
+ (NSString *)timeFormatted:(NSInteger)totalSeconds isAuto:(BOOL)isAuto;

/// 指定某个/多个角圆角
/// - Parameters:
///   - view: view
///   - corners: 圆角角度
///   - size: 圆角值
+ (void)clipView:(UIView *)view corner:(UIRectCorner)corners anSize:(CGSize)size;

/// 获取当前屏幕控制器
+ (UIViewController *)getCurrentScreenViewController;

/// 判断字符串是否为空
/// - Parameter aStr: 字符串
+ (BOOL)isBlankString:(NSString *)aStr;

/// 计算一段文字高度或宽度
/// - Parameters:
///   - text: 文本
///   - width: 想获取宽 就传0
///   - height: 想获取高 就传0
///   - font: 字体
+ (CGFloat)getWidthWithText:(NSString *)text width:(CGFloat)width height:(CGFloat)height font:(UIFont *)font;

/// 裁剪字符串 截取从0位到第n为（第n位不算在内）
/// - Parameters:
///   - index: 裁剪长度
///   - text: 内容
///   - isReplenish: 是否补充...
+ (NSString *)substringToIndex:(NSInteger)index text:(NSString *)text isReplenish:(BOOL)isReplenish;

/// 裁剪字符串 保留剩下位数
/// - Parameters:
///   - index: 裁剪长度
///   - text: 内容
///   - isReplenish: 是否补充...
+ (NSString *)substringFromIndex:(NSInteger)index text:(NSString *)text isReplenish:(BOOL)isReplenish;

/// 获取window
+ (UIWindow *)mainWindow;

/// 如果找到了就返回找到的view，没找到的话，就返回nil
/// - Parameters:
///   - className: 类名
///   - inView: 所在view
+ (UIView *)getSubViewWithClassName:(NSString *)className inView:(UIView *)inView;

/// 给一个时间,计算距离当前时间差多少秒
/// - Parameter time: 时间格式为 yyyy-MM-dd HH:mm:ss
+ (NSInteger)getTimeDifferenceWithTime:(NSString *)time;

/// 获取设备权限
/// - Parameter completionBlock: 权限状态回调
+ (void)getMediaAccess:(void(^_Nullable)(BOOL videoAccess,BOOL audioAcess))completionBlock;

@end
