//
//  AppDelegate.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/6.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

/// window
@property (strong, nonatomic) UIWindow *window;

/// 是否是横屏
@property (nonatomic, assign, getter = isLaunchScreen) BOOL launchScreen;

@end
