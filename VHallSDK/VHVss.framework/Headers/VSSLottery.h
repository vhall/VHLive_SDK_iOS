//
//  VSSLottery.h
//  VHallSDK
//
//  Created by vhall on 2019/7/5.
//  Copyright © 2019 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//获奖者
@interface Winner : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *lottery_id;
@property (nonatomic, copy) NSString *lottery_user_avatar;
@property (nonatomic, copy) NSString *lottery_user_id;
@property (nonatomic, copy) NSString *lottery_user_nickname;
@property (nonatomic, copy) NSString *preset;

@end


//抽奖信息
@interface VSSLotteryInfo : NSObject

@property (nonatomic, copy) NSString *room_id;
@property (nonatomic, copy) NSString *lottery_creator_avatar;
@property (nonatomic, copy) NSString *lottery_creator_id;
@property (nonatomic, copy) NSString *lottery_creator_nickname;
@property (nonatomic, copy) NSString *lottery_id;
@property (nonatomic, copy) NSString *lottery_type;
@property (nonatomic, copy) NSString *lottery_status;
@property (nonatomic, copy) NSString *lottery_number;

@property (nonatomic, assign) BOOL isWin;  //自己是否中奖
@property (nonatomic, copy) NSString *win_account; //自己中奖的用户id（自己中奖才有值）

@property (nonatomic, strong) NSArray <__kindof Winner *> *winnersArray;

@end




@protocol VSSLotteryDelegate <NSObject>

@optional
- (void)lotteryStart:(VSSLotteryInfo *)info;

- (void)lotteryEnd:(VSSLotteryInfo *)info;

@end



///VSS抽奖
@interface VSSLottery : NSObject

@property (nonatomic, weak) id <VSSLotteryDelegate> delegate;

@property (nonatomic, strong, nullable) VSSLotteryInfo *curLotteryInfo;

//参与抽奖Api
- (void)vssLotteryWithName:(NSString *)name
                  phoneNum:(NSString *)phone
                   success:(void (^)(NSDictionary *response))success
                   failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
