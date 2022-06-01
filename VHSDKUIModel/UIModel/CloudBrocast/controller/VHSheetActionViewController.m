//
//  VHSheetActionViewController.m
//  VhallLive
//
//  Created by jinbang.li on 2022/4/6.
//  Copyright © 2022 vhall. All rights reserved.
//

#import "VHSheetActionViewController.h"
#import "VHSheetTableViewCell.h"
#import "VHSeatTableViewCell.h"
#import "VHSheetModel.h"
#import <VHLiveSDK/VHallApi.h>
@interface VHSheetActionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) UIView *bgView;
@property (nonatomic) UITableView *sheetTableView;
@property (nonatomic) NSMutableArray <VHSheetModel *>*sheetArr;
@property (nonatomic) NSInteger  selectIndex;//当前选择机位
@property (nonatomic) BOOL  haveSeat;//有机位可用
@property (nonatomic) BOOL  isSelect;//是否选择机位
@end
static NSString *tableViewCell = @"VHSheetTableViewCell";
static NSString *seatCell = @"VHSeatTableViewCell";
@implementation VHSheetActionViewController
- (UITableView *)sheetTableView{
    if (!_sheetTableView) {
        _sheetTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _sheetTableView.dataSource = self;
        _sheetTableView.delegate = self;
        _sheetTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //_sheetTableView.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
        _sheetTableView.backgroundColor = UIColor.whiteColor;
        _sheetTableView.showsVerticalScrollIndicator = NO;
        [_sheetTableView registerClass:[VHSheetTableViewCell class] forCellReuseIdentifier:tableViewCell];
        [_sheetTableView registerClass:[VHSeatTableViewCell class] forCellReuseIdentifier:seatCell];
        _sheetTableView.layer.cornerRadius = 15;
//        _sheetTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        //self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return _sheetTableView;
}
- (instancetype)init{
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackgorundEvent];
    [self setupDataSource];
    [self sheetTableViewUI];
}
- (void)setupDataSource{
    switch (self.sheetType) {
        case SheetType_BrocastEnabled:
        case SheetType_BrocastDisable:{
            [self selectBroardCastDataSource];
        }
            break;
        case SheetType_Seat:{
            [self seatDataSource];
        }
            break;
        default:
            break;
    }
    
}
- (NSDictionary *)seatName:(NSString *)seatName status:(NSString *)seatStatus{
    return @{
        @"name":seatName,
        @"status":seatStatus,
    };
}
///机位数据源
- (void)seatDataSource{
    self.sheetArr = [NSMutableArray arrayWithCapacity:2];
    //创建8个机位 configValue表示占用状态 1:占用 2 不占用
    //模型数据的转化
    for (int i = 0; i < self.seatArray.count; i++) {
        VHSheetModel *sheet = [[VHSheetModel alloc] init];
        VHSeatModel *seat = self.seatArray[i];
        sheet.name = [NSString stringWithFormat:@"机位%d",i+1];
        sheet.seat_id = seat.seat_id;
        sheet.configValue = (seat.seat_status == 0)?@"2":@"1";
        if ([sheet.configValue isEqualToString:@"2"]) {
            self.haveSeat = YES;
        }
        [self.sheetArr addObject:sheet];
    }
    
    //假数据
//    NSArray *seatArr = @[
//        [self seatName:@"机位1" status:@"1"],
//        [self seatName:@"机位2" status:@"1"],
//        [self seatName:@"机位3" status:@"1"],
//        [self seatName:@"机位4" status:@"2"],
//        [self seatName:@"机位5" status:@"2"],
//        [self seatName:@"机位6" status:@"1"],
//        [self seatName:@"机位7" status:@"1"],
//        [self seatName:@"机位8" status:@"2"],
//    ];
//    self.sheetArr = [NSMutableArray arrayWithCapacity:2];
//    for (NSDictionary *dic in seatArr) {
//        VHSheetModel *sheet1 = [[VHSheetModel alloc] init];
//        sheet1.name = dic[@"name"];
//        sheet1.configValue = dic[@"status"];
//        if ([sheet1.configValue isEqualToString:@"2"]) {
//            self.haveSeat = YES;
//        }
//        [self.sheetArr addObject:sheet1];
//    }
//
}
///云导播开启与否的数据源
- (void)selectBroardCastDataSource{
    self.sheetArr = [NSMutableArray arrayWithCapacity:2];
    VHSheetModel *sheet1 = [[VHSheetModel alloc] init];
    sheet1.name = @"以主持人身份发起直播";
    sheet1.configValue = @"1";
    
    VHSheetModel *sheet2 = [[VHSheetModel alloc] init];
    sheet2.name = @"以视频推流形式推流到云导播";
    sheet2.configValue = (self.sheetType == SheetType_BrocastEnabled)?@"1":@"2";
    
    [self.sheetArr addObject:sheet1];
    [self.sheetArr addObject:sheet2];
}
- (void)setupBackgorundEvent {
    UIView *bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:bgView];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.55];
    self.bgView = bgView;
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
- (void)sheetTableViewUI{
    [self.view addSubview:self.sheetTableView];
    if (@available(iOS 15.0, *)) {
        self.sheetTableView.sectionHeaderTopPadding = 0;
    } else {
        // Fallback on earlier versions
    }
    [self setUpHeaderFooterView];
    switch (self.sheetType) {
        case SheetType_BrocastEnabled:
        case SheetType_BrocastDisable:{
            self.sheetTableView.scrollEnabled = NO;
            [self.sheetTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.offset(0);
                make.height.mas_equalTo(174);
            }];
        }
            break;
        case SheetType_Seat:{
            self.selectIndex = UINT_MAX;
            self.sheetTableView.scrollEnabled = YES;
            [self.sheetTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.offset(0);
                make.height.mas_equalTo(335);
            }];
        }
        default:
            break;
    }
   
}
- (void)setUpHeaderFooterView{
    self.sheetTableView.tableHeaderView = nil;
    self.sheetTableView.tableFooterView = nil;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (self.sheetType <= 1) {
        VHSheetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCell];
        if (cell == nil) {
            cell = [[VHSheetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCell];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell display:self.sheetArr[indexPath.row]];
        return cell;
    }else{
        //机位选择
        VHSeatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:seatCell];
        if (cell == nil) {
            cell = [[VHSeatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:seatCell];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell display:self.sheetArr[indexPath.row] selectStatus:indexPath.row == (self.selectIndex)];
        if ([self.sheetArr[indexPath.row].configValue isEqualToString:@"1"]) {
            cell.userInteractionEnabled = NO;
        }else{
            cell.userInteractionEnabled = YES;
        }
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sheetArr.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] init];
    if (self.sheetType > 1) {
        headView.frame = CGRectMake(0, 0, VHScreenWidth, 55);
        headView.backgroundColor = UIColor.whiteColor;
        UIButton *cancel = [UIButton creatWithTitle:@"取消" titleFont:14 titleColor:@"#666666" backgroundColor:@"#FFFFFF"];
        [cancel addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:cancel];
        [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.left.offset(15);
            make.width.mas_equalTo(32);
            make.height.mas_equalTo(18);
        }];
        UILabel *label = [UILabel creatWithFont:16 TextColor:@"#222222" Text:@"选择推流机位"];
        [headView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.offset(0);
            make.width.mas_equalTo(110);
            make.height.mas_equalTo(22);
        }];
        UIButton *sure = [UIButton creatWithTitle:@"确定" titleFont:14 titleColor:@"#FB3A32" backgroundColor:@"#FFFFFF"];
        sure.enabled = self.haveSeat;
        sure.alpha = self.haveSeat?1.0f:0.5f;
        if (self.isSelect) {
            sure.enabled = YES;
            sure.alpha = 1.0f;
        }else{
            sure.enabled = NO;
            sure.alpha = 0.5f;
        }
        [sure addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:sure];
        [sure mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.right.offset(-15);
            make.width.mas_equalTo(32);
            make.height.mas_equalTo(18);
        }];
        UILabel *line = [[UILabel alloc] init];
        line.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
        [headView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.height.mas_equalTo(1);
            make.top.offset(54);
        }];
    }
    
    return headView;
}
- (void)sureAction{
    NSLog(@"选中了第%d个机位",self.selectIndex);
    if (self.selectIndex >= self.sheetArr.count) {
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [VHWebinarBaseInfo selectSeatWithWebinarId:self.webinar_id seatId:self.sheetArr[self.selectIndex].seat_id success:^(BOOL isUse) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isUse) {
            if ([self.delegate respondsToSelector:@selector(sheetSelectAction:sheetType:screenLandsCape:)]) {
                [self.delegate sheetSelectAction:self.selectIndex sheetType:self.sheetType screenLandsCape:self.screenLandscape];
            }
        }
    } fail:^(NSError * _Nonnull error) {
        //机位被占用的提示
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.sheetArr[self.selectIndex].configValue = @"1";
        [self.sheetTableView reloadData];
        [self dismissViewControllerAnimated:YES completion:nil];
        VH_ShowToast(error.localizedDescription);
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.sheetType > 1) {
        return 55.0f;
    }else{
        return 0.00f;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc] init];
    if (self.sheetType <= 1) {
    UIView *spView = [[UIView alloc] init];
    spView.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    [footView addSubview:spView];
    [spView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-56);
        make.height.mas_equalTo(8);
        make.left.right.offset(0);
    }];
    UIButton *cancel = [UIButton creatWithTitle:@"取消" titleFont:16 titleColor:@"#222222" backgroundColor:@"#FFFFFF"];
    [cancel addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.mas_equalTo(spView.mas_bottom).offset(0);
        make.height.mas_equalTo(44);
    }];
    }
    return footView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.sheetType <= 1) {
        return 64.0f;
    }else{
        return 0.00f;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.sheetType) {
        case SheetType_BrocastEnabled:{
            if ([self.delegate respondsToSelector:@selector(sheetSelectAction:sheetType:screenLandsCape:)]) {
                [self.delegate sheetSelectAction:indexPath.row sheetType:self.sheetType screenLandsCape:self.screenLandscape];
            }
        }
            break;
        case SheetType_BrocastDisable:{
            //推流不可点击直接return
            if (indexPath.row == 1) {
                return;
            }
            if ([self.delegate respondsToSelector:@selector(sheetSelectAction:sheetType:screenLandsCape:)]) {
                [self.delegate sheetSelectAction:indexPath.row sheetType:self.sheetType screenLandsCape:self.screenLandscape];
            }
        }
            break;
        case SheetType_Seat:{
            self.isSelect = YES;
            self.selectIndex = indexPath.row;
            [self.sheetTableView reloadData];
        }
            break;
        default:
            break;
    }
}

- (void)dealloc{
    NSLog(@"%@_释放了",[self class]);
}

@end

