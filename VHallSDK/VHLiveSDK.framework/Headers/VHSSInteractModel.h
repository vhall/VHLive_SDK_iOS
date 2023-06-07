//
//  VHSSInteractModel.h
//  VHVss
//
//  Created by xiongchao on 2020/11/16.
//  Copyright © 2020 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 文档
//文档
@interface VHSSInteractDocModel : NSObject
@property (nonatomic, copy) NSString *document_id;     ///<paas文档ID
@property (nonatomic, copy) NSString *file_name;     ///<文件名
@property (nonatomic, copy) NSString *hash_value;     ///<Hash后文件名|文档的hash值
@property (nonatomic, assign) NSInteger page;     ///<文件一共多少页
@property (nonatomic, assign) NSInteger size;     ///<文件大小 字节数
@property (nonatomic, copy) NSString *created_at;     ///<创建时间
@property (nonatomic, copy) NSString *updated_at;     ///<修改时间
@property (nonatomic, copy) NSString *ext;       ///<文档类型扩展名
@end

#pragma mark - 成员
//成员
@interface VHSSInteractOnlineUserModel : NSObject
@property (nonatomic, copy) NSString *join_id;     ///<参会id
@property (nonatomic, copy) NSString *room_id;     ///<房间id
@property (nonatomic, copy) NSString *account_id;     ///<用户id
@property (nonatomic, copy) NSString *nickname;     ///<用户昵称
@property (nonatomic, copy) NSString *avatar;     ///<用户头像
@property (nonatomic, assign) NSInteger role_name;     ///<角色信息，1主持人2观众3助理4嘉宾
@property (nonatomic, assign) NSInteger is_banned;     ///<是否禁言，1是0否
@property (nonatomic, assign) NSInteger is_kicked;     ///<是否踢出，1是0否
@property (nonatomic, assign) NSInteger device_type;     ///<设备类型，0未检测 1手机端 2PC 3SDK
@property (nonatomic, assign) NSInteger device_status;     ///<设备状态，0未检测1可以上麦2不可以上麦
@property (nonatomic, assign) NSInteger is_signed;     ///<是否签到：1 是 0 否
@property (nonatomic, assign) NSInteger is_answered_questionnaire;     ///<是否回答过问卷：1 是 0 否
@property (nonatomic, assign) NSInteger is_lottery_winner;     ///<是否中奖：1 是 0 否
@property (nonatomic, assign) NSInteger is_answered_exam;     ///<是否已经成为抽奖中奖者：1 是 0 否
@property (nonatomic, assign) NSInteger is_answered_vote;     ///<是否投过票：1 是 0 否
@property (nonatomic, assign) NSInteger status;     ///<在线状态：0 离线 1 在线
@property (nonatomic, copy) NSString *updated_at;     ///<
@property (nonatomic, copy) NSString *created_at;     ///<
@property (nonatomic, copy) NSString *deleted_at;     ///<
@end

#pragma mark - 公告列表
//公告列表
@interface VHSSInteractAnnouncementModel : NSObject

@property (nonatomic, copy) NSString *content;  ///<公告内容
@property (nonatomic, copy) NSString *created_at;  ///<创建时间
@property (nonatomic, copy) NSString *event;  ///<事件
@property (nonatomic, copy) NSString *room;  ///<活动id
@property (nonatomic, copy) NSString *Id;  ///<公告id
@property (nonatomic, assign) NSInteger duration; //公告显示时长 0代表永久显示

- (instancetype)initWithDict:(NSDictionary *)dict;
@end

#pragma mark - 水印
//水印
@interface VHSSInteractWatermarkModel : NSObject
@property (nonatomic, copy) NSString *webinar_id;     ///<活动id
@property (nonatomic, copy) NSString *img_url;     ///<图片地址
@property (nonatomic, assign) NSInteger watermark_open;     ///<是否开启水印  1 开启 0 关闭
@property (nonatomic, assign) float img_alpha;     ///<图片透明度
@property (nonatomic, assign) NSInteger img_position;     ///<图片位置
///
@property (nonatomic) BOOL docWatermark_open;  ///< 1开启，0关闭
@property (nonatomic) NSString *docWatermark_title;
@property (nonatomic) NSString *docWatermark_fontColor;
@property (nonatomic) NSUInteger docWatermark_fontSize;
@property (nonatomic) float docWatermark_transparency;
@property (nonatomic) BOOL docWatermark_type_text;
@property (nonatomic) BOOL docWatermark_type_user_id;
@property (nonatomic) BOOL docWatermark_type_nick_name;
+ (instancetype)initWithDic:(NSDictionary *)dic;
@end

