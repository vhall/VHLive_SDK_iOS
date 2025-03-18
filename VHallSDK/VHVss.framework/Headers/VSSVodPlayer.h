//
//  VSSVodPlayer.h
//  VHVSS
//
//  Created by vhall on 2019/9/5.
//  Copyright © 2019 vhall. All rights reserved.
//

#import <VHLSS/VHVodPlayer.h>

NS_ASSUME_NONNULL_BEGIN

@class VSSVodPlayer;@class VHMessage;

typedef NS_ENUM(NSInteger,VHVSSVodMsgType) {
    VHVSSVodMsgType_live_start,          //开始直播
};

@protocol VSSVodPlayerDelegate <VHVodPlayerDelegate>

@optional

/// 点播消息回调
/// @param msg 消息
/// @param type 消息类型
/// @param targetIsMyself 是否只是针对自己的消息
- (void)receivedMsg:(VHMessage *)msg msgType:(VHVSSVodMsgType)type targetIsMyself:(BOOL)targetIsMyself;

@end

@interface VSSVodPlayer : VHVodPlayer

@property (nonatomic, weak) id <VSSVodPlayerDelegate> vssDelegate;
/**
 获取原流的播放链接，直播hls，回放hls，点播mp4, 可能返回nil，真正调度后才能取得值
 */
-(NSString*)GetOriginalUrl;
@end

NS_ASSUME_NONNULL_END
