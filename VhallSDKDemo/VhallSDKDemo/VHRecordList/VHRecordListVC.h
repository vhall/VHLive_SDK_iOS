//
//  VHRecordListVC.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/5/26.
//

#import "VHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SelectPlaybackVideo)(NSString * record_id);

@protocol VHRecordListDelegate <NSObject>

/// 选择指定回放视频
- (void)selectPlaybackVideoWithRecordId:(NSString *)recordId;

@end

@interface VHRecordListVC : VHBaseViewController <JXCategoryListContentViewDelegate>

/// 代理
@property (nonatomic, weak) id <VHRecordListDelegate> delegate;

/// 活动id
@property (nonatomic, copy) NSString *webinar_id;

/// 回放id
@property (nonatomic, copy) NSString *record_id;


@end

NS_ASSUME_NONNULL_END
