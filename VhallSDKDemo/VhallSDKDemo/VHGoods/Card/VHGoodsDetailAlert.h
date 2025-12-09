//
//  VHGoodsDetailAlert.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/8/10.
//

#import "VHInavAlertView.h"

typedef void(^ClickPayBtnBlock)(VHGoodsListItem *item);

@interface VHGoodsDetailAlert : VHInavAlertView

/// 商品详情
@property (nonatomic, strong) VHGoodsListItem *item;


@property (nonatomic, copy) ClickPayBtnBlock clickPayBtnBlock;

/// 显示详情弹窗
/// - Parameter item: 数据详情
- (void)showGoodsDetail:(VHGoodsListItem *)item;

/// 隐藏
- (void)dismiss;

@end

