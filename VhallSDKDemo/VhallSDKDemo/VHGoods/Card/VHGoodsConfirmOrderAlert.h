//
//  VHGoodsConfirmOrderAlert.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/8/11.
//

#import "VHInavAlertView.h"

/// 三方平台支付
typedef void(^SkipWXOrALIPayBlock)(NSURL *url,NSString *referer,NSString *order_no);

@interface VHGoodsConfirmOrderAlert : VHInavAlertView

/// 商品详情
@property (nonatomic, strong) VHGoodsListItem *item;

/// 立即购买
@property (nonatomic, copy) SkipWXOrALIPayBlock skipWXOrALIPayBlock;

/// 显示确认订单弹窗
/// - Parameter item: 数据详情
/// - Parameter settingItem: 设置详情
- (void)showGoodsOrder:(VHGoodsListItem *)item settingItem:(VHGoodsSettingItem *)settingItem webinarInfo:(VHWebinarInfo *)webinarInfo;

/// 隐藏
- (void)dismiss;

@end
