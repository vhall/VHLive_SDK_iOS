//
//  VHWebinarInfo.h
//  VHallSDK
//
//  Created by xiongchao on 2020/12/17.
//  Copyright © 2020 vhall. All rights reserved.
//
//活动相关信息，注意：此类信息仅限新版控制台(v3及以上)创建的活动使用，否则部分属性无值
#import <Foundation/Foundation.h>
#import "VHallConst.h"
@class VHWebinarScrollTextInfo;
@class VHRoleNameData;

@class VHViewProtocolModel;
@class VHStatementModel;


@class VHDirectorModel;
@class VHSeatModel;


@class VHRoomToolStatus;
@class VHSurveyListModel;
@class VHSurveyModel;
@class VHLotteryListModel;
@class VHLotteryModel;
NS_ASSUME_NONNULL_BEGIN

@protocol VHWebinarInfoDelegate <NSObject>

/// 房间人数改变回调 （目前仅支持真实人数改变触发此回调）
/// @param online_real 真实在线用户数
/// @param online_virtual 虚拟在线用户数
- (void)onlineChangeRealNum:(NSUInteger)online_real virtualNum:(NSUInteger)online_virtual;

@end

@interface VHWebinarInfo : NSObject
@property (nonatomic, weak) id<VHWebinarInfoDelegate> delegate; ///<代理
@property (nonatomic, assign, readonly) VHWebinarLiveType liveType; ///<活动直播类型 （视频、音频、互动）
@property (nonatomic, assign, readonly) VHMovieActiveState liveState; ///<活动直播状态  (直播、预告、结束、点播/回放)
@property (nonatomic, copy, readonly) NSString *webinarId; ///<活动id
@property (nonatomic, copy, readonly) NSString *join_id; ///<自己的参会id
@property (nonatomic, copy, readonly) NSString *subject; ///<活动名称
@property (nonatomic, copy, readonly) NSString *img_url; ///<活动封面图
@property (nonatomic, copy, readonly) NSString *author_userId; ///<活动发起者用户id
@property (nonatomic, copy, readonly) NSString *author_nickname; ///<活动发起者昵称
@property (nonatomic, copy, readonly) NSString *author_avatar; ///<活动发起者头像
@property (nonatomic, strong, readonly) id data;

@property (nonatomic, assign, readonly) NSUInteger online_real; ///<真实在线人数（该值会随房间人数改变实时更新）
@property (nonatomic, assign, readonly) NSUInteger online_virtual; ///<虚拟在线人数
@property (nonatomic, assign, readonly) BOOL online_show; ///<是否显示在线人数
@property (nonatomic, assign, readonly) NSUInteger pv_real; ///<真实热度
@property (nonatomic, assign, readonly) NSUInteger pv_virtual; ///<虚拟热度
@property (nonatomic, assign, readonly) BOOL pv_show; ///<是否显示热度
@property (nonatomic, assign, readonly) NSInteger inav_num;     ///<当前活动设置的支持大连麦人数， 如：6表示1v5，16表示1v15...
@property (nonatomic, strong ,readonly) VHWebinarScrollTextInfo *scrollTextInfo; ///<跑马灯信息

@end


//跑马灯配置信息
@interface VHWebinarScrollTextInfo : NSObject
@property (nonatomic, copy, readonly) NSString *webinar_id;     ///<活动id
@property (nonatomic, assign, readonly) NSInteger scrolling_open;     ///<是否开启跑马灯  1：开启 0：关闭
@property (nonatomic, copy, readonly) NSString *text;     ///<文本内容
@property (nonatomic, assign, readonly) NSInteger text_type;     ///<文本显示格式，1：固定文本 2：固定文本+观看者id和昵称
@property (nonatomic, assign, readonly) NSInteger alpha;     ///<不透明度，如：60%不透明度，则属性值为60
@property (nonatomic, assign, readonly) NSInteger size;     ///<字号
@property (nonatomic, copy, readonly) NSString *color;     ///<十六进制色值 如：#FFFFFF
@property (nonatomic, assign, readonly) NSInteger interval;     ///<间隔时间，秒
@property (nonatomic, assign, readonly) NSInteger speed;     ///<滚屏速度 10000：慢 6000：中 3000：快
@property (nonatomic, assign, readonly) NSInteger position;     ///<显示位置 1：随机 2：上 3：中 4：下
@end



