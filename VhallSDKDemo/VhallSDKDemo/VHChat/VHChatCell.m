//
//  VHChatCell.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/13.
//

#import "VHChatCell.h"

@interface VHChatPhotoCollectionCell ()
/// 图片
@property(nonatomic, strong) UIImageView * photoImg;

@end
@implementation VHChatPhotoCollectionCell
#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        //背景色
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];

        self.contentView.layer.cornerRadius = 2;
        self.contentView.layer.masksToBounds = YES;

        [self.contentView addSubview:self.photoImg];

        // 设置约束
        [self setMasonryUI];
    }
    return self;
}
#pragma mark - 设置UI布局
- (void)setMasonryUI
{
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(self);
    }];

    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_photoImg.mas_bottom).priorityHigh();
    }];
    
    self.photoImg.frame = self.contentView.frame;
}

- (void)setIsLeft:(BOOL)isLeft
{
    _isLeft = isLeft;
}

- (void)setImage_url:(NSString *)image_url
{
    _image_url = image_url;
    
    [self.photoImg sd_setImageWithURL:[NSURL URLWithString:image_url] placeholderImage:[UIImage imageNamed:@""]];
}
#pragma mark - 懒加载
- (UIImageView *)photoImg
{
    if (!_photoImg) {
        _photoImg = [UIImageView new];
        _photoImg.contentMode = UIViewContentModeScaleAspectFill;
        _photoImg.layer.cornerRadius = 3;
        _photoImg.layer.masksToBounds = YES;
    }return _photoImg;
}
@end

@interface VHChatCell ()<UICollectionViewDelegate,UICollectionViewDataSource,GKPhotoBrowserDelegate>

/// 头像
@property (nonatomic, strong) UIImageView * headImg;
/// 昵称
@property (nonatomic, strong) UILabel * nickNameLab;
/// 身份
@property (nonatomic, strong) YYLabel * roleNameLab;
/// 时间
@property (nonatomic, strong) UILabel * timeLab;
/// 背景图
@property (nonatomic, strong) UIView * cellBackgroundView;

/// 回复的line
@property (nonatomic, strong) UIView * replyLineView;
/// 回复昵称
@property (nonatomic, strong) UILabel * replyNickNameLab;
/// 回复消息
@property (nonatomic, strong) UILabel * replyMsgLab;
/// 回复图片
@property(nonatomic, strong) UICollectionView * replyCollectionView;
/// 回复图片
@property(nonatomic, strong) NSMutableArray * replyDataSource;

