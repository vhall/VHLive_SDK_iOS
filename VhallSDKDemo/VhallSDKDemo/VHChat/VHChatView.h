//
//  VHChatView.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/13.
//

#import <UIKit/UIKit.h>
#import "VHChatCustomCell.h"

@protocol VHChatViewDelegate <NSObject>

/// 收到上下线消息
/// @param msgs 消息详情
- (void)reciveOnlineMsg:(NSArray <VHallOnlineStateModel *> *)msgs;

/// 收到自己被禁言/取消禁言
/// @param forbidChat YES:禁言 NO:取消禁言
- (void)forbidChat:(BOOL)forbidChat;

/// 收到全体禁言/取消全体禁言
/// @param allForbidChat YES:禁言 NO:取消禁言
- (void)allForbidChat:(BOOL)allForbidChat;

/// 问答状态
/// @param questionStatus YES:可用 NO:不可用
- (void)questionStatus:(BOOL)questionStatus;

/// 收到虚拟人数消息
/// @param update_online_num 增加的虚拟在线人数
/// @param update_pv 增加的虚拟热度
- (void)vhBaseNumUpdateToUpdate_online_num:(NSInteger)update_online_num
                                 update_pv:(NSInteger)update_pv;

/// 点击问卷
/// @param surveyId 收到的问卷
- (void)clickSurveyToId:(NSString *)surveyId;

@end

@interface VHChatView : UIView<JXCategoryListContentViewDelegate>

/// 代理对象
@property (nonatomic, weak) id <VHChatViewDelegate> delegate;

/// 连接消息,并加载数据
/// - Parameters:
///   - vhObject: 播放器对象
///   - webinarInfoData: 房间详情
- (void)requestDataWithVHObject:(NSObject *)vhObject webinarInfoData:(VHWebinarInfoData *)webinarInfoData;

/// 发送消息
/// - Parameter text: 消息内容哦
- (void)sendText:(NSString *)text;

/// 收到礼物
/// - Parameter model: 礼物模型
- (void)vhGifttoModel:(VHallGiftModel *)model;

/// 收到自定义消息
/// - Parameters:
///   - nickName: 昵称
///   - roleName: 身份
///   - content: 详情
///   - info: 附加信息
- (void)chatCustomWithNickName:(NSString *)nickName roleName:(NSInteger)roleName content:(NSString *)content info:(NSMutableDictionary *)info;

@end
