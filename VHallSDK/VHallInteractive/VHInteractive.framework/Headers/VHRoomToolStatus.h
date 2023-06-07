//
//  VHRoomToolStatus.h
//  VHallInteractive
//
//  Created by 郭超 on 2022/8/31.
//  Copyright © 2022 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VHSSRoomToolsStatus;

NS_ASSUME_NONNULL_BEGIN

// 互动工具状态
@interface VHRoomToolStatus : NSObject

@property (nonatomic, copy, readonly) NSString *question_name;      ///<问答名字
@property (nonatomic, assign, readonly) BOOL question_status;       ///<问答状态 YES 开启了问答 NO: 关闭了问答

+ (VHRoomToolStatus *)transfer:(VHSSRoomToolsStatus *)roomStatus;

@end


NS_ASSUME_NONNULL_END
