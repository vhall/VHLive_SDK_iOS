//
//  VHRecordListVC.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/5/26.
//

#import "VHRecordListVC.h"
#import "VHRecordListCell.h"

@interface VHRecordListVC ()<UITableViewDelegate, UITableViewDataSource>
/// 列表
@property (nonatomic, strong) UITableView *tableView;
/// 数据源
@property (nonatomic, strong) NSMutableArray *dataSource;
/// 页码
@property (nonatomic, assign) NSInteger pageNum;

@end

@implementation VHRecordListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 初始化布局
    [self setUpMasonry];

    // 加载回放列表
    [self getRecordListWithPageNum:1];

}

- (void)setRecord_id:(NSString *)record_id
{
    _record_id = record_id;
    
    [_tableView reloadData];
}

#pragma mark - 初始化布局
- (void)setUpMasonry
{
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark - 回放列表
- (void)getRecordListWithPageNum:(NSInteger)pageNum {
    
    self.pageNum = pageNum;
    __weak __typeof(self)weakSelf = self;
    [VHWebinarBaseInfo getRecordListWithWebinarId:self.webinar_id pageNum:pageNum pageSize:10 complete:^(NSArray<VHRecordListModel *> *recordList, NSError *error) {
        
        if (recordList) {
            if (pageNum == 1) {
                [weakSelf.dataSource removeAllObjects];
            }

            weakSelf.pageNum++;
            [weakSelf.dataSource addObjectsFromArray:recordList];
            [weakSelf.tableView reloadData];
        }
        
        if (error) {
            [VHProgressHud showToast:[NSString stringWithFormat:@"%@",error.localizedDescription]];
        }
        
        [weakSelf.tableView.mj_header endRefreshing];
        
        if (recordList.count < 10) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VHRecordListCell *cell = [VHRecordListCell createCellWithTableView:tableView];
    cell.record_id = self.record_id;
    cell.recordListModel = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VHRecordListModel *item = self.dataSource[indexPath.row];

    if ([self.delegate respondsToSelector:@selector(selectPlaybackVideoWithRecordId:)]) {
        [self.delegate selectPlaybackVideoWithRecordId:item.record_id];
    }
    
    [self getRecordListWithPageNum:1];
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.estimatedRowHeight = 300;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        __weak __typeof(self) weakSelf = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf getRecordListWithPageNum:1];
        }];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf getRecordListWithPageNum:self.pageNum];
        }];
    }

    return _tableView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }

    return _dataSource;
}

#pragma mark - 分页
- (UIView *)listView {
    return self.view;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
