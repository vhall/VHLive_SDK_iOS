////
////  LBLelinkKitManager.h
////  LBLelinkKitSample
////
////  Created by 刘明星 on 2018/8/21.
////  Copyright © 2018 深圳乐播科技有限公司. All rights reserved.
////
//
//#import <Foundation/Foundation.h>
//#import <LBLelinkKit/LBLelinkKit.h>
//
//NS_ASSUME_NONNULL_BEGIN
//
//@interface LBLelinkKitManager : NSObject
///** 连接数组 */
//@property (nonatomic, strong) NSMutableArray *lelinkConnections;
///** 当前连接 */
//@property (nonatomic, strong) LBLelinkConnection *currentConnection;
///** 播放器 */
//@property (nonatomic, strong) LBLelinkPlayer *lelinkPlayer;
//
///** 当前播放状态 */
//@property (nonatomic, assign, readonly) LBLelinkPlayStatus currentPlayStatus;
//
//+ (instancetype)sharedManager;
//
///**
// 搜索设备
// */
//- (void)search;
//
///**
// 从乐播投屏TV端APP的首页上扫码二维码搜索设备
//
// @param value 二维码字符串值
// @param errPtr 错误指针
// @return 结果返回，YES代表从二维码搜索成功，NO代表失败
// */
//- (BOOL)searchFromQRCodeValue:(NSString *)value onError:(NSError **)errPtr;
//- (void)stopSearch;
//
///**
// 关闭设备列表时调用方法
// */
//- (void)reportSerivesListViewDisappear;
//
//@end
//
///** 设备变化通知 */
//extern NSString * const LBLelinkKitManagerServiceDidChangeNotification;
//
///** 连接成功通知 */
//extern NSString * const LBLelinkKitManagerConnectionDidConnectedNotification;
///** 连接断开通知 */
//extern NSString * const LBLelinkKitManagerConnectionDisConnectedNotification;
//
///** 播放状态通知 */
//extern NSString * const LBLelinkKitManagerPlayerStatusNotification;
///** 播放进度通知 */
//extern NSString * const LBLelinkKitManagerPlayerProgressNotification;
///** 播放错误通知 */
//extern NSString * const LBLelinkKitManagerPlayerErrorNotification;
//
//NS_ASSUME_NONNULL_END
