//
//  VHGoodsCouponAlert.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/9/6.
//

#import "VHInavAlertView.h"

typedef void(^SelectBestCoupon)(VHGoodsCouponInfoItem * bestCoupon);

@interface VHGoodsCouponAlert : VHInavAlertView

/// 选取最优优惠券
@property (nonatomic, copy) SelectBestCoupon selectBestCoupon;

/// 显示我的优惠券弹窗
/// - Parameters:
///   - webinarInfo: 活动详情
///   - goodItem: 商品详情
///   - goodNum: 商品数量
- (void)showGoodsCouponWithWebinarInfo:(VHWebinarInfo *)webinarInfo goodItem:(VHGoodsListItem *)goodItem goodNum:(NSString *)goodNum;

/// 隐藏
- (void)dismiss;

/// 可用优惠券列表
/// - Parameters:
///   - webinarInfo: 活动详情
///   - goodItem: 商品详情
///   - goodNum: 商品数量
- (void)couponAvailableListWithWebinarInfo:(VHWebinarInfo *)webinarInfo goodItem:(VHGoodsListItem *)goodItem goodNum:(NSString *)goodNum;

@end
