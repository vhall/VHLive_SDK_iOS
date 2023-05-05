//
//  VHPublishVC.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/4/17.
//

#import "VHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface VHPublishVC : VHBaseViewController

/// 活动详情
@property (nonatomic, copy) NSString * webinar_id;
/// 是否为横屏 ，YES：横屏 NO：竖屏 ，默认NO
@property (nonatomic , assign) BOOL screenLandscape;

@end

NS_ASSUME_NONNULL_END
