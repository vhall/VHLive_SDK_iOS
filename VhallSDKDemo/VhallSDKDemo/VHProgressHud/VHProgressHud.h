//
//  ProgressHud.h
//  Recycle
//
//  Created by dengbin on 2018/11/22.
//  Copyright © 2018年 recycle. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VHProgressHud : NSObject

+ (void)showToast:(NSString *)text;
+ (void)showToast:(NSString *)text offsetY:(CGFloat)offsetY;
+ (void)showToast:(NSString *)text inView:(UIView *)view offsetY:(CGFloat)offsetY;


+ (MBProgressHUD *)showLoading:(NSString *)text;
+ (MBProgressHUD *)showLoading;
+ (void)hideLoading;

+ (MBProgressHUD *)showLoading:(NSString *)text inView:(UIView *)view;
+ (void)hideLoadingInView:(UIView *)view;

+ (MBProgressHUD *)showBackgroundFullLoading;

@end

NS_ASSUME_NONNULL_END
