//
//  VHQuestionnaireController.m
//  UIModel
//
//  Created by jinbang.li on 2022/5/14.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHQuestionnaireController.h"
#import "VHQueTableViewCell.h"
#import "VHSurveyViewController.h"
@interface VHQuestionnaireController ()<UITableViewDelegate,UITableViewDataSource,VHSurveyViewControllerDelegate>
@property (nonatomic) UITableView *myTableView;
@property (nonatomic) VHSurveyViewController *surveyController;
@property (nonatomic) UIView *headView;
@end
static NSString *queTableViewCell = @"VHQueTableViewCell";
@implementation VHQuestionnaireController
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
    }
    return _headView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.myTableView];
    [self.view addSubview:self.headView];
    [self addHeadViewSubview];
    [self.myTableView reloadData];
}
- (void)addHeadViewSubview{
    UIImageView *imageVI = [[UIImageView alloc] initWithImage:BundleUIImage(@"wenjuan_top")];
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
    CGFloat height = VHScreenHeight * 2/3;
    CGFloat tableHeight = self.surveyList.count * 64;
    if (self.surveyList.count * 64 > height) {
        tableHeight = height;
    }
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
    [cell updateModel:self.surveyList[indexPath.row] isLast:(indexPath.row == self.surveyList.count - 1)?YES:NO];
    cell.openLink = ^{
        [self openSurvey:self.surveyList[indexPath.row].openLink];
    };
    return cell;
}
- (void)openSurvey:(NSURL *)url{
    if (!_surveyController) {
        _surveyController = [[VHSurveyViewController alloc] init];
        _surveyController.delegate = self;
    }
    _surveyController.view.frame = self.view.bounds;
    _surveyController.url = url;
    [self.view addSubview:_surveyController.view];
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.surveyList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 63;
}
//关闭按钮事件回调
- (void)surveyviewControllerDidCloseed:(UIButton *)sender{
    [self close];
}
//web关闭按钮事件回调
- (void)surveyViewControllerWebViewDidClosed:(VHSurveyViewController *)vc{
    [self close];
}
//提交成功
- (void)surveyViewControllerWebViewDidSubmit:(VHSurveyViewController *)vc msg:(NSDictionary *)body{
    [self close];
}
- (void)close{
    [_surveyController.view removeFromSuperview];
    _surveyController = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
