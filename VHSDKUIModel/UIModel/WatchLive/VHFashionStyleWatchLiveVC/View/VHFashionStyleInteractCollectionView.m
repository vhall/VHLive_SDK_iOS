//
//  VHFashionStyleInteractCollectionView.m
//  UIModel
//
//  Created by 郭超 on 2022/8/2.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHFashionStyleInteractCollectionView.h"

#define VHFSCVWIDTH VHScreenWidth
#define VHFSCVHEIGHT VHScreenWidth*0.56
#define VHFSCVCELLWIDTH VHScreenWidth/5.5
#define VHFSCVCELLHEIGHT VHScreenWidth/5.5*0.56

@interface VHFashionStyleInteractCollectionCell ()
/// 名字
@property (nonatomic, strong) UILabel *nameLab;
@end

@implementation VHFashionStyleInteractCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithHex:@"#000000"];
        [self configFrame];
    }
    return self;
}
#pragma mark - 约束布局
- (void)configFrame {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
    }];
}
#pragma mark - model数据
- (void)setModel:(VHLiveMemberModel * _Nonnull)model {
    _model = model;
    NSString * nickStr = model.nickname;
    if (nickStr.length > 8) {
        nickStr = [NSString stringWithFormat:@"%@...",[model.nickname substringToIndex:8]];
    }
    self.nameLab.text = nickStr;
    
    VHRenderView *videoView = [self.contentView viewWithTag:1000];
    if(videoView && videoView != model.videoView) {
        [videoView removeFromSuperview];
    }
    videoView.scalingMode = VHRenderViewScalingModeAspectFit;
    model.videoView.tag = 1000;

    [self.contentView insertSubview:model.videoView atIndex:0];
    [model.videoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

#pragma mark - 懒加载
- (UILabel *)nameLab
{
    if (!_nameLab){
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = FONT_FZZZ(8);
        _nameLab.textColor = [UIColor colorWithHex:@"#CCCCCC"];
        _nameLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_nameLab];
    }
    return _nameLab;
}
@end


@interface VHFashionStyleInteractCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

/// 主讲人
@property (nonatomic, strong) UIView * speakerView;
/// 插播/桌面共享
@property (nonatomic, strong) UIView * cutDepSharView;
/// 列表
@property (nonatomic, strong) UICollectionView *    collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout * layout;

/// 数据
@property (nonatomic, strong) NSMutableArray <VHLiveMemberModel *> * dataSource;

/// 总数据
@property (nonatomic, strong) NSMutableArray <VHLiveMemberModel *> * allDataSource;

@end

@implementation VHFashionStyleInteractCollectionView

- (instancetype)init
{
    if ([super init]) {
                
        // 添加控件
        [self addViews];

    }return self;
}

#pragma mark - 添加UI
- (void)addViews
{
    // 初始化UI
    [self masonryUI];
}

#pragma mark - 初始化UI
- (void)masonryUI
{
    [self.speakerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(self).offset(-0.5);
        make.right.mas_equalTo(self).offset(0.5);
        make.height.mas_equalTo(VHFSCVHEIGHT - VHFSCVCELLHEIGHT);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_speakerView.mas_bottom);
        make.left.mas_equalTo(self).offset(-0.5);
        make.right.mas_equalTo(self).offset(0.5);
        make.height.mas_equalTo(VHFSCVCELLHEIGHT);
    }];
    
    [self.cutDepSharView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - 上麦添加视频画面
- (void)addAttendWithUser:(VHLiveMemberModel *)model {
    
    VUI_Log(@"上麦添加视频画面流id:%@",model.videoView.streamId);
    // 所有上麦用户
    [self.allDataSource addObject:model];
    
    // 插播/共享屏幕/主讲人单独view
    if(model.videoView.streamType == VHInteractiveStreamTypeScreen || model.videoView.streamType == VHInteractiveStreamTypeFile) {
        [self reloadCutDepSharView:model];
    }else if (model.haveDocPermission){
        [self reloadSpeakerView:model];
    }else {
        // 防止同一用户视频多次添加
        for(VHLiveMemberModel *memberModel in self.dataSource.reverseObjectEnumerator) {
            if([model.account_id isEqualToString:memberModel.account_id]) {
                [self.dataSource removeObject:memberModel];
            }
        }
        [self addNewUserWithModel:model];
    }
    [self.collectionView reloadData];
}

#pragma mark - 下麦移除视频画面
- (void)removeAttendView:(VHLocalRenderView *)renderView {
    [renderView removeFromSuperview];
    
    // 移除所有上麦指定用户
    for(VHLiveMemberModel *model in self.allDataSource.reverseObjectEnumerator) {
        if([model.account_id isEqualToString:renderView.userId]) {
            VUI_Log(@"移除用户");
            [self.allDataSource removeObject:model];
        }
    }

    // 插播或桌面共享
    if (renderView.streamType == VHInteractiveStreamTypeScreen || renderView.streamType == VHInteractiveStreamTypeFile){
        self.cutDepSharView.hidden = YES;
    }else{
        for(VHLiveMemberModel *model in self.dataSource.reverseObjectEnumerator) {
            if([model.account_id isEqualToString:renderView.userId]) {
                VUI_Log(@"移除用户");
                [self.dataSource removeObject:model];
            }
        }
    }
    [self.collectionView reloadData];
}

#pragma mark - 整理数据
- (void)addNewUserWithModel:(VHLiveMemberModel *)model {
    NSMutableArray *hostArray = [NSMutableArray array];
    NSMutableArray *guestArray = [NSMutableArray array];
    NSMutableArray *assistantArray = [NSMutableArray array];
    NSMutableArray *audienceArray = [NSMutableArray array];
    
    for(int i = 0 ; i < self.dataSource.count ; i++) {
        VHLiveMemberModel *tempModel = self.dataSource[i];
        if(tempModel.role_name == VHLiveRole_Host) { //主持人
            [hostArray addObject:tempModel];
        }else if(tempModel.role_name == VHLiveRole_Guest) { //嘉宾
            [guestArray addObject:tempModel];
        }else if(tempModel.role_name == VHLiveRole_Assistant) { //助理
            [assistantArray addObject:tempModel];
        }else  { //观众
            [audienceArray addObject:tempModel];
        }
    }
    if(model.role_name == VHLiveRole_Host) { //主持人
        [hostArray addObject:model];
    }else if(model.role_name == VHLiveRole_Guest) { //嘉宾
        [guestArray addObject:model];
    }else if(model.role_name == VHLiveRole_Assistant) { //助理
        [assistantArray addObject:model];
    }else { //观众
        [audienceArray addObject:model];
    }
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:hostArray];
    [self.dataSource addObjectsFromArray:guestArray];
    [self.dataSource addObjectsFromArray:assistantArray];
    [self.dataSource addObjectsFromArray:audienceArray];
}

