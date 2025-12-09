//
//  VHGoodsConfirmOrderAlert.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/8/11.
//

#import "VHGoodsConfirmOrderAlert.h"
#import "VHGoodsNumberButton.h"
#import "UIButton+VHRadius.h"
#import "VHGoodsCouponAlert.h"
#import "VHLiveWeakTimer.h"

@interface VHGoodsConfirmOrderAlert ()

/// 标题
@property (nonatomic, strong) UILabel *titleStr;
/// 关闭按钮
@property (nonatomic, strong) UIButton *closeBtn;

/// 图片
@property (nonatomic, strong) UIImageView *img;
/// 优惠价格
@property (nonatomic, strong) UILabel *priceLab;
/// 标题
@property (nonatomic, strong) UILabel *titleLab;
/// 描述
@property (nonatomic, strong) UILabel *infoLab;
/// 购买数量按钮
@property (nonatomic, strong) VHGoodsNumberButton *numberBtn;

/// 优惠券名称
@property (nonatomic, strong) UILabel *couponNameLab;
/// 优惠券标签
@property (nonatomic, strong) YYLabel *couponTagLab;
/// 优惠券
@property (nonatomic, strong) UIButton *couponPriceBtn;

/// 用户信息
@property (nonatomic, strong) UILabel *userTitleLab;
/// 用户名
@property (nonatomic, strong) UITextField *userNameField;
/// 手机号
@property (nonatomic, strong) UITextField *phoneField;

/// 留言备注
@property (nonatomic, strong) UILabel *remarkTitleLab;
/// 备注详情
@property (nonatomic, strong) UITextField *remarkField;

/// 第一分割线
@property (nonatomic, strong) UIView *line0;

/// 微信支付
@property (nonatomic, strong) UIButton *wechatTitle;
/// 微信支付按钮
@property (nonatomic, strong) UIButton *wechatBtn;
/// 阿里支付
@property (nonatomic, strong) UIButton *aliTitle;
/// 阿里支付按钮
@property (nonatomic, strong) UIButton *aliBtn;

/// 第二分割线
@property (nonatomic, strong) UIView *line1;

/// 总价
@property (nonatomic, strong) UILabel *totalPriceLab;
/// 提交按钮
@property (nonatomic, strong) UIButton *subimtBtn;

/// 优惠券列表
@property (nonatomic, strong) VHGoodsCouponAlert *goodsCouponAlert;

/// 订单设置
@property (nonatomic, strong) VHGoodsSettingItem *settingItem;
/// 活动详情
@property (nonatomic, strong) VHWebinarInfo * webinarInfo;
/// 总价
@property (nonatomic, assign) CGFloat totalPrice;
/// 优惠券
@property (nonatomic, strong) VHGoodsCouponInfoItem *bestCoupon;
/// 计时器
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation VHGoodsConfirmOrderAlert

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.5];
        
        // 添加
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.titleStr];
        [self.contentView addSubview:self.closeBtn];
        
        [self.contentView addSubview:self.img];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.infoLab];
        [self.contentView addSubview:self.priceLab];
        [self.contentView addSubview:self.numberBtn];
        
        [self.contentView addSubview:self.couponNameLab];
        [self.contentView addSubview:self.couponTagLab];
        [self.contentView addSubview:self.couponPriceBtn];
        
        [self.contentView addSubview:self.userTitleLab];
        [self.contentView addSubview:self.userNameField];
        [self.contentView addSubview:self.phoneField];

        [self.contentView addSubview:self.remarkTitleLab];
        [self.contentView addSubview:self.remarkField];
        
        [self.contentView addSubview:self.line0];
        
        [self.contentView addSubview:self.wechatTitle];
        [self.contentView addSubview:self.wechatBtn];
        [self.contentView addSubview:self.aliTitle];
        [self.contentView addSubview:self.aliBtn];
        
        [self.contentView addSubview:self.line1];
        
        [self.contentView addSubview:self.totalPriceLab];
        [self.contentView addSubview:self.subimtBtn];

        
        // 初始化布局
        [self setUpMasonry];
        
        // 扩大点击范围
        [self.closeBtn setRadiusEdgeWithTop:10 right:10 bottom:10 left:10];
        [self.wechatBtn setRadiusEdgeWithTop:10 right:10 bottom:10 left:10];
        [self.aliBtn setRadiusEdgeWithTop:10 right:10 bottom:10 left:10];
    }

    return self;
}

