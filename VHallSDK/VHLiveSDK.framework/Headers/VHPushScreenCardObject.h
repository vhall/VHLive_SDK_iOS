//
//  VHPushScreenCardObject.h
//  VHLiveSDK
//
//  Created by 郭超 on 2023/7/3.
//  Copyright © 2023 vhall. All rights reserved.
//

#import "VHallBasePlugin.h"
#import "VHallRawBaseModel.h"

// 推屏卡片数据类
@interface VHPushScreenCardItem : VHallRawBaseModel

@property (nonatomic , copy) NSString *     ID;             ///<ID
@property (nonatomic , copy) NSString *     webinar_id;     ///<活动id
@property (nonatomic , copy) NSString *     switch_id;      ///<场次id
@property (nonatomic , copy) NSString *     updated_at;     ///<更新时间
@property (nonatomic , copy) NSString *     href_btn_label; ///<链接点击按钮文本
@property (nonatomic , copy) NSString *     title;          ///<标题
@property (nonatomic , copy) NSString *     href;           ///<链接地址
@property (nonatomic , copy) NSString *     img_url;        ///<图片地址
@property (nonatomic , copy) NSString *     created_at;     ///<创建时间
@property (nonatomic , copy) NSString *     push_time;      ///<推送时间
@property (nonatomic , assign) BOOL         href_enable;    ///<是否开启链接 NO：未开启，YES：开启
@property (nonatomic , assign) BOOL         timer_enable;   ///<是否开启倒计时 NO：未开启，YES：开启
@property (nonatomic , assign) NSInteger    img_rate;       ///<图片比例 0竖版 1横版 2方版
@property (nonatomic , assign) NSInteger    timer_interval; ///<倒计时时长
@property (nonatomic , assign) UIViewContentMode img_mode;  ///<图片裁剪类型

/** 以下部分是推屏卡片消息中带有的参数*/
@property (nonatomic , copy) NSString   *   user_id;        ///<用户id
@property (nonatomic , copy) NSString   *   remark;         ///<描述
@property (nonatomic , copy) NSString   *   operator_role;  ///<发起者角色名称
@property (nonatomic , copy) NSString   *   role_name;      ///<发起者角色
@property (nonatomic , copy) NSString   *   operator_name;  ///<发起者昵称

@end

@protocol VHPushScreenCardObjectDelegate <NSObject>

/// 开始推屏卡片
/// - Parameter model: 详情数据
- (void)pushScreenCardModel:(VHPushScreenCardItem *)model;
/// 更新推屏卡片
/// - Parameter model: 详情数据
- (void)updateScreenCardModel:(VHPushScreenCardItem *)model;
/// 删除推屏卡片
/// - Parameter list: 被删除的卡片列表(支持一次删除多个)
- (void)deleteScreenCardList:(NSArray *)list;

@end

@interface VHPushScreenCardObject : VHallBasePlugin

@property (nonatomic, weak) id <VHPushScreenCardObjectDelegate> delegate; ///<代理

/// 获取推送的推屏卡片列表
/// - Parameters:
///   - webinar_id: 活动ID
///   - switch_id: 场次ID
///   - curr_page: 当前页码，默认 1
///   - page_size: 每页条数，默认 10
///   - complete: 完成返回卡片列表,失败错误详情
+ (void)requestPushScreenCardListWithWebinarId:(NSString *)webinar_id
                                     switch_id:(NSString *)switch_id
                                     curr_page:(NSInteger)curr_page
                                     page_size:(NSInteger)page_size
                                      complete:(void (^)(NSArray <VHPushScreenCardItem *> *list, NSInteger total, NSError *error))complete;

/// 获取推屏卡片信息
/// @param webinar_id 活动ID
/// @param card_id 卡片ID
/// @param complete 完成返回推屏卡片详情,失败错误详情
+ (void)requestPushScreenCardInfoWithWebinarId:(NSString *)webinar_id
                                       card_id:(NSString *)card_id
                                      complete:(void (^)(VHPushScreenCardItem *item, NSError *error))complete;

/// 点击推屏卡片(数据打点)
/// @param webinar_id 活动ID
/// @param switch_id 活动场次ID
/// @param card_id 卡片id
/// @param fail 失败
+ (void)requestPushScreenCardClickWithWebinarId:(NSString *)webinar_id
                                      switch_id:(NSString *)switch_id
                                        card_id:(NSString *)card_id
                                           fail:(void (^)(NSError *error))fail;

@end
