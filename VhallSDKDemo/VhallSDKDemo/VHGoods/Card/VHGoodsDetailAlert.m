//
//  VHGoodsDetailAlert.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/8/10.
//

#import "VHGoodsDetailAlert.h"
#import "UIButton+VHRadius.h"

@interface VHGoodsDetailAlert ()<UIScrollViewDelegate>

/// 滚动图片
@property (nonatomic, strong) UIScrollView *imgScrollView;
/// 页数
@property (nonatomic, strong) UILabel *pageLab;
/// 优惠标签
@property (nonatomic, strong) UILabel *discountTagLab;
/// 优惠价格
@property (nonatomic, strong) UILabel *discountPriceLab;
/// 原价格
@property (nonatomic, strong) YYLabel *priceLab;
/// 标题
@property (nonatomic, strong) UILabel *titleLab;
/// 描述
@property (nonatomic, strong) UILabel *infoLab;
/// 访问店铺
@property (nonatomic, strong) UIButton *shopBtn;
/// 购买
@property (nonatomic, strong) UIButton *payBtn;
/// 关闭按钮
@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation VHGoodsDetailAlert

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.5];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        // 添加
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.imgScrollView];
        [self.contentView addSubview:self.pageLab];
        [self.contentView addSubview:self.discountTagLab];
        [self.contentView addSubview:self.discountPriceLab];
        [self.contentView addSubview:self.priceLab];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.infoLab];
        [self.contentView addSubview:self.payBtn];
        [self.contentView addSubview:self.shopBtn];
        [self.contentView addSubview:self.closeBtn];
        
        // 初始化布局
        [self setUpMasonry];
        
        // 扩大点击范围
        [self.closeBtn setRadiusEdgeWithTop:10 right:10 bottom:10 left:10];
    }

    return self;
}

#pragma mark - 初始化布局
- (void)setUpMasonry
{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(600);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    [self.pageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.imgScrollView.mas_right).offset(-12);
        make.bottom.mas_equalTo(self.imgScrollView.mas_bottom).offset(-12);
        make.size.mas_equalTo(CGSizeMake(45, 22));
    }];
    
    [self.discountTagLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(self.imgScrollView.mas_bottom).offset(12);
        make.size.mas_equalTo(CGSizeMake(34, 13));
    }];
        
    [self.discountPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.discountTagLab.mas_right).offset(6);
        make.centerY.mas_equalTo(self.discountTagLab.mas_centerY);
        // 设置右边的UILabel的压缩抗性优先级高于左边的UILabel
        make.right.equalTo(self.priceLab.mas_left).offset(-12).priorityHigh();
    }];
    
    [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.discountPriceLab.mas_right).offset(6);
        make.centerY.mas_equalTo(self.discountTagLab.mas_centerY);
        // 设置左边的UILabel的压缩抗性优先级低于右边的UILabel
        make.left.greaterThanOrEqualTo(self.discountPriceLab.mas_right).offset(12).priorityLow();
    }];

    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(self.discountTagLab.mas_bottom).offset(12);
        make.right.mas_equalTo(-12);
    }];
    
    [self.infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(self.titleLab.mas_bottom);
        make.right.mas_equalTo(-12);
    }];
    
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(- SAFE_BOTTOM);
        make.right.mas_equalTo(-12);
        make.size.mas_equalTo(CGSizeMake(100, 39));
    }];

    [self.shopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.payBtn.mas_centerY);
        make.right.mas_equalTo(self.payBtn.mas_left).offset(-12);
        make.size.mas_equalTo(CGSizeMake(100, 39));
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [VUITool clipView:self.contentView corner:UIRectCornerTopLeft | UIRectCornerTopRight anSize:CGSizeMake(16, 16)];
}