#pragma mark - 初始化布局
- (void)setUpMasonry
{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(469);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    [self.titleStr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleStr.mas_centerY);
        make.right.mas_equalTo(-12.5);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(self.titleStr.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.img.mas_top);
        make.left.mas_equalTo(self.img.mas_right).offset(8);
        make.right.mas_equalTo(-12);
    }];
    
    [self.infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom);
        make.left.mas_equalTo(self.titleLab.mas_left);
        make.right.mas_equalTo(self.titleLab.mas_right);
    }];
    
    [self.numberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.img.mas_bottom);
        make.right.mas_equalTo(self.titleLab.mas_right);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];

    [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.numberBtn.mas_centerY);
        make.left.mas_equalTo(self.titleLab.mas_left);
        make.right.mas_equalTo(self.numberBtn.mas_left);
    }];
    
    [self.couponNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.img.mas_bottom).offset(14);
        make.left.mas_equalTo(30.5);
    }];
    
    [self.couponTagLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.couponNameLab.mas_centerY);
        make.left.mas_equalTo(self.couponNameLab.mas_right).offset(6);
    }];
    
    [self.couponPriceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.couponNameLab.mas_centerY);
        make.right.mas_equalTo(self.numberBtn.mas_right);
        make.size.mas_equalTo(CGSizeMake(180, 20));
    }];
    
    [self.userTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.couponNameLab.mas_bottom).offset(16);
        make.left.mas_equalTo(self.img.mas_left);
    }];
    
    [self.userNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.userTitleLab.mas_centerY);
        make.left.mas_equalTo(self.userTitleLab.mas_right).offset(20);
        make.right.mas_equalTo(self.titleLab.mas_right);
    }];

    [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userNameField.mas_bottom).offset(24);
        make.left.mas_equalTo(self.userTitleLab.mas_right).offset(20);
        make.right.mas_equalTo(self.titleLab.mas_right);
    }];

    [self.remarkField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.phoneField.mas_bottom).offset(24);
        make.left.mas_equalTo(self.userTitleLab.mas_right).offset(20);
        make.right.mas_equalTo(self.titleLab.mas_right);
    }];
    
    [self.remarkTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.remarkField.mas_centerY);
        make.left.mas_equalTo(self.img.mas_left);
    }];
    
    [self.line0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.remarkTitleLab.mas_bottom).offset(16);
        make.left.mas_equalTo(self.img.mas_left);
        make.right.mas_equalTo(self.titleLab.mas_right);
        make.height.mas_equalTo(.5);
    }];
    
    [self.wechatTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line0.mas_bottom).offset(16);
        make.left.mas_equalTo(self.img.mas_left);
        make.size.mas_equalTo(CGSizeMake(100, 18));
    }];
    
    [self.wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.wechatTitle.mas_centerY);
        make.right.mas_equalTo(self.titleLab.mas_right);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [self.aliTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.wechatTitle.mas_bottom).offset(25);
        make.left.mas_equalTo(self.img.mas_left);
        make.size.mas_equalTo(CGSizeMake(100, 18));
    }];
    
    [self.aliBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.aliTitle.mas_centerY);
        make.right.mas_equalTo(self.titleLab.mas_right);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.aliBtn.mas_bottom).offset(24);
        make.left.mas_equalTo(self.img.mas_left);
        make.right.mas_equalTo(self.titleLab.mas_right);
        make.height.mas_equalTo(.5);
    }];
    
    [self.subimtBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line1.mas_bottom).offset(12);
        make.right.mas_equalTo(-12);
        make.size.mas_equalTo(CGSizeMake(76, 39));
    }];
    
    [self.totalPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.subimtBtn.mas_centerY);
        make.left.mas_equalTo(self.img.mas_left);
        make.right.mas_equalTo(self.subimtBtn.mas_left).offset(-12);
    }];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [VUITool clipView:self.contentView corner:UIRectCornerTopLeft | UIRectCornerTopRight anSize:CGSizeMake(16, 16)];
}

