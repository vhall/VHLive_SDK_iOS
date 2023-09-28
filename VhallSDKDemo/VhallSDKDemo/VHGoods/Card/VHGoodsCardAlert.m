//
//  VHGoodsCardAlert.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/8/9.
//

#import "VHGoodsCardAlert.h"
#import "UIButton+VHRadius.h"

@interface VHGoodsCardAlert ()


@property (nonatomic, strong) UIView *contentView;      ///<容器
@property (nonatomic, strong) UIView *priceView;        ///<价格底部背景
@property (nonatomic, strong) UIImageView *img;         ///<图片
@property (nonatomic, strong) UIImageView *priceImg;    ///<抢

@property (nonatomic, strong) UILabel *titleLab;        ///<标题
@property (nonatomic, strong) UILabel *priceLab;        ///<优惠价格

@property (nonatomic, strong) UIButton *closeBtn;       ///<关闭按钮

@end

@implementation VHGoodsCardAlert

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化卡片视图的样式和布局
        self.backgroundColor = [UIColor clearColor];
        self.layer.shadowColor = VHBlack15.CGColor;
        self.layer.shadowOffset = CGSizeMake(3,3);
        self.layer.shadowRadius = 6;
        self.layer.shadowOpacity = 1;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkDetail)];
        [self addGestureRecognizer:tap];
        
        UITapGestureRecognizer *priceViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkPay)];
        [self.priceView addGestureRecognizer:priceViewTap];

        [self addSubview:self.contentView];
        
        [_contentView addSubview:self.img];
        [_contentView addSubview:self.titleLab];
        
        [_contentView addSubview:self.priceView];
        [_priceView addSubview:self.priceLab];
        [_priceView addSubview:self.priceImg];

        [_contentView addSubview:self.closeBtn];
        
        [self setMasonryUI];
        
        // 扩大点击范围
        [self.closeBtn setRadiusEdgeWithTop:10 right:10 bottom:10 left:10];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setMasonryUI
{
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    [_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(_img.mas_width);
    }];
    
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_img.mas_bottom).offset(2.5);
        make.left.mas_equalTo(3.5);
        make.right.mas_equalTo(-3.5);
    }];
    
    [_priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLab.mas_bottom).offset(2.5);
        make.left.mas_equalTo(3.5);
        make.right.bottom.mas_equalTo(-3.5);
    }];
    
    [_priceImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_priceView.mas_centerY);
        make.right.mas_equalTo(-8);
        make.size.mas_equalTo(CGSizeMake(14, 11.5));
    }];
    
    [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.centerY.mas_equalTo(_priceView.mas_centerY);
        make.right.mas_greaterThanOrEqualTo(_priceImg.mas_right).offset(-4.28);
    }];
}


- (void)showGoodsCardItem:(VHGoodsListItem *)item {
    
    self.item = item;
    
    self.isShow = YES;
    
    [self.img sd_setImageWithURL:[NSURL URLWithString:item.cover_img]];
    
    self.titleLab.text = item.name;
    
    // 判断价格模块是否显示
    self.priceLab.hidden = [VUITool isBlankString:item.discount_price] && [VUITool isBlankString:item.price];
    
    // 设置self.priceLab的文本为item的折扣价格，格式为¥xxx
    self.priceLab.attributedText = [VUITool vhPriceToString:[NSString stringWithFormat:@"¥%@", [VUITool isBlankString:item.discount_price] ? item.price : item.discount_price]];

    // 使用动画将卡片推入屏幕
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(Screen_Width - 96 - 12, Screen_Height - 152 - 60 - SAFE_BOTTOM - NAVIGATION_BAR_H, 96, 152);
    }];
}

- (void)hide {
    
    self.isShow = NO;

    // 使用动画将卡片推出屏幕
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(Screen_Width, Screen_Height - 152 - 60 - SAFE_BOTTOM - NAVIGATION_BAR_H, 96, 152);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 查看详情
- (void)checkDetail
{
    if (self.clickCheckDetailBlock) {
        self.clickCheckDetailBlock(self.item);
    }
}

#pragma mark - 去支付
- (void)checkPay
{
    if (self.clickPayBlock) {
        self.clickPayBlock(self.item);
    }
}

#pragma mark - 点击关闭
- (void)closeBtnAction
{
    [self hide];
}

#pragma mark - 懒加载
- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 8;
    }

    return _contentView;
}

- (UIImageView *)img {
    if (!_img) {
        _img = [[UIImageView alloc] init];
        _img.layer.masksToBounds = YES;
        _img.layer.cornerRadius = 2;
    }
    return _img;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.imageView.contentMode = UIViewContentModeCenter;
        [_closeBtn setImage:[UIImage imageNamed:@"vh_goods_card_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.numberOfLines = 2;
        _titleLab.preferredMaxLayoutWidth = 96 - 6;
        _titleLab.font = FONT(9);
        _titleLab.textColor = VHBlack85;
    }

    return _titleLab;
}

- (UIView *)priceView {
    if (!_priceView) {
        _priceView = [[UIView alloc] init];
        _priceView.backgroundColor = VHMainColor;
        _priceView.layer.masksToBounds = YES;
        _priceView.layer.cornerRadius = 2;
    }
    return _priceView;
}

- (UIImageView *)priceImg {
    if (!_priceImg) {
        _priceImg = [[UIImageView alloc] init];
        _priceImg.image = [UIImage imageNamed:@"vh_goods_card_qiang"];
    }
    return _priceImg;
}

- (UILabel *)priceLab {
    if (!_priceLab) {
        _priceLab = [[UILabel alloc] init];
        _priceLab.textColor = [UIColor whiteColor];
        _priceLab.font = FONT(12);
    }
    return _priceLab;
}


@end
