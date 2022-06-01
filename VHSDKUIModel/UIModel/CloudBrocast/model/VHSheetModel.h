//
//  VHSheetModel.h
//  VhallLive
//
//  Created by jinbang.li on 2022/4/6.
//  Copyright © 2022 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VHSheetModel : NSObject
///单元格显示名字
@property (nonatomic,copy) NSString *name;
//1是云导播已开启，2是云导播未开启   1是机位已占用 2是机位可用 3-选择的机位
@property (nonatomic,copy) NSString *configValue;
//机位id
@property (nonatomic,copy) NSString *seat_id;
//机位状态
@property (nonatomic) NSInteger  status;
@end

NS_ASSUME_NONNULL_END
