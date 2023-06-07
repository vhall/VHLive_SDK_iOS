//
//  VHRecordListCell.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/5/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VHRecordListCell : UITableViewCell

/// 回放id
@property (nonatomic, copy) NSString *record_id;
/// 回放列表数据
@property (nonatomic, strong) VHRecordListModel *recordListModel;
/// index
@property (nonatomic, assign) NSInteger indexRow;

+ (VHRecordListCell *)createCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
