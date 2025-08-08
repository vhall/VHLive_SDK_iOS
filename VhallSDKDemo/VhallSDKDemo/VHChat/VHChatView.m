//
//  VHChatView.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/13.
//

#import "VHChatCell.h"
#import "VHChatGiftCell.h"
#import "VHChatLotteryCell.h"
#import "VHChatView.h"
#import "VHChatPushScreenCardCell.h"
#import "VHChatGoodsCell.h"

@interface VHChatView ()<VHallChatDelegate, UITableViewDataSource, UITableViewDelegate>
/// 聊天
@property (nonatomic, strong) VHallChat *chat;
/// 房间详情
@property (nonatomic, strong) VHWebinarInfoData *webinarInfoData;
/// 房间详情
@property (nonatomic, strong) NSObject *vhObject;
/// 列表
@property (nonatomic, strong) UITableView *chatTableView;
/// 聊天数据源
@property (nonatomic, strong) NSMutableArray *chatDataSource;
/// 页码
@property (nonatomic, assign) NSInteger pageNum;

@end

@implementation VHChatView

#pragma mark - 初始化
- (instancetype)init
{
    if ([super init]) {
        self.backgroundColor = [UIColor colorWithHex:@"#F8F8F8"];

        // 初始化UI
        [self masonryUI];
    }

    return self;
}

#pragma mark - 连接消息,并加载数据
- (void)requestDataWithVHObject:(NSObject *)vhObject webinarInfoData:(VHWebinarInfoData *)webinarInfoData
{
    self.backgroundColor = [UIColor colorWithHex:@"#F8F8F8"];

    self.vhObject = vhObject;
    self.webinarInfoData = webinarInfoData;

    // 初始化UI
    [self masonryUI];

    // 设置代理
    [self setDelegateToObject];

    // 加载数据
    [self loadHistoryWithPage:1];
}

#pragma mark - 设置代理
- (void)setDelegateToObject
{
    // 设置聊天代理
    self.chat.delegate = self;

    // 获取最新禁言状态
    if (self.delegate && [self.delegate respondsToSelector:@selector(isQaStatus:)]) {
        [self.delegate isQaStatus:self.chat.isQaStatus];
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(forbidChat:)]) {
        [self.delegate forbidChat:self.chat.isMeSpeakBlocked];
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(allForbidChat:)]) {
        [self.delegate allForbidChat:self.chat.isAllSpeakBlocked];
    }
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
- (void)loadHistoryWithPage:(NSInteger)page
{
    if (page < 1) {
        page = 1;
    }

    self.pageNum = page;

    NSString *msg_id = @"";

    if (page > 1 && self.chatDataSource.count > 0) {
        if ([[self.chatDataSource firstObject] isKindOfClass:[VHallChatModel class]]) {
            VHallChatModel *msgFirstModel = [self.chatDataSource firstObject];
            msg_id = msgFirstModel.msg_id;
        } else {
            msg_id = @"";
        }
    } else {
        [self.chatDataSource removeAllObjects];
        msg_id = @"";
    }

    __weak typeof(self) weakSelf = self;
    [self.chat getInteractsChatGetListWithMsg_id:msg_id
                                        page_num:page
                                       page_size:100
                                      start_time:nil
                                         is_role:0
                                     anchor_path:@"down"
                                         success:^(NSArray<VHallChatModel *> *msgs) {
        // 页码++
        weakSelf.pageNum++;
        //过滤私聊 传递target_id,当前用户join_id
        NSString *currentUserId = self.webinarInfoData.join_info.third_party_user_id;
        NSArray *msgArr = [self filterPrivateMsgCurrentUserId:currentUserId
                                                       origin:msgs
                                                     isFilter:YES
                                                         half:YES];

        [weakSelf reloadDataWithMsgs:msgArr];
        // 收起刷新控件
        [weakSelf.chatTableView.mj_header endRefreshing];
    }
                                          failed:^(NSDictionary *failedData) {
//        [VHProgressHud showToast:failedData[@"content"]];
        // 收起刷新控件
        [weakSelf.chatTableView.mj_header endRefreshing];
    }];
}

#pragma mark - ----------------------VHallChatDelegate----------------------
#pragma mark - 所有消息
- (void)receiveAllMessage:(VHMessage *)message
{
    
}

