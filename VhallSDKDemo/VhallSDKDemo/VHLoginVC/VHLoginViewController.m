//
//  MainViewController.m
//  PublishDemo
//
//  Created by liwenlong on 15/10/9.
//  Copyright (c) 2015年 vhall. All rights reserved.
//

#import "VHLoginViewController.h"
#import "VHSignSetVC.h"
#import "VHHomeViewController.h"

@interface VHLoginViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIControl      *   contentView;
@property (weak, nonatomic) IBOutlet UILabel        *   versionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconTop;

//注册账号登录
@property (weak, nonatomic) IBOutlet UIView         *   accountLoginView;
@property (weak, nonatomic) IBOutlet UITextField    *   accountTextField; //账号
@property (weak, nonatomic) IBOutlet UITextField    *   passwordTextField; //密码

//免注册登录
@property (weak, nonatomic) IBOutlet UIView         *   thirdIdLoginView;
@property (weak, nonatomic) IBOutlet UITextField    *   thirdIdTextField; //三方账号id
@property (weak, nonatomic) IBOutlet UITextField    *   thirdNameTextField; //昵称
@property (weak, nonatomic) IBOutlet UITextField    *   thirdAvatarTextField; //头像

@property (weak, nonatomic) IBOutlet UIButton       *   loginBtn;
@property (weak, nonatomic) IBOutlet UIButton       *   accountLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton       *   thirdIdLoginBtn;

@property (nonatomic, strong) UIButton * signSetBtn;

@end

@implementation VHLoginViewController

#pragma mark - Lifecycle Method
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"";

    // 初始化控件
    [self initViews];
}

#pragma mark - 初始化sdk
- (void)registerApp
{
    // 初始化
    [VHallApi registerApp:DEMO_Setting.appKey SecretKey:DEMO_Setting.appSecretKey];

    // 打印日志
    [VHallApi setLogType:VHLogType_OFF];
    VHLog(@"SDK版本 === %@ === %@",[VHallApi sdkVersionEX],[VHRoom sdkVersionEX]);
}

#pragma mark - Private Method
#pragma mark - 初始化控件
- (void)initViews
{
    self.iconTop.constant = NAVIGATION_BAR_H + 80;
    
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = 45/2;
    
    // 签名设置
    self.signSetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.signSetBtn.backgroundColor = [UIColor whiteColor];
    [self.signSetBtn setTitle:@"签名设置" forState:UIControlStateNormal];
    [self.signSetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.signSetBtn addTarget:self action:@selector(clickSignSet) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.signSetBtn];
    [self.signSetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(STATUS_BAR_H);
        make.right.mas_equalTo(-20);
    }];
    
    //获得build号:
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    self.versionLabel.text      = [NSString stringWithFormat:@"v%@ build:%@",[VHallApi sdkVersion],build];
    self.accountTextField.text  = DEMO_Setting.account;
    self.passwordTextField.text = DEMO_Setting.password;
    
    self.thirdIdTextField.text = DEMO_Setting.third_Id;
    self.thirdNameTextField.text = DEMO_Setting.third_nickName;
    self.thirdAvatarTextField.text = DEMO_Setting.third_avatar;
}


#pragma mark - 点击签名设置
- (void)clickSignSet
{
    VHSignSetVC * signSetVC = [VHSignSetVC new];
    [self.navigationController pushViewController:signSetVC animated:YES];
}

