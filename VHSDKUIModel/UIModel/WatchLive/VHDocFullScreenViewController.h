//
//  VHDocFullScreenViewController.h
//  UIModel
//
//  Created by LiGuoliang on 2022/6/10.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VHDocFullScreenViewController : UIViewController
@property (nonatomic) void(^handleDismiss)(UIView *docView);
@property (nonatomic) UIInterfaceOrientation orientation;
@property (nonatomic) UIView *docView;
@end

NS_ASSUME_NONNULL_END