#pragma mark - 收到上下线消息
- (void)reciveOnlineMsg:(NSArray <VHallOnlineStateModel *> *)msgs
{
    for (VHallOnlineStateModel *m in msgs) {
        NSString *content = [NSString stringWithFormat:@"在线:%@ 参会:%@ 用户id:%@", m.concurrent_user, m.attend_count, m.account_id];
        VHLog(@"%@", content);
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(reciveOnlineMsg:)]) {
        [self.delegate reciveOnlineMsg:msgs];
    }
}

#pragma mark - 收到聊天消息
- (void)reciveChatMsg:(NSArray <VHallChatModel *> *)msgs
{
    //过滤私聊 传递target_id,当前用户join_id
    NSString *currentUserId = self.webinarInfoData.join_info.third_party_user_id;
    NSArray *msgArr = [self filterPrivateMsgCurrentUserId:currentUserId origin:msgs isFilter:YES half:YES];

    [self reloadSendWithMsgs:msgArr];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(reciveChatMsg:)]) {
        [self.delegate reciveChatMsg:msgs];
    }
}

#pragma mark - 收到自定义消息
- (void)reciveCustomMsg:(NSArray <VHallCustomMsgModel *> *)msgs
{
    
}

#pragma mark - 删除消息
- (void)deleteChatMsgId:(NSString *)msgId
{
    for (id msg in self.chatDataSource.reverseObjectEnumerator) {
        if ([msg isKindOfClass:[VHallChatModel class]]) {
            if ([msgId isEqualToString:((VHallChatModel *)msg).msg_id]) {
                [self.chatDataSource removeObject:msg];
                [self reloadChatToBottom:YES beforeChange:0];
                return;
            }
        }
    }
}

#pragma mark - 收到自己被禁言/取消禁言
- (void)forbidChat:(BOOL)forbidChat
{
    [VHProgressHud showToast:forbidChat ? @"您以被禁言" : @"您已被取消禁言"];

    if (self.delegate && [self.delegate respondsToSelector:@selector(forbidChat:)]) {
        [self.delegate forbidChat:forbidChat];
    }
}

#pragma mark - 收到全体禁言/取消全体禁言
- (void)allForbidChat:(BOOL)allForbidChat
{
    [VHProgressHud showToast:allForbidChat ? @"开启全体禁言" : @"取消全体禁言"];

    if (self.delegate && [self.delegate respondsToSelector:@selector(allForbidChat:)]) {
        [self.delegate allForbidChat:allForbidChat];
    }
}

#pragma mark - 问答禁言状态状态
- (void)isQaStatus:(BOOL)isQaStatus
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(isQaStatus:)]) {
        [self.delegate isQaStatus:isQaStatus];
    }
}

#pragma mark - 收到虚拟人数消息
- (void)vhBaseNumUpdateToUpdate_online_num:(NSInteger)update_online_num
                                 update_pv:(NSInteger)update_pv
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(vhBaseNumUpdateToUpdate_online_num:update_pv:)]) {
        [self.delegate vhBaseNumUpdateToUpdate_online_num:update_online_num update_pv:update_pv];
    }
}

#pragma mark - 聊天是否过滤私聊
- (NSArray <VHallChatModel *> *)filterPrivateMsgCurrentUserId:(NSString *)currentUserId origin:(NSArray <VHallChatModel *> *)msgs isFilter:(BOOL)isFilter half:(BOOL)half
{
    if (half) {
        //半屏过滤自己
        if (isFilter) {
            //过滤
            NSMutableArray <VHallChatModel *> *filterMsgs = [NSMutableArray array];
            NSUInteger count = msgs.count;

            for (int i = 0; i < count; i++) {
                VHallChatModel *model = msgs[i];

                if (model.privateMsg && ![currentUserId isEqualToString:model.target_id]) {
                    continue;
                } else if ((model.privateMsg && [currentUserId isEqualToString:model.target_id])) {
                    //是自己的私聊消息
                    model.text = [NSString stringWithFormat:@"私聊消息---%@", model.text];
                    [filterMsgs addObject:model];
                } else {
                    [filterMsgs addObject:model];
                }
            }

            return filterMsgs;
        } else {
            //不过滤
            return msgs;
        }
    } else {
        //全屏私聊全部过滤
        if (isFilter) {
            //过滤
            NSMutableArray <VHallChatModel *> *filterMsgs = [NSMutableArray array];
            NSUInteger count = msgs.count;

            for (int i = 0; i < count; i++) {
                VHallChatModel *model = msgs[i];

                if (model.privateMsg) {
                    continue;
                } else {
                    [filterMsgs addObject:model];
                }
            }

            return filterMsgs;
        } else {
            //不过滤
            return msgs;
        }
    }
}

