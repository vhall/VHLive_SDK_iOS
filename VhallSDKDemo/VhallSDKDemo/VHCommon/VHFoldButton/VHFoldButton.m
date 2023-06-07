//
//  VHFoldButton.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/16.
//

#import "VHFoldButton.h"

@interface VHFoldButton ()<UITableViewDelegate, UITableViewDataSource> {
    BOOL __isFolded;
}

@property (nonatomic, strong) UITableView *foldTable;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, copy) VHFoldButtonDidSelectedHandler selectedHandler;

@end

@implementation VHFoldButton

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        self.itemHeight = 40;

        [self.foldButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
            make.height.mas_equalTo(30);
        }];

        [self.foldTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(0);
        }];
    }

    return self;
}

#pragma mark - 初始化数据
- (void)configDatas:(NSArray *)datas
{
    self.contentHeight = datas.count * self.itemHeight;

    if (self.dataSource.count > 0) {
        [self.dataSource removeAllObjects];
    }

    [self.dataSource addObjectsFromArray:datas];
    [self.foldTable reloadData];
}

- (void)didSelectedWithHandler:(VHFoldButtonDidSelectedHandler)handler {
    self.selectedHandler = handler;
}

#pragma mark - 点击更多按钮
- (void)foldButtonAction:(UIButton *)button {
    //保证在父视图的最前面,不被其他视图遮挡
    if (self.superview != nil) {
        if ([self.superview.subviews lastObject] != self) {
            [self.superview bringSubviewToFront:self];
        }
    }

    button.selected = !button.selected;

    if (__isFolded) {
        [self close];
    } else {
        [self open];
    }
}

#pragma mark - 打开
- (void)open {
    //如果已经展开了,直接返回
    if (__isFolded == YES) {
        return;
    }

    __isFolded = YES;

    [UIView animateWithDuration:0.1
                     animations:^{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30 + self.contentHeight);
        }];
    }
                     completion:^(BOOL finished) {
    }];
}

#pragma mark - 关闭
- (void)close {
    //如果已经关闭了,直接返回
    if (__isFolded == NO) {
        return;
    }

    __isFolded = NO;

    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
    }];
}

#pragma mark - 刷新UI
- (void)layoutSubviews {
    [super layoutSubviews];

    if (__isFolded == NO) {
        [self.foldTable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    } else {
        [UIView animateWithDuration:0.1
                         animations:^{
            [self.foldTable mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(self.contentHeight);
            }];
        }];
    }
}

#pragma mark - UITableView 代理及数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VHFoldButtonCell *cell = [VHFoldButtonCell createCellWithTableView:tableView];

    cell.item = self.dataSource[indexPath.row];

    if ([cell.item.title isEqualToString:@"问卷"]) {
        cell.accessibilityLabel = VHTests_Fold_Survey;
    }

    if ([cell.item.title isEqualToString:@"公告"]) {
        cell.accessibilityLabel = VHTests_Fold_Announcement;
    }
    cell.accessibilityHint = @"Tap to select this row";

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.itemHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VHFoldButtonItem *obj = [self.dataSource objectAtIndex:indexPath.row];

    if (self.selectedHandler) {
        self.selectedHandler(obj, indexPath.row);
    }

    [self foldButtonAction:self.foldButton];
}

#pragma mark - 懒加载
- (UIButton *)foldButton {
    if (_foldButton == nil) {
        _foldButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_foldButton setImage:[UIImage imageNamed:@"vh_fold_icon"] forState:UIControlStateNormal];
        [_foldButton addTarget:self action:@selector(foldButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:_foldButton];
    }

    return _foldButton;
}

- (UITableView *)foldTable {
    if (_foldTable == nil) {
        _foldTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _foldTable.backgroundColor = [UIColor clearColor];
        _foldTable.estimatedRowHeight = 300;
        _foldTable.delegate = self;
        _foldTable.dataSource = self;
        _foldTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_foldTable];
    }

    return _foldTable;
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }

    return _dataSource;
}

@end

#pragma mark - VHFoldButtonCell
@implementation VHFoldButtonCell

+ (VHFoldButtonCell *)createCellWithTableView:(UITableView *)tableView
{
    VHFoldButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VHFoldButtonCell"];

    if (!cell) {
        cell = [[VHFoldButtonCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"VHFoldButtonCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];

        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];

        [self.contentView addSubview:self.icon];
        [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
    }

    return self;
}

- (void)setItem:(VHFoldButtonItem *)item {
    _item = item;

    if ([item.title isEqualToString:@"问卷"]) {
        self.icon.image = [UIImage imageNamed:@"vh_more_tool_su_icon"];
    }

    if ([item.title isEqualToString:@"公告"]) {
        self.icon.image = [UIImage imageNamed:@"vh_more_tool_an_icon"];
    }

    if ([item.title isEqualToString:@"签到"]) {
        self.icon.image = [UIImage imageNamed:@"vh_more_tool_sin_icon"];
    }
}

#pragma mark - 懒加载
- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
    }

    return _icon;
}

@end

#pragma mark - VHFoldButtonItem
@implementation VHFoldButtonItem

@end
