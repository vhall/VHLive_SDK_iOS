//
//  VHBeautyAlertView.h
//  UIModel
//
//  Created by jinbang.li on 2022/3/4.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VHBeautyAlertView : UIView
+ (void)showBeatyAlertView:(AlertViewType)alertType alertTip:(NSString *)tip clickCall:(void(^)(NSInteger index))operation;
@end

NS_ASSUME_NONNULL_END
