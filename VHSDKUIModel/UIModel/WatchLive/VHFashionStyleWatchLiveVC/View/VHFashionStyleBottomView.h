//
//  VHFashionStyleBottomView.h
//  UIModel
//
//  Created by 郭超 on 2022/7/21.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MicCountDownView.h"

NS_ASSUME_NONNULL_BEGIN

// 同意上麦
typedef void(^ClickReplyInvitation)(void);
// 下麦
typedef void(^ClickUnpublish)(void);
// 点击礼物回调
typedef void(^ClickGiftBtnBlock)(void);

@interface VHFashionStyleBottomView : UIView

/// 播放器
@property (nonatomic, strong) VHallMoviePlayer  * moviePlayer;
/// 头像
@property (nonatomic, strong) UIImageView * headImg;
/// 聊天
@property (nonatomic, strong) VHallChat         * chat;
/// 上麦按钮
@property (nonatomic, strong) MicCountDownView *    upMicBtnView;

/// 同意上麦
@property (nonatomic, copy) ClickReplyInvitation clickReplyInvitation;
/// 点击下麦
@property (nonatomic, copy) ClickUnpublish clickUnpublish;
/// 点击礼物回调
@property (nonatomic, copy) ClickGiftBtnBlock clickGiftBtnBlock;

/// 更新点赞总数
- (void)vhPraiseTotalToNum:(NSInteger)num;

/// 获取当前房间点赞总数
- (void)requestGetRoomLikeWithRoomId;

/// 获取房间配置项权限
- (void)permissionsCheckWithWebinarId;

#pragma mark - --------------------上麦业务---------------------------
/// 是否允许举手
- (void)isInteractiveActivity:(BOOL)isInteractive interactivePermission:(VHInteractiveState)state;
/// 主持人同意上麦
- (void)microInvitationWithAttributes:(NSDictionary *)attributes error:(NSError *)error;
/// 主持人邀请你上麦
- (void)microInvitation:(NSDictionary *)attributes;

@end

NS_ASSUME_NONNULL_END
