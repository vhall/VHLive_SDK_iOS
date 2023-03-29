//
//  VHWatchLiveBottomView.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/13.
//

#import <UIKit/UIKit.h>

@protocol VHWatchLiveBottomViewDelegate <NSObject>

/// 发送消息
/// - Parameter text: 消息内容哦
- (void)sendText:(NSString *)text;

/// 点击礼物回调
- (void)clickGift;

/// 点击申请互动连麦
- (void)clickInav;

/// 是否开启了回放章节
- (void)watchRecordChapterIsOpen:(BOOL)isOpen;

@end

@interface VHWatchLiveBottomView : UIView

/// 代理对象
@property (nonatomic, weak) id <VHWatchLiveBottomViewDelegate> delegate;

/// 标识当前直播还是互动
@property (nonatomic, assign) BOOL isLive;

/// 初始化
/// - Parameters:
///   - obj: 对象
///   - webinarInfoData: 房间详情
- (instancetype)initWithObject:(NSObject *)obj webinarInfoData:(VHWebinarInfoData *)webinarInfoData;

/// 当前活动是否允许举手申请上麦回调
- (void)isInteractiveActivity:(BOOL)isInteractive interactivePermission:(VHInteractiveState)state;

/// 收到自己被禁言/取消禁言
- (void)forbidChat:(BOOL)forbidChat;

/// 收到全体被禁言/取消禁言
- (void)allForbidChat:(BOOL)allForbidChat;

/// 问答状态
/// @param isQaStatus 是否开启了问答禁言 YES 开启 NO 未开启
- (void)isQaStatus:(BOOL)isQaStatus;

/// 参与聊天还是参与问答
/// - Parameter IsChat: YES 参与聊天 NO 参与问答
- (void)participateInIsChat:(BOOL)IsChat;


@end
