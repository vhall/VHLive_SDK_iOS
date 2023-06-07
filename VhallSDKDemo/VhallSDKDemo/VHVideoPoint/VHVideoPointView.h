//
//  VHVideoPointView.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/3/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VHVideoPointViewListCell : UITableViewCell

/// 视频打点数据
@property (nonatomic, strong) VHVidoePointModel *vidoePointModel;
/// index
@property (nonatomic, assign) NSInteger indexRow;


+ (VHVideoPointViewListCell *)createCellWithTableView:(UITableView *)tableView;

@end

@protocol VHVideoPointViewDelegate <NSObject>

/// 点击打点
/// - Parameter time: 打点时间
- (void)clickVideoPointTime:(NSInteger)time;

@end

@interface VHVideoPointView : UIView<JXCategoryListContentViewDelegate>

@property (nonatomic, weak) id <VHVideoPointViewDelegate> delegate;

/// 初始化
/// - Parameter frame: frame
/// - Parameter pointArr: 打点互数据
- (instancetype)initVPWithFrame:(CGRect)frame videoPointArr:(NSArray <VHVidoePointModel *> *)pointArr;

@end


NS_ASSUME_NONNULL_END
