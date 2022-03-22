//
//  VHChangeSegmentView.h
//  UIModel
//
//  Created by jinbang.li on 2022/2/28.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^btnClickBlock)(NSInteger index);
NS_ASSUME_NONNULL_BEGIN

@interface VHChangeSegmentView : UIView
/**
 *  未选中时的文字颜色,默认黑色
 */
@property (nonatomic,strong) UIColor *titleNomalColor;

/**
 *  选中时的文字颜色,默认红色
 */
@property (nonatomic,strong) UIColor *titleSelectColor;

/**
 *  字体大小，默认15
 */
@property (nonatomic,strong) UIFont  *titleFont;

/**
 *  默认选中的index=1，即第一个
 */
@property (nonatomic,assign) NSInteger defaultIndex;

/**
 *  点击后的block
 */
@property (nonatomic,copy)btnClickBlock block;

/**
 *  初始化方法
 *
 *  @param frame      frame
 *  @param titleArray 传入数组
 *  @param block      点击后的回调
 *
 *  @return
 */
-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titleArray clickBlick:(btnClickBlock)block;

-(void)updateselectLineFrameWithoffset:(CGFloat)offsetx;
@end

NS_ASSUME_NONNULL_END
