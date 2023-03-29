//
//  VHLotterySubmitView.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/3/16.
//

#import "VHLotterySubmitView.h"

@interface VHLotterySubmitListCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView * bgView;
@property (nonatomic, strong) UILabel * is_required_lab;
@end

@implementation VHLotterySubmitListCell

+ (VHLotterySubmitListCell *)createCellWithTableView:(UITableView *)tableView index:(NSInteger)index
{
    NSString * tagStr = [NSString stringWithFormat:@"VHLotterySubmitListCell%ld",index];
    VHLotterySubmitListCell * cell = [tableView dequeueReusableCellWithIdentifier:tagStr];
    if (!cell) {
        cell = [[VHLotterySubmitListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tagStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.is_required_lab];
        [self.bgView addSubview:self.contentTF];
        
        // 设置约束
        [self setMasonryUI];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
}
- (void)setMasonryUI
{
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(44);
    }];
    
    [self.is_required_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bgView.mas_centerY);
        make.left.mas_equalTo(16);
        make.size.mas_equalTo(CGSizeMake(7.5, 20));
    }];

    [self.contentTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bgView.mas_centerY);
        make.left.mas_equalTo(self.is_required_lab.mas_right).offset(4);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(20);
    }];
    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(8).priorityHigh();
    }];
}

#pragma mark - 赋值
- (void)setSubmitConfig:(VHallLotterySubmitConfig *)submitConfig
{
    _submitConfig = submitConfig;
    
    self.is_required_lab.hidden = !submitConfig.is_required;
    
    self.contentTF.placeholder = submitConfig.placeholder;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([VUITool isInputRuleNotBlank:string] || [string isEqualToString:@""]) {//当输入符合规则和退格键时允许改变输入框
        return YES;
    } else {
        return NO;
    }
}
- (void)textFieldChanged:(UITextField *)textField
{
    int strLenth = 20;
    if ([self.submitConfig.field_key isEqualToString:@"name"]) {
        strLenth = 20;
    } else if ([self.submitConfig.field_key isEqualToString:@"phone"]) {
        strLenth = 20;
    } else {
        strLenth = 50;
    }
    
    NSString *toBeString = textField.text;
    
    if (![VUITool isInputRuleAndBlank:toBeString]) {
        textField.text = [VUITool disable_emoji:toBeString];
        return;
    }
   
    NSString *lang = [[textField textInputMode] primaryLanguage]; // 获取当前键盘输入模式
    if([lang isEqualToString:@"zh-Hans"]) { //简体中文输入,第三方输入法（搜狗）所有模式下都会显示“zh-Hans”
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if(!position) {
            NSString *getStr = [VUITool getSubStr:toBeString strLenth:strLenth];
            if(getStr && getStr.length > 0) {
                textField.text = getStr;
            }
        }
    } else{
         NSString *getStr = [VUITool getSubStr:toBeString strLenth:strLenth];
        if(getStr && getStr.length > 0) {
            textField.text= getStr;
        }
    }
}

#pragma mark - 懒加载
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 6;
    }
    return _bgView;
}
- (UILabel *)is_required_lab {
    if (!_is_required_lab) {
        _is_required_lab = [[UILabel alloc] init];
        _is_required_lab.text = @"*";
        _is_required_lab.textColor = VHMainColor;
        _is_required_lab.font = FONT(14);
    }
    return _is_required_lab;
}
- (UITextField *)contentTF
{
    if (!_contentTF) {
        _contentTF = [UITextField new];
        _contentTF.delegate = self;
        _contentTF.textColor = [UIColor colorWithHex:@"#262626"];
        _contentTF.font = FONT(14);
        [_contentTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    }return _contentTF;
}

@end

@interface VHLotterySubmitView ()<UITableViewDelegate,UITableViewDataSource>
/// 标题图片
@property (nonatomic, strong) UIImageView * titleImg;
/// 关闭按钮
@property (nonatomic, strong) UIButton * closeBtn;
/// 查看中奖名单按钮
@property (nonatomic, strong) UITableView * tableView;
/// 提交按钮
@property (nonatomic, strong) UIButton * submitBtn;
/// 抽奖类
@property (nonatomic, strong) VHallLottery * vhLottery;
/// 结束抽奖数据
@property (nonatomic, strong) VHallEndLotteryModel * endLotteryModel;
/// 数据源
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation VHLotterySubmitView
#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]){
        
        self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.5];
                        
        [self addSubview:self.contentView];
        [self addSubview:self.titleImg];
        [self.contentView addSubview:self.closeBtn];
        [self.contentView addSubview:self.tableView];
        [self.contentView addSubview:self.submitBtn];

        // 初始化布局
        [self setUpMasonry];

    }return self;

}
#pragma mark - 初始化布局
- (void)setUpMasonry
{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(Screen_Height - NAVIGATION_BAR_H - Screen_Width * 9 / 16);
    }];
    
    [self.titleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.contentView.mas_top).offset(-6.5);
        make.size.mas_equalTo(CGSizeMake(240, 40));
    }];

    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14);
        make.right.mas_equalTo(-16);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(50);
        make.bottom.mas_equalTo(-100);
    }];
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(24);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(44);
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
        
    [self.contentView setBackgroundColor:[UIColor bm_colorGradientChangeWithSize:self.contentView.size direction:IHGradientChangeDirectionLevel startColor:[UIColor colorWithHex:@"#FFFBE8"] endColor:[UIColor colorWithHex:@"#FBF0E6"]]];
}

