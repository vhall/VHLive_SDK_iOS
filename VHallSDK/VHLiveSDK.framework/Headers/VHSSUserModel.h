//
//  VHSSUserModel.h
//  VHVss
//
//  Created by xiongchao on 2020/11/17.
//  Copyright © 2020 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface VHSSUserModel : NSObject
/** token */
@property (nonatomic, copy) NSString *token;
/** app老接口token */
@property (nonatomic, copy) NSString *o_token;
/** 头像 */
@property (nonatomic, copy) NSString *avatar;
/** 昵称 */
@property (nonatomic, copy) NSString *nick_name;
/** 账号 */
@property (nonatomic, copy) NSString *name;
/** 手机号 */
@property (nonatomic, copy) NSString *phone;
/** 用户id */
@property (nonatomic, copy) NSString *user_id;

///是否跳转化蝶
@property (nonatomic, assign) BOOL is_jump_hd;

- (instancetype)initWithDic:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
