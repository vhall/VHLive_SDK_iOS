//
//  VHDanmu.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2024/2/1.
//

#import <Foundation/Foundation.h>
#import <VHLiveSDK/VHallApi.h>

NS_ASSUME_NONNULL_BEGIN

@interface VHDanmu : NSObject

/// 发送弹幕
/// - Parameter msgModel: 聊天消息数据源
/// - Parameter superView: 父view
- (void)sendWithMsgModel:(VHallChatModel *)msgModel superView:(UIView *)superView;

/// 启动弹幕, 内部时钟从0开始;
/// 若是stop之后的start,则start函数内部会清空records;
/// 视频开始的时候需要同时运行此方法.
- (void)start;

/// 暂停, 已经渲染上去的保持不变, 此时发送弹幕无效, 内部时钟暂停;
/// 视频暂停的时候需要同时运行此方法.
- (void)pause;

/// 停止弹幕渲染, 会清空所有; 再发弹幕就无效了; 一切都会停止;
/// 此方法在不再需要弹幕的时候必须调用,否则可能造成内存泄露.
- (void)stop;


@end

NS_ASSUME_NONNULL_END
