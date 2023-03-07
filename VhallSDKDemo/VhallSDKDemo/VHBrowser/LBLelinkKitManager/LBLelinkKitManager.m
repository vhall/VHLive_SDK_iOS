////
////  LBLelinkKitManager.m
////  LBLelinkKitSample
////
////  Created by 刘明星 on 2018/8/21.
////  Copyright © 2018 深圳乐播科技有限公司. All rights reserved.
////
//
//#import "LBLelinkKitManager.h"
//
///** 服务变化通知 */
//NSString * const LBLelinkKitManagerServiceDidChangeNotification = @"LBLelinkKitManagerServiceDidChangeNotification";
//
///** 连接和断开连接通知 */
//NSString * const LBLelinkKitManagerConnectionDidConnectedNotification = @"LBLelinkKitManagerConnectionDidConnectedNotification";
//NSString * const LBLelinkKitManagerConnectionDisConnectedNotification = @"LBLelinkKitManagerConnectionDisConnectedNotification";
//
///** 播放状态相关通知 */
//NSString * const LBLelinkKitManagerPlayerStatusNotification = @"LBLelinkKitManagerPlayerStatusNotification";
//NSString * const LBLelinkKitManagerPlayerProgressNotification = @"LBLelinkKitManagerPlayerProgressNotification";
//NSString * const LBLelinkKitManagerPlayerErrorNotification = @"LBLelinkKitManagerPlayerErrorNotification";
//
//@interface LBLelinkKitManager ()<LBLelinkBrowserDelegate, LBLelinkConnectionDelegate, LBLelinkPlayerDelegate>
//
//@property (nonatomic, strong) LBLelinkBrowser *lelinkBrowser;
//
//@property (nonatomic, assign) LBLelinkPlayStatus currentPlayStatus;
//
//@end
//
//@implementation LBLelinkKitManager
//
//+ (instancetype)sharedManager {
//    static id _sharedInstance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _sharedInstance = [[self alloc] init];
//    });
//    return _sharedInstance;
//}
//
//#pragma mark - API
//
//- (void)search {
//    [self.lelinkBrowser searchForLelinkService];
//}
//
//- (BOOL)searchFromQRCodeValue:(NSString *)value onError:(NSError **)errPtr {
//    return [self.lelinkBrowser searchForLelinkServiceFormQRCode:value onError:errPtr];
//}
//
//- (void)stopSearch {
//    [self.lelinkBrowser stop];
//}
//
//#pragma mark - LBLelinkBrowserDelegate
//- (void)lelinkBrowser:(LBLelinkBrowser *)browser onError:(NSError *)error {
//    NSLog(@"搜索错误 %@", error);
//    /**
//     注意：如有需要，通知更新UI
//     */
//}
//
//- (void)lelinkBrowser:(LBLelinkBrowser *)browser didFindLelinkServices:(NSArray<LBLelinkService *> *)services {
//    NSLog(@"发现设备 %lu NSThread:%@",(unsigned long)services.count,[NSThread currentThread]);
//    if (services == nil) {
//        return;
//    }
//    
//    /**
//     遍历services，使用services中的lelinkService创建lelinkConnection，并添加到self.lelinkConnections中
//     注意去重，如果有，则不重复创建
//     */
//    for (LBLelinkService * lelinkService in services) {
//        if (self.lelinkConnections.count > 0) {
//            BOOL containThisService = NO;
//            for (LBLelinkConnection * lelinkConnection in self.lelinkConnections) {
//                if ([lelinkService isEqual:lelinkConnection.lelinkService]) {
//                    containThisService = YES;
//                    NSLog(@"包含 %@ %@ %@",lelinkService.lelinkServiceName, lelinkService,lelinkConnection.lelinkService);
//                    break;
//                }
//            }
//            if (!containThisService) {
//                LBLelinkConnection * lelinkConnection = [[LBLelinkConnection alloc] initWithLelinkService:lelinkService delegate:self];
//                [self.lelinkConnections addObject:lelinkConnection];
//            }
//        }else{
//            LBLelinkConnection * lelinkConnection = [[LBLelinkConnection alloc] initWithLelinkService:lelinkService delegate:self];
//            [self.lelinkConnections addObject:lelinkConnection];
//        }
//    }
//    NSLog(@"%lu", self.lelinkConnections.count);
//    
//    /**
//     遍历self.lelinkConnections，如果其中的lelinkConnection.lelinkService不包含在services中，并且lelinkConnection的处于未连接状态，则将lelinkConnection从self.lelinkConnections中移除
//     */
//    NSMutableArray * tempArr = [NSMutableArray array];
//    for (LBLelinkConnection * lelinkConnection in self.lelinkConnections) {
//        if (services.count == 0) {
//            if (!lelinkConnection.isConnected) {
//                [tempArr addObject:lelinkConnection];
//            }
//        }else{
//            BOOL has = NO;
//            for (LBLelinkService * lelinkService in services) {
//                if ([lelinkService isEqualToLelinkService:lelinkConnection.lelinkService]) {
//                    has = YES;
//                    break;
//                }
//            }
//            if (!has && !lelinkConnection.isConnected) {
//                [tempArr addObject:lelinkConnection];
//            }
//        }
//    }
//    for (LBLelinkConnection * connection in tempArr) {
//        [self.lelinkConnections removeObject:connection];
//    }
//    
//    NSLog(@"%lu", self.lelinkConnections.count);
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:LBLelinkKitManagerServiceDidChangeNotification object:nil];
//
//}
//
//#pragma mark - LBLelinkConnectionDelegate
//- (void)lelinkConnection:(LBLelinkConnection *)connection onError:(NSError *)error {
//    NSLog(@"连接错误 %@",error);
//    /**
//     注意：如有需要，则通知更新UI
//     */
//}
//
//- (void)lelinkConnection:(LBLelinkConnection *)connection didConnectToService:(LBLelinkService *)service {
//    NSLog(@"连接到设备 %@",service.lelinkServiceName);
//    /**
//     注意：如有需要，则通知更新UI
//     */
//    [[NSNotificationCenter defaultCenter] postNotificationName:LBLelinkKitManagerConnectionDidConnectedNotification object:nil userInfo:@{@"connection":connection}];
//}
//
//- (void)lelinkConnection:(LBLelinkConnection *)connection disConnectToService:(LBLelinkService *)service {
//    NSLog(@"%@ 断开连接",service.lelinkServiceName);
//    /**
//     断开连接，需要判断，service是否在self.lelinkBrowser.lelinkServices中，
//     如果不在，则需要将connection从self.lelinkConnections中移除
//     注意：如有需要，则通知更新UI
//     */
//    if (![self.lelinkBrowser.lelinkServices containsObject:service]) {
//        if ([self.lelinkConnections containsObject:connection]) {
//            [self.lelinkConnections removeObject:connection];
//        }
//    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:LBLelinkKitManagerConnectionDisConnectedNotification object:nil userInfo:@{@"connection":connection}];
//}
//
//#pragma mark - LBLelinkPlayerDelegate
//
//- (void)lelinkPlayer:(LBLelinkPlayer *)player onError:(NSError *)error {
//    NSLog(@"播放错误 %@",error);
//    [[NSNotificationCenter defaultCenter] postNotificationName:LBLelinkKitManagerPlayerErrorNotification object:nil userInfo:@{@"error":error}];
//}
//
//- (void)lelinkPlayer:(LBLelinkPlayer *)player playStatus:(LBLelinkPlayStatus)playStatus {
//    NSLog(@"播放状态 %lu", (unsigned long)playStatus);
//    self.currentPlayStatus = playStatus;
//    [[NSNotificationCenter defaultCenter] postNotificationName:LBLelinkKitManagerPlayerStatusNotification object:nil userInfo:@{@"playStatus":[NSNumber numberWithInteger:playStatus]}];
//    
//}
//
//- (void)lelinkPlayer:(LBLelinkPlayer *)player progressInfo:(LBLelinkProgressInfo *)progressInfo {
//    NSLog(@"播放进度 总时长：%ld, 当前播放位置：%ld",(long)progressInfo.duration, (long)progressInfo.currentTime);
//    [[NSNotificationCenter defaultCenter] postNotificationName:LBLelinkKitManagerPlayerProgressNotification object:nil userInfo:@{@"progressInfo":progressInfo}];
//}
//
//#pragma mark - method
//- (void)reportSerivesListViewDisappear {
//    [self.lelinkBrowser reportServiceListDisappear];
//}
//
//#pragma mark - setter & getter
//
//- (LBLelinkBrowser *)lelinkBrowser{
//    if (_lelinkBrowser == nil) {
//        _lelinkBrowser = [[LBLelinkBrowser alloc] init];
//        _lelinkBrowser.delegate = self;
//        
//    }
//    return _lelinkBrowser;
//}
//
//- (void)setCurrentConnection:(LBLelinkConnection *)currentConnection {
//    _currentConnection = currentConnection;
//    /** 在重设currentConnection时一定要重新设置lelinkPlayer的lelinkConnection属性 */
//    self.lelinkPlayer.lelinkConnection = currentConnection;
//}
//
//- (LBLelinkPlayer *)lelinkPlayer{
//    if (_lelinkPlayer == nil) {
//        _lelinkPlayer = [[LBLelinkPlayer alloc] initWithConnection:self.currentConnection];
//        _lelinkPlayer.delegate = self;
//    }
//    return _lelinkPlayer;
//}
//
//- (NSMutableArray *)lelinkConnections{
//    if (_lelinkConnections == nil) {
//        _lelinkConnections = [NSMutableArray array];
//    }
//    return _lelinkConnections;
//}
//
//@end
