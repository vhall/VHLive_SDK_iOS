//
//  VHGoodsCardAlert.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/8/9.
//

#import <UIKit/UIKit.h>

/// 查看详情
typedef void(^ClickCheckDetailBlock)(VHGoodsListItem *item);

@interface VHGoodsCardAlert : UIView

/// 详情
@property (nonatomic, strong) VHGoodsListItem *item;
/// 是否显示中
@property (nonatomic, assign) BOOL isShow;
/// 查看详情
@property (nonatomic, copy) ClickCheckDetailBlock clickCheckDetailBlock;

/// 显示
- (void)showGoodsCardItem:(VHGoodsListItem *)item;
/// 隐藏
- (void)hide;

@end

