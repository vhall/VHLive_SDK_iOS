//
//  VHGoodsObject.h
//  VHLiveSDK
//
//  Created by 郭超 on 2023/8/9.
//  Copyright © 2023 vhall. All rights reserved.
//

#import <VHLiveSDK/VHallBasePlugin.h>
#import <VHLiveSDK/VHallRawBaseModel.h>

// 订单明细
@interface VHGoodsCouponInfoItem : VHallRawBaseModel
@property (nonatomic, copy)   NSString *coupon_id;                  ///<优惠券id
@property (nonatomic, copy)   NSString *coupon_name;                ///<优惠券名称
@property (nonatomic, copy)   NSString *validity_start_time;        ///<有效期开始时间
@property (nonatomic, copy)   NSString *validity_end_time;          ///<有效期结束时间
@property (nonatomic, copy)   NSString *use_desc;                   ///<使用说明
@property (nonatomic, copy)   NSString *goods_num;                  ///<商品数量
@property (nonatomic, copy)   NSString *business_uid;               ///<操作人id
@property (nonatomic, copy)   NSString *nick_name;                  ///<操作人昵称
@property (nonatomic, copy)   NSString *updated_at;                 ///<更新时间
@property (nonatomic, copy)   NSString *coupon_user_id;             ///<用户领取优惠券ID
@property (nonatomic, assign) CGFloat   threshold_amount;           ///<门槛金额
@property (nonatomic, assign) CGFloat   deduction_amount;           ///<减免金额
@property (nonatomic, assign) NSInteger coupon_type;                ///<优惠券类型 0-满减优惠 1-无门槛优惠
@property (nonatomic, assign) NSInteger validity_type;              ///<有效期类型 0-固定日期 1-固定天数
@property (nonatomic, assign) NSInteger validity_day;               ///<有效期天数
@property (nonatomic, assign) NSInteger applicable_product_type;    ///<适用商品类型 0-全部商品 1-指定商品可用 2-指定商品不可用
@property (nonatomic, assign) NSInteger unavailable_type;           ///<不可用原因 0-未达条件 1-已失效-2-已使用


/** 业务封装 */
@property (nonatomic, assign) BOOL isAvailable;                     ///<当前优惠券是否可用  YES:可用 NO:不可用
@property (nonatomic, assign) BOOL isBest;                          ///<是否最优,这个参数只在可用优惠券列表生效 YES:是 NO:不是
@property (nonatomic, assign) BOOL isShowUseDesc;                   ///<是否展开详情 YES:是 NO:不是
@end


// 订单明细
@interface VHGoodsOrderInfoItem : VHallRawBaseModel
@property (nonatomic, copy)   NSString *goods_id;           ///<商品ID
@property (nonatomic, copy)   NSString *cover_img;          ///<商品封面图片
@property (nonatomic, copy)   NSString *price;              ///<商品原价
@property (nonatomic, copy)   NSString *discount_price;     ///<商品优惠价
@property (nonatomic, copy)   NSString *info;               ///<商品描述
@property (nonatomic, copy)   NSString *name;               ///<商品名称
@property (nonatomic, assign) NSInteger quantity;           ///<商品数量
@end

//订单详情
@interface VHGoodsOrderInfo : VHallRawBaseModel
@property (nonatomic, copy)   NSString *order_no;           ///<订单号
@property (nonatomic, copy)   NSString *total_amount;       ///<订单总金额
@property (nonatomic, copy)   NSString *pay_amount;         ///<实付金额
@property (nonatomic, copy)   NSString *webinar_subject;    ///<活动名称
@property (nonatomic, copy)   NSString *created_at;         ///<下单时间
@property (nonatomic, copy)   NSString *username;           ///<用户姓名
@property (nonatomic, copy)   NSString *phone;              ///<用户手机号
@property (nonatomic, copy)   NSString *remark;             ///<用户留言
@property (nonatomic, copy)   NSString *order_status;       ///<订单状态
@property (nonatomic, copy)   NSString *pay_channel;        ///<支付渠道
@property (nonatomic, copy)   NSString *pay_time;           ///<支付时间
@property (nonatomic, copy)   NSString *service_code;       ///<支付方式
@property (nonatomic, copy)   NSString *trade_no;           ///<交易流水号
@property (nonatomic, assign) NSInteger webinar_id;         ///<活动ID
@property (nonatomic, assign) NSInteger buy_type;           ///<购买类型(1.平台购买 2.外链购买 3.自定义购买)
@property (nonatomic, copy)   NSArray<VHGoodsOrderInfoItem *> *order_items;///<订单明细
@end

// 创建订单模型
@interface VHGoodsCreateOtherItem : VHallRawBaseModel
@property (nonatomic, copy)   NSString *order_no;           ///<订单号
@property (nonatomic, copy)   NSString *order_status;       ///<订单状态
@property (nonatomic, copy)   NSString *order_url;          ///<支付url
@property (nonatomic, copy)   NSString *referer;            ///<referer
@end

