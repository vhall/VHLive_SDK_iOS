//
//  WatchPlayBackViewController.h
//  VHallSDKDemo
//
//  Created by developer_k on 16/4/12.
//  Copyright © 2016年 vhall. All rights reserved.
//
//看回放
#import <UIKit/UIKit.h>
#import "VHBaseViewController.h"

@interface WatchPlayBackViewController : VHBaseViewController

@property(nonatomic,copy)NSString       *roomId;
@property(nonatomic,copy)NSString       *kValue;
@property(nonatomic,copy)NSString * k_id;   //活动维度下k值的唯一ID
@property(nonatomic,assign)NSInteger    timeOut;

@end
