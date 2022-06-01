//
//  VHSheetActionViewController.h
//  VhallLive
//
//  Created by jinbang.li on 2022/4/6.
//  Copyright © 2022 vhall. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VHSeatModel;
typedef enum : NSUInteger {
    SheetType_BrocastEnabled = 0, //云导播已开启
    SheetType_BrocastDisable = 1,  //云导播未开启
    SheetType_Seat = 2,  //推流选择机位
}SheetType;
@protocol VHSheetActionDelegate <NSObject>

- (void)sheetSelectAction:(NSInteger)selectIndex sheetType:(SheetType)sheetType screenLandsCape:(BOOL)landscape;

@end
NS_ASSUME_NONNULL_BEGIN

@interface VHSheetActionViewController : UIViewController
@property (nonatomic,assign) SheetType  sheetType;//底部弹框
@property(nonatomic,weak)id<VHSheetActionDelegate> delegate;
@property (nonatomic) BOOL  screenLandscape;//横竖屏
@property (nonatomic) NSArray <VHSeatModel *>*seatArray;//机位列表
@property (nonatomic) NSString *webinar_id;//活动id
@end

NS_ASSUME_NONNULL_END