// 支付结果
@interface VHGoodsPayStatusItem : VHallRawBaseModel
@property (nonatomic, copy)   NSString *order_no;           ///<订单号
@property (nonatomic, copy)   NSString *order_status;       ///<订单状态
@property (nonatomic, copy)   NSString *pay_time;           ///<支付时间
@property (nonatomic, copy)   NSString *trade_no;           ///<交易号
@end

// 商品设置参数
@interface VHGoodsSettingItem : VHallRawBaseModel
@property (nonatomic, copy)   NSString *webinar_id;         ///<活动id
@property (nonatomic, assign) NSInteger enable_username;    ///<开启姓名;0.否 1.是
@property (nonatomic, assign) NSInteger enable_phone;       ///<开启手机号;0.否 1.是
@property (nonatomic, assign) NSInteger enable_remark;      ///<开启留言;0.否 1.是
@property (nonatomic, assign) BOOL      enable_wx;          ///<开启微信;NO.否 YES.是
@property (nonatomic, assign) BOOL      enable_ali;         ///<开启支付宝;NO.否 YES.是

@end

// 商品图片list
@interface VHGoodsImageList_Item : VHallRawBaseModel
@property (nonatomic, copy)   NSString *img_url;            ///<图片地址
@property (nonatomic, assign) NSInteger is_cover;           ///<是否是封面图片(0.否 1.是)
@end

// 商品类
@interface VHGoodsListItem : VHallRawBaseModel

@property (nonatomic, copy)   NSString *goods_id;           ///<商品ID
@property (nonatomic, copy)   NSString *price;              ///<原价
@property (nonatomic, copy)   NSString *discount_price;     ///<优惠价
@property (nonatomic, copy)   NSString *info;               ///<商品描述
@property (nonatomic, copy)   NSString *cover_img;          ///<封面图片
@property (nonatomic, copy)   NSString *url;                ///<商品链接
@property (nonatomic, copy)   NSString *qr_code_url;        ///<二维码链接
@property (nonatomic, copy)   NSString *name;               ///<商品名称
@property (nonatomic, copy)   NSString *shop_url;           ///<店铺链接
@property (nonatomic, copy)   NSString *third_goods_id;     ///<三方商品ID
@property (nonatomic, assign) NSInteger buy_type;           ///<购买类型;1.平台购买 2.外链购买 3.自定义购买
@property (nonatomic, assign) NSInteger webinar_goods_id;   ///<活动商品ID
@property (nonatomic, assign) NSInteger order_num;          ///<排序
@property (nonatomic, assign) NSInteger status;             ///<上架状态;(0.下架  1.上架 2.推送上架)
@property (nonatomic, assign) NSInteger push_status;        ///<推送状态;(0.未推送 1. 推送中 2.已推送)
@property (nonatomic, assign) NSInteger shop_show;          ///<显示店铺
@property (nonatomic, copy)   NSArray<VHGoodsImageList_Item *> *images; ///<图片集合
@end

@interface VHGoodsPushMessageItem : VHallRawBaseModel

@property (nonatomic, copy)   NSString *cdn_url;            ///<cdn请求(获取列表数据)
@property (nonatomic, copy)   NSString *room_id;            ///<lss_id
@property (nonatomic, copy)   NSString *pusher_nickname;    ///<推送人昵称
@property (nonatomic, copy)   NSString *type;               ///<消息类型
@property (nonatomic, copy)   NSString *goods_name;         ///<商品名称
@property (nonatomic, assign) NSInteger role_name;          ///<用户身份
@property (nonatomic, assign) NSInteger push_status;        ///<推送状态 1推送 2.取消推送
@property (nonatomic, assign) NSInteger goods_id;           ///<商品id
@property (nonatomic, strong) VHGoodsListItem *goods_info;  ///<详情

@end

@protocol VHGoodsObjectDelegate <NSObject>

/// 商品推屏/取消推屏
/// - Parameter model: 消息数据详情
/// - Parameter push_status: 推送状态 1推送 2.取消推送
- (void)pushGoodsCardModel:(VHGoodsPushMessageItem *)model push_status:(NSInteger)push_status;

/// 商品添加
/// - Parameter goods_info: 商品详情
/// - Parameter cdn_url: 商品列表cdn请求地址
- (void)addGoodsInfo:(VHGoodsListItem *)goods_info cdn_url:(NSString *)cdn_url;

/// 商品删除
/// - Parameter del_goods_ids: 删除的商品,id_list
/// - Parameter cdn_url: 商品列表cdn请求地址
- (void)deleteGoods:(NSArray *)del_goods_ids cdn_url:(NSString *)cdn_url;

/// 商品更新
/// - Parameter goods_info: 商品详情
/// - Parameter cdn_url: 商品列表cdn请求地址
- (void)updateGoodsInfo:(VHGoodsListItem *)goods_info cdn_url:(NSString *)cdn_url;

