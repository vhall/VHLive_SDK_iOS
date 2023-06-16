//
//  VHFileDownloadVC.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/6/9.
//

#import "VHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol VHFileDownloadDelegate <NSObject>

/// 更新文件下载列表
- (void)uploadFileDownLoadWithModel:(VHFileDownLoadUploadModel *)model;

@end

@interface VHFileDownloadVC : VHBaseViewController <JXCategoryListContentViewDelegate>

/// 代理对象
@property (nonatomic, weak) id <VHFileDownloadDelegate> delegate;

/// 获取文件列表
/// - Parameters:
///   - webinar_id: 活动id
///   - file_download_menu_id: 文件下载id
- (void)getFileDownloadListWithWebinarId:(NSString *)webinar_id file_download_menu_id:(NSString *)file_download_menu_id;

@end

NS_ASSUME_NONNULL_END