#pragma mark - 弹窗
- (void)showGoodsDetail:(VHGoodsListItem *)item
{
    [super show];

    self.item = item;
    
    // 添加滚动视图
    [self addImgScrollView:item];
    
    // 设置self.titleLab的文本为item的名称
    self.titleLab.text = item.name;

    // 设置self.infoLab的文本为item的信息
    self.infoLab.text = item.info;

    // 设置self.discountPriceLab的文本为item的折扣价格，格式为¥xxx
    self.discountPriceLab.attributedText = [VUITool vhPriceToString:[NSString stringWithFormat:@"¥%@", [VUITool isBlankString:item.discount_price] ? item.price : item.discount_price]];

    // 创建一个NSMutableAttributedString对象，将商品的原价作为初始字符串
    NSMutableAttributedString *attributedText = [VUITool vhPriceToString:[NSString stringWithFormat:@"¥%@", [VUITool isBlankString:item.discount_price] ? @"" : item.price]];

    // 删除线
    YYTextDecoration *strikethrough = [YYTextDecoration decorationWithStyle:YYTextLineStyleSingle];
    [attributedText yy_setTextStrikethrough:strikethrough range:NSMakeRange(0, attributedText.length)];

    // 设置attributedText的颜色为VHBlack25
    attributedText.yy_color = VHBlack25;

    // 将attributedText设置为self.priceLab的属性文本
    self.priceLab.attributedText = attributedText;
    
    // 优惠价标签动态显示
    self.discountTagLab.hidden = [VUITool isBlankString:item.discount_price];

    if ([VUITool isBlankString:item.discount_price]) {
        
        [self.discountTagLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(self.imgScrollView.mas_bottom).offset(12);
            make.size.mas_equalTo(CGSizeMake(0, 13));
        }];
        
        [self.discountPriceLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.centerY.mas_equalTo(self.discountTagLab.mas_centerY);
        }];

    } else {
        
        [self.discountTagLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(self.imgScrollView.mas_bottom).offset(12);
            make.size.mas_equalTo(CGSizeMake(34, 13));
        }];
        
        [self.discountPriceLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.discountTagLab.mas_right).offset(6);
            make.centerY.mas_equalTo(self.discountTagLab.mas_centerY);
            // 设置右边的UILabel的压缩抗性优先级高于左边的UILabel
            make.right.equalTo(self.priceLab.mas_left).offset(-12).priorityHigh();
        }];

    }
    
    // 是否显示店铺
    self.shopBtn.hidden = item.shop_show == 0;
        
    [self layoutIfNeeded];

    // 获取提交按钮底部位置
    CGFloat infoBottom = CGRectGetMaxY(self.infoLab.frame);

    // 更新父视图的总高度
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        // 更新父视图的高度约束
        make.height.equalTo(@(infoBottom + SAFE_BOTTOM + 50));
    }];
}

#pragma mark - 添加滚动视图
- (void)addImgScrollView:(VHGoodsListItem *)item
{
    for (UIView *subview in self.imgScrollView.subviews) {
        [subview removeFromSuperview];
    }
    
    for (NSInteger i = 0; i < item.images.count; i++) {
        VHGoodsImageList_Item * image_item = item.images[i];
        // 创建图片视图
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * Screen_Width, 0, Screen_Width, Screen_Width)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:image_item.img_url]];

        // 添加图片视图到滚动视图
        [self.imgScrollView addSubview:imageView];
    }

    // 设置滚动内容大小
    self.imgScrollView.contentSize = CGSizeMake(Screen_Width * item.images.count, Screen_Width);
    
    // 初始化页数
    self.pageLab.text = [NSString stringWithFormat:@"%d/%ld", 1, item.images.count];
    
    // 初始化滚动到第一页
    CGPoint contentOffset = CGPointMake(0, 0); // 第一页的偏移量
    [self.imgScrollView setContentOffset:contentOffset animated:NO];
}

#pragma mark - 代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int currentPage = scrollView.contentOffset.x / Screen_Width + 1;
    self.pageLab.text = [NSString stringWithFormat:@"%d/%ld", currentPage, self.item.images.count];
}

#pragma mark - 隐藏
- (void)dismiss
{
    [super disMissContentView];
}

#pragma mark - 隐藏
- (void)disMissContentView
{
    
}

#pragma mark - 访问店铺
- (void)shopBtnAction
{
    [self dismiss];
    
    // 外链购买直接跳转出去
    [[UIApplication sharedApplication]  openURL:[NSURL URLWithString:self.item.shop_url]
                                        options:@{}
                              completionHandler:^(BOOL success) {
        VHLog(@"外链跳转%@", success ? @"完成" : @"失败");
    }];

}