#pragma mark - 弹窗
- (void)showGoodsOrder:(VHGoodsListItem *)item settingItem:(VHGoodsSettingItem *)settingItem webinarInfo:(VHWebinarInfo *)webinarInfo
{
    [self show];

    self.item = item;
    self.settingItem = settingItem;
    self.webinarInfo = webinarInfo;
    
    // 刷新优惠券
    [self.goodsCouponAlert couponAvailableListWithWebinarInfo:self.webinarInfo goodItem:self.item goodNum:[NSString stringWithFormat:@"%.0f",self.numberBtn.currentNumber]];

    // 是否隐藏三方平台支付
    [self updateUI];

    // 图片
    [self.img sd_setImageWithURL:[NSURL URLWithString:item.cover_img]];

    // 设置self.titleLab的文本为item的名称
    self.titleLab.text = item.name;

    // 设置self.infoLab的文本为item的信息
    self.infoLab.text = item.info;

    // 用户信息
    NSString * userInfoText = [NSString stringWithFormat:@"*用户信息"];
    NSMutableAttributedString *userInfo_attributedText = [[NSMutableAttributedString alloc] initWithString:userInfoText];
    userInfo_attributedText.yy_font = FONT(12);
    userInfo_attributedText.yy_color = VHBlack85;
    // 设置'*'的颜色
    [userInfo_attributedText yy_setColor:VHMainColor range:[userInfoText rangeOfString:@"*"]];
    self.userTitleLab.attributedText = userInfo_attributedText;

    // 设置self.priceLab的文本为item的折扣价格，格式为¥xxx
    self.priceLab.attributedText = [VUITool vhPriceToString:[NSString stringWithFormat:@"¥%@", [VUITool isBlankString:item.discount_price] ? item.price : item.discount_price]];

    // 设置默认数量为1
    self.numberBtn.currentNumber = 1;
    // 设置默认不用优惠券
    self.bestCoupon = nil;

    // 刷新总价
    [self reloadTotalPrice];
}

#pragma mark - 刷新总价
- (void)reloadTotalPrice
{
    // 设置self.totalPriceLab的文本为item的总价格，格式为¥xxx
    CGFloat price = [[VUITool isBlankString:self.item.discount_price] ? self.item.price : self.item.discount_price floatValue];
    CGFloat deduction_amount = self.bestCoupon.deduction_amount;
    
    self.totalPrice = self.numberBtn.currentNumber * price - deduction_amount;
    
    NSString * deduction_amount_text = deduction_amount > 0 ? [NSString stringWithFormat:@"\n共减 ¥%.2f",deduction_amount] : @"";
    NSString * totalText = [NSString stringWithFormat:@"合计¥%@%@", [NSString stringWithFormat:@"%.2f",self.totalPrice],deduction_amount_text];
    NSMutableAttributedString *total_attributedText = [VUITool vhPriceToString:totalText];
    // 设置'合计'的颜色
    [total_attributedText yy_setFont:FONT(16) range:[totalText rangeOfString:@"合计"]];
    [total_attributedText yy_setColor:VHBlack85 range:[totalText rangeOfString:@"合计"]];
    // 优惠样式
    [total_attributedText yy_setFont:FONT(12) range:[totalText rangeOfString:deduction_amount_text]];

    self.totalPriceLab.attributedText = total_attributedText;
}

