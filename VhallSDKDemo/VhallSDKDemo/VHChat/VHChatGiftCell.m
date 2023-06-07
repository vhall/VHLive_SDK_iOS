//
//  VHChatGiftCell.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/26.
//

#import "VHChatGiftCell.h"

@interface VHChatGiftCell ()

@property (nonatomic, strong) UIView *bgView;   ///<背景
@property (nonatomic, strong) YYLabel *msg;     ///<聊天内容
@property (nonatomic, strong) UIImageView *giftImgView;  ///<礼物图片

@end

@implementation VHChatGiftCell

+ (VHChatGiftCell *)createCellWithTableView:(UITableView *)tableView
{
    VHChatGiftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VHChatGiftCell"];

    if (!cell) {
        cell = [[VHChatGiftCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"VHChatGiftCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //背景色
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];

        // 添加控件
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.msg];
        [self.bgView addSubview:self.giftImgView];

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

    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(16);
        make.width.mas_greaterThanOrEqualTo(80);
        make.height.mas_equalTo(24);
    }];

    [self.msg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.mas_equalTo(self.bgView.mas_centerY);
    }];

    [self.giftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.msg.mas_right).offset(3);
        make.centerY.mas_equalTo(self.msg.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];

    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.giftImgView.mas_right).offset(12);
    }];

    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bgView.mas_bottom);
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = self.bgView.height / 2;
    self.bgView.backgroundColor = [UIColor colorWithHexString:@"#FFD1C9" alpha:.2];
}

#pragma mark - 赋值
- (void)setGiftModel:(VHallGiftModel *)giftModel
{
    _giftModel = giftModel;

    NSString *nickName = giftModel.gift_user_nickname;

    if (nickName.length > 8) {
        nickName = [NSString stringWithFormat:@"%@...", [nickName substringToIndex:8]];
    }

    NSString *content = [NSString stringWithFormat:@"%@ 送出一个 %@", nickName, giftModel.gift_name];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    attributedString.yy_font = FONT(14);
    attributedString.yy_color = [UIColor colorWithHex:@"#262626"];

    NSRange nickNameRange = [content rangeOfString:nickName];
    [attributedString yy_setColor:[UIColor colorWithHexString:@"#595959"] range:nickNameRange];

    self.msg.attributedText = attributedString;

    [self.giftImgView sd_setImageWithURL:[NSURL URLWithString:giftModel.gift_image_url]];
}

#pragma mark - 懒加载
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
    }

    return _bgView;
}

- (YYLabel *)msg
{
    if (!_msg) {
        _msg = [YYLabel new];
    }

    return _msg;
}

- (UIImageView *)giftImgView
{
    if (!_giftImgView) {
        _giftImgView = [UIImageView new];
        _giftImgView.layer.masksToBounds = YES;
        _giftImgView.layer.cornerRadius = 20 / 2;
        [self addSubview:_giftImgView];
    }

    return _giftImgView;
}

@end
