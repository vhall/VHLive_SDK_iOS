//
//  VHGoodsCouponAlert.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/9/6.
//

#import "VHGoodsCouponAlert.h"
#import "UIButton+VHRadius.h"

/// 优惠券菜单按钮
@interface VHGoodsCouponMenuBtn : UIButton
/// 标题
@property (nonatomic, strong) UILabel *titleLab;
/// 下划线
@property (nonatomic, strong) UIView *lineView;
@end

@implementation VHGoodsCouponMenuBtn

- (instancetype)init
{
    if ([super init]) {
        
        self = [VHGoodsCouponMenuBtn buttonWithType:UIButtonTypeCustom];

        [self addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        [self addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(50, 2.5));
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    self.lineView.backgroundColor = selected ? VHMainColor : [UIColor clearColor];
    self.titleLab.textColor = selected ? VHBlack85 : VHBlack65;
    self.titleLab.font = selected ? FONT_Medium(14) : FONT(14);
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [UIView new];
    }
    return _lineView;
}

- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [UILabel new];
    }
    return _titleLab;
}

@end

typedef void(^ClickUseDescBtn)(void);
typedef void(^ClickSelectBtn)(BOOL isSelect);

/// 优惠券样式
@interface VHGoodsCouponCell : UITableViewCell

/// 点击使用说明
@property (nonatomic, copy) ClickUseDescBtn clickUseDescBtn;
@property (nonatomic, copy) ClickSelectBtn clickSelectBtn;
/// 优惠卷详情
@property (nonatomic, strong) VHGoodsCouponInfoItem *couponInfoItem;

/// 左边模块
@property (nonatomic, strong) UIView *leftView;
/// 减免金额
@property (nonatomic, strong) UILabel *deductionLab;
/// 门槛金额
@property (nonatomic, strong) UILabel *thresholdLab;

/// 右边模块
@property (nonatomic, strong) UIView *rightView;
/// 水印
@property (nonatomic, strong) UIImageView *watermarkImg;
/// 优惠券名称
@property (nonatomic, strong) UILabel *nameLab;
/// 使用类型
@property (nonatomic, strong) UILabel *productTypeLab;
/// 有效期
@property (nonatomic, strong) UILabel *timeLab;
/// 使用说明
@property (nonatomic, strong) UIButton *useDescBtn;
/// 选中按钮
@property (nonatomic, strong) UIButton *selectBtn;
/// 未达条件
@property (nonatomic, strong) UIImageView *unfulfilledConditionImg;
/// 不可用标识
@property (nonatomic, strong) UIImageView *unusableImg;

/// 使用说明
@property (nonatomic, strong) YYLabel *useDescLab;

/// 上面圆
@property (nonatomic, strong) UIView *topLine;
/// 下面圆
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation VHGoodsCouponCell

