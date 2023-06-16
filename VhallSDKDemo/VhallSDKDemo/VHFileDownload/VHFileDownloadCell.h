//
//  VHFileDownloadCell.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/6/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VHFileDownloadCell : UITableViewCell

/// 文件数据
@property (nonatomic, strong) VHFileDownloadListModel *fileDownloadListModel;
/// index
@property (nonatomic, assign) NSInteger indexRow;

+ (VHFileDownloadCell *)createCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
