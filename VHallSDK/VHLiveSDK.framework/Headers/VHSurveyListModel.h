//
//  VHSurveyListModel.h
//  VHallSDK
//
//  Created by 郭超 on 2022/8/31.
//  Copyright © 2022 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>
@class VHSurveyModel;

NS_ASSUME_NONNULL_BEGIN

// 问卷列表
@interface VHSurveyListModel : NSObject
@property (nonatomic, strong) NSArray <VHSurveyModel *> *listModel;
+ (VHSurveyListModel *)fetchSurveyListModel:(NSArray *)surveyList surveyURL:(NSString *)surveyUrl;
@end

//问卷详情
@interface VHSurveyModel : NSObject
@property (nonatomic, strong, readonly) NSURL *openLink;        ///<问卷的URL
@property (nonatomic, copy) NSString *title;                    ///<问卷标题
@property (nonatomic, copy) NSString *question_id;              ///<问卷id
@property (nonatomic, copy) NSString *question_no;              ///<问卷编号
@property (nonatomic, copy) NSString *alias;                    ///<问卷别名
@property (nonatomic, copy) NSString *created_at;               ///<问卷创建时间
@property (nonatomic, copy) NSString *updated_at;               ///<问卷更新时间
@property (nonatomic, assign) BOOL is_answered;                 ///<问卷是否参与
@end

NS_ASSUME_NONNULL_END
