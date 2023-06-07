//
//  VHallRawBaseModel.h
//  VHallSDK
//
//  Created by 郭超 on 2022/8/5.
//  Copyright © 2022 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VHallRawBaseModel : NSObject

@property (nonatomic, strong) NSDictionary *responseObject;

- (instancetype)initWithResponseObject:(NSDictionary *)responseObject;

@end
