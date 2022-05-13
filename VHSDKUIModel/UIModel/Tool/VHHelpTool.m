//
//  VHHelpTool.m
//  UIModel
//
//  Created by jinbang.li on 2022/5/12.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHHelpTool.h"

@implementation VHHelpTool
+ (NSMutableArray <VHallChatModel *>*)filterPrivateMsgCurrentUserId:(NSString *)currentUserId origin:(NSArray <VHallChatModel *>*)msgs isFilter:(BOOL)isFilter half:(BOOL)half{
    if (half) {
        //半屏过滤自己
        if (isFilter) {
            //过滤
            NSMutableArray <VHallChatModel *>*filterMsgs = [NSMutableArray array];
            NSUInteger count = msgs.count;
            for (int i = 0; i < count; i++) {
                VHallChatModel *model = msgs[i];
                if (model.privateMsg && ![currentUserId isEqualToString:model.target_id]) {
                    continue;
                }else if ((model.privateMsg && [currentUserId isEqualToString:model.target_id])){
                    //是自己的私聊消息
                    model.text = [NSString stringWithFormat:@"私聊消息---%@",model.text];
                    [filterMsgs addObject:model];
                }
                else{
                    [filterMsgs addObject:model];
                }
            }
            return filterMsgs;
        }else{
            //不过滤
            return msgs;
        }
    }else{
        //全屏私聊全部过滤
        if (isFilter) {
            //过滤
            NSMutableArray <VHallChatModel *>*filterMsgs = [NSMutableArray array];
            NSUInteger count = msgs.count;
            for (int i = 0; i < count; i++) {
                VHallChatModel *model = msgs[i];
                if (model.privateMsg) {
                    continue;
                }else{
                    [filterMsgs addObject:model];
                }
            }
            return filterMsgs;
        }else{
            //不过滤
            return msgs;
        }
    }
}
@end
