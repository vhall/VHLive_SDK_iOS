//
//  VHInavRenderAlertView.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/20.
//

#import "VHInavAlertView.h"

typedef void(^ClickCameraAction)(BOOL cameraStatus);
typedef void(^ClickMicAction)(BOOL micStatus);
typedef void(^ClickOverturnAction)(void);
typedef void(^ClickUnApplyAction)(void);

@interface VHInavRenderAlertView : VHInavAlertView

@property (nonatomic, copy) ClickCameraAction cameraAction;

@property (nonatomic, copy) ClickMicAction micAction;

@property (nonatomic, copy) ClickOverturnAction overturnAction;

@property (nonatomic, copy) ClickUnApplyAction unApplyAction;

/// 显示并传递当前摄像头 麦克风状态
- (void)showCameraStatus:(BOOL)cameraStatus micStatus:(BOOL)micStatus isShow:(BOOL)isShow;

@end
