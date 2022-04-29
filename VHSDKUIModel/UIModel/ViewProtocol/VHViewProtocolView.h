//
//  VHViewProtocolView.h
//  UIModel
//
//  Created by jinbang.li on 2022/4/12.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VHViewProtocolView : UIView
/*
 title:协议标题
 content:协议内容
 rule:1-同意后进入(知道了)0-强制阅读(阅读+退出)
 statement_status:--0---关闭协议栏，不显示statement_content，1---显示协议栏，显示statement_content
 statement_content
 **/
+ (void)showViewProtocolView:(NSString *)title content:(NSString *)content statement_status:(NSInteger)status rule:(NSInteger)rule  statement_content:(NSString *)statement_content info:(NSArray *)infoArr click:(void(^)(NSInteger index))operation;
@end

NS_ASSUME_NONNULL_END
