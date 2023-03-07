//
//  VHChatCustomCell.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/23.
//

#import <UIKit/UIKit.h>

@interface VHChatCustomModel : NSObject

/// 昵称
@property(nonatomic, copy) NSString * nickName;
/// 身份
@property (nonatomic, assign) NSInteger roleName;
/// 详情
@property(nonatomic, copy) NSString * content;
/// 附加信息
@property (nonatomic, strong) NSMutableDictionary * info;

@end

typedef void(^ClickSurveyToModel)(VHChatCustomModel * chatCustomModel);

@interface VHChatCustomCell : UITableViewCell

@property (nonatomic, strong) VHChatCustomModel * chatCustomModel;

@property (nonatomic, copy) ClickSurveyToModel clickSurveyToModel;

/// 初始化
+ (VHChatCustomCell *)createCellWithTableView:(UITableView *)tableView;

@end

