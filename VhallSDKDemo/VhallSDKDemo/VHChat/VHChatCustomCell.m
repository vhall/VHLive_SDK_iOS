//
//  VHChatCustomCell.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/23.
//

#import "VHChatCustomCell.h"
#import "VHSurveyWebView.h"

@implementation VHChatCustomModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

@end

@interface VHChatCustomCell ()

@property (nonatomic, strong) YYLabel * msg;    ///<聊天内容

@property (nonatomic, strong) VHSurveyWebView * surveyWebView;

@end

@implementation VHChatCustomCell

+ (VHChatCustomCell *)createCellWithTableView:(UITableView *)tableView
{
    VHChatCustomCell * cell = [tableView dequeueReusableCellWithIdentifier:@"VHChatCustomCell"];
    if (!cell) {
        cell = [[VHChatCustomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"VHChatCustomCell"];
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
- (void)setChatCustomModel:(VHChatCustomModel *)chatCustomModel
{
    _chatCustomModel = chatCustomModel;
    
    chatCustomModel.nickName = [VUITool substringToIndex:8 text:chatCustomModel.nickName isReplenish:YES];
    
    // 角色：1-主持人；2-观众；3-助理；4-嘉宾
    NSString * roleName = @"";
    switch (chatCustomModel.roleName) {
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
    roleName = [NSString stringWithFormat:@" %@ ",roleName];

    // 聊天内容
    NSString * content = @"";
    
    if ([chatCustomModel.content containsString:@"问卷"]) {
        content = [NSString stringWithFormat:@"%@ %@ %@ 点击查看",chatCustomModel.nickName,roleName,chatCustomModel.content];
    } else {
        content = [NSString stringWithFormat:@"%@ %@ %@",chatCustomModel.nickName,roleName,chatCustomModel.content];
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    attributedString.yy_font = FONT(14);
    attributedString.yy_color = [UIColor colorWithHex:@"#595959"];
    
    [attributedString yy_setFont:FONT(12) range:[content rangeOfString:roleName]];
    [attributedString yy_setColor:chatCustomModel.roleName == 1 ? [UIColor colorWithHex:@"#FB2626"] : [UIColor colorWithHex:@"#0A7FF5"] range:[content rangeOfString:roleName]];
    YYTextBorder * border = [YYTextBorder borderWithFillColor:chatCustomModel.roleName == 1 ? [UIColor colorWithHex:@"#FFD1C9"] : [UIColor colorWithHex:@"#ADE1FF"] cornerRadius:15/2];
    border.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
    [attributedString yy_setTextBackgroundBorder:border range:[content rangeOfString:roleName]];

    __weak __typeof(self)weakSelf = self;
    [attributedString yy_setTextHighlightRange:[content rangeOfString:@"点击查看"] color:[UIColor colorWithHex:@"#0A7FF5"] backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([chatCustomModel.content containsString:@"问卷"]) {
            if (strongSelf.clickSurveyToModel) {
                strongSelf.clickSurveyToModel(chatCustomModel);
            }
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
- (VHSurveyWebView *)surveyWebView
{
    if (!_surveyWebView) {
        _surveyWebView = [[VHSurveyWebView alloc] initWithFrame:[VUITool getCurrentScreenViewController].view.frame];
        [[VUITool getCurrentScreenViewController].view addSubview:_surveyWebView];
        [_surveyWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(0);
        }];
    }return _surveyWebView;
}

@end
