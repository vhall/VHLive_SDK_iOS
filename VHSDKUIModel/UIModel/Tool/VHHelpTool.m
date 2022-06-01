//
//  VHHelpTool.m
//  UIModel
//
//  Created by jinbang.li on 2022/5/12.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHHelpTool.h"
#import "VHPrivacyManager.h"
static NSString *upMicroAuthErrorTip = @"只有获取摄像头和麦克风权限后，才能参与连麦";
static NSString *liveAuthErrorTip = @"直播需要允许访问您的摄像头和麦克风权限";
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
+ (void)getMediaAccess:(void(^_Nullable)(BOOL videoAccess,BOOL audioAcess))completionBlock {
    __block BOOL videoAccess = NO;
    __block BOOL audioAccess = NO;
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        //相机权限
        [VHPrivacyManager openCaptureDeviceServiceWithBlock:^(BOOL isOpen) {
            NSLog(@"相机权限：%d",isOpen);
            videoAccess = isOpen;
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        dispatch_group_enter(group);
        //麦克风权限
        [VHPrivacyManager openRecordServiceWithBlock:^(BOOL isOpen) {
            NSLog(@"麦克风权限：%d",isOpen);
            audioAccess = isOpen;
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (videoAccess && audioAccess) {
            completionBlock ? completionBlock(videoAccess,audioAccess) : nil;
        }else{
            [self shwoMediaAuthorityAlertWithMessage:upMicroAuthErrorTip];
        }
       
    });
}

//弹出媒体权限提示
+ (void)shwoMediaAuthorityAlertWithMessage:(NSString *)string {
    [VHAlertView showAlertWithTitle:string content:nil cancelText:nil cancelBlock:nil confirmText:@"去设置" confirmBlock:^{
        // 去设置界面
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
}
#pragma mark ---直播权限检查
+ (void)liveGetMediaAccess:(void(^_Nullable)(BOOL videoAccess,BOOL audioAcess))completionBlock{
    __block BOOL videoAccess = NO;
    __block BOOL audioAccess = NO;
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        //相机权限
        [VHPrivacyManager openCaptureDeviceServiceWithBlock:^(BOOL isOpen) {
            NSLog(@"相机权限：%d",isOpen);
            videoAccess = isOpen;
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        dispatch_group_enter(group);
        //麦克风权限
        [VHPrivacyManager openRecordServiceWithBlock:^(BOOL isOpen) {
            NSLog(@"麦克风权限：%d",isOpen);
            audioAccess = isOpen;
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (videoAccess && audioAccess) {
            completionBlock ? completionBlock(videoAccess,audioAccess) : nil;
        }else{
            [self shwoMediaAuthorityAlertWithMessage:liveAuthErrorTip];
        }
       
    });
}
@end
