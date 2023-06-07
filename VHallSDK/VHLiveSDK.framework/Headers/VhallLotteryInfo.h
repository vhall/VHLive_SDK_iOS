//
//  VhallLotteryInfo.h
//  VHLiveSDK
//
//  Created by 郭超 on 2023/3/15.
//  Copyright © 2023 vhall. All rights reserved.
//

#import "VHallRawBaseModel.h"

//检查抽奖信息（是否中奖，是否领奖等）
@interface VhallLotteryCheckInfo : VHallRawBaseModel
@property (nonatomic, assign) NSInteger win;                        ///<是否已中奖 0-否 1-是
@property (nonatomic, assign) NSInteger take_award;                 ///<是否已领奖 0-否 1-是
@property (nonatomic, assign) NSInteger need_take_award;            ///是否需要领奖 0-否 1-是
@end

//奖品信息
@interface VhallLotteryAward : VHallRawBaseModel
@property (nonatomic, copy) NSString *award_name;                   ///<奖品名
@property (nonatomic, copy) NSString *award_desc;                   ///<奖品描述
@property (nonatomic, copy) NSString *ID;                           ///<奖品id
@property (nonatomic, copy) NSString *image_url;                    ///<奖品图片
@property (nonatomic, copy) NSString *link_url;                     ///<奖品链接
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *source_id;
@property (nonatomic, copy) NSString *app_id;

@property (nonatomic, assign) NSInteger quantity;
@property (nonatomic, assign) NSInteger surplus;
@property (nonatomic, assign) NSInteger lottery_id;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, assign) NSInteger business_uid;

@end

//中奖人名单和奖品
@interface VhallLotteryInfoAwardItem : VHallRawBaseModel
@property (nonatomic, copy) NSString *uid;                          ///<用户id
@property (nonatomic, copy) NSString *award_name;                   ///<奖品名称
@end

//抽奖信息
@interface VhallLotteryInfo : VHallRawBaseModel
@property (nonatomic, strong) NSMutableArray <VhallLotteryInfoAwardItem *> *lottery_winners_award;  ///<中奖人名单和奖品
@property (nonatomic, strong) VhallLotteryAward *award;             ///<奖品信息

@property (nonatomic, copy) NSString *room_id;                      ///<直播房间id lss_
@property (nonatomic, copy) NSString *lottery_creator_avatar;       ///<抽奖发起者头像
@property (nonatomic, copy) NSString *lottery_creator_id;           ///<抽奖发起者id
@property (nonatomic, copy) NSString *lottery_creator_nickname;     ///<抽奖发起者昵称
@property (nonatomic, copy) NSString *lottery_id;                   ///<抽奖id
@property (nonatomic, copy) NSString *lottery_status;               ///<抽奖状态：0 开始抽奖 1 抽奖完成（结束）
@property (nonatomic, copy) NSString *icon;                         ///<抽奖动画图片url
@property (nonatomic, copy) NSString *remark;                       ///<抽奖说明
@property (nonatomic, copy) NSString *command;                      ///<口令
@property (nonatomic, copy) NSString *lottery_number;               ///<抽奖人数
@property (nonatomic, copy) NSString *title;                        ///<抽奖标题
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *lottery_publisher_id;
@property (nonatomic, copy) NSString *lottery_winners;              ///<中奖人id,逗号隔开的

@property (nonatomic, assign) NSInteger actual_lottery_number;      ///<实际中奖人数
@property (nonatomic, assign) NSInteger publish_winner;             ///<抽奖结束后是否显示中奖名单 1: 显示
@property (nonatomic, assign) NSInteger is_new;                     ///<是否为新版抽奖 1：是
@property (nonatomic, assign) NSInteger lottery_type;               ///<抽奖类型：* 1 全体参会用户      * 2 参与问卷的参会者      * 3 参与签到的参会者      * 4.全体观众      * 5.已登录观众      * 6.参与问卷的观众      * 7.参与签到的观众      * 8.口令参与      * 9.分享参与      * 10.邀请人数参与      * 20 批量上传用户      * 21参与快问快答',
@property (nonatomic, assign) NSInteger is_last_batch;              ///<是否为最后一批,1: 是最后一批
@property (nonatomic, assign) NSInteger need_take_award;            ///<是否需要领奖, 1: 需要领奖
@property (nonatomic, assign) NSInteger img_order;
@property (nonatomic, assign) NSInteger can_look_award_pool;


//-------------自定义属性--------------
@property (nonatomic, copy) NSString *isWin_userId;                 ///<自己中奖的用户id（自己中奖才有值）

@property (nonatomic, assign) BOOL isWin;                           ///<自己是否中奖
@property (nonatomic, assign) BOOL isCallBack;      ///<中奖结果是否已经回调出去（防止分批接收中奖结果消息，出现延迟很久才收到消息的异常情况发生时引发多次回调）
@end
