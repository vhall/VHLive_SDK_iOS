//
//  VHRoomInfo.h
//  VHallInteractive
//
//  Created by xiongchao on 2021/4/19.
//  Copyright © 2021 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VHInteractive/VHRoomEnum.h>
#import <VHLiveSDK/VHallConst.h>
#import <VHLiveSDK/VHDocument.h>
#import <VHLiveSDK/VHSSInteractModel.h>
#import <VHLiveSDK/VHWebinarInfoData.h>

NS_ASSUME_NONNULL_BEGIN

// 房间活动相关信息 （v3控制台新创建的活动才会有值）
@interface VHRoomInfo : NSObject

@property (nonatomic, strong) id data;                                          ///<活动详情原数据
@property (nonatomic, strong) VHSSRoomToolsStatus *toolsStatus;                 ///<进入房间时，房间工具状态
@property (nonatomic, strong) VHWebinarInfoData *webinarInfoData;               ///<活动详情数据模型
@property (nonatomic, assign) VHWebinarLiveType webinar_type;                   ///<1 音频直播 2 视频直播 3 互动直播
@property (nonatomic, assign) VHRoomRoleNameType selfRoleName;                  ///<自己的角色  1主持人 2观众 3助理 4嘉宾
@property (nonatomic, assign) NSInteger no_delay_webinar;                       ///<是否无延迟直播 1:是 0:否
@property (nonatomic, assign) NSInteger live_type;                              ///<0-直播；2-彩排
@property (nonatomic, assign) NSInteger inav_num;                               ///<当前活动支持的最大连麦人数，如：6表示1v5，16表示1v15
@property (nonatomic, assign) NSInteger speakerAndShowLayout;                   ///<0 -- 分离模式；1 -- 合并模式；
@property (nonatomic, assign) BOOL live_rehearsal;                              ///<是否有彩排权限
@property (nonatomic, assign) BOOL membersManageAuthority;                      ///<自己是否有成员管理权限
@property (nonatomic, assign) BOOL selfBanChat;                                 ///<自己是否被禁言  YES：禁言 NO：未禁言
@property (nonatomic, assign) BOOL allBanChat;                                  ///<全员是否被禁言  YES：禁言 NO：未禁言
@property (nonatomic, assign) BOOL documentOpenState;                           ///<进入房间后，此时的文档开启状态  YES：开启  NO：关闭
@property (nonatomic, assign) BOOL handsUpOpenState;                            ///<进入房间后，此时的举手开启状态  YES：开启  NO：关闭
@property (nonatomic, copy) NSString *webinarId;                                ///<活动id
@property (nonatomic, copy) NSString *webinar_title;                            ///<活动标题
@property (nonatomic, copy) NSString *webinar_user_nick;                        ///<活动作者昵称
@property (nonatomic, copy) NSString *webinar_user_icon;                        ///<活动作者头像
@property (nonatomic, copy) NSString *selfUserId;                               ///<自己的用户id
@property (nonatomic, copy) NSString *selfNickName;                             ///<自己的昵称
@property (nonatomic, copy) NSString *selfAvatar;                               ///<自己的头像
@property (nonatomic, copy) NSString *join_id;                                  ///<自己的参会id
@property (nonatomic, copy) NSString *mainSpeakerId;                            ///<当前主讲人（具有文档操作权限）的用户id (会随主讲人改变，实时更新)
@property (nonatomic, copy) NSString *main_screen;                              ///<主画面
@property (nonatomic, copy) NSString *layout;                                   ///<获取观看端布局, 未设置返回空
@property (nonatomic, copy) NSString *videoBackGround;                          /// 背景图片
@property (nonatomic, copy) NSString *finalVideoBackground;                     /// 背景图片(带透明度等属性的地址链接)
@property (nonatomic, copy) NSString *videoBackGroundColor;                     /// 背景颜色
@property (nonatomic, copy) NSDictionary *videoBackGroundSize;                  /// 背景尺寸

#pragma mark - 在线人数
@property (nonatomic, assign) BOOL online_show;                                 ///<是否显示在线人数
@property (nonatomic, assign) BOOL pv_show;                                     ///<是否显示热度
@property (nonatomic, assign) NSUInteger online_real;                           ///<真实在线人数（该值会随房间人数改变实时更新）
@property (nonatomic, assign) NSUInteger online_virtual;                        ///<虚拟在线人数
@property (nonatomic, assign) NSUInteger pv_real;                               ///<真实热度
@property (nonatomic, assign) NSUInteger pv_virtual;                            ///<虚拟热度

#pragma mark - 问答
@property (nonatomic, assign) BOOL qaOpenState;                                 ///<进入房间后，此时的问答开关状态  YES：开启  NO：关闭
@property (nonatomic, copy) NSString *questionName;                             ///<问答名称
@property (nonatomic, copy) NSString *announcement;                             ///<进入房间后，此时是否有公告，有则为公告内容，没有则为nil
@property (nonatomic, copy) NSString *announcementTime;                         ///<进入房间后，此时是否有公告，有则为公告发布时间，没有则为nil

#pragma mark - 文档
@property (nonatomic, readonly) VHDocWatermarkModel *docWatermarkModel;         ///<文档水印项
@property (nonatomic, weak, readonly) VHDocument *documentManager;              ///<文档实例对象 ，获取该对象后，设置VHDocument的代理，监听文档相关回调

#pragma mark - 嘉宾，主持人权限值 100037
@property (nonatomic) NSArray *permission;

@end
// 互动消息
@interface VHRoomMessage : NSObject
@property (nonatomic, assign) VHRoomMessageType messageType;                    ///<消息类型
@property (nonatomic, assign) BOOL targetForMe;                                 ///<该消息目标用户是否为自己
@property (nonatomic, copy) NSString *targetId;                                 ///<该消息对应的目标用户id
@property (nonatomic, copy) NSString *targetName;                               ///<该消息对应的目标用户昵称
@property (nonatomic) NSString *inviter_Id;                                     ///<嘉宾称为主讲人邀请上麦的id
@end



NS_ASSUME_NONNULL_END
