//
//  VHSignSetVC.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/7.
//

#import "VHCodeVC.h"
#import "VHSignSetVC.h"

@interface VHSignSetVC ()
/// appKey
@property (weak, nonatomic) IBOutlet UITextField *appKeyTF;
/// appSK
@property (weak, nonatomic) IBOutlet UITextField *appSecretKeyTF;
/// rsa
@property (weak, nonatomic) IBOutlet UITextField *rsaTF;
/// 包名
@property (weak, nonatomic) IBOutlet UITextField *bundleIDTF;
/// 保存
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end

@implementation VHSignSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.view.backgroundColor = [UIColor whiteColor];

    self.title = @"签名设置";

    self.appKeyTF.text = DEMO_Setting.appKey;

    self.appSecretKeyTF.text = DEMO_Setting.appSecretKey;
    
    self.rsaTF.text = DEMO_Setting.rsaPrivateKey;

    self.bundleIDTF.text = [[NSBundle mainBundle] bundleIdentifier];

    self.saveBtn.accessibilityLabel = VHTests_SignSet_Save;
    self.saveBtn.layer.masksToBounds = YES;
    self.saveBtn.layer.cornerRadius = 45 / 2;

    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 30);
    [rightBtn setImage:[UIImage imageNamed:@"vh_signSet_alert_w"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clickRightBarItem:) forControlEvents:UIControlEventTouchUpInside];
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightView addSubview:rightBtn];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];

    UIButton *codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [codeBtn setFrame:CGRectMake(0, 0, 30, 30)];
    [codeBtn setImage:[UIImage imageNamed:@"vh_signSet_code_w"] forState:UIControlStateNormal];
    [codeBtn addTarget:self action:@selector(clickCodeBtn) forControlEvents:UIControlEventTouchUpInside];
    UIView *codeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [codeView addSubview:codeBtn];
    UIBarButtonItem *codeBarItem = [[UIBarButtonItem alloc] initWithCustomView:codeView];

    self.navigationItem.rightBarButtonItems = @[codeBarItem, rightBarItem];
}

- (IBAction)saveBtn:(UIButton *)sender {
    DEMO_Setting.appKey = self.appKeyTF.text;
    DEMO_Setting.appSecretKey = self.appSecretKeyTF.text;
    DEMO_Setting.rsaPrivateKey = self.rsaTF.text;

    if (self.clickSaveBtn) {
        self.clickSaveBtn();
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickRightBarItem:(UIButton *)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"如何设置签名" message:@"APPKey及APP SecretKey从微吼控制台开发设置中获取，参考文档开通账号/权限；将签名信息复制到微吼控制台开发设置中对应的位置，保存即可" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) { }];

    [alertAction setValue:VHMainColor forKey:@"titleTextColor"];
    [alertController addAction:alertAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 复制
- (IBAction)clickCopyBtn:(UIButton *)sender
{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];

    pboard.string = self.bundleIDTF.text;
    [VHProgressHud showToast:@"复制成功"];
}

#pragma mark - 扫描二维码
- (void)clickCodeBtn
{
    VHCodeVC *codeVC = [VHCodeVC new];

    codeVC.codeType = VHCodeENUM_Setting;
    __weak __typeof(self) weakSelf = self;
    codeVC.scanSettingWithData = ^(NSString *appKey, NSString *appSecretKey) {
        weakSelf.appKeyTF.text = appKey;
        weakSelf.appSecretKeyTF.text = appSecretKey;
    };
    [self.navigationController pushViewController:codeVC animated:YES];
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
