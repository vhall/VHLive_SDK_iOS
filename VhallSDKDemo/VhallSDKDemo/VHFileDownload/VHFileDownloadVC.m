//
//  VHFileDownloadVC.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/6/9.
//

#import "VHFileDownloadVC.h"
#import "VHFileDownloadCell.h"

@interface VHFileDownloadVC ()<UITableViewDelegate, UITableViewDataSource, VHFileDownloadObjectDelegate>
/// 列表
@property (nonatomic, strong) UITableView *tableView;
/// 数据源
@property (nonatomic, strong) NSMutableArray *dataSource;
/// 页码
@property (nonatomic, assign) NSInteger pageNum;
/// 活动id
@property (nonatomic, copy) NSString *webinar_id;
/// 文件下载列表id
@property (nonatomic, copy) NSString *file_download_menu_id;
/// 文件下载类
@property (nonatomic, strong) VHFileDownloadObject * fileDownload;
@end

@implementation VHFileDownloadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 初始化布局
    [self setUpMasonry];
}

#pragma mark - 初始化布局
- (void)setUpMasonry
{
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark - 文件列表
- (void)getFileDownloadListWithWebinarId:(NSString *)webinar_id file_download_menu_id:(NSString *)file_download_menu_id
{
    self.webinar_id = webinar_id;
    self.file_download_menu_id = file_download_menu_id;
    
    __weak __typeof(self)weakSelf = self;
    [self.fileDownload getFileDownLoadWithWebinarId:webinar_id menu_id:file_download_menu_id complete:^(NSDictionary *config, NSArray<VHFileDownloadListModel *> *file_download_list, NSError *error) {
        
        [weakSelf.dataSource removeAllObjects];
        
        if (file_download_list) {
            [weakSelf.dataSource addObjectsFromArray:file_download_list];
            [weakSelf.tableView reloadData];
        }
        
        if (error) {
            [VHProgressHud showToast:[NSString stringWithFormat:@"%@",error.localizedDescription]];
        }
        
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VHFileDownloadCell *cell = [VHFileDownloadCell createCellWithTableView:tableView];
    cell.fileDownloadListModel = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VHFileDownloadListModel * fileDownloadListModel = self.dataSource[indexPath.row];

    [self.fileDownload getCheckDownloadWithWebinarId:self.webinar_id menu_id:self.file_download_menu_id file_id:fileDownloadListModel.file_id complete:^(NSString *download_url, NSError *error) {
        
        if (download_url) {
            NSURL * url = [NSURL URLWithString:download_url];
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                VHLog(@"%@",success ? @"完成下载" : @"错误");
            }];
        }
        
        if (error) {
            [VHProgressHud showToast:[NSString stringWithFormat:@"%@",error.localizedDescription]];
        }

    }];
}

#pragma mark - 更新文件下载列表
- (void)uploadFileDownLoadWithModel:(VHFileDownLoadUploadModel *)model {
    if ([self.delegate respondsToSelector:@selector(uploadFileDownLoadWithModel:)]) {
        [self.delegate uploadFileDownLoadWithModel:model];
    }
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 999, 999) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.estimatedRowHeight = 80;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        __weak __typeof(self) weakSelf = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf getFileDownloadListWithWebinarId:self.webinar_id file_download_menu_id:self.file_download_menu_id];
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

- (VHFileDownloadObject *)fileDownload
{
    if (!_fileDownload) {
        _fileDownload = [VHFileDownloadObject new];
        _fileDownload.delegate = self;
    }
    
    return _fileDownload;
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
