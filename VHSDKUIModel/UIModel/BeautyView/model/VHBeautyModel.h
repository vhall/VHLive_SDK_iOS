//
//  VHBeautyModel.h
//  UIModel
//
//  Created by jinbang.li on 2022/2/17.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VHBeautyModel : NSObject<NSCoding>
///特效名字
@property (nonatomic,copy) NSString  *effectName;
///美颜特效名字
@property (nonatomic,copy) NSString *name;
///美颜特效icon
@property (nonatomic,copy) NSString *icon;
///美颜特效调节值
@property (nonatomic,assign) float currentValue;
///默认值
@property (nonatomic,assign) float  defaultValue;
///最小值
@property (nonatomic,assign) float  minValue;
///最大值
@property (nonatomic,assign) float  maxValue;
@end

NS_ASSUME_NONNULL_END