//活动基础信息
@interface VHWebinarBaseInfo : NSObject
@property (nonatomic, strong) id data;
@property (nonatomic, copy) NSString *ID;           ///<活动id
@property (nonatomic, copy) NSString *user_id;       ///<活动创建者用户id
@property (nonatomic, copy) NSString *subject;       ///<标题
@property (nonatomic, copy) NSString *introduction;       ///<简介
@property (nonatomic, copy) NSString *img_url;       ///<封面图片
@property (nonatomic, copy) NSString *category;          ///<类别，eg：金融
@property (nonatomic, copy) NSString *start_time;           ///<直播开始时间
@property (nonatomic, copy) NSString *actual_start_time;       ///<实际开始时间
@property (nonatomic, copy) NSString *end_time;             ///<直播结束时间
@property (nonatomic, assign) VHWebinarLiveType webinar_type;    ///<1 音频直播 2 视频直播 3 互动直播
@property (nonatomic, assign) VHMovieActiveState type;       ///<1为直播,2为预约,3为结束,4回放
@property (nonatomic,assign) NSInteger webinar_show_type; ///横竖屏 0竖屏 1横屏
@property (nonatomic, assign) NSInteger no_delay_webinar;     ///<是否无延迟直播 1:是 0:否
@property (nonatomic, assign) NSInteger inav_num;     ///<当前活动设置的最大连麦人数， 如：6表示1v5，16表示1v15...
@property (nonatomic, assign,readonly) NSInteger is_director;///能否使用云导播功能 0-否 1-是

/// 查询活动基础信息
/// @param webinarId 活动id
/// @param success 成功
/// @param fail 失败
+ (void)getWebinarBaseInfoWithWebinarId:(NSString *)webinarId success:(void(^)(VHWebinarBaseInfo *baseInfo))success fail:(void(^)(NSError *error))fail;
///角色数据
@property (nonatomic,strong) VHRoleNameData *roleData;

///返回角色数据
+ (void)getRoleNameWebinar_id:(NSString *)webinarId dataCallBack:(void(^)(VHRoleNameData *))roleNameData;
///获取美颜权限结果
@property (nonatomic,assign) BOOL  allowAdvanceBeauty;

///开启观看协议需前置获取观看协议
+ (void)fetchViewProtocol:(NSString *)webinarId success:(void(^)(VHViewProtocolModel *protocolModel))success fail:(void(^)(NSError *error))fail;
///同意观看协议
+ (void)agreeViewProtocol:(NSString *)webinarId success:(void(^)(void))success fail:(void(^)(NSError *error))fail;

///云导播活动
///导播台是否开启 director_status=YES:已开启，NO:未开启
+ (void)getDirectorStatusWithWebinarId:(NSString *)webinarId success:(void(^)(BOOL  director_status))success fail:(void(^)(NSError *error))fail;
///以视频推流到云导播获取机位列表
+ (void)getSeatList:(NSString *)webinarId success:(void(^)(VHDirectorModel *directorModel))success fail:(void(^)(NSError *error))fail;
///选择机位
+ (void)selectSeatWithWebinarId:(NSString *)webinarId seatId:(NSString *)seatId success:(void(^)(BOOL))success fail:(void(^)(NSError *error))fail;
///云导播台的房间流状态
+ (void)getDirectorRoomStreamStatus:(NSString *)webinarId success:(void(^)(BOOL isHaveStream))success fail:(void(^)(NSError *error))fail;


/// 获取问卷历史
/// @param webinarId 活动id
/// @param roomId 房间id
/// @param switchId 场次id
/// @param success 成功
/// @param fail 失败
+ (void)fetchSurveyListWebinarId:(NSString *)webinarId
                          roomId:(NSString *)roomId
                        switchId:(NSString *)switchId
                         success:(void(^)(VHSurveyListModel * listModel))success
                            fail:(void(^)(NSError *error))fail;

/// 获取抽奖列表接口
/// @param showAll 是否需要展示所有抽奖 0-否(默认：仅展示进行中、已中奖抽奖) 1-全部抽奖 2 已中奖抽奖（sdk专用）
/// @param webinarId 活动id
/// @param success 成功
/// @param fail 失败
+ (void)fetchLotteryListShowAll:(NSInteger)showAll
                      webinarId:(NSString *)webinarId
                        success:(void (^)(VHLotteryListModel * listModel))success
                           fail:(void (^)(NSError *error))fail;

@end


// 文档
@interface VHRoomDocumentModel : NSObject
@property (nonatomic, copy) NSString *document_id;     ///<文档ID
@property (nonatomic, copy) NSString *file_name;     ///<文件名
@property (nonatomic, assign) NSInteger size;     ///<文件大小 字节数：size/(1024*1024.0)为M
@property (nonatomic, copy) NSString *created_at;     ///<创建时间
@property (nonatomic, copy) NSString *updated_at;     ///<修改时间
@property (nonatomic, copy) NSString *ext;       ///<文档类型扩展名
@end

