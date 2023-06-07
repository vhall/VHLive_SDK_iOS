//
//  VHCodeVC.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/4/6.
//

#import "VHBaseViewController.h"

typedef void (^ScanSettingWithData)(NSString *appKey, NSString *appSecretKey);

typedef void (^ScanWebianrIDWithData)(NSString *webinarId);

typedef NS_ENUM(NSInteger, VHCodeENUM) {
    VHCodeENUM_Setting   = 0,// 设置界面 appkey sk
    VHCodeENUM_WebinarID = 1 // 首页 活动id
};

@interface VHCodeVC : VHBaseViewController

/// 判断扫描类型
@property (nonatomic, assign) VHCodeENUM codeType;

@property (nonatomic, copy) ScanSettingWithData scanSettingWithData;

@property (nonatomic, copy) ScanWebianrIDWithData scanWebianrIDWithData;

@end
