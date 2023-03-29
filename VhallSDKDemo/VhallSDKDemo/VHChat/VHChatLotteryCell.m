//
//  VHChatLotteryCell.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/3/20.
//

#import "VHChatLotteryCell.h"

@interface VHChatLotteryCell ()
/// 聊天内容
@property (nonatomic, strong) YYLabel * msg;
@end

@implementation VHChatLotteryCell

+ (VHChatLotteryCell *)createCellWithTableView:(UITableView *)tableView
{
    VHChatLotteryCell * cell = [tableView dequeueReusableCellWithIdentifier:@"VHChatLotteryCell"];
    if (!cell) {
        cell = [[VHChatLotteryCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"VHChatLotteryCell"];
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
        make.height.mas_equalTo(24);
    }];
    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.msg.mas_bottom);
    }];
}

#pragma mark - 赋值
- (void)setStartModel:(VHallStartLotteryModel *)startModel
{
    _startModel = startModel;
    
    // 聊天内容
    NSString * content = @"抽奖正在进行中";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    attributedString.yy_font = FONT(14);
    attributedString.yy_color = [UIColor colorWithHex:@"#595959"];

    self.msg.attributedText = attributedString;
}

- (void)setEndModel:(VHallEndLotteryModel *)endModel
{
    _endModel = endModel;
    
    // 聊天内容
    NSString * content = @"抽奖已结束，查看中奖名单";

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    attributedString.yy_font = FONT(14);
    attributedString.yy_color = [UIColor colorWithHex:@"#595959"];
    
    __weak __typeof(self)weakSelf = self;
    [attributedString yy_setTextHighlightRange:[content rangeOfString:@"查看中奖名单"] color:[UIColor colorWithHex:@"#0A7FF5"] backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        if (weakSelf.clickChekWinList) {
            weakSelf.clickChekWinList(endModel);
        }
    }];

    self.msg.attributedText = attributedString;
}

#pragma mark - 懒加载
- (YYLabel *)msg
{
    if (!_msg) {
        _msg = [YYLabel new];
        _msg.backgroundColor = [UIColor colorWithHexString:@"#FFD1C9" alpha:.2];
        _msg.layer.masksToBounds = YES;
        _msg.layer.cornerRadius = 24/2;
        _msg.textContainerInset = UIEdgeInsetsMake(2, 12, 2, 12);
    } return _msg;
}

@end
