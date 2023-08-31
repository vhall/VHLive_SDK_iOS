//
//  VHChatGoodsCell.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/8/14.
//

#import "VHChatGoodsCell.h"

@interface VHChatGoodsCell ()
/// 详情
@property (nonatomic, strong) YYLabel *msg;
@end

@implementation VHChatGoodsCell

+ (VHChatGoodsCell *)createCellWithTableView:(UITableView *)tableView
{
    VHChatGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VHChatGoodsCell"];

    if (!cell) {
        cell = [[VHChatGoodsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"VHChatGoodsCell"];
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
        [self.contentView addSubview:self.msg];

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

    [self.msg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(16);
    }];

    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.msg.mas_bottom);
    }];
}

#pragma mark - 赋值
- (void)setMessageItem:(VHGoodsPushMessageItem *)messageItem
{
    _messageItem = messageItem;
    
    // 角色：1-主持人；2-观众；3-助理；4-嘉宾
    NSString *roleName = @"";
    switch (messageItem.role_name) {
        case 1:
            roleName = @"主持人";
            break;

        case 2:
            roleName = @"观众";
            break;

        case 3:
            roleName = @"助理";
            break;

        case 4:
            roleName = @"嘉宾";
            break;

        default:
            break;
    }
    
    NSString *content = [NSString stringWithFormat:@"%@ %@ 推送了商品 点击查看\n%@", roleName, messageItem.pusher_nickname, messageItem.goods_name];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
        
    attributedString.yy_font = FONT(14);
    attributedString.yy_color = [UIColor colorWithHex:@"#595959"];

    [attributedString yy_setFont:FONT(12) range:[content rangeOfString:roleName]];
    [attributedString yy_setColor:messageItem.role_name == 1 ? [UIColor colorWithHex:@"#FB2626"] : [UIColor colorWithHex:@"#0A7FF5"] range:[content rangeOfString:roleName]];
    YYTextBorder *border = [YYTextBorder borderWithFillColor:messageItem.role_name == 1 ? [UIColor colorWithHex:@"#FFD1C9"] : [UIColor colorWithHex:@"#ADE1FF"] cornerRadius:15 / 2];
    border.insets = UIEdgeInsetsMake(-2, -2, -2, -2);
    [attributedString yy_setTextBackgroundBorder:border range:[content rangeOfString:roleName]];

    [attributedString yy_setColor:VHBlack45 range:[content rangeOfString:messageItem.pusher_nickname]];

    __weak __typeof(self) weakSelf = self;
    [attributedString yy_setTextHighlightRange:[content rangeOfString:@"点击查看"]
                                         color:[UIColor colorWithHex:@"#0A7FF5"]
                               backgroundColor:nil
                                     tapAction:^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
        __strong __typeof(weakSelf) self = weakSelf;
        if (self.clickGoodsCell) {
            self.clickGoodsCell(messageItem);
        }
    }];
    
    [attributedString yy_setAlignment:NSTextAlignmentCenter range:NSMakeRange(0, attributedString.length)];
    self.msg.attributedText = attributedString;

}

#pragma mark - 懒加载
- (YYLabel *)msg
{
    if (!_msg) {
        _msg = [YYLabel new];
        _msg.numberOfLines = 2;
        _msg.preferredMaxLayoutWidth = Screen_Width - 32;
        _msg.backgroundColor = [UIColor colorWithHexString:@"#FFD1C9" alpha:.2];
        _msg.layer.masksToBounds = YES;
        _msg.layer.cornerRadius = 24 / 2;
        _msg.textContainerInset = UIEdgeInsetsMake(2, 12, 2, 12);
    }

    return _msg;
}

@end
