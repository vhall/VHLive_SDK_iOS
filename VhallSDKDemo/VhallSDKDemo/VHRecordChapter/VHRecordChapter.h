//
//  VHRecordChapter.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/3/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VHRecordChapterListCell : UITableViewCell

/// 章节打点数据
@property (nonatomic, strong) VHChaptersItem * chaptersItem;
/// index
@property (nonatomic, assign) NSInteger indexRow;

+ (VHRecordChapterListCell *)createCellWithTableView:(UITableView *)tableView;

@end

@protocol VHRecordChapterDelegate <NSObject>

/// 点击章节
/// - Parameter createAt: 章节时间
- (void)clickChapterItemCreateAt:(CGFloat)createAt;

@end

@interface VHRecordChapter : UIView<JXCategoryListContentViewDelegate>

@property (nonatomic, weak) id <VHRecordChapterDelegate> delegate;

/// 初始化
/// - Parameter frame: frame
/// - Parameter webinarInfoData: 活动详情
- (instancetype)initRCWithFrame:(CGRect)frame webinarInfoData:(VHWebinarInfoData *)webinarInfoData;


@end

NS_ASSUME_NONNULL_END
