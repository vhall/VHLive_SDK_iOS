//
//  VHWatchVC.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/13.
//

#import "VHBaseViewController.h"

@interface VHWatchVC : VHBaseViewController

/// 活动id
@property (nonatomic, copy) NSString * webinar_id;

/// 活动状态 1-直播中，2-预约，3-结束，4-点播，5-回放
@property (nonatomic) VHMovieActiveState type;

@end
