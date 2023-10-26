//
//  VhallSharedDur.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/10/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "zlib.h"

@interface VhallSharedDur : NSObject

//VHSee是否开启
@property (nonatomic,assign) BOOL vhBool;

@property (nonatomic, copy) NSString *session_id;

+ (instancetype)shareInstance;

//计算页面停留时长
- (CGFloat) durInterval;

//获取View路径
- (NSString *)getViewToPath:(id)view;

//获取view所在的VC
- (UIViewController *)viewControllerToView:(UIView *)view;

//获取当前的控制器
- (UIViewController *)vhGetCurrentVC;

//截图
- (NSData *)pixData;

/// 上传数据
/// - Parameters:
///   - data: 图片data
///   - parameters: 附带参数
- (void)postUserIconImageData:(NSData *)data parameters:(NSMutableDictionary *)parameters;

@end

