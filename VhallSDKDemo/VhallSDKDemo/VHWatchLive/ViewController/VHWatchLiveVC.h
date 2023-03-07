//
//  VHWatchVideoVC.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/13.
//

#import "VHBaseViewController.h"

@interface VHWatchVideoVC : VHBaseViewController

/// 活动观看密码
@property (nonatomic, copy) NSString * kValue;
/// 活动详情
@property (nonatomic, strong) VHWebinarInfoData * webinarInfoData;

@end
