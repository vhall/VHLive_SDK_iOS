//
//  VHLotteryListModel.h
//  VHallSDK
//
//  Created by 郭超 on 2022/8/31.
//  Copyright © 2022 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VHLotteryModel;

NS_ASSUME_NONNULL_BEGIN

// 抽奖列表
@interface VHLotteryListModel : NSObject

@property (nonatomic, strong) NSArray <VHLotteryModel *> *listModel;

+ (VHLotteryListModel *)fetchLotteryList:(NSArray *)lotteryList;

@end

// 抽奖详情
@interface VHLotteryModel : NSObject
@property (nonatomic, copy, readonly) id award_snapshoot;           ///<奖品快照
@property (nonatomic, copy, readonly) NSString *title;              ///<抽奖标题
@property (nonatomic, copy, readonly) NSString *created_at;         ///<创建时间
@property (nonatomic, copy, readonly) NSString *icon;               ///<图标地址
@property (nonatomic, copy, readonly) NSString *img_order;          ///<抽奖动图下标
@property (nonatomic, copy, readonly) NSString *remark;             ///<本次抽奖说明
@property (nonatomic, copy, readonly) NSString *lottery_id;         ///<抽奖id
@property (nonatomic, assign, readonly) BOOL win;                   ///<已中奖
@property (nonatomic, assign, readonly) BOOL take_award;            ///<已领奖
@property (nonatomic, assign, readonly) BOOL need_take_award;       ///<是否需要领奖
@property (nonatomic, assign, readonly) BOOL publish_winner;        ///<是否显示中奖名单
@end


NS_ASSUME_NONNULL_END