#pragma mark - 是否隐藏三方平台支付
- (void)updateUI
{
    // 再根据其他设置配置U
    self.userTitleLab.hidden = (self.settingItem.enable_username == 0 && self.settingItem.enable_phone == 0) ? YES : NO;
    self.userNameField.hidden = self.settingItem.enable_username == 0 ? YES : NO;
    self.phoneField.hidden = self.settingItem.enable_phone == 0 ? YES : NO;

    [self.phoneField mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.settingItem.enable_username == 0) {
            make.centerY.mas_equalTo(self.userTitleLab.mas_centerY);
        } else {
            make.top.mas_equalTo(self.userNameField.mas_bottom).offset(24);
        }
        make.left.mas_equalTo(self.userTitleLab.mas_right).offset(20);
        make.right.mas_equalTo(self.titleLab.mas_right);
    }];
    
    self.remarkTitleLab.hidden = self.settingItem.enable_remark == 0 ? YES : NO;
    self.remarkField.hidden = self.settingItem.enable_remark == 0 ? YES : NO;

    [self.remarkField mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.settingItem.enable_username == 0 && self.settingItem.enable_phone == 0) {
            make.top.mas_equalTo(self.img.mas_bottom).offset(24);
        } else {
            make.top.mas_equalTo(self.phoneField.mas_bottom).offset(24);
            if (self.settingItem.enable_username == 0) {
                make.top.mas_equalTo(self.phoneField.mas_bottom).offset(24);
            } else if (self.settingItem.enable_phone == 0) {
                make.top.mas_equalTo(self.userNameField.mas_bottom).offset(24);
            }
        }
        make.left.mas_equalTo(self.userTitleLab.mas_right).offset(20);
        make.right.mas_equalTo(self.titleLab.mas_right);
    }];
    
    [self.line0 mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.settingItem.enable_remark == 0) {
            make.top.mas_equalTo(self.phoneField.mas_bottom).offset(16);
            if (self.settingItem.enable_username == 0 && self.settingItem.enable_phone == 0) {
                make.top.mas_equalTo(self.couponNameLab.mas_bottom).offset(16);
            } else {
                if (self.settingItem.enable_username == 0) {
                    make.top.mas_equalTo(self.phoneField.mas_bottom).offset(16);
                } else if (self.settingItem.enable_phone == 0) {
                    make.top.mas_equalTo(self.userNameField.mas_bottom).offset(16);
                }
            }
        } else {
            make.top.mas_equalTo(self.remarkTitleLab.mas_bottom).offset(16);
        }
        make.left.mas_equalTo(self.img.mas_left);
        make.right.mas_equalTo(self.titleLab.mas_right);
        make.height.mas_equalTo(.5);
    }];
    
    // 更新三方支付的UI
    self.wechatTitle.hidden = !self.settingItem.enable_wx;
    self.wechatBtn.hidden = !self.settingItem.enable_wx;
    self.aliTitle.hidden = !self.settingItem.enable_ali;
    self.aliBtn.hidden = !self.settingItem.enable_ali;
    self.line1.hidden = !self.settingItem.enable_wx && !self.settingItem.enable_ali ? YES : NO;
    
    // 三方支付都开启了用默认微信,否则谁开了用谁
    if (self.settingItem.enable_wx && self.settingItem.enable_ali) {
        self.wechatBtn.selected = YES;
        self.aliBtn.selected = NO;
    } else {
        self.wechatBtn.selected = self.settingItem.enable_wx;
        self.aliBtn.selected = self.settingItem.enable_ali;
    }
    
    // 刷新三方支付布局
    [self.aliTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.settingItem.enable_wx) {
            make.top.mas_equalTo(self.line0.mas_bottom).offset(16);
        } else {
            make.top.mas_equalTo(self.wechatTitle.mas_bottom).offset(25);
        }
        make.left.mas_equalTo(self.img.mas_left);
        make.size.mas_equalTo(CGSizeMake(100, 18));
    }];

    [self.line1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.settingItem.enable_wx && !self.settingItem.enable_ali) {
            make.top.mas_equalTo(self.line0.mas_bottom);
        } else {
            if (!self.settingItem.enable_ali) {
                make.top.mas_equalTo(self.wechatBtn.mas_bottom).offset(24);
            } else {
                make.top.mas_equalTo(self.aliBtn.mas_bottom).offset(24);
            }
        }
        make.left.mas_equalTo(self.img.mas_left);
        make.right.mas_equalTo(self.titleLab.mas_right);
        make.height.mas_equalTo(.5);
    }];
    
    [self layoutIfNeeded];

    // 刷新优惠券按钮样式
    self.couponPriceBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -self.couponPriceBtn.imageView.frame.size.width, 0, self.couponPriceBtn.imageView.frame.size.width);
    self.couponPriceBtn.imageEdgeInsets = UIEdgeInsetsMake(0, self.couponPriceBtn.titleLabel.frame.size.width + 4, 0, -self.couponPriceBtn.titleLabel.frame.size.width);

    // 获取提交按钮底部位置
    CGFloat subimtBottom = CGRectGetMaxY(self.subimtBtn.frame);

    // 更新父视图的总高度
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        // 更新父视图的高度约束
        make.height.equalTo(@(subimtBottom + SAFE_BOTTOM));
    }];
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

