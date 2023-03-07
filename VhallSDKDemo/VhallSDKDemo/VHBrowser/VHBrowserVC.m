////
////  VHBrowserVC.m
////  VhallSDKDemo
////
////  Created by 郭超 on 2023/2/7.
////
//
//#import "VHBrowserVC.h"
//#import "LBLelinkKitManager.h"
//
//@interface VHBrowserVC ()<UITableViewDelegate,UITableViewDataSource>
//
///// 列表
//@property (nonatomic, strong) UITableView * tableView;
//
//
//@end
//
//@implementation VHBrowserVC
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    
//    self.view.backgroundColor = [UIColor whiteColor];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDeviceList:) name:LBLelinkKitManagerConnectionDidConnectedNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDeviceList:) name:LBLelinkKitManagerConnectionDisConnectedNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDeviceList:) name:LBLelinkKitManagerServiceDidChangeNotification object:nil];
//
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(NAVIGATION_BAR_H);
//        make.left.bottom.right.mas_equalTo(0);
//    }];
//    
//    // 搜索
//    [[LBLelinkKitManager sharedManager] search];
//
//}
//
//#pragma mark - notification
//- (void)connectionDidConnected:(NSNotification *)notification {
//    
//    LBLelinkPlayerItem * item = [[LBLelinkPlayerItem alloc] init];
//    item.mediaType = LBLelinkMediaTypeVideoOnline;
//    item.mediaURLString = @"http://v3.cztv.com/cztv/vod/2018/06/28/7c45987529ea410dad7c088ba3b53dac/h264_1500k_mp4.mp4";
//    /** 注意，为了适配接收端的bug，播放之前先stop，否则当先推送音乐再推送视频的时候会导致连接被断开 */
//    [[LBLelinkKitManager sharedManager].lelinkPlayer stop];
//    [[LBLelinkKitManager sharedManager].lelinkPlayer playWithItem:item];
//
//}
//
//- (void)updateDeviceList:(NSNotification *)notification {
//    [self.tableView reloadData];
//}
//
//#pragma mark - UITableViewDelegate,UITableViewDataSource
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [LBLelinkKitManager sharedManager].lelinkConnections.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    LBLelinkConnection * lelinkConnection = [LBLelinkKitManager sharedManager].lelinkConnections[indexPath.row];
//
//    cell.textLabel.text = lelinkConnection.lelinkService.lelinkServiceName;
//    
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // 点击设备，如果未连接，则建立连接，如果已连接，则断开连接
//    // 当前连接
//    LBLelinkConnection * currentConnection = [LBLelinkKitManager sharedManager].currentConnection;
//    // 选择的连接
//    LBLelinkConnection * selectedConnection = [LBLelinkKitManager sharedManager].lelinkConnections[indexPath.row];
//    if (currentConnection == nil) {
//        [LBLelinkKitManager sharedManager].currentConnection = selectedConnection;
//        currentConnection = selectedConnection;
//        [currentConnection connect];
//    }else{
//        if ([currentConnection isEqual:selectedConnection]) {
//            if (currentConnection.isConnected) {
//                [currentConnection disConnect];
//            } else {
//                [currentConnection connect];
//            }
//        } else {
//            if (currentConnection.isConnected) {
//                [currentConnection disConnect];
//            }
//            [LBLelinkKitManager sharedManager].currentConnection = selectedConnection;
//            currentConnection = selectedConnection;
//            [currentConnection connect];
//        }
//    }
//}
//
//- (UITableView *)tableView
//{
//    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//        _tableView.backgroundColor = [UIColor clearColor];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        [self.view addSubview:_tableView];
//    }
//    return _tableView;
//}
//
//@end
