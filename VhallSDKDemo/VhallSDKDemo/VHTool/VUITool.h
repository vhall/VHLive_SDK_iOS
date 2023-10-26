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
extern NSString *VH_MB_HOST;
extern NSString *VH_MB_GUEST;
extern NSString *VH_MB_ASSIST;

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
/// - Parameter isAuto: 不够一小时是否省略
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

/// 字母、数字、中文正则判断（不包括空格）
/// - Parameter str: 字符串
+ (BOOL)isInputRuleNotBlank:(NSString *)str;

/// 字母、数字、中文正则判断（包括空格）（在系统输入法中文输入时会出现拼音之间有空格，需要忽略，当按return键时会自动用字母替换，按空格输入响应汉字）
/// - Parameter str: 字符串
+ (BOOL)isInputRuleAndBlank:(NSString *)str;

/// 获得 kMaxLength长度的字符
/// - Parameter str: 字符串
/// - Parameter strLenth: 字符串长度
+ (NSString *)getSubStr:(NSString *)str strLenth:(int)strLenth;

/// 处理表情为空串
/// - Parameter text: 字符串
+ (NSString *)disable_emoji:(NSString *)str;

/// 发送自动化测试消息
/// - Parameter key: 应用通知消息
/// - Parameter userInfo: 其它信息
+ (void)sendTestsNotificationCenterWithKey:(NSString *)key otherInfo:(NSDictionary *)otherInfo;

/// 当前是否为全屏状态
+ (BOOL)isFullScreen;

/// 格式化微吼价格样式¥xxx.xx
/// - Parameter string: 价格样式¥xxx.xx
+ (NSMutableAttributedString *)vhPriceToString:(NSString *)string;

/// 将传入的URL字符串进行解码
/// - Parameter urlString: 字符串
+ (NSString *)vh_URLDecodedString:(NSString *)urlString;

/// 将传入的URL字符串进行编码
/// - Parameter urlString: 字符串
+ (NSString *)vh_URLEncodedString:(NSString *)urlString;

/// 字典转json字符串方法
/// - Parameter dict: 字典
+ (NSString *)jsonStringWithObject:(id)dict;

/// 当前时间戳
+ (NSString *)nowTimeInterval;

@end
