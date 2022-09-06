//
//  VHFashionStyleInteractView.h
//  UIModel
//
//  Created by 郭超 on 2022/7/21.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ClickLeave)(void);

@protocol VHFashionStyleInteractViewDelegate <NSObject>

/// 自己的麦克风开关状态改变回调（主动操作/被操作都会触发此回调，收到此回调后不需要再主动设置麦克风状态）
- (void)room:(VHRoom *)room microphoneClosed:(BOOL)isClose;

/// 自己的摄像头开关状态改变回调（主动操作/被操作都会触发此回调，收到此回调后不需要再主动设置摄像头状态
- (void)room:(VHRoom *)room screenClosed:(BOOL)isClose;

@end

@interface VHFashionStyleInteractView : UIView

/// 活动id
@property (nonatomic, copy) NSString * roomId;
/// 活动观看密码
@property (nonatomic, copy) NSString * kValue;
/// 互动美颜开关
@property (nonatomic, assign) BOOL interactBeautifyEnable;

/// 代理对象
@property (nonatomic, weak) id <VHFashionStyleInteractViewDelegate> delegate;
/// 互动SDK
@property (nonatomic, strong) VHRoom * inavRoom;
/// 本地视频view
@property (nonatomic, strong) VHLocalRenderView * localRenderView;

/// 退出互动房间
@property (nonatomic, copy) ClickLeave clickLeave;

/// 上麦推流
- (void)enterRoomPublish;

/// 下麦并退出互动房间
- (void)leave;

@end

NS_ASSUME_NONNULL_END
