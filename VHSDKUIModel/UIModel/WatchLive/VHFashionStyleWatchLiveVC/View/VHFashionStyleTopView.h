//
//  VHFashionStyleTopView.h
//  UIModel
//
//  Created by 郭超 on 2022/7/21.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VHFashionStyleTopView : UIView

/// 活动详情
@property (nonatomic, strong) VHWebinarInfo * webinarInfo;

/// 收到虚拟人数消息
- (void)vhBaseNumUpdateToUpdate_online_num:(NSInteger)update_online_num
                                 update_pv:(NSInteger)update_pv;

/// 收到上下线消息
- (void)reciveOnlineMsg:(NSArray <VHallOnlineStateModel *> *)msgs;

/// 开启互动
- (void)watchLiveChangeInteract:(BOOL)isChange localRenderView:(VHLocalRenderView *)localRenderView;

/// 自己的麦克风开关状态改变回调
- (void)room:(VHRoom *)room microphoneClosed:(BOOL)isClose;

/// 自己的摄像头开关状态改变回调
- (void)room:(VHRoom *)room screenClosed:(BOOL)isClose;

@end

NS_ASSUME_NONNULL_END