+ (VHGoodsCouponCell *)createCellWithTableView:(UITableView *)tableView
{
    VHGoodsCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VHGoodsCouponCell"];

    if (!cell) {
        cell = [[VHGoodsCouponCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"VHGoodsCouponCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.leftView];
        [self.leftView addSubview:self.deductionLab];
        [self.leftView addSubview:self.thresholdLab];
        
        [self.contentView addSubview:self.rightView];
        [self.rightView addSubview:self.watermarkImg];
        [self.rightView addSubview:self.unusableImg];
        [self.rightView addSubview:self.nameLab];
        [self.rightView addSubview:self.unfulfilledConditionImg];
        [self.rightView addSubview:self.productTypeLab];
        [self.rightView addSubview:self.timeLab];
        [self.rightView addSubview:self.useDescBtn];
        [self.rightView addSubview:self.selectBtn];
        
        [self.contentView addSubview:self.useDescLab];
        
        [self.contentView addSubview:self.topLine];
        [self.contentView addSubview:self.bottomLine];
        
        // 设置约束
        [self setMasonryUI];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setMasonryUI
{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(12);
        make.size.mas_equalTo(CGSizeMake(120, 95));
    }];
    
    [self.deductionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16);
        make.centerX.mas_equalTo(self.leftView.mas_centerX);
    }];
    
    [self.thresholdLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.deductionLab.mas_bottom).offset(2);
        make.centerX.mas_equalTo(self.leftView.mas_centerX);
    }];
    
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.leftView.mas_top);
        make.bottom.mas_equalTo(self.leftView.mas_bottom);
        make.left.mas_equalTo(self.leftView.mas_right);
        make.right.mas_equalTo(-12);
    }];
    
    [self.watermarkImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(3.37);
        make.right.mas_equalTo(-25.75);
        make.size.mas_equalTo(CGSizeMake(127.5, 127.5));
    }];
    
    [self.unusableImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(-27.5);
        make.right.mas_equalTo(23.2);
        make.size.mas_equalTo(CGSizeMake(74.5, 74.5));
    }];
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(12);
    }];
    
    [self.unfulfilledConditionImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(-13.5);
        make.right.mas_equalTo(14.5);
        make.size.mas_equalTo(CGSizeMake(79, 42.5));
    }];
    
    [self.productTypeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLab.mas_left);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(self.nameLab.mas_bottom).offset(8);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLab.mas_left);
        make.right.mas_equalTo(-35);
        make.top.mas_equalTo(self.productTypeLab.mas_bottom);
    }];
    
    [self.useDescBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLab.mas_left);
        make.top.mas_equalTo(self.timeLab.mas_bottom).offset(4);
        make.size.mas_equalTo(CGSizeMake(60, 14));
    }];
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.rightView.mas_centerY);
        make.right.mas_equalTo(-12);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [self.useDescLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftView.mas_left);
        make.right.mas_equalTo(self.rightView.mas_right);
        make.top.mas_equalTo(self.leftView.mas_bottom);
        make.height.mas_equalTo(0);
    }];

    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.leftView.mas_top).offset(-6);
        make.left.mas_equalTo(self.leftView.mas_right).offset(-6);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.leftView.mas_bottom).offset(-6);
        make.left.mas_equalTo(self.leftView.mas_right).offset(-6);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.useDescLab.mas_bottom).priorityHigh();
    }];
}

