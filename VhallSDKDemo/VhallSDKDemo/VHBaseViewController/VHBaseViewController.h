//
//  VHBaseViewController.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/6.
//

#import <UIKit/UIKit.h>

@interface VHBaseViewController : UIViewController
///是否隐藏导航栏 默认 NO 不隐藏
@property (nonatomic, assign) BOOL vh_NavIsHidden;
/// 点击返回
- (void)clickLeftBarItem;
/// 前台
- (void)appWillEnterForeground;
/// 后台
- (void)appDidEnterBackground;

@end
