//
//  VHQuestionnaireController.h
//  UIModel
//
//  Created by jinbang.li on 2022/5/14.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VHLiveSDK/VHallApi.h>
NS_ASSUME_NONNULL_BEGIN

@interface VHQuestionnaireController : UIViewController
@property (nonatomic) NSArray <VHSurveyModel *>*surveyList;
@end

NS_ASSUME_NONNULL_END