/// 聊天内容
@property (nonatomic, strong) YYLabel * msg;
/// 图片
@property(nonatomic, strong) UICollectionView * collectionView;
/// 图片
@property(nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation VHChatCell

+ (VHChatCell *)createCellWithTableView:(UITableView *)tableView
{
    VHChatCell * cell = [tableView dequeueReusableCellWithIdentifier:@"VHChatCell"];
    if (!cell) {
        cell = [[VHChatCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"VHChatCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //背景色
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
                
        [self.contentView addSubview:self.headImg];
        [self.contentView addSubview:self.nickNameLab];
        [self.contentView addSubview:self.roleNameLab];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.cellBackgroundView];

        [self.cellBackgroundView addSubview:self.replyLineView];
        [self.cellBackgroundView addSubview:self.replyNickNameLab];
        [self.cellBackgroundView addSubview:self.replyMsgLab];
        [self.cellBackgroundView addSubview:self.replyCollectionView];

        [self.cellBackgroundView addSubview:self.msg];
        [self.cellBackgroundView addSubview:self.collectionView];

        // 设置约束
        [self setMasonryUI];
    }
    return self;
}
#pragma mark - 设置约束
- (void)setMasonryUI
{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(self);
    }];
    
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.nickNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImg.mas_top);
        make.left.mas_equalTo(self.headImg.mas_right).offset(8);
    }];
    
    [self.roleNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nickNameLab.mas_centerY);
        make.left.mas_equalTo(self.nickNameLab.mas_right).offset(8);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nickNameLab.mas_centerY);
        make.right.mas_equalTo(-8);
    }];
    
    [self.cellBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nickNameLab.mas_bottom).offset(6);
        make.left.mas_equalTo(self.nickNameLab.mas_left);
        make.right.mas_lessThanOrEqualTo(-12);
    }];
        
    [self.replyNickNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(17);
        make.left.mas_equalTo(self.replyLineView.mas_right).offset(6);
    }];
    
    [self.replyMsgLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.replyNickNameLab.mas_top);
        make.left.mas_equalTo(self.replyNickNameLab.mas_right).offset(6);
        make.right.mas_lessThanOrEqualTo(-8);
    }];
    
    [self.replyCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.replyMsgLab.mas_bottom);
        make.left.mas_equalTo(self.replyNickNameLab.mas_left);
        make.right.mas_lessThanOrEqualTo(self.cellBackgroundView.mas_right);
        
        make.width.mas_equalTo(160 + 12);
        make.height.mas_equalTo(999);
    }];
    
    [self.replyLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.replyNickNameLab.mas_top);
        make.left.mas_equalTo(8);
        make.width.mas_equalTo(3);
        make.bottom.mas_equalTo(self.replyCollectionView.mas_bottom);
    }];
    
    [self.msg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.replyCollectionView.mas_bottom).offset(6.5);
        make.left.mas_equalTo(8);
        make.right.mas_lessThanOrEqualTo(-8);
    }];
        
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.msg.mas_bottom);
        make.left.mas_equalTo(self.msg.mas_left);
        make.right.mas_lessThanOrEqualTo(self.cellBackgroundView.mas_right);
        make.bottom.mas_equalTo(-5).priorityHigh();
        
        make.width.mas_equalTo(160 + 12);
        make.height.mas_equalTo(999);
    }];

    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.cellBackgroundView.mas_bottom);
    }];
}
#pragma mark - 赋值
- (void)setModel:(VHallChatModel *)model
{
    // 头像
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"vh_no_head_icon"]];
    // 昵称
    self.nickNameLab.text = [VUITool substringToIndex:8 text:model.user_name isReplenish:YES];
    // 时间
    self.timeLab.text = [VUITool substringFromIndex:11 text:model.time isReplenish:NO];
    // 身份
    [self changeRoleName:model.role];
    // 回复
    [self isHaveReplyMsg:model];
    // 图片
    [self isChatMsg:model];
}
#pragma mark - 是否有回复消息
- (void)isHaveReplyMsg:(VHallChatModel *)model
{
    self.replyNickNameLab.text = [VUITool substringToIndex:8 text:model.replyMsg.user_name isReplenish:YES];
    self.replyMsgLab.text = model.replyMsg.text;

    self.replyLineView.hidden = !model.replyMsg;
    self.replyNickNameLab.hidden = !model.replyMsg;
    self.replyMsgLab.hidden = !model.replyMsg;
    self.replyCollectionView.hidden = !model.replyMsg;

    if (model.replyMsg) {
        
        [self.msg mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.replyCollectionView.mas_bottom).offset(6.5);
            make.left.mas_equalTo(8);
            make.right.mas_lessThanOrEqualTo(-8);
        }];
    } else {
        
        [self.msg mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.left.mas_equalTo(8);
            make.right.mas_lessThanOrEqualTo(-8);
        }];
    }
    
    // 图片
    [self.replyDataSource removeAllObjects];
    
    if (model.replyMsg.imageUrls.count > 0) {
        
        self.replyDataSource = [NSMutableArray arrayWithArray:model.replyMsg.imageUrls];

        [self.replyCollectionView reloadData];

        CGFloat wid = self.replyDataSource.count * 40 + (self.replyDataSource.count) * 2 + 10;
        if (self.replyDataSource.count > 4) {
            wid = 4 * 40 + 4 * 2 + 10;
        }

        [self.replyCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.replyMsgLab.mas_bottom);
            make.left.mas_equalTo(self.replyNickNameLab.mas_left);
            make.right.mas_lessThanOrEqualTo(self.cellBackgroundView.mas_right);
            
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(ceilf((float)self.replyDataSource.count / 4) * 40);
        }];

    }else{
        
        [self.replyCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.replyMsgLab.mas_bottom);
            make.left.mas_equalTo(self.replyNickNameLab.mas_left);
            make.right.mas_lessThanOrEqualTo(self.cellBackgroundView.mas_right);
            
            make.width.height.mas_equalTo(0);
        }];
    }
}
#pragma mark - 图片
- (void)isChatMsg:(VHallChatModel *)model
{
    // 聊天内容
    NSString * content = [NSString stringWithFormat:@"%@%@",model.replyMsg ? @"回复 " : @"",model.text];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    attributedString.yy_font = FONT(14);
    attributedString.yy_color = [UIColor colorWithHex:@"#262626"];
    if (model.replyMsg) {
        [attributedString yy_setColor:[UIColor colorWithHex:@"#FC9600"] range:[content rangeOfString:@"回复 "]];
    }
    self.msg.attributedText = attributedString;
    
    // 图片
    [self.dataSource removeAllObjects];
    
    if (model.imageUrls.count > 0) {
        
        self.dataSource = [NSMutableArray arrayWithArray:model.imageUrls];

        [self.collectionView reloadData];

        CGFloat wid = self.dataSource.count * 40 + (self.dataSource.count) * 2 + 10;
        if (self.dataSource.count > 4) {
            wid = 4 * 40 + 4 * 2 + 10;
        }
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.msg.mas_bottom);
            make.left.mas_equalTo(self.msg.mas_left);
            make.right.mas_lessThanOrEqualTo(self.cellBackgroundView.mas_right);
            make.bottom.mas_equalTo(-5).priorityHigh();
            
            make.width.mas_equalTo(wid);
            make.height.mas_equalTo(ceilf((float)self.dataSource.count / 4) * 40);
        }];

    }else{
        
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.msg.mas_bottom);
            make.left.mas_equalTo(self.msg.mas_left);
            make.right.mas_lessThanOrEqualTo(self.cellBackgroundView.mas_right);
            make.bottom.mas_equalTo(0).priorityHigh();
            
            make.width.height.mas_equalTo(0);
        }];
    }
}

