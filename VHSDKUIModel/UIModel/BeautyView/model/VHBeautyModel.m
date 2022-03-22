//
//  VHBeautyModel.m
//  UIModel
//
//  Created by jinbang.li on 2022/2/17.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHBeautyModel.h"

@implementation VHBeautyModel

-(void)encodeWithCoder:(NSCoder *)aCoder
{
//         NSLog(@"调用了encodeWithCoder:方法");
//    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.effectName forKey:@"effectName"];
//    [aCoder encodeObject:self.icon forKey:@"icon"];
    [aCoder encodeFloat:self.currentValue forKey:@"currentValue"];
    [aCoder encodeFloat:self.defaultValue forKey:@"defaultValue"];
    [aCoder encodeFloat:self.minValue forKey:@"minValue"];
    [aCoder encodeFloat:self.maxValue forKey:@"maxValue"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
//     NSLog(@"调用了initWithCoder:方法");
     //注意：在构造方法中需要先初始化父类的方法
     if (self=[super init]) {
//             self.name = [aDecoder decodeObjectForKey:@"name"];
             self.effectName = [aDecoder decodeObjectForKey:@"effectName"];
//             self.icon = [aDecoder decodeObjectForKey:@"icon"];
             self.defaultValue = [aDecoder decodeFloatForKey:@"defaultValue"];
            self.currentValue = [aDecoder decodeFloatForKey:@"currentValue"];
           self.minValue = [aDecoder decodeFloatForKey:@"minValue"];
           self.maxValue = [aDecoder decodeFloatForKey:@"maxValue"];
         }
     return self;
 }
@end
