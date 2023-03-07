//
//  VHAnnouncementView.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/19.
//

#import <UIKit/UIKit.h>

@interface VHAnnouncementView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

/// 开始动画
/// - Parameter content: 详情
/// - Parameter view: 父view
- (void)startAnimationWithContent:(NSString*)content pushTime:(NSString*)pushTime duration:(NSInteger)duration view:(UIView *)view isFull:(BOOL)isFull;

/// 结束动画
- (void)endAnimation;

@end
