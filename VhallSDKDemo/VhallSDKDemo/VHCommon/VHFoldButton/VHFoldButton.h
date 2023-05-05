//
//  VHFoldButton.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/16.
//

#import <UIKit/UIKit.h>

@class VHFoldButtonItem;

/// 选中的回调 Block
/// @param obj 选中的元素
/// @param index 选中的索引
typedef void(^VHFoldButtonDidSelectedHandler)(VHFoldButtonItem *obj, NSInteger index);

@interface VHFoldButton : UIView

/// 展开视图的高度
@property (nonatomic, assign) CGFloat contentHeight;

/// 每个选择项的高度
@property (nonatomic, assign) CGFloat itemHeight;

/// 内容文本的属性
@property (nonatomic, strong)NSDictionary<NSAttributedStringKey,id> *textAttribute;

/// 配置需要展示的数据源
/// @param datas 数据源
- (void)configDatas:(NSArray *)datas;

/// 选中方法回调
/// @param handler 回调 Block
- (void)didSelectedWithHandler:(VHFoldButtonDidSelectedHandler) handler ;

@end

#pragma mark - VHFoldButtonCell
@interface VHFoldButtonCell : UITableViewCell
@property (nonatomic, strong) VHFoldButtonItem * item;
@property (nonatomic, strong) UIImageView * icon;
+ (VHFoldButtonCell *)createCellWithTableView:(UITableView *)tableView;
@end

#pragma mark - VHFoldButtonItem
@interface VHFoldButtonItem : NSObject
@property (nonatomic, copy) NSString * title;
@end
