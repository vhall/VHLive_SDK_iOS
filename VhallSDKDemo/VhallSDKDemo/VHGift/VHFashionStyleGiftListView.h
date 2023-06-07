//
//  VHFashionStyleGiftListView.h
//  UIModel
//
//  Created by 郭超 on 2022/7/27.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^ClickSendBtnBlock)(void);

@interface VHFashionStyleGiftListCell : UICollectionViewCell

/// 是否选中
@property (nonatomic, assign) BOOL isSelect;
/// 白色背景
@property (nonatomic, strong) UIView *giftView;
/// 礼物图片
@property (nonatomic, strong) UIImageView *giftImg;
/// 标题
@property (nonatomic, strong) UILabel *titleLab;
/// 发送按钮
@property (nonatomic, strong) UIButton *sendBtn;

/// 数据model
@property (nonatomic, strong) VHallGiftListItem *giftListItem;

/// 点击发送回调
@property (nonatomic, copy) ClickSendBtnBlock clickSendBtnBlock;
@end

@interface VHFashionStyleGiftListView : UIView

/// 展示礼物列表
- (void)showGiftToWebinarInfoData:(VHWebinarInfoData *)webinarInfoData;

/// 关闭计时器
- (void)dismiss;

@end
