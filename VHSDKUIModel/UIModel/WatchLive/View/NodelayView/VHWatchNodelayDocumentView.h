//
//  VHWatchNodelayDocumentView.h
//  UIModel
//
//  Created by xiongchao on 2021/10/29.
//  Copyright © 2021 www.vhall.com. All rights reserved.
//
//无延迟观看，文档容器
#import <UIKit/UIKit.h>
#import <VHLiveSDK/VHDocument.h>

NS_ASSUME_NONNULL_BEGIN
@protocol VHWatchNodelayDocumentViewDelegate <NSObject>
- (void)nodelayDidChangeDocument;
@end
@interface VHWatchNodelayDocumentView : UIView
@property (nonatomic, weak) id<VHWatchNodelayDocumentViewDelegate> delegate;
@property (nonatomic) VHDocWatermarkModel *watermark;
//设置文档对象和初始显示
- (void)setDocument:(VHDocument *)document defaultShow:(BOOL)show;

@end

NS_ASSUME_NONNULL_END
