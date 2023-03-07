//
//  VHDocView.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/14.
//

#import <UIKit/UIKit.h>

@protocol VHDocViewDelegate <NSObject>

/// 切换全屏
- (void)fullWithSelect:(BOOL)isSelect;

@end

@interface VHDocView : UIView<JXCategoryListContentViewDelegate>

@property (nonatomic, weak) id <VHDocViewDelegate> delegate;

/// 添加文档
- (void)addToDocumentView:(UIView *)documentView;

/// 退出全屏
- (void)quitFull;

@end
