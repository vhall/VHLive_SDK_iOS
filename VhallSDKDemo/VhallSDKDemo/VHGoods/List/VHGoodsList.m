//
//  VHGoodsList.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/8/9.
//

#import "VHGoodsList.h"
#import "VHGoodsCardAlert.h"
#import "VHGoodsDetailAlert.h"
#import "VHGoodsConfirmOrderAlert.h"
#import "VHPushScreenCardDeleteAlert.h"

@implementation VHGoodsListCell

+ (VHGoodsListCell *)createCellWithTableView:(UITableView *)tableView
{
    VHGoodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VHGoodsListCell"];

    if (!cell) {
        cell = [[VHGoodsListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"VHGoodsListCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];

        [self.contentView addSubview:self.img];
        [_img addSubview:self.numLab];
        
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.infoLab];
        [self.contentView addSubview:self.discountTagLab];
        [self.contentView addSubview:self.discountPriceLab];
        [self.contentView addSubview:self.priceLab];
        [self.contentView addSubview:self.payBtn];

        // 设置约束
        [self setMasonryUI];
    }

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [VUITool clipView:_numLab corner:UIRectCornerTopLeft | UIRectCornerBottomRight anSize:CGSizeMake(2, 2)];
}

- (void)setMasonryUI
{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(12.5);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.width.mas_greaterThanOrEqualTo(20);
        make.height.mas_greaterThanOrEqualTo(13);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.img.mas_right).offset(8);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-12);
    }];
    
    [self.infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.img.mas_right).offset(8);
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(1);
        make.right.mas_equalTo(-12);
    }];

    [self.discountTagLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.img.mas_right).offset(8);
        make.bottom.mas_equalTo(self.img.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(34, 13));
    }];
    
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.bottom.mas_equalTo(self.img.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(48, 26));
    }];
    
    [self.discountPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.discountTagLab.mas_right).offset(6);
        make.bottom.mas_equalTo(self.img.mas_bottom);
    }];
    
    [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.discountPriceLab.mas_right).offset(6);
        make.bottom.mas_equalTo(self.img.mas_bottom);
    }];
    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.img.mas_bottom).offset(12.5).priorityHigh();
    }];
}

- (void)setItem:(VHGoodsListItem *)item
{
    _item = item;
    
    // 使用SDWebImage库设置self.img的图片为指定URL的图片
    [self.img sd_setImageWithURL:[NSURL URLWithString:item.cover_img]];

    // 设置self.titleLab的文本为商品名称
    self.titleLab.text = item.name;

    // 设置self.infoLab的文本为商品信息
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
            make.left.mas_equalTo(self.img.mas_right).offset(8);
            make.bottom.mas_equalTo(self.img.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
        
        [self.discountPriceLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.img.mas_right).offset(8);
            make.bottom.mas_equalTo(self.img.mas_bottom);
        }];

    } else {
        
        [self.discountTagLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.img.mas_right).offset(8);
            make.bottom.mas_equalTo(self.img.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(34, 13));
        }];
        
        [self.discountPriceLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.discountTagLab.mas_right).offset(6);
            make.bottom.mas_equalTo(self.img.mas_bottom);
        }];

    }
}

- (void)setIndex:(NSInteger)index
{
    _index = index;
    
    // 设置self.numLab的文本为订单号，格式为xxx，如果订单号小于10，则在前面添加0
    self.numLab.text = [NSString stringWithFormat:@"%@%ld", index + 1 < 10 ? @"0" : @"", index + 1];
}

#pragma mark - 立即购买
- (void)payBtnAction
{
    if (self.clickPayBtnBlock) {
        self.clickPayBtnBlock(self.item);
    }
}

#pragma mark - 懒加载

- (YYLabel *)numLab {
    if (!_numLab) {
        _numLab = [[YYLabel alloc] init];
        _numLab.textColor = [UIColor whiteColor];
        _numLab.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.45];
        _numLab.font = FONT(10);
        _numLab.layer.masksToBounds = YES;
        _numLab.textContainerInset = UIEdgeInsetsMake(2, 4, 2, 4);
    }
    return _numLab;
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
        _titleLab.numberOfLines = 2;
        _titleLab.preferredMaxLayoutWidth = Screen_Width - 12 - 80 - 8 - 12;
        _titleLab.font = FONT(14);
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


