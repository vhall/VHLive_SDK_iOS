//
//  VHChatSetting.h
//  VhallSDKDemo
//
//  Created by Vhall on 2026/7/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VHChatSetting : UIView

// 回调定义：传出三个开关状态
typedef void(^VHChatSettingCallback)(BOOL onlyWatchHost, BOOL onlyWatchContext, BOOL hideEffect);
@property (nonatomic, copy) VHChatSettingCallback callback;

/// 自定义初始化，传入初始状态
- (instancetype)initWithOnlyWatchHost:(BOOL)isOnlyWatchHost showOnlyHost:(BOOL)showOnlyHost showChat:(BOOL)showChat effect:(BOOL)effect;

- (void)show;
@end

NS_ASSUME_NONNULL_END
