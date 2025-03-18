//
//  VHSSCommon.h
//  VHVss
//
//  Created by xiongchao on 2020/11/24.
//  Copyright © 2020 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VHSSCommon : NSObject


/// 上传文件
/// @param path 上传 主目录/子目录
/// @param imageBase64 上传的Base64
/// @param type 上传类型(image,video,app,exe,doc,exel,audio,csv)
/// @param method 图片传base64，默认不传是file类型
+ (void)uploadFileWithPath:(NSString *)path imageBase64:(NSString *)imageBase64 type:(NSString *)type method:(NSString *)method sucess:(void (^)(NSString *file_url, NSString *domain_url))sucessBlock failure:(void (^)(NSError *error))failureBlock;


/// 请求化蝶接口是否回滚 http://yapi.vhall.domain/project/102/interface/api/28443
/// @param complete 完成回调
+ (void)requestRollBackComplete:(void (^)(NSDictionary *data, NSError *error))complete;

/// 强制升级
/// @param complete 完成回调
+ (void)requestVersionUpgradeComplete:(void (^)(NSDictionary *data, NSError *error))complete;

/// 重定向下载地址
/// @param complete 完成回调
+ (void)requestDownloadLinkComplete:(void (^)(NSDictionary *data, NSError *error))complete;

/// 微信授权场景提交手机号
/// @param complete 完成回调
+ (void)requestNoticeWechatSubmit:(NSString *)webinar_id phone:(NSString *)phone visitor_id:(NSString *)visitor_id code:(NSString *)code complete:(void (^)(NSDictionary *data, NSError *error))complete;

@end

NS_ASSUME_NONNULL_END
