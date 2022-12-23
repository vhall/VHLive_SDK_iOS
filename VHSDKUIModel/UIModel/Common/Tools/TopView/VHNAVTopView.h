//
//  VHNAVTopView.h
//  UIModel
//
//  Created by 郭超 on 2022/11/22.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickBackBlock)(void);

@interface VHNAVTopView : UIView

@property (nonatomic, strong) UIButton          *   backBtn;            ///<返回按钮
@property (nonatomic, strong) UILabel           *   titleLab;           ///<标题
@property (nonatomic, copy)   ClickBackBlock        clickBackBlock;     ///<回调

@end