#pragma mark - 刷新数据
- (void)reloadDataWithMsgs:(NSArray *)msgs
{
    // 判断是否最底部
    BOOL isBottom = self.chatDataSource.count > 0 ? NO : YES;
    // 获取添加前的index
    int beforeChange = (int)msgs.count;

    if (self.chatDataSource.count > 0) {
        NSRange range = NSMakeRange(0, [msgs count]);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.chatDataSource insertObjects:msgs atIndexes:indexSet];
    } else {
        [self.chatDataSource addObjectsFromArray:msgs];
    }

    [self reloadChatToBottom:isBottom beforeChange:beforeChange];
}

#pragma mark - 发送的消息
- (void)reloadSendWithMsgs:(NSArray *)msgs
{
    [self.chatDataSource addObjectsFromArray:msgs];
    [self reloadChatToBottom:YES beforeChange:0];
}

#pragma mark - 刷新
- (void)reloadChatToBottom:(BOOL)toBottom beforeChange:(int)beforeChange
{
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        // 刷新
        [weakSelf.chatTableView reloadData];

        // 如果数组为空 则不进行操作
        if (weakSelf.chatDataSource.count <= 0 || weakSelf.chatTableView.contentSize.height <= 0) {
            return;
        }

        if (toBottom) {
            // 如果需要移动到最新消息
            [weakSelf.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.chatDataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        } else {
            // 如果需要保持原位
            if (beforeChange > 0) {
                [weakSelf.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:beforeChange inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        }
    });
}

#pragma mark UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chatDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.chatDataSource.count > indexPath.row) {
        id model = [self.chatDataSource objectAtIndex:indexPath.row];
        VHChatCell *cell = [VHChatCell createCellWithTableView:tableView];

        VHChatCustomCell *customCell = [VHChatCustomCell createCellWithTableView:tableView];
        __weak __typeof(self) weakSelf = self;
        customCell.clickSurveyToModel = ^(VHChatCustomModel *chatCustomModel) {
            if ([weakSelf.delegate respondsToSelector:@selector(clickSurveyToId:surveyURL:)]) {
                [weakSelf.delegate clickSurveyToId:chatCustomModel.info[@"surveyId"] surveyURL:chatCustomModel.info[@"surveyURL"]];
            }
        };

        VHChatGiftCell *giftCell = [VHChatGiftCell createCellWithTableView:tableView];

        VHChatLotteryCell *lotteryCell = [VHChatLotteryCell createCellWithTableView:tableView];
        lotteryCell.clickChekWinList = ^(VHallEndLotteryModel *endLotteryModel) {
            if ([weakSelf.delegate respondsToSelector:@selector(clickCheckWinListWithEndLotteryModel:)]) {
                [weakSelf.delegate clickCheckWinListWithEndLotteryModel:endLotteryModel];
            }
        };
        
        VHChatPushScreenCardCell *pushScreenCardCell = [VHChatPushScreenCardCell createCellWithTableView:tableView];
        pushScreenCardCell.clickPushScreenCardCell = ^(VHPushScreenCardItem *pushScreenCardListItem) {
            if ([weakSelf.delegate respondsToSelector:@selector(clickCheckPushScreenCardModel:)]) {
                [weakSelf.delegate clickCheckPushScreenCardModel:pushScreenCardListItem];
            }
        };

        VHChatGoodsCell *goodsCell = [VHChatGoodsCell createCellWithTableView:tableView];
        goodsCell.clickGoodsCell = ^(VHGoodsPushMessageItem *messageItem) {
            if ([weakSelf.delegate respondsToSelector:@selector(clickCheckGoodsDetailModel:)]) {
                [weakSelf.delegate clickCheckGoodsDetailModel:messageItem];
            }
        };

        if ([model isKindOfClass:[VHallChatModel class]]) {
            [cell setModel:model];
        } else if ([model isKindOfClass:[VHChatCustomModel class]]) {
            [customCell setChatCustomModel:model];
            return customCell;
        } else if ([model isKindOfClass:[VHallGiftModel class]]) {
            [giftCell setGiftModel:model];
            return giftCell;
        } else if ([model isKindOfClass:[VHallStartLotteryModel class]]) {
            [lotteryCell setStartModel:model];
            return lotteryCell;
        } else if ([model isKindOfClass:[VHallEndLotteryModel class]]) {
            [lotteryCell setEndModel:model];
            return lotteryCell;
        } else if ([model isKindOfClass:[VHPushScreenCardItem class]]) {
            [pushScreenCardCell setPushScreenCardListItem:model];
            return pushScreenCardCell;
        } else if ([model isKindOfClass:[VHGoodsPushMessageItem class]]) {
            [goodsCell setMessageItem:model];
            return goodsCell;
        }
        return cell;
    } else {
        UITableViewCell *defaultCell = [[UITableViewCell alloc]
                                         initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:nil];
        defaultCell.textLabel.text = @"No Data Available";
        return defaultCell;
    }
}