#pragma mark - reloadAllData
- (void)reloadAllData
{
    [self.dataSource removeAllObjects];
    for (VHLiveMemberModel *model in self.allDataSource) {
        // 插播/共享屏幕/主讲人单独view
        if(model.videoView.streamType == VHInteractiveStreamTypeScreen || model.videoView.streamType == VHInteractiveStreamTypeFile) {
            [self reloadCutDepSharView:model];
        }else if (model.haveDocPermission){
            [self reloadSpeakerView:model];
        }else {
            // 防止同一用户视频多次添加
            for(VHLiveMemberModel *memberModel in self.dataSource.reverseObjectEnumerator) {
                if([model.account_id isEqualToString:memberModel.account_id]) {
                    [self.dataSource removeObject:memberModel];
                }
            }
            [self addNewUserWithModel:model];
        }
    }
    [self.collectionView reloadData];
}

#pragma mark - 主讲人单独view
- (void)reloadSpeakerView:(VHLiveMemberModel *)model
{
    VHRenderView *videoView = [self.speakerView viewWithTag:100011];
    if(videoView && videoView != model.videoView) {
        [videoView removeFromSuperview];
    }

    model.videoView.tag = 100011;
    [self.speakerView addSubview:model.videoView];
    [model.videoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_speakerView);
    }];
}
#pragma mark - 插播/共享屏幕
- (void)reloadCutDepSharView:(VHLiveMemberModel *)model
{
    [self addSubview:self.cutDepSharView];
    [self.cutDepSharView setHidden:NO];

    VHRenderView *videoView = [self.speakerView viewWithTag:100012];
    if(videoView && videoView != model.videoView) {
        [videoView removeFromSuperview];
    }

    model.videoView.tag = 100012;
    [self.cutDepSharView addSubview:model.videoView];
    [model.videoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_cutDepSharView);
    }];
}