#pragma mark - 立即购买
- (void)payBtnAction
{
    [self dismiss];

    if (self.item.status == 0) {
        [VHProgressHud showToast:@"该商品已下架"];
        return;
    }
    
    if (self.clickPayBtnBlock) {
        self.clickPayBtnBlock(self.item);
    }
}

#pragma mark - 点击关闭
- (void)closeBtnAction
{
    [self dismiss];
}

#pragma mark - 懒加载
- (UIScrollView *)imgScrollView
{
    if (!_imgScrollView) {
        _imgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Width)];
        _imgScrollView.delegate = self;
        _imgScrollView.pagingEnabled = YES;
        _imgScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _imgScrollView;
}

- (UILabel *)pageLab {
    if (!_pageLab) {
        _pageLab = [UILabel new];
        _pageLab.textAlignment = NSTextAlignmentCenter;
        _pageLab.textColor = [UIColor whiteColor];
        _pageLab.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.45];
        _pageLab.layer.cornerRadius = 22/2;
        _pageLab.layer.masksToBounds = YES;
        _pageLab.font = FONT(14);
    }
    return _pageLab;
}

- (UILabel *)discountTagLab {
    if (!_discountTagLab) {
        _discountTagLab = [[UILabel alloc] init];
        _discountTagLab.backgroundColor = [UIColor colorWithHexString:@"#FB2626" alpha:.15];
        _discountTagLab.textColor = VHMainColor;
        _discountTagLab.font = FONT(10);
        _discountTagLab.text = @"优惠价";
        _discountTagLab.textAlignment = NSTextAlignmentCenter;
    }
    return _discountTagLab;
}

- (UILabel *)discountPriceLab {
    if (!_discountPriceLab) {
        _discountPriceLab = [[UILabel alloc] init];
        _discountPriceLab.textColor = VHMainColor;
        _discountPriceLab.font = FONT(10);
    }
    return _discountPriceLab;
}

- (YYLabel *)priceLab {
    if (!_priceLab) {
        _priceLab = [[YYLabel alloc] init];
        _priceLab.textColor = VHBlack25;
        _priceLab.font = FONT(7);
    }
    return _priceLab;
}

- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.numberOfLines = 1;
        _titleLab.preferredMaxLayoutWidth = Screen_Width - 12 - 12;
        _titleLab.font = FONT_Medium(14);
        _titleLab.textColor = VHBlack85;
    }

    return _titleLab;
}

- (UILabel *)infoLab
{
    if (!_infoLab) {
        _infoLab = [[UILabel alloc] init];
        _infoLab.numberOfLines = 3;
        _infoLab.preferredMaxLayoutWidth = Screen_Width - 12 - 12;
        _infoLab.font = FONT(12);
        _infoLab.textColor = VHBlack65;
    }

    return _infoLab;
}

- (UIButton *)shopBtn {
    if (!_shopBtn) {
        _shopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shopBtn.layer.masksToBounds = YES;
        _shopBtn.layer.cornerRadius = 39/2;
        _shopBtn.layer.borderColor = VHMainColor.CGColor;
        _shopBtn.layer.borderWidth = .5;
        _shopBtn.titleLabel.font = FONT(12);
        [_shopBtn setTitle:@"访问店铺" forState:UIControlStateNormal];
        [_shopBtn setTitleColor:VHMainColor forState:UIControlStateNormal];
        [_shopBtn addTarget:self action:@selector(shopBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shopBtn;
}

- (UIButton *)payBtn {
    if (!_payBtn) {
        _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _payBtn.backgroundColor = VHMainColor;
        _payBtn.layer.masksToBounds = YES;
        _payBtn.layer.cornerRadius = 39/2;
        _payBtn.titleLabel.font = FONT(12);
        [_payBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_payBtn addTarget:self action:@selector(payBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payBtn;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.imageView.contentMode = UIViewContentModeCenter;
        [_closeBtn setImage:[UIImage imageNamed:@"vh_goods_detail_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

@end
