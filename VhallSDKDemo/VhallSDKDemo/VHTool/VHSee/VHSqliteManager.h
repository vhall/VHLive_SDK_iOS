//
//  VHSqliteManager.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/10/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VHSqliteManager : NSObject

+ (instancetype)shareManager;

//创建并且打开数据库
- (BOOL)openDataBase;

//添加数据
- (BOOL)addVHSeeCoreDataDic:(NSMutableDictionary *)zgSeedic dicNumber:(NSInteger )dicNum;

//上传存储的数据
- (NSMutableArray *)uploadDataStoredNumData:(NSInteger)numData;

//删除数据
- (void)deleteVHSeeCoreDataSid:(NSString *)sid;

@end

NS_ASSUME_NONNULL_END
