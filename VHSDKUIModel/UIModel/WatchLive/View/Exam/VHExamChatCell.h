//
//  VHExamChatCell.h
//  UIModel
//
//  Created by 郭超 on 2022/12/12.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VHExamChatModel : NSObject
@property (nonatomic, strong) NSURL * examWebUrl;
@property (nonatomic, copy) NSString * stuatus;

@end

typedef void(^ClickLookBtnWithExamDetailWebView)(NSURL * examWebUrl);

@interface VHExamChatCell : UITableViewCell

// 懒加载
+ (VHExamChatCell *)createCellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) VHExamChatModel * model; ///<快问快答模型

/// 点击查看详情
@property (nonatomic, copy) ClickLookBtnWithExamDetailWebView clickLookBtnWithExamDetailWebView;

@end