- (void)setCouponInfoItem:(VHGoodsCouponInfoItem *)couponInfoItem
{
    _couponInfoItem = couponInfoItem;
    
    // 满减价格
    NSString * deduction_string = [NSString stringWithFormat:@"¥%.2f",couponInfoItem.deduction_amount];
    NSMutableAttributedString *deduction_attributedText = [[NSMutableAttributedString alloc] initWithString:deduction_string];
    deduction_attributedText.yy_color = [UIColor whiteColor];
    deduction_attributedText.yy_font = FONT_Blod(30);
    // 设置'¥'的字体大小为15
    [deduction_attributedText yy_setFont:FONT_Blod(15) range:[deduction_string rangeOfString:@"¥"]];
    self.deductionLab.attributedText = deduction_attributedText;
    
    // 使用门槛
    self.thresholdLab.text = couponInfoItem.threshold_amount > 0 ? [NSString stringWithFormat:@"满%.2f可用",couponInfoItem.threshold_amount] : @"无门槛";
    
    // 名称
    self.nameLab.text = couponInfoItem.coupon_name;
    // 类型
    if (couponInfoItem.applicable_product_type == 0) {
        self.productTypeLab.text = @"全部商品可用";
    } else if (couponInfoItem.applicable_product_type == 1) {
        self.productTypeLab.text = @"指定商品可用";
    } else {
        self.productTypeLab.text = @"指定商品不可用";
    }
    // 时间
    if (self.couponInfoItem.validity_type == 0) {
        self.timeLab.text = [NSString stringWithFormat:@"%@ - %@",couponInfoItem.validity_start_time,couponInfoItem.validity_end_time];
    } else {
        self.timeLab.text = [NSString stringWithFormat:@"自领取起%ld天内有效",couponInfoItem.validity_day];
    }
    
    // 使用说明
    self.useDescLab.text = couponInfoItem.use_desc;
    // 是否选中
    self.selectBtn.selected = couponInfoItem.isBest;

    // 刷新详情是否显示
    [self.useDescLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftView.mas_left);
        make.right.mas_equalTo(self.rightView.mas_right);
        make.top.mas_equalTo(self.leftView.mas_bottom);
        if (self.couponInfoItem.isShowUseDesc) {
            make.height.mas_greaterThanOrEqualTo(0);
        } else {
            make.height.mas_equalTo(0);
        }
    }];

    // 刷新UI
    [self layoutIfNeeded];

    // 刷新按钮
    self.useDescBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -self.useDescBtn.imageView.frame.size.width, 0, self.useDescBtn.imageView.frame.size.width);
    self.useDescBtn.imageEdgeInsets = UIEdgeInsetsMake(0, self.useDescBtn.titleLabel.frame.size.width + 4.5, 0, -self.useDescBtn.titleLabel.frame.size.width);

    // 根据是否可用类型 刷新UI
    self.selectBtn.userInteractionEnabled = couponInfoItem.isAvailable;
    self.selectBtn.hidden = !couponInfoItem.isAvailable;
    
    self.unusableImg.hidden = YES;
    self.unfulfilledConditionImg.hidden = YES;
    
    self.watermarkImg.image = [UIImage imageNamed:@"vh_goods_coupon_watermark"];
    
    self.nameLab.textColor = [UIColor colorWithHex:@"#FB2626"];

    self.rightView.backgroundColor = [UIColor colorWithHex:@"#FFE8E4"];
    self.leftView.backgroundColor = [UIColor bm_colorGradientChangeWithSize:self.leftView.size direction:IHGradientChangeDirectionLevel startColor:[UIColor colorWithHex:@"#FF7C7C"] endColor:[UIColor colorWithHex:@"#FB2626"]];

    if (!couponInfoItem.isAvailable) {
        
        self.watermarkImg.image = [UIImage imageNamed:couponInfoItem.unavailable_type == 0 ? @"vh_goods_coupon_watermark" : @"vh_goods_coupon_watermark_black"];
        
        if (couponInfoItem.unavailable_type == 0) {
            self.unfulfilledConditionImg.hidden = NO;
        } else if (couponInfoItem.unavailable_type == 1) {
            self.unusableImg.hidden = NO;
            self.unusableImg.image = [UIImage imageNamed:@"vh_goods_coupon_expired"];
        } else if (couponInfoItem.unavailable_type == 2) {
            self.unusableImg.hidden = NO;
            self.unusableImg.image = [UIImage imageNamed:@"vh_goods_coupon_use"];
        }
        
        self.nameLab.textColor = couponInfoItem.unavailable_type == 0 ? [UIColor colorWithHex:@"#FB2626"] : VHBlack85;

        self.rightView.backgroundColor = [UIColor colorWithHex:couponInfoItem.unavailable_type == 0 ? @"#FFE8E4" : @"#F5F5F5"];
        self.leftView.backgroundColor = [UIColor bm_colorGradientChangeWithSize:self.leftView.size direction:IHGradientChangeDirectionLevel startColor:[UIColor colorWithHex:couponInfoItem.unavailable_type == 0 ? @"#FF7C7C" : @"#D2D2D2"] endColor:[UIColor colorWithHex: couponInfoItem.unavailable_type == 0 ? @"#FB2626" : @"#BFBFBF"]];
    }
    
    self.topLine.backgroundColor = [UIColor bm_colorGradientChangeWithSize:CGSizeMake(12, 12) direction:IHGradientChangeDirectionLevel startColor:[UIColor colorWithHex:@"#FDF1ED"] endColor:[UIColor colorWithHex:@"#F3F2FF"]];
    self.bottomLine.backgroundColor = [UIColor bm_colorGradientChangeWithSize:CGSizeMake(12, 12) direction:IHGradientChangeDirectionLevel startColor:[UIColor colorWithHex:@"#FDF1ED"] endColor:[UIColor colorWithHex:@"#F3F2FF"]];
}

#pragma mark - 使用说明
- (void)useDescAction
{
    self.couponInfoItem.isShowUseDesc = !self.couponInfoItem.isShowUseDesc;
    
    if (self.clickUseDescBtn) {
        self.clickUseDescBtn();
    }
}

#pragma mark - 点击优惠券
- (void)selectBtnAction:(UIButton *)sender
{
    if (self.clickSelectBtn) {
        self.clickSelectBtn(!sender.selected);
    }
}

#pragma mark - 懒加载
- (UIView *)leftView
{
    if (!_leftView) {
        _leftView = [UIView new];
        _leftView.layer.cornerRadius = 8;
        // iOS 11.0以上设置指定圆角
        _leftView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMinXMaxYCorner;
    }
    return _leftView;
}
- (UILabel *)deductionLab
{
    if (!_deductionLab) {
        _deductionLab = [UILabel new];
    }
    return _deductionLab;
}
- (UILabel *)thresholdLab
{
    if (!_thresholdLab) {
        _thresholdLab = [UILabel new];
        _thresholdLab.textColor = [UIColor whiteColor];
        _thresholdLab.font = FONT(12);
    }
    return _thresholdLab;
}

