//
//  VHSurveyListView.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/16.
//

#import <UIKit/UIKit.h>

@interface VHSurveyListCell : UITableViewCell

@property (nonatomic, strong) UIView * bgView;      ///<背景
@property (nonatomic, strong) UILabel * timeLab;    ///<时间
@property (nonatomic, strong) UILabel * titleLab;   ///<标题
@property (nonatomic, strong) UILabel * checkLab;   ///<查看

@property (nonatomic, strong) VHSurveyModel * model;

+ (VHSurveyListCell *)createCellWithTableView:(UITableView *)tableView;

@end

@protocol VHSurveyListViewDelegate <NSObject>

/// 收到问卷
- (void)receivedSurveyWithURL:(NSURL *)surveyURL surveyId:(NSString *)surveyId;

@end

@interface VHSurveyListView : UIView

/// 代理对象
@property (nonatomic, weak) id <VHSurveyListViewDelegate> delegate;

/// 初始化
/// - Parameter obj: 播放器
- (instancetype)initSurveyWithObject:(NSObject *)obj webinarInfoData:(VHWebinarInfoData *)webinarInfoData;

/// 显示问卷
- (void)showSurveyIsShow:(BOOL)isShow;

/// 显示问卷
/// - Parameter surveyId: 问卷id
- (void)clickSurveyToId:(NSString *)surveyId surveyURL:(NSURL *)surveyURL;

@end

