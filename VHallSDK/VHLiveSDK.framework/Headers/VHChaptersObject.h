//
//  VHChaptersObject.h
//  VHLiveSDK
//
//  Created by 郭超 on 2022/10/27.
//  Copyright © 2022 vhall. All rights reserved.
//

#import "VHallBasePlugin.h"
#import "VHallRawBaseModel.h"

// 章节打点数据类
@interface VHChaptersItem : VHallRawBaseModel
@property (nonatomic, copy) NSString *title;                                ///<标题
@property (nonatomic, assign) CGFloat created_at;                           ///<时间
@property (nonatomic, copy) NSString *document_id;                          ///<文档id
@property (nonatomic, copy) NSString *page;                                 ///<页数
@property (nonatomic, copy) NSString *step;                                 ///<步数
@property (nonatomic, copy) NSArray *subsection;                            ///<
@property (nonatomic, copy) NSString *vh_hash;                              ///<
@end

@interface VHChaptersObject : VHallBasePlugin

/// 章节打点列表
/// @param record_id 房间id
/// @param complete chaptersList:章节打点数据 error:错误详情
+ (void)getRecordChaptersList:(NSString *)record_id
                     complete:(void (^)(NSArray <VHChaptersItem *> *chaptersList, NSError *error))complete;

@end