#pragma mark - 选取优惠券
- (void)couponPriceBtnAction
{
    [self.goodsCouponAlert showGoodsCouponWithWebinarInfo:self.webinarInfo goodItem:self.item goodNum:[NSString stringWithFormat:@"%.0f",self.numberBtn.currentNumber]];
}

#pragma mark - 微信购买
- (void)wechatBtnAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.aliBtn.selected = !sender.selected;
}

#pragma mark - 支付宝购买
- (void)aliBtnAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.wechatBtn.selected = !sender.selected;
}

#pragma mark - 提交购买
- (void)subimtBtnAction
{
    if (self.item.status == 0) {
        [VHProgressHud showToast:@"该商品已下架"];
        return;
    }

    NSString * username = self.settingItem.enable_username == 0 ? @"" : self.userNameField.text;
    NSString * phone = self.settingItem.enable_phone == 0 ? @"" : self.phoneField.text;
    NSString * remark = self.settingItem.enable_remark == 0 ? @"" : self.remarkField.text;
    
    // 支付渠道,如果是三方则需要传WEIXIN,ALIPAY,否则传@""
    NSString * pay_channel = self.wechatBtn.selected ? @"WEIXIN" : @"ALIPAY";
    pay_channel = !self.aliBtn.selected && !self.wechatBtn.selected ? @"" : pay_channel;

    __weak __typeof(self)weakSelf = self;
     [VHGoodsObject goodsCreateOtherWithSwitchId:self.webinarInfo.webinarInfoData.data_switch.switch_id buy_type:self.item.buy_type third_user_id:self.webinarInfo.webinarInfoData.join_info.third_party_user_id username:username phone:phone remark:remark goods_id:self.item.goods_id quantity:self.numberBtn.currentNumber pay_channel:pay_channel channel_source:@"main" pay_amount:[NSString stringWithFormat:@"%.2lf",self.totalPrice] coupon_user_ids:self.bestCoupon ? [NSArray arrayWithObject:self.bestCoupon.coupon_user_id] : nil complete:^(VHGoodsCreateOtherItem *createOtherItem, NSError *error) {
        __strong __typeof(weakSelf)self = weakSelf;
        
        if (createOtherItem) {
            NSURL * url = [NSURL URLWithString:createOtherItem.order_url];
            if (([createOtherItem.order_url containsString:@"wx"] || [createOtherItem.order_url containsString:@"ali"]) && self.skipWXOrALIPayBlock) {
              //   判断如果包含微信或者支付宝则跳转三方支付
                self.skipWXOrALIPayBlock(url,createOtherItem.referer,createOtherItem.order_no);
            } else {
                // 打开客户端
                [[UIApplication sharedApplication]  openURL:url
                              options:@{}
                    completionHandler:^(BOOL success) {
                    NSLog(@"客户端跳转%@", success ? @"完成" : @"失败");
                }];
            }
            
            [self dismiss];
        }
        
        if (error) {
            [VHProgressHud showToast:error.domain];
        }
        
    }];
}


