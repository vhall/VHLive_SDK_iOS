//
//  VHFashionStyleChatView.m
//  UIModel
//
//  Created by 郭超 on 2022/7/21.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHFashionStyleChatView.h"

@interface VHCChatTableViewCell ()

/// 聊天内容
@property (nonatomic, strong) YYLabel * msgLab;

/// 角色
@property (nonatomic, strong) YYLabel * roleLab;

/// 礼物图片
@property (nonatomic, strong) UIImageView * giftImg;

@end

@implementation VHCChatTableViewCell


+ (VHCChatTableViewCell *)createCellWithTableView:(UITableView *)tableView
{
    VHCChatTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"VHCChatTableViewCell"];
    if (!cell) {
        cell = [[VHCChatTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"VHCChatTableViewCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //背景色
        [self.contentView addSubview:self.msgLab];
        // 设置约束
        [self setMasonryUI];
    }
    return self;
}

#pragma mark - 设置约束
- (void)setMasonryUI
{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self);
    }];
    
    [self.msgLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14);
        make.left.mas_equalTo(0);
    }];
    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.msgLab.mas_bottom).offset(0);
    }];
}

#pragma mark - 赋值
- (void)setModel:(VHallChatModel *)model {
    
    _model = model;
    if([_model isKindOfClass:[VHallCustomMsgModel class]]) { // 自定义消息
        
    }else{ // 聊天消息
        // 聊天内容
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:model.text];
        attributedString.yy_font = FONT_FZZZ(14);
        attributedString.yy_kern = @1;
        attributedString.yy_color = [UIColor colorWithHex:@"#FFFFFF"];

        
        self.roleLab.hidden = NO;
        _roleLab.font = FONT_FZZZ(10);

        //1:主持人 2：观众  3：助理 4：嘉宾
        CGSize roleSize = CGSizeMake(28, 15);
        switch (model.role_name) {
            case 1:
                _roleLab.backgroundColor = [UIColor colorWithHexString:@"#FB2626" alpha:.15];
                _roleLab.textColor = [UIColor colorWithHex:@"#FB2626"];
                _roleLab.text = @"主持人";
                roleSize = CGSizeMake(38, 15);
                break;
            case 2:
                _roleLab.hidden = YES;
                break;
            case 3:
                _roleLab.backgroundColor = [UIColor colorWithHexString:@"#0A7FF5" alpha:.15];
                _roleLab.textColor = [UIColor colorWithHex:@"#0A7FF5"];
                _roleLab.text = @"助理";
                break;
            case 4:
                _roleLab.backgroundColor = [UIColor colorWithHexString:@"#0A7FF5" alpha:.15];
                _roleLab.textColor = [UIColor colorWithHex:@"#0A7FF5"];
                _roleLab.text = @"嘉宾";
                break;
            default:
                break;
        }

        NSString * nickName = model.user_name;
        if (nickName.length > 8) {
            nickName = [NSString stringWithFormat:@"%@...",[model.user_name substringToIndex:8]];
        }

        NSMutableAttributedString * nickNameAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",nickName]];
        nickNameAtt.yy_font = FONT_FZZZ(14);
        nickNameAtt.yy_color = [UIColor colorWithHexString:@"#FFFFFF" alpha:.65];
        [attributedString insertAttributedString:nickNameAtt atIndex:0];

        if (model.role_name && model.role_name != 2) {
            
            NSMutableAttributedString * kgAtt = [[NSMutableAttributedString alloc] initWithString:@" "];
            [attributedString insertAttributedString:kgAtt atIndex:0];

            NSMutableAttributedString *attachment = [NSMutableAttributedString yy_attachmentStringWithContent:_roleLab contentMode:UIViewContentModeScaleToFill attachmentSize:roleSize alignToFont:FONT_FZZZ(14) alignment:YYTextVerticalAlignmentCenter];
            [attributedString insertAttributedString:attachment atIndex:0];
        }
        
        self.msgLab.attributedText = attributedString;
    }
    
}
- (void)setGiftModel:(VHallGiftModel *)giftModel
{
    _giftModel = giftModel;
    
    NSString * nickName = giftModel.gift_user_nickname;
    if (nickName.length > 8) {
        nickName = [NSString stringWithFormat:@"%@...",[giftModel.gift_user_nickname substringToIndex:8]];
    }

    // 聊天内容
    NSString * content = [NSString stringWithFormat:@"%@ 送出%@",nickName,giftModel.gift_name];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    attributedString.yy_font = FONT_FZZZ(13);
    attributedString.yy_color = [UIColor colorWithHex:@"#FFFFFF"];
    
    NSRange nickNameRange = [content rangeOfString:giftModel.gift_user_nickname];
    [attributedString yy_setColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:.65] range:nickNameRange];
    
    // 礼物图片
    [self.giftImg sd_setImageWithURL:[NSURL URLWithString:giftModel.gift_image_url]];
    NSMutableAttributedString * giftImgAtt = [NSMutableAttributedString yy_attachmentStringWithContent:_giftImg contentMode:UIViewContentModeScaleToFill attachmentSize:_giftImg.size alignToFont:FONT_FZZZ(13) alignment:YYTextVerticalAlignmentCenter];
    [attributedString appendAttributedString:giftImgAtt];

    self.msgLab.attributedText = attributedString;
}
#pragma mark - 懒加载
- (YYLabel *)msgLab
{
    if (!_msgLab) {
        _msgLab = [YYLabel new];
        _msgLab.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.25];
        _msgLab.numberOfLines = 0;
        _msgLab.preferredMaxLayoutWidth = 253;
        _msgLab.textColor = [UIColor colorWithHex:@"F7F7F7"];
        _msgLab.layer.masksToBounds = YES;
        _msgLab.layer.cornerRadius = 19 / 2;
        _msgLab.textContainerInset = UIEdgeInsetsMake(0, 6, 0, 6);
    }return _msgLab;
}

