//
//  VHallGiftObject.h
//  VHallSDK
//
//  Created by 郭超 on 2022/7/27.
//  Copyright © 2022 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VHallBasePlugin.h"
#import "VHallRawBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

// 礼物
@interface VHallGiftModel : NSObject
@property (nonatomic, assign) NSInteger source_status;              ///<来源类型：0 web 1 app
@property (nonatomic, assign) CGFloat gift_price;                   ///<价格
@property (nonatomic, copy) NSString *event_type;                   ///<事件名称
@property (nonatomic, copy) NSString *type;                         ///<消息类型
@property (nonatomic, copy) NSString *gift_creator_id;              ///<礼物创建者ID
@property (nonatomic, copy) NSString *gift_id;                      ///<礼物id
@property (nonatomic, copy) NSString *gift_image_url;               ///<礼物图片
@property (nonatomic, copy) NSString *gift_name;                    ///<礼物名称
@property (nonatomic, copy) NSString *gift_receiver_id;             ///<礼物接收者ID
@property (nonatomic, copy) NSString *gift_user_avatar;             ///<赠送礼物者用户头像
@property (nonatomic, copy) NSString *gift_user_id;                 ///<赠送礼物者用户ID
@property (nonatomic, copy) NSString *gift_user_name;               ///<赠送礼物者用户名
@property (nonatomic, copy) NSString *gift_user_nickname;           ///< 赠送礼物者昵称
@property (nonatomic, copy) NSString *room_id;                      ///< 房间id

- (instancetype)initWithData:(NSDictionary *)data;

@end


@interface VHallGiftListItem : VHallRawBaseModel

@property (nonatomic, copy) NSString *giftId;                           ///<礼物id
@property (nonatomic, copy) NSString *image_url;                        ///<礼物图片
@property (nonatomic, copy) NSString *name;                             ///<礼物名称
@property (nonatomic, copy) NSString *price;                            ///<礼物价格
@property (nonatomic, assign) NSInteger source_status;                    ///<来源类型：0 web 1 app
@property (nonatomic, assign) NSInteger source_type;                      ///<0 系统礼物 1 自定义礼物

@end

@interface VHallSendGiftModel : VHallRawBaseModel

@property (nonatomic, copy) NSString *source_type;                      ///<0 系统礼物 1 自定义礼物
@property (nonatomic, copy) NSString *gift_user_id;                     ///<赠送礼物者用户ID
@property (nonatomic, copy) NSString *gift_user_avatar;                 ///<赠送礼物者用户头像
@property (nonatomic, copy) NSString *gift_id;                          ///<礼物ID
@property (nonatomic, copy) NSString *gift_user_name;                   ///<赠送礼物者用户名
@property (nonatomic, copy) NSString *name;                             ///<礼物名称
@property (nonatomic, copy) NSString *source_id;                        ///<房间ID
@property (nonatomic, copy) NSString *gift_user_nickname;               ///<赠送礼物者昵称
@property (nonatomic, copy) NSString *gift_user_phone;                  ///<赠送礼物者用户手机号
@property (nonatomic, copy) NSString *source_status;                    ///<来源类型：0 web 1 app
@property (nonatomic, copy) NSString *pay_status;                       ///<礼物支付状态：0 等待支付 1 支付成功 2 支付失败
@property (nonatomic, copy) NSString *trade_no;                         ///<礼物订单号
@property (nonatomic, copy) NSString *creator_id;                       ///<礼物创建者ID
@property (nonatomic, copy) NSString *receiver_id;                      ///<礼物接收者ID
@property (nonatomic, copy) NSString *image_url;                        ///<礼物图片地址
@property (nonatomic, copy) NSString *price;                            ///<礼物价格

@property (nonatomic, copy) NSString *creator_nickname;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, copy) NSString *bu;
@property (nonatomic, copy) NSString *deleted;
@property (nonatomic, copy) NSString *creator_avatar;
@property (nonatomic, copy) NSString *app_id;
@property (nonatomic, copy) NSString *deleted_at;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, strong) NSDictionary *data;

@end

@protocol VHallGiftObjectDelegate <NSObject>

/// 收到礼物
/// @param model 礼物数据
- (void)vhGifttoModel:(VHallGiftModel *)model;

@end

@interface VHallGiftObject : VHallBasePlugin

@property (nonatomic, weak) id <VHallGiftObjectDelegate> delegate; ///<代理

/// 观看端_获取活动使用的礼物列表
/// @param roomId 房间id
/// @param complete giftItem:礼物列表 error:错误详情
+ (void)webinarUsingGiftListWithRoomId:(NSString *)roomId
                              complete:(void (^)(NSArray <VHallGiftListItem *> *giftList, NSError *error))complete;


/// 观看端_发送礼物给主持人
/// @param roomId 房间id
/// @param channel
/// @param service_code 支付方式
/// "QR_PAY":支付宝二维码支付 "H5_PAY":支付宝移动支付 "CASHIER":支付宝收银台支付
/// "QR_PAY":微信二维码支付 "QR_PAY":微信移动浏览器支付 "JSAPI":微信内置支付
/// @param giftItem 礼物数据模型(其参数giftId不能为空)
/// @param complete sendGiftModel:发送成功返回的数据详情 error:错误详情
+ (void)sendGiftWithRoomId:(NSString *)roomId
                   channel:(NSString *)channel
              service_code:(NSString *)service_code
                  giftItem:(VHallGiftListItem *)giftItem
                  complete:(void (^)(VHallSendGiftModel *sendGiftModel, NSError *error))complete;


@end

NS_ASSUME_NONNULL_END
