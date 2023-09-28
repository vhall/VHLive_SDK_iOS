//
//  VHPublishToolView.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/4/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ClickOpenBeauty)(BOOL isSelect);
typedef void (^ClickMirror)(BOOL mirror);
typedef void (^ClickCamera)(BOOL isSelect);
typedef void (^ClickMic)(BOOL isSelect);
typedef void (^ClickPlay)(BOOL isSelect);

@interface VHPublishToolView : UIView

/// 网速
@property (nonatomic, strong) UILabel *kbpsLab;

@property (nonatomic, copy) ClickOpenBeauty clickOpenBeauty;
@property (nonatomic, copy) ClickMirror clickMirror;
@property (nonatomic, copy) ClickCamera clickCamera;
@property (nonatomic, copy) ClickMic clickMic;
@property (nonatomic, copy) ClickPlay clickPlay;

@end

NS_ASSUME_NONNULL_END