#pragma mark - 点击关闭
- (void)closeBtnAction
{
    [self dismiss];
}

#pragma mark - 懒加载

- (UILabel *)titleStr {
    if (!_titleStr) {
        _titleStr = [[UILabel alloc] init];
        _titleStr.textColor = [UIColor blackColor];
        _titleStr.font = FONT(14);
        _titleStr.text = @"确认订单";
    }
    return _titleStr;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.imageView.contentMode = UIViewContentModeCenter;
        [_closeBtn setImage:[UIImage imageNamed:@"vh_goods_other_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIImageView *)img {
    if (!_img) {
        _img = [[UIImageView alloc] init];
        _img.layer.masksToBounds = YES;
        _img.layer.cornerRadius = 2;
    }
    return _img;
}

- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = FONT_Medium(14);
        _titleLab.textColor = VHBlack85;
    }

    return _titleLab;
}

- (UILabel *)infoLab
{
    if (!_infoLab) {
        _infoLab = [[UILabel alloc] init];
        _infoLab.font = FONT(12);
        _infoLab.textColor = VHBlack65;
    }

    return _infoLab;
}

- (UILabel *)priceLab {
    if (!_priceLab) {
        _priceLab = [[UILabel alloc] init];
        _priceLab.textColor = VHMainColor;
    }
    return _priceLab;
}

- (VHGoodsNumberButton *)numberBtn {
    if (!_numberBtn) {
        _numberBtn = [[VHGoodsNumberButton alloc] initWithFrame:CGRectZero];
        _numberBtn.minValue = 1;
        _numberBtn.maxValue = 100;
        _numberBtn.currentNumber = 1;
        _numberBtn.editing = YES;
        __weak __typeof(self)weakSelf = self;
        _numberBtn.blockCurrentNumber = ^(NSString *currentNumber) {
            __strong __typeof(weakSelf)self = weakSelf;
            VHLog(@"商品数量%@",currentNumber);

            int num = [currentNumber intValue];
            num = num < 1 ? 1 : num;
            
            // 刷新总价
            [self reloadTotalPrice];
            
            [self.timer invalidate]; // 取消之前的计时器

            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(reloadBestCoupon) userInfo:nil repeats:NO];
        };
    }
    return  _numberBtn;
}
// 刷新
- (void)reloadBestCoupon
{
    // 刷新优惠券
    [self.goodsCouponAlert couponAvailableListWithWebinarInfo:self.webinarInfo goodItem:self.item goodNum:[NSString stringWithFormat:@"%.0f",self.numberBtn.currentNumber]];
}

- (UILabel *)couponNameLab {
    if (!_couponNameLab) {
        _couponNameLab = [[UILabel alloc] init];
        _couponNameLab.text = @"优惠券";
        _couponNameLab.textColor = VHBlack85;
        _couponNameLab.font = FONT(12);
    }
    return _couponNameLab;
}

- (YYLabel *)couponTagLab {
    if (!_couponTagLab) {
        _couponTagLab = [[YYLabel alloc] init];
        _couponTagLab.backgroundColor = [UIColor whiteColor];
        _couponTagLab.layer.masksToBounds = YES;
        _couponTagLab.layer.cornerRadius = 2;
        _couponTagLab.layer.borderWidth = .5;
        _couponTagLab.layer.borderColor = [UIColor colorWithHex:@"#FB2626"].CGColor;
        _couponTagLab.hidden = YES;
        _couponTagLab.text = @"已选优惠券";
        _couponTagLab.textColor = [UIColor colorWithHex:@"#FB2626"];
        _couponTagLab.font = FONT(8);
        _couponTagLab.textContainerInset = UIEdgeInsetsMake(0.5, 0.5, 0.5, 0.5);
    }
    return _couponTagLab;
}