- (UIView *)rightView
{
    if (!_rightView) {
        _rightView = [UIView new];
        _rightView.layer.masksToBounds = YES;
        _rightView.layer.cornerRadius = 8;
        _rightView.layer.maskedCorners = kCALayerMaxXMinYCorner | kCALayerMaxXMaxYCorner;
    }
    return _rightView;
}

- (UIImageView *)watermarkImg {
    if (!_watermarkImg) {
        _watermarkImg = [[UIImageView alloc] init];
    }
    return _watermarkImg;
}

- (UIImageView *)unusableImg {
    if (!_unusableImg) {
        _unusableImg = [[UIImageView alloc] init];
        _unusableImg.hidden = YES;
    }
    return _unusableImg;
}

- (UILabel *)nameLab {
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = FONT_Blod(14);
    }
    return _nameLab;
}

- (UIImageView *)unfulfilledConditionImg {
    if (!_unfulfilledConditionImg) {
        _unfulfilledConditionImg = [[UIImageView alloc] init];
        _unfulfilledConditionImg.hidden = YES;
        _unfulfilledConditionImg.image = [UIImage imageNamed:@"vh_goods_coupon_unfulfilledCondition"];
    }
    return _unfulfilledConditionImg;
}


- (UILabel *)productTypeLab {
    if (!_productTypeLab) {
        _productTypeLab = [[UILabel alloc] init];
        _productTypeLab.textColor = [UIColor colorWithHex:@"#434343"];
        _productTypeLab.font = FONT(10);
    }
    return _productTypeLab;
}

- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.textColor = [UIColor colorWithHex:@"#434343"];
        _timeLab.font = FONT(10);
    }
    return _timeLab;
}

- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setImage:[UIImage imageNamed:@"vh_goods_coupon_select"] forState:UIControlStateSelected];
        [_selectBtn setImage:[UIImage imageNamed:@"vh_goods_coupon_noselect"] forState:UIControlStateNormal];
        [_selectBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        // 扩大点击范围
        [_selectBtn setRadiusEdgeWithTop:10 right:10 bottom:10 left:10];
    }
    return _selectBtn;
}

- (UIButton *)useDescBtn {
    if (!_useDescBtn) {
        _useDescBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _useDescBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _useDescBtn.titleLabel.font = FONT(10);
        [_useDescBtn setTitle:@"使用说明" forState:UIControlStateNormal];
        [_useDescBtn setTitleColor:VHBlack45 forState:UIControlStateNormal];
        [_useDescBtn setTitleColor:VHMainColor forState:UIControlStateSelected];
        [_useDescBtn setImage:[UIImage imageNamed:@"vh_goods_coupon_useDesc"] forState:UIControlStateNormal];
        [_useDescBtn addTarget:self action:@selector(useDescAction) forControlEvents:UIControlEventTouchUpInside];
        // 扩大点击范围
        [_useDescBtn setRadiusEdgeWithTop:10 right:10 bottom:10 left:10];
    }
    return _useDescBtn;
}

- (YYLabel *)useDescLab
{
    if (!_useDescLab) {
        _useDescLab = [YYLabel new];
        _useDescLab.layer.cornerRadius = 8;
        _useDescLab.layer.maskedCorners = kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner;
        _useDescLab.numberOfLines = 0;
        _useDescLab.preferredMaxLayoutWidth = Screen_Width - 12*2;
        _useDescLab.font = FONT(10);
        _useDescLab.textColor = VHBlack45;
        _useDescLab.textContainerInset = UIEdgeInsetsMake(8, 12, 8, 12);
    }
    return _useDescLab;
}
- (UIView *)topLine
{
    if (!_topLine) {
        _topLine = [UIView new];
        _topLine.backgroundColor = VHBlack15;
        _topLine.layer.masksToBounds = YES;
        _topLine.layer.cornerRadius = 6;
    }
    return _topLine;
}
- (UIView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = VHBlack15;
        _bottomLine.layer.masksToBounds = YES;
        _bottomLine.layer.cornerRadius = 6;
    }
    return _bottomLine;
}
@end