#pragma mark - 某个用户是否在麦上
- (BOOL)haveRenderViewWithTargerId:(NSString *)targerId {
    __block BOOL have = NO;
    [self.dataSource enumerateObjectsUsingBlock:^(VHLiveMemberModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj.videoView.userId isEqualToString:targerId]) {
            have = YES;
            *stop = YES;
        }
    }];
    return have;
}


#pragma mark - 某个用户摄像头开关改变
- (void)targerId:(NSString *)targerId closeCamera:(BOOL)state {
    for(int i = 0 ; i < self.dataSource.count ; i++) {
        VHLiveMemberModel *model = self.dataSource[i];
        if([model.account_id isEqualToString:targerId]) {
            model.closeCamera = state;
            VHFashionStyleInteractCollectionCell *cell = (VHFashionStyleInteractCollectionCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            cell.model = model;
            break;
        }
    }
}

#pragma mark - 某个用户麦克风开关改变
- (void)targerId:(NSString *)targerId closeMicrophone:(BOOL)state {
    for(int i = 0 ; i < self.dataSource.count ; i++) {
        VHLiveMemberModel *model = self.dataSource[i];
        if([model.account_id isEqualToString:targerId]) {
           // NSLog(@"是否有音频：%zd,是否有视频：%zd,远端流：%@",model.videoView.hasAudio,model.videoView.hasVideo, [model.videoView.remoteMuteStream mj_JSONObject]);
            model.closeMicrophone = state;
            VHFashionStyleInteractCollectionCell *cell = (VHFashionStyleInteractCollectionCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            cell.model = model;
            break;
        }
    }
}

#pragma mark - 某个视频摄像头开关改变
- (void)renderView:(VHRenderView *)renderView closeCamera:(BOOL)state {
    for(int i = 0 ; i < self.dataSource.count ; i++) {
        VHLiveMemberModel *model = self.dataSource[i];
        if(model.videoView == renderView) {
           // NSLog(@"是否有音频：%zd,是否有视频：%zd,远端流：%@",model.videoView.hasAudio,model.videoView.hasVideo, [model.videoView.remoteMuteStream mj_JSONObject]);
            model.closeCamera = state;
            VHFashionStyleInteractCollectionCell *cell = (VHFashionStyleInteractCollectionCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            cell.model = model;
            break;
        }
    }
}

#pragma mark - 某个视频麦克风开关改变
- (void)renderView:(VHRenderView *)renderView closeMicrophone:(BOOL)state {
    for(int i = 0 ; i < self.dataSource.count ; i++) {
        VHLiveMemberModel *model = self.dataSource[i];
        if(model.videoView == renderView) {
            // NSLog(@"是否有音频：%zd,是否有视频：%zd,远端流：%@",model.videoView.hasAudio,model.videoView.hasVideo, [model.videoView.remoteMuteStream mj_JSONObject]);
            model.closeMicrophone = state;
            VHFashionStyleInteractCollectionCell *cell = (VHFashionStyleInteractCollectionCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            cell.model = model;
            break;
        }
    }
}

#pragma mark - 主讲人（具有文档操作权限）视频
- (VHLocalRenderView *)docPermissionVideoView {
    for(VHLiveMemberModel *model in self.dataSource) {
        if(model.haveDocPermission) {
            return model.videoView;
        }
    }
    return nil;
}

#pragma mark - 获取上麦用户列表
- (NSMutableArray *)getMicUserList {
    return self.allDataSource;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VHFashionStyleInteractCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VHFashionStyleInteractCollectionCell" forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.item];
    return cell;
}

#pragma mark - 懒加载
- (UIView *)speakerView
{
    if (!_speakerView) {
        _speakerView = [UIView new];
        [self addSubview:_speakerView];
    }return _speakerView;
}
- (UIView *)cutDepSharView
{
    if (!_cutDepSharView) {
        _cutDepSharView = [UIView new];
        [self addSubview:_cutDepSharView];
    }return _cutDepSharView;
}
- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.itemSize = CGSizeMake(VHFSCVCELLWIDTH, VHFSCVCELLHEIGHT);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[VHFashionStyleInteractCollectionCell class] forCellWithReuseIdentifier:@"VHFashionStyleInteractCollectionCell"];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

- (NSMutableArray<VHLiveMemberModel *> *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }return _dataSource;
}
- (NSMutableArray<VHLiveMemberModel *> *)allDataSource
{
    if (!_allDataSource) {
        _allDataSource = [NSMutableArray array];
    }return _allDataSource;
}
@end
