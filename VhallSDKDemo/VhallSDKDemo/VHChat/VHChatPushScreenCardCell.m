//
//  VHChatPushScreenCardCell.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/7/3.
//

#import "VHChatPushScreenCardCell.h"

@interface VHChatPushScreenCardCell ()
/// 详情
@property (nonatomic, strong) YYLabel *msg;
@end

@implementation VHChatPushScreenCardCell

+ (VHChatPushScreenCardCell *)createCellWithTableView:(UITableView *)tableView
{
    VHChatPushScreenCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VHChatPushScreenCardCell"];

    if (!cell) {
        cell = [[VHChatPushScreenCardCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"VHChatPushScreenCardCell"];
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
- (void)setPushScreenCardListItem:(VHPushScreenCardItem *)pushScreenCardListItem
{
    _pushScreenCardListItem = pushScreenCardListItem;

    NSString *content = [NSString stringWithFormat:@"%@ %@ 推送了卡片 点击查看\n%@", pushScreenCardListItem.operator_role, pushScreenCardListItem.operator_name, pushScreenCardListItem.title];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
        
    attributedString.yy_font = FONT(14);
    attributedString.yy_color = [UIColor colorWithHex:@"#595959"];

    [attributedString yy_setFont:FONT(12) range:[content rangeOfString:pushScreenCardListItem.operator_role]];
    [attributedString yy_setColor:[pushScreenCardListItem.role_name integerValue] == 1 ? [UIColor colorWithHex:@"#FB2626"] : [UIColor colorWithHex:@"#0A7FF5"] range:[content rangeOfString:pushScreenCardListItem.operator_role]];
    YYTextBorder *border = [YYTextBorder borderWithFillColor:[pushScreenCardListItem.role_name integerValue] == 1 ? [UIColor colorWithHex:@"#FFD1C9"] : [UIColor colorWithHex:@"#ADE1FF"] cornerRadius:15 / 2];
    border.insets = UIEdgeInsetsMake(-2, -2, -2, -2);
    [attributedString yy_setTextBackgroundBorder:border range:[content rangeOfString:pushScreenCardListItem.operator_role]];

    [attributedString yy_setColor:VHBlack45 range:[content rangeOfString:pushScreenCardListItem.operator_name]];

    __weak __typeof(self) weakSelf = self;
    [attributedString yy_setTextHighlightRange:[content rangeOfString:@"点击查看"]
                                         color:[UIColor colorWithHex:@"#0A7FF5"]
                               backgroundColor:nil
                                     tapAction:^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
        __strong __typeof(weakSelf) self = weakSelf;
        if (self.clickPushScreenCardCell) {
            self.clickPushScreenCardCell(pushScreenCardListItem);
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
