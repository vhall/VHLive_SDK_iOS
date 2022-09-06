//
//  VHFashionStyleInteractCollectionView.h
//  UIModel
//
//  Created by 郭超 on 2022/8/2.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VHInteractive/VHRoom.h>
#import "VHLiveMemberModel.h"

@interface VHFashionStyleInteractCollectionCell : UICollectionViewCell

/** 成员模型 */
@property (nonatomic, strong) VHLiveMemberModel *model;

@end


@interface VHFashionStyleInteractCollectionView : UIView

/// 数据
@property (nonatomic, strong , readonly) NSMutableArray <VHLiveMemberModel *> *dataSource;

/// 当前主讲人（具有文档操作权限）的用户id (会随主讲人改变，实时更新)
@property (nonatomic, copy) NSString * mainSpeakerId;

/// 重新刷新collectionView数据
- (void)reloadAllData;

/// 上麦添加视频画面
- (void)addAttendWithUser:(VHLiveMemberModel *)model;

/// 下麦移除视频画面
- (void)removeAttendView:(VHLocalRenderView *)renderView;

/// 某个视频摄像头开关改变
- (void)renderView:(VHRenderView *)renderView closeCamera:(BOOL)state;
/// 某个视频麦克风开关改变
- (void)renderView:(VHRenderView *)renderView closeMicrophone:(BOOL)state;

/// 某个用户摄像头开关改变
- (void)targerId:(NSString *)targerId closeCamera:(BOOL)state;
/// 某个用户麦克风开关改变
- (void)targerId:(NSString *)targerId closeMicrophone:(BOOL)state;

/// 某个用户是否在麦上
- (BOOL)haveRenderViewWithTargerId:(NSString *)targerId;

/// 获取连麦用户列表
- (NSMutableArray<VHLiveMemberModel *> *)getMicUserList;

@end

