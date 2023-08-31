//
//  NSObject+VHRunTime.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/8/11.
//

#import <Foundation/Foundation.h>

@interface NSObject (VHRunTime)
//获取对象所有的属性
- (NSArray *)getPropertylist;

//获取对象所有属性及属性的值  key(属性)=value(值)
- (NSArray <NSDictionary *>*)getPropertyAndValueList;

//获取对象所有的方法
- (NSArray *)getMethodlist;

//获取对象所有的成员变量
- (NSArray *)getIvarlist;

@end
