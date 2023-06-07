//
//  VHIntroView.h
//  VHLiveSDK
//
//  Created by 郭超 on 2022/12/16.
//  Copyright © 2022 vhall. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VHIntroView : UIView<JXCategoryListContentViewDelegate>

/// 活动详情
@property (nonatomic, strong) VHWebinarInfoData *webinarInfoData;

@end

NS_ASSUME_NONNULL_END
