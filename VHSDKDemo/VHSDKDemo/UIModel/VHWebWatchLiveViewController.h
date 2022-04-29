//
//  VHWebWatchLiveViewController.h
//  UIModel
//
//  Created by xiongchao on 2020/10/29.
//  Copyright © 2020 www.vhall.com. All rights reserved.
//
//web看直播
#import "VHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum: NSInteger{
    VHWebWatchType_Live = 0,//看直播
    VHWebWatchType_Protocol = 1,//看协议
}VHWebWatchType;
@interface VHWebWatchLiveViewController : VHBaseViewController

@property(nonatomic,copy)NSString * roomId; //活动id
@property (nonatomic) VHWebWatchType  webWathType;
//非看直播调新增看协议方法
- (void)webViewProtocol:(NSString *)link;
@end

NS_ASSUME_NONNULL_END
