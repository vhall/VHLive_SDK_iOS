//
//  VHLikeObject.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/16.
//

#import <UIKit/UIKit.h>

@interface VHLikeObject : UIButton

/// 初始化
/// - Parameters:
///   - obj: 对象
///   - webinarInfoData: 房间详情
- (void)requestObject:(NSObject *)obj webinarInfoData:(VHWebinarInfoData *)webinarInfoData;

@end
