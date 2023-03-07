//
//  VHSurveyWebView.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/16.
//

#import <UIKit/UIKit.h>

@interface VHSurveyWebView : UIView

/// 问卷URL
/// - Parameter watchUrl: url
- (void)showSurveyUrl:(NSURL *)surveyUrl;

@end
