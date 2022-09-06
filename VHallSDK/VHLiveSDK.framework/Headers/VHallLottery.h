//
//  VHallLottery.h
//  VHallSDK
//
//  Created by Ming on 16/10/13.
//  Copyright © 2016年 vhall. All rights reserved.
//
// 抽奖
// !!!!:注意实例方法使用时机，看直播/回放————>在收到"播放连接成功回调"或"视频信息预加载成功回调"以后使用。

#import <Foundation/Foundation.h>
#import "VHallMsgModels.h"
#import "VHallBasePlugin.h"
#import "VHLotteryListModel.h"

/// 领奖页提交中奖用户信息填写选项的配置
@interface VHallLotterySubmitConfig : NSObject
@property (nonatomic, assign) NSInteger         is_required;    ///<是否必填 1:必填 0:非必填
@property (nonatomic, assign) NSInteger         is_system;      ///<是否是系统选项，即非自定义项 1:是 0:否
@property (nonatomic, assign) NSInteger         rank;           ///<输入项显示位置，控制台添加的自定义项显示顺序，越大越靠后显示
@property (nonatomic, copy) NSString *          field;          ///<该输入项标题
@property (nonatomic, copy) NSString *          placeholder;    ///<该输入项placeholder
@property (nonatomic, copy) NSString *          field_key;      ///<提交中奖信息传参字典对应的key
@end


//抽奖消息
@interface VHallLotteryModel : NSObject
@property (nonatomic, copy) NSString * lottery_id;      ///<抽奖ID
@property (nonatomic, copy) NSString * survey_id;       ///<活动ID

//-----------新版抽奖新增----------------
@property (nonatomic, assign) BOOL is_new;  ///<是否为新版抽奖（即使用新版v3版控制台创建的活动） 1：是 0：否
@end

//开始抽奖消息
@interface VHallStartLotteryModel : VHallLotteryModel
@property (nonatomic, copy) NSString * num; ///<抽奖人数

//-----------以下属性为新版抽奖新增----------------
@property (nonatomic, assign) NSInteger type;       ///<抽奖类型 (0：普通抽奖 1：口令抽奖)
@property (nonatomic, copy) NSString *  title;      ///<抽奖标题
@property (nonatomic, copy) NSString *  remark;     ///<抽奖说明
@property (nonatomic, copy) NSString *  icon;       ///<抽奖动图
@property (nonatomic, copy) NSString *  command;    ///<抽奖口令(如果是口令抽奖)
@end

//中奖名单
@interface VHallLotteryResultModel : NSObject
@property (nonatomic, copy) NSString * nick_name;       ///<中奖人昵称

//-----------以下属性为新版抽奖新增----------------
@property (nonatomic, copy) NSString * avatar;         ///<中奖人头像
@property (nonatomic, copy) NSString * userId;         ///<中奖人id
@end


//奖品信息
@interface VHallAwardPrizeInfoModel : NSObject
@property (nonatomic, copy) NSString *awardName;  ///<奖品名称
@property (nonatomic, copy) NSString *awardIcon;  ///<奖品图片
@property (nonatomic, copy) NSString *award_desc;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *link_url;
@end

//结束抽奖消息
@interface VHallEndLotteryModel : VHallLotteryModel
@property (nonatomic, assign) BOOL                          isWin;              ///<自己是否中奖
@property (nonatomic, copy) NSString *                      account;            ///<自己的登录账号（自己中奖才有值）
@property (nonatomic, copy) NSMutableArray<VHallLotteryResultModel *> *resultModels; ///<中奖名单 (旧版抽奖会返回此值，新版抽奖结束消息将不会返回此值，请使用VHallLottery调用接口获取中奖名单)

//-----------以下属性为新版抽奖新增----------------
@property (nonatomic, strong) VHallAwardPrizeInfoModel *    prizeInfo;          ///<奖品信息
@property (nonatomic, assign) BOOL                          publish_winner;     ///<是否显示中奖名单
@property (nonatomic, assign) BOOL                          need_take_award;    ///<是否需要领奖
@end


@protocol VHallLotteryDelegate <NSObject>
@optional
/// 抽奖开始
- (void)startLottery:(VHallStartLotteryModel *)msg;
/// 抽奖结束
- (void)endLottery:(VHallEndLotteryModel *)msg;
@end

@interface VHallLottery : VHallBasePlugin

@property (nonatomic, weak) id <VHallLotteryDelegate> delegate; ///<代理

/// 提交个人中奖信息
/// @param info 个人信息 @{@"name":姓名,@"phone":手机号,...}
/// @param success 成功回调Block
/// @param reslutFailedCallback 失败回调Block 字典结构：{code：错误码，content：错误信息}
- (void)submitLotteryInfo:(NSDictionary *)info
                  success:(void(^)(void))success
                   failed:(void (^)(NSDictionary *failedData))reslutFailedCallback;

/// 获取领奖页中奖信息列表，通过各项中的field_key作为key，以及对应输入内容作为value，一起组成字典，用于提交中奖信息接口传参 （v6.0新增，仅支持v3控制台新建的直播抽奖使用）
/// @param success 成功回调Block
/// @param reslutFailedCallback 失败回调Block 字典结构：{code：错误码，content：错误信息}
- (void)getSubmitConfigSuccess:(void(^)(NSArray <VHallLotterySubmitConfig *> *submitList))success
                        failed:(void (^)(NSDictionary *failedData))reslutFailedCallback;

/// 参加口令抽奖 （v6.0新增，仅支持v3控制台新建的直播抽奖使用）
/// @param success 成功回调Block
/// @param reslutFailedCallback 失败回调Block 字典结构：{code：错误码，content：错误信息}
- (void)lotteryParticipationSuccess:(void(^)(void))success
                             failed:(void (^)(NSDictionary *failedData))reslutFailedCallback;

/// 获取中奖名单 （v6.0新增，仅支持v3控制台新建的直播抽奖使用）
/// @param success 成功回调blck
/// @param reslutFailedCallback 失败回调Block 字典结构：{code：错误码，content：错误信息}
- (void)getLotteryWinListSuccess:(void(^)(NSArray <VHallLotteryResultModel *> *submitList))success
                          failed:(void (^)(NSDictionary *failedData))reslutFailedCallback;

/// 获取抽奖列表接口
/// @param showAll 是否需要展示所有抽奖 0-否(默认：仅展示进行中、已中奖抽奖) 1-全部抽奖 2 已中奖抽奖（sdk专用）
/// @param webinarId 活动id
/// @param success 成功
/// @param fail 失败
- (void)fetchLotteryListShowAll:(NSInteger)showAll
                      webinarId:(NSString *)webinarId
                        success:(void (^)(VHLotteryListModel * listModel))success
                           fail:(void (^)(NSError * error))fail;
@end