- (YYLabel *)roleLab
{
    if (!_roleLab) {
        _roleLab = [YYLabel new];
        _roleLab.layer.masksToBounds = YES;
        _roleLab.layer.cornerRadius = 15 / 2;
        _roleLab.textContainerInset = UIEdgeInsetsMake(0, 4, 0, 4);
    }return _roleLab;
}

- (UIImageView *)giftImg
{
    if (!_giftImg) {
        _giftImg = [UIImageView new];
        _giftImg.frame = CGRectMake(0, 0, 18, 18);
        _giftImg.layer.masksToBounds = YES;
        _giftImg.layer.cornerRadius = 18/2;
    }return _giftImg;
}
@end

@interface VHFashionStyleChatView ()<UITableViewDataSource,UITableViewDelegate>
/// 列表
@property (nonatomic, strong) UITableView* chatTableView;
/// 聊天数据源
@property (nonatomic, strong) NSMutableArray * chatDataSource;

@end

@implementation VHFashionStyleChatView


- (instancetype)init
{
    if ([super init]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        // 添加控件
        [self addViews];

    }return self;
}

#pragma mark - 添加UI
- (void)addViews
{
    // 初始化UI
    [self masonryUI];
}

#pragma mark - 初始化UI
- (void)masonryUI
{
    [self.chatTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
    }];
}

#pragma mark - 获取历史聊天记录
- (void)loadHistoryWithChat:(VHallChat *)chat page:(NSInteger)page
{
    if (page<1) {page = 1;}
    self.chatListPage = page;
    
    NSString * msg_id = @"";
    if (page > 1 && self.chatDataSource.count > 0) {
        VHallChatModel * msgFirstModel = [self.chatDataSource firstObject];
        msg_id = msgFirstModel.msg_id;
    }else{
        msg_id = @"";
    }
    
    __weak typeof(self) weakSelf = self;
    [chat getInteractsChatGetListWithMsg_id:msg_id page_num:page page_size:10 start_time:nil is_role:0 anchor_path:@"down" success:^(NSArray<VHallChatModel *> *msgs) {
        //过滤私聊 传递target_id,当前用户join_id
        NSString *currentUserId = self.webinarInfo.data[@"join_info"][@"third_party_user_id"];
        NSArray * msgArr = [VHHelpTool filterPrivateMsgCurrentUserId:currentUserId origin:msgs isFilter:YES half:YES];
        [weakSelf reloadDataWithMsgs:msgArr];
    } failed:^(NSDictionary *failedData) {
        VH_ShowToast(failedData[@"content"]);
    }];
}
#pragma mark - 收到礼物
- (void)vhGifttoModel:(VHallGiftModel *)model
{
    [self.chatDataSource addObject:model];
    
    [self reloadChat];
}

#pragma mark - 刷新数据
- (void)reloadDataWithMsgs:(NSArray *)msgs
{
    [self.chatDataSource addObjectsFromArray:msgs];
    
    [self reloadChat];
}

#pragma mark - 刷新
- (void)reloadChat
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_chatTableView reloadData];
        if(self.chatDataSource.count > 0 && _chatTableView.contentSize.height > 0) {
            [_chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatDataSource.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    });
}

#pragma mark UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chatDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = [self.chatDataSource objectAtIndex:indexPath.row];
    VHCChatTableViewCell * cell = [VHCChatTableViewCell createCellWithTableView:tableView];
    if ([model isKindOfClass:[VHallChatModel class]]){
        [cell setModel:model];
    }else if ([model isKindOfClass:[VHallGiftModel class]]){
        [cell setGiftModel:model];
    }
    return cell;
}

#pragma mark - 懒加载
- (NSMutableArray *)chatDataSource {
    if (!_chatDataSource) {
        _chatDataSource = [[NSMutableArray alloc] init];
    }
    return _chatDataSource;
}
- (UITableView *)chatTableView {
    if(!_chatTableView) {
        _chatTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _chatTableView.backgroundColor = [UIColor clearColor];
        _chatTableView.delegate = self;
        _chatTableView.dataSource = self;
        _chatTableView.estimatedRowHeight = 90;
        _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _chatTableView.showsVerticalScrollIndicator = NO;
        [self addSubview:_chatTableView];
    }
    return _chatTableView;
}

@end