#pragma mark - 如何获取三方ID
- (IBAction)clickRequestThirdId:(UIButton *)sender {

    NSString * title = @"";
    NSString * message = @"";
    if(self.accountLoginBtn.selected) {
        title = @"如何获取三方ID";
        message = @"三方用户ID是用来关联微吼和外部用户，主播使用的三方用户ID请参考创建直播账号，third_user_id为三方用户ID，pass即为密码";
    }else{
        title = @"如何获取三方ID";
        message = @"三方用户ID是用来关联微吼和外部用户，您可以选择自己随机设置一串符，点击登录后微吼会自动生成一个对应的用户身份，可以调用OpenAPI接口创建一个三方用户后使用接口中third_user_id来此登录。特别注意头像和昵称只可设置一次且不可修改";
    }
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * alertAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { }];
    [alertAction setValue:VHMainColor forKey:@"titleTextColor"];
    [alertController addAction:alertAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 登录
- (IBAction)loginBtnClick:(id)sender
{
    // 点击登录
    if(self.accountLoginBtn.selected) {
        
        [self accountLogin];
        
    }else {
        
        [self thirdIdLogin];
        
    }
}

#pragma mark - 注册账号登录
- (void)accountLogin{
    
    if(self.accountTextField.text.length <= 0 || self.passwordTextField.text.length <= 0) {
        [VHProgressHud showToast:@"账号或密码不能为空"];
        return;
    }

    // 初始化sdk
    [self registerApp];

    // 记录登录信息
    DEMO_Setting.account  = self.accountTextField.text;
    DEMO_Setting.password = self.passwordTextField.text;

    [VHProgressHud showLoading];
    
    __weak __typeof(self)weakSelf = self;
    [VHallApi loginWithAccount:DEMO_Setting.account password:DEMO_Setting.password success:^{
        
        [VHProgressHud hideLoading];
        VHLog(@"Account: %@ userID:%@",[VHallApi currentAccount],[VHallApi currentUserID]);
        [VHProgressHud showToast:@"登录成功"];
        
        // 进入首页
        VHHomeViewController * homeVC = [[VHHomeViewController alloc] init];
        homeVC.vh_NavIsHidden = YES;
        [weakSelf.navigationController pushViewController:homeVC animated:YES];

    } failure:^(NSError * error) {
        VHLog(@"登录失败%@",error);
        [VHProgressHud showToast:error.domain];
    }];
}

#pragma mark - 第三方id登录
- (void)thirdIdLogin {
    
    if(_thirdIdTextField.text.length <= 0) {
        [VHProgressHud showToast:@"三方ID不能为空"];
        return;
    }
    
    // 初始化sdk
    [self registerApp];

    // 记录登录信息
    DEMO_Setting.third_Id = self.thirdIdTextField.text;
    DEMO_Setting.third_nickName = self.thirdNameTextField.text;
    DEMO_Setting.third_avatar = self.thirdAvatarTextField.text;

    [VHProgressHud showLoading];

    __weak __typeof(self)weakSelf = self;
    [VHallApi loginWithThirdUserId:DEMO_Setting.third_Id nickName:DEMO_Setting.third_nickName avatar:DEMO_Setting.third_avatar success:^{

        [VHProgressHud hideLoading];
        VHLog(@"Account: %@ userID:%@",[VHallApi currentAccount],[VHallApi currentUserID]);
        [VHProgressHud showToast:@"登录成功"];

        // 进入首页
        VHHomeViewController * homeVC = [[VHHomeViewController alloc] init];
        homeVC.vh_NavIsHidden = YES;
        [weakSelf.navigationController pushViewController:homeVC animated:YES];

    } failure:^(NSError *error) {
        VHLog(@"登录失败%@",error);
        [VHProgressHud showToast:error.domain];
    }];
}

#pragma mark - 注册账号登录
- (IBAction)accountLoginBtnClick:(UIButton *)sender {
    self.accountLoginBtn.selected = YES;
    self.thirdIdLoginBtn.selected = NO;
    self.accountLoginView.hidden = NO;
    self.thirdIdLoginView.hidden = YES;
    self.accountTextField.text  = DEMO_Setting.account;
    self.passwordTextField.text = DEMO_Setting.password;
}

#pragma mark - 第三方id登录
- (IBAction)thirdIdLoginBtnClick:(UIButton *)sender {
    self.accountLoginBtn.selected = NO;
    self.thirdIdLoginBtn.selected = YES;
    self.accountLoginView.hidden = YES;
    self.thirdIdLoginView.hidden = NO;
    self.thirdIdTextField.text  = DEMO_Setting.third_Id;
    self.thirdNameTextField.text = DEMO_Setting.third_nickName;
    self.thirdAvatarTextField.text = DEMO_Setting.third_avatar;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 收起键盘
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    return YES;
}

#pragma mark - 状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
@end