#pragma mark - 弹窗
- (void)showLotterySubmitWithVHLottery:(VHallLottery *)vhLottery endLotteryModel:(VHallEndLotteryModel *)endLotteryModel submitList:(NSArray <VHallLotterySubmitConfig *> *)submitList
{
    self.vhLottery = vhLottery;
    self.endLotteryModel = endLotteryModel;
    self.dataSource = [NSMutableArray arrayWithArray:submitList];
    
    __weak __typeof(self)weakSelf = self;
    [self.vhLottery lotteryWinningUserInfoWithRoomId:endLotteryModel.huadieInfo.room_id complete:^(VHallLotteryUserInfo *userInfo, NSError *error) {
        for (UIView * view in weakSelf.tableView.subviews) {
            if ([view isKindOfClass:[VHLotterySubmitListCell class]]) {
                VHLotterySubmitListCell * cell = (VHLotterySubmitListCell *)view;
                if ([cell.submitConfig.field_key isEqualToString:@"name"]) {
                    cell.contentTF.text = userInfo.lottery_user_name;
                } else if ([cell.submitConfig.field_key isEqualToString:@"phone"]) {
                    cell.contentTF.text = userInfo.lottery_user_phone;
                } else if ([cell.submitConfig.field_key isEqualToString:@"address"]) {
                    cell.contentTF.text = userInfo.lottery_user_address;
                }
            }
        }
    }];

    [[VUITool getCurrentScreenViewController].view addSubview:self];

    [self.tableView reloadData];

    [super show];
}
#pragma mark - 隐藏
- (void)disMissContentView
{
    [self endEditing:YES];
}
#pragma mark - 隐藏
- (void)dismiss
{
    [super disMissContentView];
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VHLotterySubmitListCell *cell = [VHLotterySubmitListCell createCellWithTableView:tableView index:indexPath.row];
    cell.submitConfig = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark - 点击提交领奖信息
- (void)clickSubmitBtn
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    for (UIView * view in self.tableView.subviews) {
        if ([view isKindOfClass:[VHLotterySubmitListCell class]]) {
            VHLotterySubmitListCell * cell = (VHLotterySubmitListCell *)view;
            for (VHallLotterySubmitConfig *model in self.dataSource) {
                if (cell.submitConfig == model) {
                    if(model.is_required && cell.contentTF.text.length == 0) { //判断必填项
                        [VHProgressHud showToast:@"必填项不能为空"];
                        return;
                    }
                    [param setValue:cell.contentTF.text forKey:model.field_key];
                    break;
                }
            }
        }
    }
    
    //兼容抽奖历史
    if (self.endLotteryModel.huadieInfo.lottery_id) {
        param[@"lotteryId"] = self.endLotteryModel.huadieInfo.lottery_id;
    }
    
    __weak __typeof(self)weakSelf = self;
    [self.vhLottery submitLotteryInfo:param success:^{
        [VHProgressHud showToast:@"提交成功"];
        [weakSelf dismiss];
    } failed:^(NSDictionary *failedData) {
        NSString * msg = [NSString stringWithFormat:@"%@",failedData[@"content"]];
        [VHProgressHud showToast:msg];
    }];
}
#pragma mark - 点击关闭
- (void)clickCloseBtn
{
    [self dismiss];
}
#pragma mark - 懒加载
- (UIImageView *)titleImg
{
    if (!_titleImg) {
        _titleImg = [[UIImageView alloc] init];
        _titleImg.image = [UIImage imageNamed:@"vh_lottery_alert_submit_title"];
    }
    return _titleImg;
}
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
        [_closeBtn setImage:[UIImage imageNamed:@"vh_lottery_alert_submit_close"] forState:UIControlStateNormal];
    }
    return _closeBtn;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.estimatedRowHeight = 300;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitBtn.layer setMasksToBounds:YES];
        [_submitBtn.layer setCornerRadius:44/2];
        [_submitBtn.titleLabel setFont:FONT(16)];
        [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitBtn setBackgroundColor:VHMainColor];
        [_submitBtn addTarget:self action:@selector(clickSubmitBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
@end
