//
//  VHHelpTool.h
//  UIModel
//
//  Created by jinbang.li on 2022/5/12.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VHLiveSDK/VHallApi.h>
NS_ASSUME_NONNULL_BEGIN

@interface VHHelpTool : NSObject
///聊天是否过滤私聊
+ (NSMutableArray <VHallChatModel *>*)filterPrivateMsgCurrentUserId:(NSString *)currentUserId origin:(NSArray <VHallChatModel *>*)msgs isFilter:(BOOL)isFilter half:(BOOL)half;
///互动麦克风和相机权限
+ (void)getMediaAccess:(void(^_Nullable)(BOOL videoAccess,BOOL audioAcess))completionBlock;
///直播麦克风和相机权限
+ (void)liveGetMediaAccess:(void(^_Nullable)(BOOL videoAccess,BOOL audioAcess))completionBlock;
@end

NS_ASSUME_NONNULL_END
