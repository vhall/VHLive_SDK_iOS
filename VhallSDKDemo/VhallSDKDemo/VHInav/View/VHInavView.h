//
//  VHInavView.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/20.
//

#import <UIKit/UIKit.h>

@interface VHInavCell : UICollectionViewCell

/// 互动画面
@property (nonatomic, strong) VHRenderView * attendView;
/// 关闭摄像头时的头像
@property (nonatomic, strong) UIImageView * headIcon;
/// 昵称
@property (nonatomic, strong) UILabel * nickNameLab;
/// 是否是自己
@property (nonatomic, assign) BOOL isMe;

@end

@protocol VHInavViewDelegate <NSObject>

/// 下麦
- (void)unApplyAction;

/// 退出互动
- (void)errorLeaveInav;

/// 被踢出
- (void)isKickout:(BOOL)isKickout;

/// 退出房间
- (void)leaveRoom;

@end

@interface VHInavView : UIView

/// 代理对象
@property (nonatomic, weak) id <VHInavViewDelegate> delegate;

/// 播放器
@property (nonatomic, strong) VHRoom  * inavRoom;
/// 本地视频view
@property (nonatomic, strong) VHLocalRenderView * localRenderView;

/// 初始化
/// - Parameters:
///   - webinarInfoData: 活动详情
- (instancetype)initWithWebinarInfoData:(VHWebinarInfoData *)webinarInfoData;

/// 进入房间
- (void)enterRoomBtn;

/// 销毁播放器
- (void)destroyMP;

/// 弹出设备权限操作
- (void)clickInavRenderAlertViewIsShow:(BOOL)isShow;

@end

