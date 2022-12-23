//
//  GLEnvsCustomController.h
//  AFNetworking
//
//  Created by liguoliang on 2019/6/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLEnvsCustomController : UITableViewController
@property (nonatomic, strong) NSMutableDictionary *data;
@property (nonatomic, strong) void (^handleSave)(NSDictionary *newdata);
@end

NS_ASSUME_NONNULL_END