#pragma mark - 发送消息
- (void)sendText:(NSString *)text
{
    if (_chat.isAllSpeakBlocked) {
        [VHProgressHud showToast:@"已开启全体禁言"];
        return;
    }

    if (_chat.isSpeakBlocked) {
        [VHProgressHud showToast:@"您已被禁言"];
        return;
    }

    if (text.length == 0) {
        [VHProgressHud showToast:@"发送的消息不能为空"];
        return;
    }

    [_chat sendMsg:text
           success:^{
    }
            failed:^(NSDictionary *failedData) {
        NSString *str = [NSString stringWithFormat:@"%@", failedData[@"content"]];
        [VHProgressHud showToast:str];
    }];
}

#pragma mark - 收到礼物
- (void)vhGifttoModel:(VHallGiftModel *)model
{
    [self.chatDataSource addObject:model];

    [self reloadChatToBottom:YES beforeChange:0];
}

#pragma mark - 收到自定义消息
- (void)chatCustomWithNickName:(NSString *)nickName roleName:(NSInteger)roleName content:(NSString *)content info:(NSMutableDictionary *)info
{
    VHChatCustomModel *customModel = [VHChatCustomModel new];

    customModel.nickName = nickName;
    customModel.roleName = roleName;
    customModel.content = content;
    customModel.info = info;
    [self.chatDataSource addObject:customModel];

    [self reloadChatToBottom:YES beforeChange:0];
}

#pragma mark - 收到抽奖消息
- (void)chatLotteryWithStartModel:(VHallStartLotteryModel *)startModel endModel:(VHallEndLotteryModel *)endModel
{
    [self.chatDataSource addObject:startModel ? startModel : endModel];

    [self reloadChatToBottom:YES beforeChange:0];
}

#pragma mark - 收到推屏卡片消息
- (void)chatPushScreenCardModel:(VHPushScreenCardItem *)model
{
    [self.chatDataSource addObject:model];

    [self reloadChatToBottom:YES beforeChange:0];
}

#pragma mark - 收到商品消息
- (void)chatGoodsModel:(VHGoodsPushMessageItem *)model
{
    [self.chatDataSource addObject:model];

    [self reloadChatToBottom:YES beforeChange:0];
}

#pragma mark - 懒加载
- (VHallChat *)chat
{
    if (!_chat) {
        _chat = [[VHallChat alloc] initWithObject:self.vhObject];
    }

    return _chat;
}

- (UITableView *)chatTableView
{
    if (!_chatTableView) {
        _chatTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _chatTableView.backgroundColor = [UIColor clearColor];
        _chatTableView.delegate = self;
        _chatTableView.dataSource = self;
        _chatTableView.estimatedRowHeight = 90;
        _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _chatTableView.showsVerticalScrollIndicator = NO;
        // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        // 设置文字
        [header setTitle:@"加载完成" forState:MJRefreshStateIdle];
        [header setTitle:@"加载更多" forState:MJRefreshStatePulling];
        [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
        // 设置字体
        header.stateLabel.font = FONT(10);
        // 设置颜色
        header.stateLabel.textColor = [UIColor colorWithHex:@"#333333"];
        // 隐藏时间
        header.lastUpdatedTimeLabel.hidden = YES;
        // 设置刷新控件
        _chatTableView.mj_header = header;

        [self addSubview:_chatTableView];
    }

    return _chatTableView;
}

- (void)loadNewData
{
    [self loadHistoryWithPage:1];
}

- (void)loadMoreData
{
    [self loadHistoryWithPage:self.pageNum];
}

- (NSMutableArray *)chatDataSource
{
    if (!_chatDataSource) {
        _chatDataSource = [[NSMutableArray alloc] init];
    }

    return _chatDataSource;
}

#pragma mark - 分页
- (UIView *)listView {
    return self;
}

@end
