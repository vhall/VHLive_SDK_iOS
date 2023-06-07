//
//  VHSignSetVC.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/7.
//

#import "VHBaseViewController.h"

typedef void(^ClickSaveBtn)(void);

@interface VHSignSetVC : VHBaseViewController

@property (nonatomic, copy) ClickSaveBtn clickSaveBtn;

@end