/// 商品列表快速刷新
/// - Parameter cdn_url: 商品列表cdn请求地址
- (void)updateGoodsListWithCdnUrl:(NSString *)cdn_url;

/// 支付状态
/// - Parameter item: 订单信息
- (void)goodsOrderItem:(VHGoodsPayStatusItem *)item;

/// 跳转支付是否完成
/// - Parameter complete: YES : 成功  NO : 失败
- (void)paySkipIsComplete:(BOOL)complete;

/// 跳转支付失败详情
/// - Parameter error: 详情
- (void)errorDetail:(NSError *)error;

@end

@interface VHGoodsObject : VHallBasePlugin

@property (nonatomic, weak) id <VHGoodsObjectDelegate> delegate; ///<代理

/// 在线活动商品列表(发起/观看端)
/// - Parameters:
///   - status: 状态(1. 上架 2.上架及推送上架). 不传默认查询所有
///   - complete: 完成返回列表,失败错误详情
+ (void)goodsGetOnlineListWithStatus:(NSInteger)status complete:(void (^)(NSArray <VHGoodsListItem *> *list, NSError *error))complete;

/// 获取商品活动设置
/// - Parameters:
///   - webinar_id: 活动id
///   - complete: 完成返回详情,失败错误详情
+ (void)goodsWebinarSettingInfoWithWebinarId:(NSString *)webinar_id complete:(void (^)(VHGoodsSettingItem *settingItem, NSError *error))complete;

/// 获取商品详情
/// - Parameters:
///   - goods_id: 商品id
///   - complete: 完成返回详情,失败错误详情
+ (void)goodsWebinarOnlineGoodsInfoWithGoodsId:(NSString *)goods_id complete:(void (^)(VHGoodsListItem *goodsItem, NSError *error))complete;

/// 创建订单
/// - Parameters:
///   - switch_id: 场次ID
///   - third_user_id: 三方用户ID
///   - username: 姓名,不能超过30个字符
///   - phone: 手机号(是国内手机号)
///   - remark: 留言备注,不能超过50个字符
///   - goods_id: 商品ID
///   - quantity: 数量,不能超过100个
///   - pay_channel: 支付渠道(取值范围:WEIXIN,ALIPAY)
///   - channel_source: 渠道来源(main)
///   - pay_amount: 实付金额
///   - coupon_user_ids: 优惠券集合 coupon_user_id
///   - complete: 完成返回详情,失败错误详情
+ (void)goodsCreateOtherWithSwitchId:(NSString *)switch_id third_user_id:(NSString *)third_user_id username:(NSString *)username phone:(NSString *)phone remark:(NSString *)remark goods_id:(NSString *)goods_id quantity:(NSInteger)quantity pay_channel:(NSString *)pay_channel channel_source:(NSString *)channel_source pay_amount:(NSString *)pay_amount coupon_user_ids:(NSArray *)coupon_user_ids complete:(void (^)(VHGoodsCreateOtherItem *createOtherItem, NSError *error))complete;

/// 获取我的订单信息
/// - Parameters:
///   - order_no: 订单号
///   - complete: 完成返回详情,失败错误详情
+ (void)goodsOrderInfoWithOrderNo:(NSString *)order_no complete:(void (^)(VHGoodsOrderInfo *orderInfo, NSError *error))complete;

/// 三方平台支付
/// - Parameter url: 使用创建订单接口返回的ext地址,创建url对象进行跳转
/// - Parameter scheme: app配置的scheme,用来支付完成后返回应用,必须使用微信配置的顶级域名或子域名,例如顶级域名是vhall.com,则可以设置为demo.vhall.com
/// - Parameter referer: 用来配置微信支付授权的必传参数,最好使用微信配置的顶级域名
- (void)platformPaymentToPayWithOrderUrl:(NSURL *)url scheme:(NSString *)scheme referer:(NSString *)referer;

/// 可用优惠券列表
/// - Parameters:
///   - webinar_id: 活动id
///   - goods_id: 商品id
///   - goods_num: 商品数量
///   - complete: 完成返回详情,失败错误详情
+ (void)couponAvailableListWithWebinarId:(NSString *)webinar_id goods_id:(NSString *)goods_id goods_num:(NSString *)goods_num complete:(void (^)(NSArray <VHGoodsCouponInfoItem *> *list, NSError *error))complete;

/// 不可用优惠券列表
/// - Parameters:
///   - webinar_id: 活动id
///   - goods_id: 商品id
///   - goods_num: 商品数量
///   - complete: 完成返回详情,失败错误详情
+ (void)couponUnavailableListWithWebinarId:(NSString *)webinar_id goods_id:(NSString *)goods_id goods_num:(NSString *)goods_num complete:(void (^)(NSArray <VHGoodsCouponInfoItem *> *list, NSError *error))complete;

@end


