//
//  VHBeautyAdjustController.h
//  UIModel
//
//  Created by jinbang.li on 2022/2/17.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VHBeautyAdjustController : UIViewController
///弹框实时弹出刷新最新值
- (void)refreshEffect:(VHBeautifyKit *)beautyModule;
//横竖屏
@property (nonatomic,assign) BOOL  landscape;
//选择美化类型
@property (nonatomic,assign) BeautyType  beautyType;
//写入缓存数据
- (void)saveBeautyConfigModel;
@end

NS_ASSUME_NONNULL_END