- (UIButton *)couponPriceBtn {
    if (!_couponPriceBtn) {
        _couponPriceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _couponPriceBtn.titleLabel.font = FONT(12);
        [_couponPriceBtn setImage:[UIImage imageNamed:@"vh_goods_coupon_arrow"] forState:UIControlStateNormal];
        [_couponPriceBtn setTitle:@"无可用优惠券" forState:UIControlStateNormal];
        [_couponPriceBtn setTitleColor:VHBlack25 forState:UIControlStateNormal];
        _couponPriceBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_couponPriceBtn addTarget:self action:@selector(couponPriceBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _couponPriceBtn;
}


- (UILabel *)userTitleLab {
    if (!_userTitleLab) {
        _userTitleLab = [[UILabel alloc] init];
    }
    return _userTitleLab;
}

- (UITextField *)userNameField {
    if (!_userNameField) {
        _userNameField = [[UITextField alloc] init];
        _userNameField.placeholder = @"请填写姓名";
        _userNameField.font = FONT(12);
        _userNameField.textColor = [UIColor blackColor];
        _userNameField.textAlignment = NSTextAlignmentRight;
    }
    return _userNameField;
}

- (UITextField *)phoneField {
    if (!_phoneField) {
        _phoneField = [[UITextField alloc] init];
        _phoneField.placeholder = @"请填写手机号，获得更优质的服务";
        _phoneField.font = FONT(12);
        _phoneField.textColor = [UIColor blackColor];
        _phoneField.textAlignment = NSTextAlignmentRight;
    }
    return _phoneField;
}

- (UILabel *)remarkTitleLab {
    if (!_remarkTitleLab) {
        _remarkTitleLab = [[UILabel alloc] init];
        _remarkTitleLab.text = @" 留言备注";
        _remarkTitleLab.font = FONT(12);
        _remarkTitleLab.textColor = [UIColor blackColor];
    }
    return _remarkTitleLab;
}

- (UITextField *)remarkField {
    if (!_remarkField) {
        _remarkField = [[UITextField alloc] init];
        _remarkField.placeholder = @"请输入备注";
        _remarkField.font = FONT(12);
        _remarkField.textColor = [UIColor blackColor];
        _remarkField.textAlignment = NSTextAlignmentRight;
    }
    return _remarkField;
}

- (UIView *)line0 {
    if (!_line0) {
        _line0 = [[UIView alloc] init];
        _line0.backgroundColor = VHBlack15;
    }
    return _line0;
}

- (UIButton *)wechatTitle {
    if (!_wechatTitle) {
        _wechatTitle = [UIButton buttonWithType:UIButtonTypeCustom];
        _wechatTitle.titleLabel.font = FONT(12);
        [_wechatTitle setImage:[UIImage imageNamed:@"vh_goods_other_wechat"] forState:UIControlStateNormal];
        [_wechatTitle setTitle:@"微信支付" forState:UIControlStateNormal];
        [_wechatTitle setTitleColor:[UIColor colorWithHex:@"#1A1A1A"] forState:UIControlStateNormal];
        _wechatTitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        // 设置按钮的图片在左侧，文本在图片右边
        CGFloat spacing = 4.0; // 图片和文本的间距
        _wechatTitle.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
        _wechatTitle.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
    }
    return _wechatTitle;
}

- (UIButton *)wechatBtn {
    if (!_wechatBtn) {
        _wechatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _wechatBtn.selected = YES;
        [_wechatBtn setImage:[UIImage imageNamed:@"vh_goods_other_noclick"] forState:UIControlStateNormal];
        [_wechatBtn setImage:[UIImage imageNamed:@"vh_goods_other_click"] forState:UIControlStateSelected];
        [_wechatBtn addTarget:self action:@selector(wechatBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wechatBtn;
}

- (UIButton *)aliTitle {
    if (!_aliTitle) {
        _aliTitle = [UIButton buttonWithType:UIButtonTypeCustom];
        _aliTitle.titleLabel.font = FONT(12);
        [_aliTitle setImage:[UIImage imageNamed:@"vh_goods_other_ali"] forState:UIControlStateNormal];
        [_aliTitle setTitle:@"支付宝支付" forState:UIControlStateNormal];
        [_aliTitle setTitleColor:[UIColor colorWithHex:@"#1A1A1A"] forState:UIControlStateNormal];
        _aliTitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        // 设置按钮的图片在左侧，文本在图片右边
        CGFloat spacing = 4.0; // 图片和文本的间距
        _aliTitle.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
        _aliTitle.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
    }
    return _aliTitle;
}

- (UIButton *)aliBtn {
    if (!_aliBtn) {
        _aliBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _aliBtn.selected = NO;
        [_aliBtn setImage:[UIImage imageNamed:@"vh_goods_other_noclick"] forState:UIControlStateNormal];
        [_aliBtn setImage:[UIImage imageNamed:@"vh_goods_other_click"] forState:UIControlStateSelected];
        [_aliBtn addTarget:self action:@selector(aliBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _aliBtn;
}

- (UIView *)line1 {
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = VHBlack15;
    }
    return _line1;
}

- (UILabel *)totalPriceLab {
    if (!_totalPriceLab) {
        _totalPriceLab = [[UILabel alloc] init];
        _totalPriceLab.numberOfLines = 2;
        _totalPriceLab.textColor = VHMainColor;
    }
    return _totalPriceLab;
}

- (UIButton *)subimtBtn {
    if (!_subimtBtn) {
        _subimtBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _subimtBtn.backgroundColor = VHMainColor;
        _subimtBtn.layer.masksToBounds = YES;
        _subimtBtn.layer.cornerRadius = 39/2;
        _subimtBtn.titleLabel.font = FONT(12);
        [_subimtBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_subimtBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_subimtBtn addTarget:self action:@selector(subimtBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _subimtBtn;
}

- (VHGoodsCouponAlert *)goodsCouponAlert
{
    if (!_goodsCouponAlert) {
        _goodsCouponAlert = [[VHGoodsCouponAlert alloc] initWithFrame:[VUITool getCurrentScreenViewController].view.bounds];
        __weak __typeof(self)weakSelf = self;
        _goodsCouponAlert.selectBestCoupon = ^(VHGoodsCouponInfoItem *bestCoupon) {
            __strong __typeof(weakSelf)self = weakSelf;
            self.bestCoupon = bestCoupon;
            
            // 刷新总价
            [self reloadTotalPrice];

            [self.couponTagLab setHidden:bestCoupon ? NO : YES];
            
            [self.couponPriceBtn setTitle:bestCoupon ? [NSString stringWithFormat:@"减 ¥%.2f",bestCoupon.deduction_amount] : @"无可用优惠券" forState:UIControlStateNormal];
            [self.couponPriceBtn setTitleColor:bestCoupon ? [UIColor colorWithHex:@"#FB2626"] : VHBlack25 forState:UIControlStateNormal];
            
            // 刷新优惠券按钮样式
            self.couponPriceBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -self.couponPriceBtn.imageView.frame.size.width, 0, self.couponPriceBtn.imageView.frame.size.width);
            self.couponPriceBtn.imageEdgeInsets = UIEdgeInsetsMake(0, self.couponPriceBtn.titleLabel.frame.size.width + 4, 0, -self.couponPriceBtn.titleLabel.frame.size.width);
        };
        [[VUITool getCurrentScreenViewController].view addSubview:_goodsCouponAlert];
    }
    return _goodsCouponAlert;
}

@end
