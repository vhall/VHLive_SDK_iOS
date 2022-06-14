//
//  VHLotteryViewController.m
//  UIModel
//
//  Created by jinbang.li on 2022/6/6.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHLotteryViewController.h"
#import "VHQueTableViewCell.h"
@interface VHLotteryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) UITableView *myTableView;
@property (nonatomic) UIView *headView;
@end
static NSString *queTableViewCell = @"VHQueTableViewCell";
@implementation VHLotteryViewController
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //_myTableView.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
        _myTableView.backgroundColor = UIColor.whiteColor;
        _myTableView.showsVerticalScrollIndicator = NO;
        [_myTableView registerClass:[VHQueTableViewCell class] forCellReuseIdentifier:queTableViewCell];
//        [_myTableView registerClass:[VHSeatTableViewCell class] forCellReuseIdentifier:seatCell];
        _myTableView.layer.cornerRadius = 15;
//        _myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        //self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return _myTableView;
}
- (instancetype)init {
    if((self = [super init])) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    }
    return self;
}
- (UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc] init];
        _headView.backgroundColor = [UIColor whiteColor];
    }
    return _headView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.myTableView];
    [self.view addSubview:self.headView];
    [self addHeadViewSubview];
    [self.myTableView reloadData];
    [self setupBackgorundEvent];
}
- (void)setupBackgorundEvent {
    UIView *bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:bgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapBgView)];
    [bgView addGestureRecognizer:tap];
    [self.view sendSubviewToBack:bgView];
}
- (void)onTapBgView {
    [self dismiss];
}
- (void)dismiss {
    if(self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)addHeadViewSubview{
    UIImageView *imageVI = [[UIImageView alloc] initWithImage:BundleUIImage(@"插图_礼物_已中奖")];
    [self.headView addSubview:imageVI];
    [imageVI mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.center.offset(0);
    }];
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    [close setImage:BundleUIImage(@"关闭") forState:UIControlStateNormal];
    close.tag = 100;
    [close addTarget:self action:@selector(operationAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:close];
    [close mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.right.offset(-20);
        make.width.height.mas_equalTo(25);
    }];
}
- (void)operationAction:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLayoutSubviews{
    //定义
    //tableHeight
    CGFloat height = VHScreenHeight * 0.5;
    CGFloat tableHeight = self.lotteryList.count * 64;
    if (self.lotteryList.count * 64 > height) {
        tableHeight = height;
    }
    tableHeight = 200;
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.mas_equalTo(tableHeight);
    }];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.bottom.offset(-tableHeight);
        make.height.mas_equalTo(50);
    }];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    VHQueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:queTableViewCell];
    if (cell == nil) {
        cell = [[VHQueTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:queTableViewCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateLottery:self.lotteryList[indexPath.row] isLast:(indexPath.row == self.lotteryList.count - 1)?YES:NO];
   
    cell.openLink = ^{
        //立即领奖
        [self openLottery:self.lotteryList[indexPath.row]];
    };
    return cell;
}
- (void)openLottery:(VHLotteryModel *)model{
    VHallEndLotteryModel *endModel = [[VHallEndLotteryModel alloc] init];
    endModel.is_new = YES;
    endModel.lottery_id = model.lottery_id;
    endModel.need_take_award = model.need_take_award;
    endModel.isWin = model.win;
    endModel.publish_winner = model.publish_winner;
    if ([self.delegate respondsToSelector:@selector(lotteryOpen:)]) {
        [self.delegate lotteryOpen:endModel];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lotteryList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 63;
}

@end