#pragma mark - 身份转换
- (void)changeRoleName:(NSString *)role_name
{
    // host：主持人 guest：嘉宾 assistant：助手 user：观众
    self.roleNameLab.hidden = NO;

    if ([role_name isEqualToString:@"host"]) {
        [self roleNameWithText:@"主持人" textColor:@"#FB2626" backgroundColor:@"#FFD1C9"];
    }
    if ([role_name isEqualToString:@"guest"]) {
        [self roleNameWithText:@"嘉宾" textColor:@"#0A7FF5" backgroundColor:@"#ADE1FF"];
    }
    if ([role_name isEqualToString:@"assistant"]) {
        self.roleNameLab.hidden = YES;
        [self roleNameWithText:@"助手" textColor:@"" backgroundColor:@""];
    }
    if ([role_name isEqualToString:@"user"]) {
        self.roleNameLab.hidden = YES;
        [self roleNameWithText:@"观众" textColor:@"" backgroundColor:@""];
    }
}
- (void)roleNameWithText:(NSString *)text textColor:(NSString *)textColor backgroundColor:(NSString *)backgroundColor
{
    self.roleNameLab.text = text;
    self.roleNameLab.textColor = [UIColor colorWithHex:textColor];
    self.roleNameLab.backgroundColor = [UIColor colorWithHex:backgroundColor];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([collectionView isEqual:self.collectionView]) {
        return self.dataSource.count;
    } else {
        return self.replyDataSource.count;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VHChatPhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VHChatPhotoCollectionCell" forIndexPath:indexPath];
    cell.isLeft = YES;
    if ([collectionView isEqual:self.collectionView]) {
        cell.image_url = self.dataSource[indexPath.row];
    } else {
        cell.image_url = self.replyDataSource[indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray * photoArray = [NSMutableArray array];
    if ([collectionView isEqual:self.collectionView]) {
        photoArray = self.dataSource;
    } else {
        photoArray = self.replyDataSource;
    }
    
    NSMutableArray * photos = [NSMutableArray new];
    [photoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GKPhoto *photo = [GKPhoto new];
        photo.placeholderImage = [UIImage imageNamed:@"vh_cell_img_error"];
        photo.url = [NSURL URLWithString:obj];
        [photos addObject:photo];
    }];
    GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:indexPath.row];
    browser.delegate = self;
    browser.showStyle = GKPhotoBrowserShowStyleNone;
    browser.isFollowSystemRotation = YES;
    browser.isFullWidthForLandScape = NO;
    browser.countLabel.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.5];
    [browser showFromVC:[VUITool viewControllerWithView:self]];
    
    browser.countLabel.font = FONT(12);
    browser.countLabel.layer.masksToBounds = YES;
    browser.countLabel.layer.cornerRadius = 16/2;
    [browser.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-24);
        make.centerX.mas_equalTo(browser.contentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(30, 16));
    }];
}

