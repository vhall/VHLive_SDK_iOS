//
//  VHFileDownloadObject.h
//  VHLiveSDK
//
//  Created by 郭超 on 2023/6/9.
//  Copyright © 2023 vhall. All rights reserved.
//

#import "VHallBasePlugin.h"
#import "VHallRawBaseModel.h"

@interface VHFileDownLoadUploadModel : VHallRawBaseModel

/// 是否显示 1显示 0不显示
@property (nonatomic , assign) NSInteger             status;
/// 活动id
@property (nonatomic , copy) NSString              * webinar_id;
/// 用户id
@property (nonatomic , copy) NSString              * user_id;
/// 类型
@property (nonatomic , copy) NSString              * type;
/// 菜单id
@property (nonatomic , copy) NSString              * menu_id;
/// 名称
@property (nonatomic , copy) NSString              * name;
/// url
@property (nonatomic , copy) NSString              * url;

@end

@interface VHFileDownloadListModel : VHallRawBaseModel

/// 文件名称
@property (nonatomic , copy) NSString              * file_name;
/// 文件大小
@property (nonatomic , copy) NSString              * file_size;
/// 文件类型
@property (nonatomic , copy) NSString              * file_ext;
/// 文件id
@property (nonatomic , copy) NSString              * file_id;
/// 文件类型
@property (nonatomic , copy) NSString              * file_type;
/// 文件简介
@property (nonatomic , copy) NSString              * file_desc;
/// 文件icon图片
@property (nonatomic , copy) NSString              * img_url;

@end

@protocol VHFileDownloadObjectDelegate <NSObject>

/// 更新文件下载列表
- (void)uploadFileDownLoadWithModel:(VHFileDownLoadUploadModel *)model;

@end

@interface VHFileDownloadObject : VHallBasePlugin

@property (nonatomic, weak) id <VHFileDownloadObjectDelegate> delegate; ///<代理

/// 获取控制台/观看端 自定义菜单绑定文件列表
/// - Parameters:
///   - webinarId: 活动id
///   - menu_id: 文件列表菜单id
///   - complete: 完成回调
- (void)getFileDownLoadWithWebinarId:(NSString *)webinarId menu_id:(NSString *)menu_id complete:(void (^)(NSDictionary * config, NSArray <VHFileDownloadListModel *> *file_download_list, NSError *error))complete;

/// 观看端 获取文件下载地址
/// - Parameters:
///   - webinarId: 活动id
///   - menu_id: 文件列表菜单id
///   - file_id: 文件id
///   - complete: 完成回调
- (void)getCheckDownloadWithWebinarId:(NSString *)webinarId menu_id:(NSString *)menu_id file_id:(NSString *)file_id  complete:(void (^)(NSString * download_url, NSError *error))complete;
@end
