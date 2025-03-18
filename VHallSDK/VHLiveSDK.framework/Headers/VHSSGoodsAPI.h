//
//  VHGoodsAPI.h
//  SaaSShareApi
//
//  Created by 郭超 on 2023/8/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VHSSGoodsAPI : NSObject

/// 在线活动商品列表(发起/观看端)
/// - Parameters:
///   - status: 状态(1. 上架 2.上架及推送上架). 不传默认查询所有
///   - success: 成功
///   - fail: 失败
+ (void)goodsGetOnlineListWithStatus:(NSInteger)status success:(void (^)(NSDictionary *responseObject))success fail:(void (^)(NSError *error))fail;

/// 获取活动设置
/// - Parameters:
///   - webinar_id: 活动id
///   - success: 成功
///   - fail: 失败
+ (void)goodsWebinarSettingInfoWithWebinarId:(NSString *)webinar_id success:(void (^)(NSDictionary *responseObject))success fail:(void (^)(NSError *error))fail;

/// 查询商户号绑定列表
/// - Parameters:
///   - webinar_id: 活动id
///   - success: 成功
///   - fail: 失败
+ (void)goodsPartnerWithWithWebinarId:(NSString *)webinar_id success:(void (^)(NSDictionary *responseObject))success fail:(void (^)(NSError *error))fail;

/// 获取商品详情
/// - Parameters:
///   - goods_id: 商品id
///   - success: 成功
///   - fail: 失败
+ (void)goodsWebinarOnlineGoodsInfoWithGoodsId:(NSString *)goods_id success:(void (^)(NSDictionary *responseObject))success fail:(void (^)(NSError *error))fail;

/// 获取我的订单信息
/// - Parameters:
///   - order_no: 订单号
///   - success: 成功
///   - fail: 失败
+ (void)goodsOrderInfoWithOrderNo:(NSString *)order_no success:(void (^)(NSDictionary *responseObject))success fail:(void (^)(NSError *error))fail;

/// 可用优惠券列表
/// - Parameters:
///   - webinar_id: 活动id
///   - goods_id: 商品id
///   - goods_num: 商品数量
///   - success: 成功
///   - fail: 失败
+ (void)couponAvailableListWithWebinarId:(NSString *)webinar_id goods_id:(NSString *)goods_id goods_num:(NSString *)goods_num success:(void (^)(NSDictionary *responseObject))success fail:(void (^)(NSError *error))fail;

/// 不可用优惠券列表
/// - Parameters:
///   - webinar_id: 活动id
///   - goods_id: 商品id
///   - goods_num: 商品数量
///   - success: 成功
///   - fail: 失败
+ (void)couponUnavailableListWithWebinarId:(NSString *)webinar_id goods_id:(NSString *)goods_id goods_num:(NSString *)goods_num success:(void (^)(NSDictionary *responseObject))success fail:(void (^)(NSError *error))fail;
@end

NS_ASSUME_NONNULL_END