// 成员
@interface VHRoomMember : NSObject
@property (nonatomic, copy) NSString *account_id; ///<用户id
@property (nonatomic, copy) NSString *join_id; ///<参会id
@property (nonatomic, copy) NSString *avatar; ///<头像
@property (nonatomic, copy) NSString *nickname; ///<昵称
@property (nonatomic, assign) VHRoomRoleNameType role_name; ///<角色  1主持人 2观众 3助理 4嘉宾
@property (nonatomic, assign) NSInteger is_speak; ///<是否上麦中 1：上麦中 其他：未上麦
@property (nonatomic, assign) BOOL is_banned; ///<是否被禁言
@property (nonatomic, assign) BOOL is_kicked; ///<是否被踢出
@property (nonatomic, assign) NSInteger device_type; ///<设备类型 0未知 1手机端 2PC 3SDK
@property (nonatomic, assign) NSInteger device_status; ///< 设备检测状态 0:未检测 1:可以上麦 2:不可以上麦

@end
///互动工具状态
@interface VHRoomToolStatus : NSObject
///问答名字
@property (nonatomic,copy,readonly) NSString *question_name;
///问答状态 YES 开启了问答 NO: 关闭了问答
@property (nonatomic,assign,readonly) BOOL  question_status;

@end
@interface VHRoleNameData : NSObject
///主持人角色名称
@property (nonatomic,copy) NSString *host_name;
///嘉宾角色名称
@property (nonatomic,copy) NSString *guest_name;
///助理角色名称
@property (nonatomic,copy) NSString *assist_name;
@end

//观看协议模型数据
@interface VHViewProtocolModel : NSObject
///用户协议是否同意 0-未同意，1-同意
@property (nonatomic,assign,readonly) NSInteger is_agree;
///观看协议开关0-关闭，1-打开
@property (nonatomic,assign,readonly) NSInteger is_open;
///观看协议title
@property (nonatomic,copy,readonly) NSString *title;
///观看协议content
@property (nonatomic,copy,readonly) NSString *content;
///协议规则rule 0-强制，1-非强制
@property (nonatomic,assign,readonly) NSInteger rule;
///声明状态 0-关 1-开
@property (nonatomic,assign,readonly) NSInteger statement_status;
///协议提示内容
@property (nonatomic,copy,readonly) NSString *statement_content;
///协议介绍
@property (nonatomic,copy,readonly) NSArray<VHStatementModel *> *statement_info;
@end
@interface VHStatementModel : NSObject
///协议
@property (nonatomic,copy,readonly) NSString *title;
//协议链接
@property (nonatomic,copy,readonly) NSString *link;
@end



@interface VHDirectorModel : NSObject
//云导播台开启状态 0-未开启 1-已开启
@property (nonatomic,readonly) NSInteger  director_status;
//机位列表(可用状态+机位id+机位名称)
@property (nonatomic,readonly)NSArray <VHSeatModel *> *seatList;
@end
@interface VHSeatModel : NSObject
//机位名称
@property (nonatomic,copy,readonly) NSString *name;
//机位ID
@property (nonatomic,copy,readonly) NSString *seat_id;
//机位状态
@property (nonatomic,readonly) NSInteger  seat_status;
@end


@interface VHSurveyListModel : NSObject
@property (nonatomic,strong) NSArray <VHSurveyModel *>*listModel;
@end
@interface VHSurveyModel : NSObject
//问卷标题
@property (nonatomic,copy) NSString *title;
//问卷id
@property (nonatomic,copy) NSString *question_id;
//问卷编号
@property (nonatomic,copy) NSString *question_no;
//问卷别名
@property (nonatomic,copy) NSString *alias;
//问卷是否参与
@property (nonatomic,assign)BOOL is_answered;
//问卷创建时间
@property (nonatomic,copy) NSString *created_at;
//问卷更新时间
@property (nonatomic,copy) NSString *updated_at;
//问卷的URL
@property (nonatomic,strong,readonly) NSURL *openLink;
@end
//抽奖
@interface VHLotteryListModel : NSObject
@property (nonatomic,strong) NSArray <VHLotteryModel *>*listModel;
@end
@interface VHLotteryModel : NSObject
///抽奖标题
@property (nonatomic,copy,readonly) NSString *title;
//创建时间
@property (nonatomic,copy,readonly) NSString *created_at;
///图标地址
@property (nonatomic,copy,readonly) NSString *icon;
///抽奖动图下标
@property (nonatomic,copy,readonly) NSString *img_order;
///本次抽奖说明
@property (nonatomic,copy,readonly) NSString *remark;
///奖品快照
@property (nonatomic,copy,readonly) id award_snapshoot;
///已中奖
@property (nonatomic,assign,readonly)BOOL win;
///已领奖
@property (nonatomic,assign,readonly)BOOL take_award;
///是否需要领奖
@property (nonatomic,assign,readonly)BOOL need_take_award;
///是否显示中奖名单
@property (nonatomic,assign,readonly)BOOL publish_winner;
//抽奖id
@property (nonatomic,copy,readonly) NSString *lottery_id;
@end
NS_ASSUME_NONNULL_END
