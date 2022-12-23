//
//  VHExamList.h
//  UIModel
//
//  Created by 郭超 on 2022/11/25.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VHExamListCell : UITableViewCell

// 懒加载
+ (VHExamListCell *)createCellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) VHExamGetPushedPaperListModel * examGetPushedPaperListModel; ///<快问快答模型

@property (nonatomic, strong) UIView  * bgView;     ///<背景
@property (nonatomic, strong) UILabel * titleLab;   ///<标题
@property (nonatomic, strong) UILabel * contentLab; ///<时间
@property (nonatomic, strong) UILabel * statusLab;  ///<状态
@property (nonatomic, strong) UILabel * rightRateLab; ///<正确率
@property (nonatomic, strong) UILabel * totalScoreLab;///<分数

@end

typedef void(^ClickExamDetailWebView)(NSURL * watchUrl);

@interface VHExamList : UIView

/// 快问快答类
@property (nonatomic, strong) VHExamObject * examObject;
/// 点击试卷
@property (nonatomic, copy) ClickExamDetailWebView clickExamDetailWebView;
/// 快问快答列表
- (void)examGetPushedPaperListWithWebinarInfoData:(VHWebinarInfoData *)webinarInfoData;
/// 刷新列表数据
- (void)requestExamList;

@end
