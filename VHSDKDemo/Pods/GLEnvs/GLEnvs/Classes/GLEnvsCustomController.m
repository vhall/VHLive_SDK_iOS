//
//  GLEnvsCustomController.m
//  AFNetworking
//
//  Created by liguoliang on 2019/6/24.
//

#import "GLEnvsCustomController.h"

@interface GLEnvsCustomController ()
@end

@implementation GLEnvsCustomController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onClickCancel:)];
    UIBarButtonItem *saveBarButton = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(onClickSave:)];

    self.navigationItem.leftBarButtonItem = backBarButton;
    self.navigationItem.rightBarButtonItem = saveBarButton;
    self.title = @"自定义环境";
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableHeaderView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)onClickCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onClickSave:(id)sender {
    if (self.handleSave) {
        self.handleSave(self.data);
    }
    [self onClickCancel:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.allKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ENVC"];
    NSArray *temp = [self.data.allKeys sortedArrayUsingComparator:^NSComparisonResult (id _Nonnull obj1, id _Nonnull obj2) {
        return obj1 > obj2 ? NSOrderedAscending : NSOrderedDescending;
    }];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ENVC"];
        UILabel *label = [UILabel new];
        label.tag = 80;
        label.font = [UIFont systemFontOfSize:12.f];
        [cell.contentView addSubview:label];
        UITextField *textField = [[UITextField alloc]init];
        [textField addTarget:self action:@selector(willChangeValueForKey:) forControlEvents:UIControlEventEditingChanged];
        textField.tag = 85;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.font = [UIFont systemFontOfSize:10.f];
        [cell.contentView addSubview:textField];
    }
    ((UILabel *)[cell viewWithTag:80]).text = temp[indexPath.row];
    ((UILabel *)[cell viewWithTag:80]).frame = CGRectMake(10, 10, tableView.bounds.size.width - 20, 20);
    ((UITextField *)[cell viewWithTag:85]).text = self.data[temp[indexPath.row]];
    ((UITextField *)[cell viewWithTag:85]).frame = CGRectMake(30, CGRectGetMaxY(((UILabel *)[cell viewWithTag:80]).frame) + 10, tableView.bounds.size.width - 40, 35);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}

- (void)willChangeValueForKey:(UITextField *)sender {
    UILabel *titleLab = [sender.superview viewWithTag:80];
    self.data[titleLab.text] = sender.text;
}

@end
