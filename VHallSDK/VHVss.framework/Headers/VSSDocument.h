//
//  VSSDocument.h
//  VSSDemo
//
//  Created by vhall on 2019/7/1.
//  Copyright © 2019 vhall. All rights reserved.
//

#import <VHDoc/VHDocument.h>

NS_ASSUME_NONNULL_BEGIN

@interface VSSDocumentInfoModel : NSObject

@property (nonatomic, copy) NSString *account_id;
@property (nonatomic, copy) NSString *app_id;       //微吼云appId
@property (nonatomic, copy) NSString *created_at;   //创建时间
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, copy) NSString *deleted;      //是否已删除 0未删除，1已删除
@property (nonatomic, copy) NSString *document_id;  //文档id
@property (nonatomic, copy) NSString *ext;          //文件类型，如：docx
@property (nonatomic, copy) NSString *file_name;    //文件名
@property (nonatomic, copy) NSString *doc_hash;     //文件哈希值
@property (nonatomic, copy) NSString *ID;           //文档记录ID，删除文档时会使用
@property (nonatomic, copy) NSString *page;          //文档总页数
@property (nonatomic, copy) NSString *room_id;
@property (nonatomic, copy) NSString *status;           //动态装换状态
@property (nonatomic, copy) NSString *converted_page; //动态转换成功页数
@property (nonatomic, copy) NSString *status_jpeg;       //静态装换状态
@property (nonatomic, copy) NSString *converted_page_jpeg;   //静态转成功页数
@property (nonatomic, copy) NSString *converted_page_swf;       //swf转换成功页数
@property (nonatomic, copy) NSString *status_swf;        //swf转换状态
@property (nonatomic, copy) NSString *bu;           //平台标识
@property (nonatomic, copy) NSString *trans_num;         //转换次数
@property (nonatomic, copy) NSString *trans_status;       //转换状态
@property (nonatomic, copy) NSString *uploader_id;  //上传者id
@property (nonatomic, assign) CGFloat size;      //文件大小 kb
@property (nonatomic, copy) NSString *storage_provider;    //存储提供商
@property (nonatomic, assign) CGFloat width;        //文档宽度
@property (nonatomic, assign) CGFloat height;        //文档高度


@property (nonatomic, assign)BOOL selected;


@end

@interface VSSDocument : VHDocument

//开启/关闭文档 1开启，0关闭
- (void)setDocSwichIsOn:(BOOL)on
                success:(void (^)(NSDictionary *response))success
                failure:(void (^)(NSError *error))failure;

//删除文档
+ (void)docDeleteWithJoinId:(NSString *)joinId
                      docId:(NSString *)docId
                    success:(void (^)(NSDictionary *response))success
                    failure:(void (^)(NSError *error))failure;


/// 获取用户的文档列表
/// @param page 当前页码，从1开始
/// @param pageSize 指定每页多少条，传0默认20条
/// @param keyWords 搜索关键字，没有传空
/// @param success 成功回调 dataArr：文档模型列表 haveNextPage：是否可以加载下一页
/// @param failure 失败回调
+ (void)getDocListWithAccountId:(NSString *)accountId page:(NSInteger)page pageSize:(NSInteger)pageSize keyWords:(nullable NSString *)keyWords success:(void (^)(NSMutableArray <VSSDocumentInfoModel *> *dataArr , BOOL haveNextPage))success failure:(void (^)(NSError *error))failure;

/// 获取房间的文档列表
/// @param page 当前页码，从1开始
/// @param pageSize 指定每页多少条，传0默认20条
/// @param keyWords 搜索关键字，没有传空
/// @param success 成功回调 dataArr：文档模型列表 haveNextPage：是否可以加载下一页
/// @param failure 失败回调
+ (void)getDocListWithRoomId:(NSString *)roomId page:(NSInteger)page pageSize:(NSInteger)pageSize keyWords:(nullable NSString *)keyWords success:(void (^)(NSMutableArray <VSSDocumentInfoModel *> *dataArr , BOOL haveNextPage))success failure:(void (^)(NSError *error))failure;

/// 设置文档/白板操作权限
/// @param account_id 被设置人id
/// @param success 成功回调
/// @param failure 失败回调
+ (void)setDocPermissionWithTargetAccountId:(NSString *)account_id success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError *error))failure;
@end

NS_ASSUME_NONNULL_END
