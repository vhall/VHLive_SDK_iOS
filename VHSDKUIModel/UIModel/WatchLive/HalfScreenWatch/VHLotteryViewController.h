//
//  VHLotteryViewController.h
//  UIModel
//
//  Created by jinbang.li on 2022/6/6.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VHLiveSDK/VHallApi.h>
@protocol VHLotteryOpenDelegate <NSObject>

- (void)lotteryOpen:(VHallEndLotteryModel *)endLotteryModel;

@end
NS_ASSUME_NONNULL_BEGIN

@interface VHLotteryViewController : UIViewController
@property (nonatomic) NSArray <VHLotteryModel *>*lotteryList;
@property(nonatomic,weak)id<VHLotteryOpenDelegate> delegate;
@end

NS_ASSUME_NONNULL_END