- (UIButton *)payBtn {
    if (!_payBtn) {
        _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _payBtn.backgroundColor = VHMainColor;
        _payBtn.layer.masksToBounds = YES;
        _payBtn.layer.cornerRadius = 24/2;
        _payBtn.titleLabel.font = FONT(12);
        [_payBtn setTitle:@"购买" forState:UIControlStateNormal];
        [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_payBtn addTarget:self action:@selector(payBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payBtn;
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


@end

@interface VHGoodsList ()<UITableViewDelegate, UITableViewDataSource, VHGoodsObjectDelegate>

/// 列表
@property (nonatomic, strong) UITableView *tableView;
/// 数据源
@property (nonatomic, strong) NSMutableArray *dataSource;

/// 活动详情
@property (nonatomic, strong) VHWebinarInfo * webinarInfo;
/// 推屏卡片类
@property (nonatomic, strong) VHGoodsObject *goodsObject;
/// 商品卡片弹窗
@property (nonatomic, strong) VHGoodsCardAlert *goodsCardAlert;
/// 商品详情弹窗
@property (nonatomic, strong) VHGoodsDetailAlert *goodsDetailAlert;
/// 订单详情
@property (nonatomic, strong) VHGoodsConfirmOrderAlert *goodOrderAlert;
/// 已被删除提示
@property (nonatomic, strong) VHPushScreenCardDeleteAlert *pushScreenCardDeleteAlert;
/// 订单号
@property (nonatomic, copy) NSString *order_no;
/// 设置界面的详情
@property (nonatomic, strong) VHGoodsSettingItem *settingItem;
@end

@implementation VHGoodsList

- (instancetype)initWithFrame:(CGRect)frame object:(NSObject *)object
{
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithHex:@"#F8F8F8"];
        self.webinarInfo = ((VHallMoviePlayer *)object).webinarInfo;
        
        // 推屏卡片
        if (!_goodsObject) {
            _goodsObject = [[VHGoodsObject alloc] initWithObject:object];
            _goodsObject.delegate = self;
        }

        [self addSubview:self.tableView];

        // 初始化布局
        [self setUpMasonry];
        
        // 接收刷新订单详情的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goodsOrderInfo) name:VH_GOODS_ORDERINFO object:self];
    }

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - 初始化布局
- (void)setUpMasonry
{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

#pragma mark - 在线活动商品列表(发起/观看端)
- (void)requestGoodsGetList
{
    __weak __typeof(self) weakSelf = self;
    [VHGoodsObject goodsGetOnlineListWithStatus:1 complete:^(NSArray<VHGoodsListItem *> *list, NSError *error) {
        __strong __typeof(weakSelf)self = weakSelf;
        if (list) {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:list];
            
            for (VHGoodsListItem * item in list) {
                if (item.push_status == 1) {
                    [self.goodsCardAlert showGoodsCardItem:item];
                    break;
                }
            }
        }
        
        if (error) {
            [VHProgressHud showToast:error.domain];
        }
        
        // 回调当前是否有商品
        if (self.delegate && [self.delegate respondsToSelector:@selector(isHaveGoods:)]) {
            [self.delegate isHaveGoods:self.dataSource.count > 0];
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
    VHGoodsListCell *cell = [VHGoodsListCell createCellWithTableView:tableView];
    cell.item = self.dataSource[indexPath.row];
    cell.index = indexPath.row;
    __weak __typeof(self)weakSelf = self;
    cell.clickPayBtnBlock = ^(VHGoodsListItem *item) {
        __strong __typeof(weakSelf)self = weakSelf;
        [self goodsSettingWithListItem:item];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 点击展示
    VHGoodsListItem * item = self.dataSource[indexPath.row];
    [self checkDetailWithInquire:item];
}

#pragma mark - 详情查询
- (void)checkDetailWithInquire:(VHGoodsListItem * )item
{
    __weak __typeof(self)weakSelf = self;
    [VHGoodsObject goodsWebinarOnlineGoodsInfoWithGoodsId:item.goods_id complete:^(VHGoodsListItem *goodsItem, NSError *error) {
        __strong __typeof(weakSelf)self = weakSelf;
        
        if (goodsItem) {
            [self.goodsDetailAlert showGoodsDetail:goodsItem];
        }
        
        if (error) {
            if (error.code == 530094) {
                // 商品已被删除
                [[VUITool getCurrentScreenViewController].view addSubview:self.pushScreenCardDeleteAlert];
                [self.pushScreenCardDeleteAlert show];
            } else {
                [VHProgressHud showToast:error.domain];
            }
        }
    }];
}
#pragma mark - 点击查看商品详情页
- (void)clickCheckDetail:(VHGoodsListItem *)item
{
    [self checkDetailWithInquire:item];
}

#pragma mark - 获取订单设置详情
- (void)goodsSettingWithListItem:(VHGoodsListItem *)listItem
{
    // 平台购买
    if (listItem.buy_type == 1) {
        __weak __typeof(self)weakSelf = self;
        [VHGoodsObject goodsWebinarSettingInfoWithWebinarId:self.webinarInfo.webinarId complete:^(VHGoodsSettingItem *settingItem, NSError *error) {
            __strong __typeof(weakSelf)self = weakSelf;
            if (settingItem) {
                self.settingItem = settingItem;
                [self.goodOrderAlert showGoodsOrder:listItem settingItem:settingItem webinarInfo:self.webinarInfo];
            }
            
            if (error) {
                [VHProgressHud showToast:error.domain];
            }
        }];
    }
    
    // 外链购买直接跳转出去
    if (listItem.buy_type == 2) {
        [[UIApplication sharedApplication]  openURL:[NSURL URLWithString:listItem.url]
                                            options:@{}
                                  completionHandler:^(BOOL success) {
            VHLog(@"外链跳转%@", success ? @"完成" : @"失败");
        }];
    }
    
    // 自定义购买
    if (listItem.buy_type == 3) {
        [VHProgressHud showToast:[NSString stringWithFormat:@"三方商品id%@",listItem.third_goods_id]];
    }
}

#pragma mark - 获取订单详情
- (void)goodsOrderInfo
{
    [VHGoodsObject goodsOrderInfoWithOrderNo:self.order_no complete:^(VHGoodsOrderInfo *orderInfo, NSError *error) {
        if (orderInfo) {
            [VHProgressHud showToast:[NSString stringWithFormat:@"支付状态 %@",orderInfo.order_status]];
        }
        if (error) {
            [VHProgressHud showToast:error.domain];
        }
    }];
}

#pragma mark - VHGoodsObjectDelegate
#pragma mark 商品 推屏/取消推屏
- (void)pushGoodsCardModel:(VHGoodsPushMessageItem *)model push_status:(NSInteger)push_status
{
    // 推送
    if (push_status == 1) {
        [self.goodsCardAlert showGoodsCardItem:model.goods_info];
        
        if ([self.delegate respondsToSelector:@selector(pushGoodsCardModel:)]) {
            [self.delegate pushGoodsCardModel:model];
        }
    }
    
    // 取消推送
    if (push_status == 2 && _goodsCardAlert) {
        [_goodsCardAlert hide];
    }
}

#pragma mark 删除商品
- (void)deleteGoods:(NSArray *)del_goods_ids cdn_url:(NSString *)cdn_url
{
    if (del_goods_ids.count > 0) {
        // 刷新列表
        [self requestGoodsGetList];
        
        // 判断是否需要移除推屏商品
        for (NSString * idString in del_goods_ids) {
            // 走隐藏弹窗逻辑
            [self hiddenAlertWithGoodsId:idString];
        }
    }
}

#pragma mark 商品添加
- (void)addGoodsInfo:(VHGoodsListItem *)goods_info cdn_url:(NSString *)cdn_url
{    
    /** 也可以直接请求 cdn_url 速度更快*/
    // 刷新列表
    [self requestGoodsGetList];
}

#pragma mark 商品更新
- (void)updateGoodsInfo:(VHGoodsListItem *)goods_info cdn_url:(NSString *)cdn_url
{
    if (goods_info.status == 0) {
        // 走隐藏弹窗逻辑
        [self hiddenAlertWithGoodsId:goods_info.goods_id];
    } else {
        // 走更新逻辑
        [VHProgressHud showToast:@"当前商品信息发生变化"];
        if (self.goodsCardAlert.isShow) {
            [self.goodsCardAlert showGoodsCardItem:goods_info];
        }
        
        if (self.goodsDetailAlert.isShow) {
            [self checkDetailWithInquire:goods_info];
        }
        
        if (self.goodOrderAlert.isShow) {
            [self.goodOrderAlert showGoodsOrder:goods_info settingItem:self.settingItem webinarInfo:self.webinarInfo];
        }
    }
    
    /** 也可以直接请求 cdn_url 速度更快*/
    // 刷新列表
    [self requestGoodsGetList];
}

#pragma mark 商品列表快速刷新
- (void)updateGoodsListWithCdnUrl:(NSString *)cdn_url
{
    /** 也可以直接请求 cdn_url 速度更快*/
    // 刷新列表
    [self requestGoodsGetList];
}

#pragma mark 支付状态
- (void)goodsOrderItem:(VHGoodsPayStatusItem *)item
{
    VHLog(@"支付状态 == %@",item.order_status);
    [VHProgressHud showToast:[NSString stringWithFormat:@"支付状态 %@",item.order_status]];
}

#pragma mark 跳转支付是否完成
- (void)paySkipIsComplete:(BOOL)complete
{
    VHLog(@"跳转支付是否完成 == %d",complete);
    [VHProgressHud showToast:[NSString stringWithFormat:@"跳转支付%@",complete ? @"完成" : @"失败"]];
}

#pragma mark 跳转支付失败详情
- (void)errorDetail:(NSError *)error
{
    VHLog(@"跳转支付失败详情 == %@",error.localizedDescription);
    [VHProgressHud showToast:[NSString stringWithFormat:@"跳转支付失败 %@",error.localizedDescription]];
}

#pragma mark - 隐藏弹窗
- (void)hiddenAlertWithGoodsId:(NSString *)goods_id
{
    if ([_goodsCardAlert.item.goods_id isEqualToString:goods_id]) {
        [VHProgressHud showToast:@"当前商品已下架或删除"];
        [_goodsCardAlert hide];
    }
    if ([_goodsDetailAlert.item.goods_id isEqualToString:goods_id]) {
        [VHProgressHud showToast:@"当前商品已下架或删除"];
        [_goodsDetailAlert dismiss];
    }
    if ([_goodOrderAlert.item.goods_id isEqualToString:goods_id]) {
        [VHProgressHud showToast:@"当前商品已下架或删除"];
        [_goodOrderAlert dismiss];
    }
}

#pragma mark - 懒加载

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, 400) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHex:@"#F8F8F8"];
        _tableView.estimatedRowHeight = 180;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

- (VHGoodsCardAlert *)goodsCardAlert
{
    if (!_goodsCardAlert) {
        _goodsCardAlert = [[VHGoodsCardAlert alloc] initWithFrame:CGRectMake(Screen_Width, Screen_Height - 152 - 60 - SAFE_BOTTOM - NAVIGATION_BAR_H, 96, 152)];
        __weak __typeof(self)weakSelf = self;
        _goodsCardAlert.clickCheckDetailBlock = ^(VHGoodsListItem *item) {
            __strong __typeof(weakSelf)self = weakSelf;
            [self checkDetailWithInquire:item];
        };
        [[VUITool getCurrentScreenViewController].view addSubview:_goodsCardAlert];
    }
    return _goodsCardAlert;
}

- (VHGoodsDetailAlert *)goodsDetailAlert
{
    if (!_goodsDetailAlert) {
        _goodsDetailAlert = [[VHGoodsDetailAlert alloc] initWithFrame:[VUITool getCurrentScreenViewController].view.bounds];
        __weak __typeof(self)weakSelf = self;
        _goodsDetailAlert.clickPayBtnBlock = ^(VHGoodsListItem *item) {
            __strong __typeof(weakSelf)self = weakSelf;
            [self goodsSettingWithListItem:item];
        };
        [[VUITool getCurrentScreenViewController].view addSubview:_goodsDetailAlert];
    }
    return _goodsDetailAlert;
}

- (VHGoodsConfirmOrderAlert *)goodOrderAlert
{
    if (!_goodOrderAlert) {
        _goodOrderAlert = [[VHGoodsConfirmOrderAlert alloc] initWithFrame:[VUITool getCurrentScreenViewController].view.bounds];
        __weak __typeof(self)weakSelf = self;
        _goodOrderAlert.skipWXOrALIPayBlock = ^(NSURL *url,NSString *referer,NSString *order_no) {
            __strong __typeof(weakSelf)self = weakSelf;
            // 订单号
            self.order_no = order_no;
            // 跳转三方应用支付
            [self.goodsObject platformPaymentToPayWithOrderUrl:url scheme:@"demo.vhall.com" referer:referer];
        };
        [[VUITool getCurrentScreenViewController].view addSubview:_goodOrderAlert];
    }
    return _goodOrderAlert;
}

- (VHPushScreenCardDeleteAlert *)pushScreenCardDeleteAlert
{
    if (!_pushScreenCardDeleteAlert) {
        _pushScreenCardDeleteAlert = [[VHPushScreenCardDeleteAlert alloc] initWithFrame:[VUITool getCurrentScreenViewController].view.bounds];
    }
    
    return _pushScreenCardDeleteAlert;
}

#pragma mark - 分页
- (UIView *)listView {
    return self;
}

#pragma mark - 释放
- (void)dealloc
{
    VHLog(@"%s释放", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String]);
}


@end

