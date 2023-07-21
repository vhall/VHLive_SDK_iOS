//
//  VHPushScreenCardList.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/7/3.
//

#import <UIKit/UIKit.h>

@interface VHPushScreenCardListCell : UITableViewCell

@property (nonatomic, strong) UIView *bgView;       ///<背景
@property (nonatomic, strong) UILabel *timeLab;     ///<时间
@property (nonatomic, strong) UILabel *titleLab;    ///<标题

@property (nonatomic, strong) VHPushScreenCardItem *model;

+ (VHPushScreenCardListCell *)createCellWithTableView:(UITableView *)tableView;

@end

@protocol VHPushScreenCardListDelegate <NSObject>

/// 开始推屏卡片
- (void)pushScreenCardModel:(VHPushScreenCardItem *)model;

@end

@interface VHPushScreenCardList : UIView

@property (nonatomic, weak) id <VHPushScreenCardListDelegate> delegate; ///<代理

/// 初始化
/// - Parameters:
///   - frame: frame
///   - object: 播放器类
///   - webinar_id: 活动id
///   - switch_id: 场次id
- (instancetype)initWithFrame:(CGRect)frame object:(NSObject *)object;

/// 推屏卡片列表
/// - Parameters:
///   - webinar_id: 活动id
///   - switch_id: 场次id
///   - isShow: 是否展示
- (void)loadDataWebinarId:(NSString *)webinar_id switch_id:(NSString *)switch_id isShow:(BOOL)isShow;

/// 显示弹窗
/// - Parameters:
///   - model: 推屏卡片数据
- (void)showPushScreenCard:(VHPushScreenCardItem *)model;

@end