@interface VHGoodsCouponAlert ()<UITableViewDelegate, UITableViewDataSource>
/// 标题
@property (nonatomic, strong) UILabel *titleLab;
/// 关闭按钮
@property (nonatomic, strong) UIButton *closeBtn;
/// 可用优惠券按钮
@property (nonatomic, strong) VHGoodsCouponMenuBtn *couponAvailableBtn;
/// 不可用优惠券按钮
@property (nonatomic, strong) VHGoodsCouponMenuBtn *couponUnavailableBtn;

/// 列表
@property (nonatomic, strong) UITableView *tableView;
/// 数据源
@property (nonatomic, strong) NSMutableArray *dataSource;

/// 房间详情
@property (nonatomic, strong) VHWebinarInfo *webinarInfo;
/// 商品详情
@property (nonatomic, strong) VHGoodsListItem *goodItem;
/// 商品数量
@property (nonatomic, copy) NSString *goodNum;

@end

@implementation VHGoodsCouponAlert

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.5];
        self.contentView.backgroundColor = [UIColor bm_colorGradientChangeWithSize:CGSizeMake(Screen_Width, 422) direction:IHGradientChangeDirectionLevel startColor:[UIColor colorWithHex:@"#FDF1ED"] endColor:[UIColor colorWithHex:@"#F3F2FF"]];

        // 添加
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.closeBtn];
        [self.contentView addSubview:self.couponAvailableBtn];
        [self.contentView addSubview:self.couponUnavailableBtn];
        [self.contentView addSubview:self.tableView];

        // 初始化布局
        [self setUpMasonry];
        
        // 扩大点击范围
        [self.closeBtn setRadiusEdgeWithTop:10 right:10 bottom:10 left:10];
        
        // 抽奖结束通知(优惠券需要刷新)
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lotteryEndReloadList) name:VH_LOTTERY_END object:nil];
    }

    return self;
}

#pragma mark - 初始化布局
- (void)setUpMasonry
{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(422);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(self.titleLab.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [self.couponAvailableBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(12);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.5);
        make.height.mas_equalTo(40);
    }];
    
    [self.couponUnavailableBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(12);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.5);
        make.height.mas_equalTo(40);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.couponAvailableBtn.mas_bottom).offset(16);
        make.left.bottom.right.mas_equalTo(0);
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [VUITool clipView:self.contentView corner:UIRectCornerTopLeft | UIRectCornerTopRight anSize:CGSizeMake(18, 18)];
}

#pragma mark - 可用优惠券列表
- (void)couponAvailableListWithWebinarInfo:(VHWebinarInfo *)webinarInfo goodItem:(VHGoodsListItem *)goodItem goodNum:(NSString *)goodNum
{
    self.webinarInfo = webinarInfo;
    self.goodItem = goodItem;
    self.goodNum = goodNum;
    
    [self couponAvailableList:YES];
}

#pragma mark - 结束抽奖刷新列表
- (void)lotteryEndReloadList
{
    [self couponAvailableList:YES];
    [self couponUnavailableList:NO];
}

#pragma mark - 可用优惠券列表
- (void)couponAvailableList:(BOOL)isShow
{
    __weak __typeof(self)weakSelf = self;
    [VHGoodsObject couponAvailableListWithWebinarId:self.webinarInfo.webinarId goods_id:self.goodItem.goods_id goods_num:self.goodNum complete:^(NSArray<VHGoodsCouponInfoItem *> *list, NSError *error) {
        __strong __typeof(weakSelf)self = weakSelf;
        self.couponAvailableBtn.titleLab.text = @"可用优惠券";
        if (list) {
            self.couponAvailableBtn.titleLab.text = [NSString stringWithFormat:@"可用优惠券（%ld）",list.count];

            if (isShow) {
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:list];
                
                // 选择第一个优惠券
                if (self.selectBestCoupon) {
                    self.selectBestCoupon([list firstObject]);
                }
            }
        }
        
        if (error) {
            [VHProgressHud showToast:error.domain];
        }
        
        [self.tableView reloadData];

    }];
}

