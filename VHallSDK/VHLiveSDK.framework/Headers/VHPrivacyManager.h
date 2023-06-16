//
//  VHPrivacyManager.h
//  NestleHD
//
//  Created by 郭超 on 2020/3/20.
//  Copyright © 2020 vhall. All rights reserved.
//

#import <EventKit/EventKit.h>//日历备忘录
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ReturnBlock)(BOOL isOpen);

@interface VHPrivacyManager : NSObject
//是否开启摄像头
+ (void)openCaptureDeviceServiceWithBlock:(ReturnBlock)returnBlock;
//是否开启麦克风
+ (void)openRecordServiceWithBlock:(ReturnBlock)returnBlock;
// 获取设备权限
+ (void)getMediaAccess:(void (^_Nullable)(BOOL videoAccess, BOOL audioAccess))completionBlock;

//是否开启相册
+ (void)openAlbumServiceWithBlock:(ReturnBlock)returnBlock;

////是否开启定位
//+ (void)openLocationServiceWithBlock:(ReturnBlock)returnBlock;
////是否允许消息推送
//+ (void)openMessageNotificationServiceWithBlock:(ReturnBlock)returnBlock;
////是否开启通讯录
//+ (void)openContactsServiceWithBolck:(ReturnBlock)returnBolck;
////是否开启蓝牙
//+ (void)openPeripheralServiceWithBolck:(ReturnBlock)returnBolck;
////是否开启日历备忘录
//+ (void)openEventServiceWithBolck:(ReturnBlock)returnBolck withType:(EKEntityType)entityType;
////是否开启互联网
//+ (void)openEventServiceWithBolck:(ReturnBlock)returnBolck;
////是否开启健康
//+ (void)openHealthServiceWithBolck:(ReturnBlock)returnBolck;
//// 是否开启Touch ID
//+ (void)openTouchIDServiceWithBlock:(ReturnBlock)returnBlock;
////是否开启Apple Pay
//+ (void)openApplePayServiceWithBlock:(ReturnBlock)returnBlock;
////是否开启语音识别
//+ (void)openSpeechServiceWithBlock:(ReturnBlock)returnBlock;
////是否开启媒体资料库
//+ (void)openMediaPlayerServiceWithBlock:(ReturnBlock)returnBlock;
////是否开启Siri
//+ (void)openSiriServiceWithBlock:(ReturnBlock)returnBlock;

@end

NS_ASSUME_NONNULL_END
