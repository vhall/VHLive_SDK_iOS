//
//  VHFashionStyleGiftPushView.h
//  UIModel
//
//  Created by 郭超 on 2022/8/3.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface VHFashionStyleGiftPushView : UIView

/// 礼物动画
- (void)showGiftPushForNickName:(NSString *)nickName giftName:(NSString *)giftName giftImg:(NSString *)giftImg;

/// 隐藏
- (void)dismiss;

@end
