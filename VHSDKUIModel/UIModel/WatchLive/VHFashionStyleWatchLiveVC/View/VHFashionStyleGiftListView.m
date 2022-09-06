//
//  VHFashionStyleGiftListView.m
//  UIModel
//
//  Created by 郭超 on 2022/7/27.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHFashionStyleGiftListView.h"

@implementation VHFashionStyleGiftListCell

- (void)dealloc
{
    VHLog(@"%s释放",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String]);
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = 8;
        self.contentView.backgroundColor = [UIColor whiteColor];
                
        [self setMasonryUI];
    }
    return self;
}
- (void)setMasonryUI
{
    [self.giftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(2);
        make.right.mas_equalTo(-2);
        make.bottom.mas_equalTo(-25.5);
    }];
    
    [self.giftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(7.5);
        make.centerX.mas_equalTo(_giftView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_giftImg.mas_bottom).offset(1);
        make.centerX.mas_equalTo(_giftView.mas_centerX);
    }];
    
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(25.5);
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
    }];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - 更改颜色
- (void)setIsSelect:(BOOL)isSelect
{
    _isSelect = isSelect;
    
    self.contentView.backgroundColor = [UIColor colorWithHex:isSelect ? @"#FB2626" : @"#FFFFFF"];
}


#pragma mark - 赋值
- (void)setGiftListItem:(VHallGiftListItem *)giftListItem
{
    _giftListItem = giftListItem;
    
    [_giftImg sd_setImageWithURL:[NSURL URLWithString:giftListItem.image_url]];
    
    _titleLab.text = giftListItem.name;
}

#pragma mark - 点击赠送
- (void)clickSendBtn
{
    if (self.clickSendBtnBlock) {
        self.clickSendBtnBlock();
    }
}
#pragma mark - 懒加载
- (UIView *)giftView
{
    if (!_giftView) {
        _giftView = [UIView new];
        _giftView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_giftView];
    }return _giftView;
}
- (UIImageView *)giftImg
{
    if (!_giftImg) {
        _giftImg = [UIImageView new];
        [self.giftView addSubview:_giftImg];
    }return _giftImg;
}

- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.textColor = [UIColor colorWithHex:@"#000000"];
        _titleLab.font = FONT_FZZZ(9);
        [self.giftView addSubview:_titleLab];
    }return _titleLab;
}

- (UIButton *)sendBtn
{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.titleLabel.font = FONT_FZZZ(12);
        [_sendBtn setTitle:@"赠送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(clickSendBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_sendBtn];
    }return _sendBtn;
}

@end

@interface VHFashionStyleGiftListView ()<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate>

/// 活动详情
@property (nonatomic, strong) VHWebinarInfo * webinarInfo;

/// 容器
@property (nonatomic, strong) UIView *              contentView;
/// 分割线
@property (nonatomic, strong) UIView *              lineView;
/// 关闭按钮
@property (nonatomic, strong) UIButton *            closeBtn;
/// 列表
@property (nonatomic, strong) UICollectionView *    collectionView;
/// 数据
@property (nonatomic, strong) NSMutableArray *      dataSource;
/// 选中的index
@property (nonatomic, assign) NSInteger             isSelectIndex;

@end

@implementation VHFashionStyleGiftListView


- (instancetype)init
{
    if ([super init]) {
        
        self.alpha = 0;

        self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.7];
        
        self.isSelectIndex = 9999;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];

        // 添加控件
        [self addViews];

    }return self;
}
#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isEqual:self]) {
        return YES;
    }else{
        return NO;
    }
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
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(305+VH_KBottomSafeMargin);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(51);
        make.height.mas_equalTo(1);
        make.left.right.mas_equalTo(0);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_lineView.mas_top).offset(-11.5);
        make.right.mas_equalTo(-16);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_lineView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-VH_KBottomSafeMargin);
    }];
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [UIModelTools clipView:_contentView corner:UIRectCornerTopLeft | UIRectCornerTopRight anSize:CGSizeMake(8, 8)];
}
#pragma mark - 请求礼物列表
- (void)requestWebinarUsingGiftListWithRoomId
{
    @weakify(self);
    [VHallGiftObject webinarUsingGiftListWithRoomId:self.webinarInfo.data[@"interact"][@"room_id"] complete:^(NSArray<VHallGiftListItem *> * _Nonnull giftList, NSError * _Nonnull error) {
        @strongify(self);
        if (giftList) {
            self.dataSource = [NSMutableArray arrayWithArray:giftList];
            [self.collectionView reloadData];
        }
        
        if (error) {
            VH_ShowToast(error.localizedDescription);
        }
    }];
}

#pragma mark - 展示礼物列表
- (void)showGiftToWebinarInfo:(VHWebinarInfo *)webinarInfo
{
    self.webinarInfo = webinarInfo;
    
    [self requestWebinarUsingGiftListWithRoomId];
    
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {

    }];
}

#pragma mark - 关闭计时器
- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - UICollectionViewDelegate
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
    VHFashionStyleGiftListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VHFashionStyleGiftListCell" forIndexPath:indexPath];
    cell.giftListItem = self.dataSource[indexPath.row];
    if (indexPath.row == self.isSelectIndex) {
        cell.isSelect = YES;
    }else{
        cell.isSelect = NO;
    }
    @weakify(self);
    cell.clickSendBtnBlock = ^{
        @strongify(self);
        self.isSelectIndex = indexPath.row;
        [collectionView reloadData];
        
        VHallGiftListItem * giftItem = self.dataSource[indexPath.row];
        [VHallGiftObject sendGiftWithRoomId:self.webinarInfo.data[@"interact"][@"room_id"] channel:@"WEIXIN" service_code:@"QR_PAY" giftItem:giftItem complete:^(VHallSendGiftModel * _Nonnull sendGiftModel, NSError * _Nonnull error) {
            if (sendGiftModel) {
                NSString * giftname = [NSString stringWithFormat:@"赠送成功%@",sendGiftModel.name];
                VH_ShowToast(giftname);
            }
            if (error) {
                VH_ShowToast(error.localizedDescription);
            }
        }];
        [self dismiss];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.isSelectIndex = indexPath.row;
    [collectionView reloadData];
}
#pragma mark - 懒加载
- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
    }return _contentView;
}
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor colorWithHex:@"#FBF2F2"];
        [self.contentView addSubview:_lineView];
    }return _lineView;
}
- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:BundleUIImage(@"关闭") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_closeBtn];
    }return _closeBtn;
}
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, 25.5, 0, 25.5);
        layout.itemSize = CGSizeMake(80, 110);
        layout.minimumLineSpacing = 17.5;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, VHScreenWidth, 253) collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[VHFashionStyleGiftListCell class] forCellWithReuseIdentifier:@"VHFashionStyleGiftListCell"];
        [self.contentView addSubview:_collectionView];
    }return _collectionView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }return _dataSource;
}
@end
