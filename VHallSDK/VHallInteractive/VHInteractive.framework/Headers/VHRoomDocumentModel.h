//
//  VHRoomDocumentModel.h
//  VHallInteractive
//
//  Created by 郭超 on 2022/8/31.
//  Copyright © 2022 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 文档
@interface VHRoomDocumentModel : NSObject
@property (nonatomic, assign) NSInteger size;           ///<文件大小 字节数：size/(1024*1024.0)为M
@property (nonatomic, copy) NSString *created_at;       ///<创建时间
@property (nonatomic, copy) NSString *updated_at;       ///<修改时间
@property (nonatomic, copy) NSString *ext;              ///<文档类型扩展名
@property (nonatomic, copy) NSString *document_id;      ///<文档ID
@property (nonatomic, copy) NSString *file_name;        ///<文件名
@end

NS_ASSUME_NONNULL_END