#pragma mark - 不可用优惠券列表
- (void)couponUnavailableList:(BOOL)isShow
{
    __weak __typeof(self)weakSelf = self;
    [VHGoodsObject couponUnavailableListWithWebinarId:self.webinarInfo.webinarId goods_id:self.goodItem.goods_id goods_num:self.goodNum complete:^(NSArray<VHGoodsCouponInfoItem *> *list, NSError *error) {
        __strong __typeof(weakSelf)self = weakSelf;
        self.couponUnavailableBtn.titleLab.text = @"不可用优惠券";
        
        if (list) {
            self.couponUnavailableBtn.titleLab.text = [NSString stringWithFormat:@"不可用优惠券（%ld）",list.count];
            
            if (isShow) {
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:list];
            }
        }
        
        if (error) {
            [VHProgressHud showToast:error.domain];
        }
        
        [self.tableView reloadData];

    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak __typeof(self)weakSelf = self;

    VHGoodsCouponCell *cell = [VHGoodsCouponCell createCellWithTableView:tableView];
    // 取出每一个item
    VHGoodsCouponInfoItem * item = self.dataSource[indexPath.row];
    // set方法赋值
    cell.couponInfoItem = item;
    
    // 展开详情描述
    cell.clickUseDescBtn = ^{
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    };
    
    // 选择优惠券
    cell.clickSelectBtn = ^(BOOL isSelect) {
        __strong __typeof(weakSelf)self = weakSelf;
        
        // 先清空优惠券
        if (self.selectBestCoupon) {
            self.selectBestCoupon(nil);
        }
        
        // 遍历优惠券(单选)
        for (int i = 0; i<self.dataSource.count; i++) {
            VHGoodsCouponInfoItem *couponInfoItem = self.dataSource[i];
            if (isSelect == YES) {
                if (indexPath.row == i) {
                    if (self.selectBestCoupon) {
                        self.selectBestCoupon(item);
                    }
                    couponInfoItem.isBest = isSelect;
                } else {
                    couponInfoItem.isBest = !isSelect;
                }
            } else {
                couponInfoItem.isBest = NO;
            }
        }
        // 刷新TableView
        [tableView reloadData];
    };
    return cell;
}

#pragma mark - 弹窗
- (void)showGoodsCouponWithWebinarInfo:(VHWebinarInfo *)webinarInfo goodItem:(VHGoodsListItem *)goodItem goodNum:(NSString *)goodNum
{
    [super show];
    
    self.webinarInfo = webinarInfo;
    self.goodItem = goodItem;
    self.goodNum = goodNum;
    
    self.couponAvailableBtn.selected = YES;
    self.couponUnavailableBtn.selected = NO;
    
    [self couponAvailableList:self.couponAvailableBtn.selected];
    [self couponUnavailableList:!self.couponAvailableBtn.selected];
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

#pragma mark - 点击可用优惠券
- (void)clickCouponAvailableBtn
{
    self.couponAvailableBtn.selected = YES;
    self.couponUnavailableBtn.selected = NO;
    
    [self couponAvailableList:YES];
}

#pragma mark - 点击不可用优惠券
- (void)clickCouponUnavailableBtn
{
    self.couponAvailableBtn.selected = NO;
    self.couponUnavailableBtn.selected = YES;
    
    [self couponUnavailableList:YES];
}

#pragma mark - 点击关闭
- (void)closeBtnAction
{
    [self dismiss];
}

#pragma mark - 懒加载
- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = @"我的优惠券";
        _titleLab.font = FONT_Medium(14);
        _titleLab.textColor = [UIColor blackColor];
    }
    return _titleLab;
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

- (VHGoodsCouponMenuBtn *)couponAvailableBtn
{
    if (!_couponAvailableBtn) {
        _couponAvailableBtn = [[VHGoodsCouponMenuBtn alloc] init];
        _couponAvailableBtn.selected = YES;
        [_couponAvailableBtn addTarget:self action:@selector(clickCouponAvailableBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _couponAvailableBtn;
}

- (VHGoodsCouponMenuBtn *)couponUnavailableBtn
{
    if (!_couponUnavailableBtn) {
        _couponUnavailableBtn = [[VHGoodsCouponMenuBtn alloc] init];
        _couponUnavailableBtn.selected = NO;
        [_couponUnavailableBtn addTarget:self action:@selector(clickCouponUnavailableBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _couponUnavailableBtn;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.estimatedRowHeight = 180;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImage:[UIImage imageNamed:@"vh_goods_coupon_placeholder"] titleStr:@"暂无优惠券" detailStr:nil];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