#pragma mark - 懒加载
- (UIImageView *)headImg {
    if (!_headImg) {
        _headImg = [[UIImageView alloc] init];
        _headImg.layer.masksToBounds = YES;
        _headImg.layer.cornerRadius = 28/2;
    } return _headImg;
}
- (UILabel *)nickNameLab {
    if (!_nickNameLab) {
        _nickNameLab = [[UILabel alloc] init];
        _nickNameLab.textColor = [UIColor colorWithHex:@"#8C8C8C"];
        _nickNameLab.font = FONT(14);
    } return _nickNameLab;
}
- (YYLabel *)roleNameLab
{
    if (!_roleNameLab) {
        _roleNameLab = [YYLabel new];
        _roleNameLab.layer.masksToBounds = YES;
        _roleNameLab.layer.cornerRadius = 15/2;
        _roleNameLab.font = FONT(11);
        _roleNameLab.textContainerInset = UIEdgeInsetsMake(2, 4, 2, 4);
    } return _roleNameLab;
}
- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.textColor = [UIColor colorWithHex:@"#999999"];
        _timeLab.font = FONT(12);
    } return _timeLab;
}
- (UIView *)cellBackgroundView
{
    if (!_cellBackgroundView) {
        _cellBackgroundView = [UIView new];
        _cellBackgroundView.layer.masksToBounds = YES;
        _cellBackgroundView.layer.cornerRadius = 8;
        _cellBackgroundView.backgroundColor = [UIColor whiteColor];
    } return _cellBackgroundView;
}

- (UIView *)replyLineView {
    if (!_replyLineView) {
        _replyLineView = [[UIView alloc] init];
        _replyLineView.layer.masksToBounds = YES;
        _replyLineView.layer.cornerRadius = 3/2;
        _replyLineView.backgroundColor = [UIColor colorWithHex:@"#BFBFBF"];
    } return _replyLineView;
}

- (UILabel *)replyNickNameLab {
    if (!_replyNickNameLab) {
        _replyNickNameLab = [[UILabel alloc] init];
        _replyNickNameLab.textColor = [UIColor colorWithHex:@"#595959"];
        _replyNickNameLab.font = FONT(14);
    } return _replyNickNameLab;
}

- (UILabel *)replyMsgLab {
    if (!_replyMsgLab) {
        _replyMsgLab = [[UILabel alloc] init];
        _replyMsgLab.textColor = [UIColor colorWithHex:@"#595959"];
        _replyMsgLab.font = FONT(14);
    } return _replyMsgLab;
}

- (UICollectionView *)replyCollectionView {
    if (_replyCollectionView == nil) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(40, 40);
        layout.sectionInset = UIEdgeInsetsMake(0, 2, 0, 10);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 2;
        layout.minimumInteritemSpacing = 2;
        
        _replyCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, 999) collectionViewLayout:layout];
        _replyCollectionView.backgroundColor = [UIColor whiteColor];
        _replyCollectionView.delegate = self;
        _replyCollectionView.dataSource = self;
        [_replyCollectionView registerClass:[VHChatPhotoCollectionCell class] forCellWithReuseIdentifier:@"VHChatPhotoCollectionCell"];
    } return _replyCollectionView;
}

- (NSMutableArray *)replyDataSource
{
    if (!_replyDataSource) {
        _replyDataSource = [NSMutableArray array];
    } return _replyDataSource;
}

- (YYLabel *)msg
{
    if (!_msg) {
        _msg = [YYLabel new];
        _msg.numberOfLines = 0;
        _msg.backgroundColor = [UIColor clearColor];
        _msg.textContainerInset = UIEdgeInsetsMake(6, 8, 6, 8);
        _msg.preferredMaxLayoutWidth = Screen_Width - 10 - 30 - 8 - 8 - 8 - 12;
    } return _msg;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(40, 40);
        layout.sectionInset = UIEdgeInsetsMake(0, 2, 0, 10);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 2;
        layout.minimumInteritemSpacing = 2;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, 999) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[VHChatPhotoCollectionCell class] forCellWithReuseIdentifier:@"VHChatPhotoCollectionCell"];
    } return _collectionView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    } return _dataSource;
}

@end