#pragma mark - 跑马灯
//跑马灯
@interface VHSSInteractScrollScreenModel : NSObject
@property (nonatomic, copy) NSString *webinar_id;     ///<活动id
@property (nonatomic, assign) NSInteger scrolling_open;     ///<是否开启跑马灯  1 开启 0 关闭
@property (nonatomic, assign) NSInteger text_type;     ///<文本显示格式
@property (nonatomic, copy) NSString *text;     ///<文本内容
@property (nonatomic, assign) float alpha;     ///<不透明度
@property (nonatomic, assign) NSInteger size;     ///<字号
@property (nonatomic, copy) NSString *color;     ///<十六进制色值 #ffffff
@property (nonatomic, assign) NSInteger interval;     ///<间隔时间
@property (nonatomic, assign) NSInteger speed;     ///<滚屏速度
@property (nonatomic, assign) NSInteger position;     ///<显示位置
@property (nonatomic, assign) NSInteger scroll_type;     ///<显示方式 1 滚动 2 闪烁

+ (instancetype)initWithDic:(NSDictionary *)dic;
@end

#pragma mark - 上麦列表
//上麦列表
@interface VHSSRoomSpeaker : NSObject
/** 昵称 */
@property (nonatomic, copy) NSString *nick_name;
/** 角色  1主持人 2观众 3助理 4嘉宾*/
@property (nonatomic, assign) NSInteger role_name;
/** 用户id */
@property (nonatomic, copy) NSString *account_id;
/** 是否开启麦克风 1:开启 0未开启 */
@property (nonatomic, assign) NSInteger audio;
/** 是否开启摄像头 1:开启 0未开启 */
@property (nonatomic, assign) NSInteger video;
@end

#pragma mark - 房间互动工具状态
//房间互动工具状态
@interface VHSSRoomToolsStatus : NSObject
@property (nonatomic, assign) BOOL all_banned;          //全体禁言1禁言0取消禁言
@property (nonatomic, assign) BOOL is_banned;           //当前用户是否被禁言
@property (nonatomic, assign) BOOL is_kicked;           //当前用户是否被踢出
@property (nonatomic, assign) BOOL question_status;     //问答是否处于开启状态 1 开启 0 关闭
@property (nonatomic, assign) BOOL qa_status;           //是否开启了问答禁言 YES 开启 NO 未开启
//问答名称
@property (nonatomic, copy) NSString *question_name;
@property (nonatomic, assign) BOOL is_desktop;          //开关桌面演示，1开0关
@property (nonatomic, assign) BOOL is_doc;              //开关文档，1开0关
@property (nonatomic, assign) BOOL is_handsup;          //当前举手开关，1开0关
@property (nonatomic, assign) BOOL is_invitecard;       //开关邀请卡 1是0否
@property (nonatomic, assign) NSInteger speakerAndShowLayout;   //0 -- 分离模式；1 -- 合并模式；
@property (nonatomic, assign) NSInteger start_type;     //获取活动发起类型 1 web 2 app 3 sdk 4 推拉流 5 定时 6 admin后台 7第三方8 助手
@property (nonatomic, copy)   NSString *doc_permission;   //文档权限（主讲人的id）
@property (nonatomic, copy)   NSString *main_screen;      //主画面绑定的参会ID，默认为主持人
@property (nonatomic, copy)   NSString *rebroadcast;      //转播源房间id
@property (nonatomic, copy)   NSString *layout;         //获取观看端布局, 未设置返回空
@property (nonatomic, strong) NSArray <VHSSRoomSpeaker *> *speaker_list;    //此时的上麦列表
@property (nonatomic, strong) NSString *definition;     //获取视频清晰度， 未设置返回空
@property (nonatomic, strong) NSDictionary *videoBackGroundMap; //背景图相关属性
- (instancetype)initWithDict:(NSDictionary *)dict;
@end


@interface VHSSInteractModel : NSObject

@end

NS_ASSUME_NONNULL_END
