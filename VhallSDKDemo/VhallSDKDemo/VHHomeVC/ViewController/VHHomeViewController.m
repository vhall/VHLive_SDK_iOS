//
//  VHSignSetVC.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/7.
//


#import "VHHomeViewController.h"
#import "VHWarmUpViewController.h"
#import "VHWatchVC.h"
#import "VHAuthAlertView.h"

@interface VHHomeViewController ()<VHallApiDelegate,VHWarmUpViewControllerDelegate,VHAuthAlertViewDelegate>

/// 退出登录
@property (weak, nonatomic) IBOutlet UIButton * outLoginBtn;
/// 头像
@property (weak, nonatomic) IBOutlet UIImageView * headImage;
/// 昵称
@property (weak, nonatomic) IBOutlet UILabel * nickName;
/// 活动id
@property (weak, nonatomic) IBOutlet UITextField * activityTF;
/// 是否开启权限校验
@property (weak, nonatomic) IBOutlet UISwitch * authSwitch;
/// 进入按钮
@property (weak, nonatomic) IBOutlet UIButton * enterRoomBtn;
/// 观看权限弹窗
@property (nonatomic, strong) VHAuthAlertView * authAlertView;
/// 观看权限类型
@property (nonatomic, copy) NSString * type;
@end

@implementation VHHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.type = @"";

    // 初始化
    [self initWithData];
    
    // 设置样式
    [self setWithUI];
}

#pragma mark - 初始化
- (void)initWithData
{
    self.nickName.text             = [VHallApi currentUserNickName];
    
    self.activityTF.text       = DEMO_Setting.activityID;
    
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:[VHallApi currentUserHeadUrl]] placeholderImage:[UIImage imageNamed:@"defaultHead"]];

}
#pragma mark - 设置样式
- (void)setWithUI
{
    self.authSwitch.onTintColor = VHMainColor;
    
    self.enterRoomBtn.layer.masksToBounds = YES;
    self.enterRoomBtn.layer.cornerRadius = 40/2;
}

#pragma mark - 点击退出登录
- (IBAction)clickOutLoginBtn:(UIButton *)sender {
    
    [VHallApi logout:^{
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [VHProgressHud showToast:error.localizedDescription];
    }];
}
#pragma mark - 点击进入房间
- (IBAction)clickEnterRoomBtn:(UIButton *)sender {

    if (self.activityTF.text.length <= 0) {
        [VHProgressHud showToast:@"请输入活动ID"];
        return;
    }
        
    // 记录房间号
    DEMO_Setting.activityID = self.activityTF.text;
    
    // 判断是否校验观看权限
    if (self.authSwitch.on) {
        
        // 防止重复点击
        self.enterRoomBtn.userInteractionEnabled = NO;
        __weak __typeof(self)weakSelf = self;
        [VHWebinarInfoData queryWatchAuthWithWebinarId:self.activityTF.text complete:^(NSString *type, BOOL authStatus, NSError *error) {
            // 防止重复点击
            weakSelf.enterRoomBtn.userInteractionEnabled = YES;

            // 先判断是否报错
            if (error) {
                [VHProgressHud showToast:error.domain];
                return;
            }
            
            // 判断是否需要校验
            if (authStatus) {
                // 需要校验
                weakSelf.type = type;
                [weakSelf.authAlertView showAuthWithType:type];
                // 判断校验类型
            } else {
                // 不需要校验
                [weakSelf watchInit];
            }
            
        }];
        
    } else {
        // 不校验
        [self watchInit];
    }
}

#pragma mark - 获取房间详情
- (void)watchInit
{
    // 防止重复点击
    self.enterRoomBtn.userInteractionEnabled = NO;
    
    __weak __typeof(self)weakSelf = self;
    // 增加一个hud
    [VHProgressHud showLoading];
    // 房间详情接口
    [VHWebinarInfoData requestWatchInitWebinarId:self.activityTF.text pass:nil k_id:nil nick_name:nil email:nil record_id:nil auth_model:1 complete:^(VHWebinarInfoData *webinarInfoData, NSError *error) {
        // 防止重复点击
        weakSelf.enterRoomBtn.userInteractionEnabled = YES;

        // 有返回数据
        if (webinarInfoData) {
            [VHProgressHud hideLoading];

            //1-直播中，2-预约，3-结束，4-点播，5-回放
            switch (webinarInfoData.webinar.type) {
                case 1:
                {
                    VHWatchVC * watchVC = [VHWatchVC new];
                    watchVC.webinarInfoData = webinarInfoData;
                    [weakSelf.navigationController pushViewController:watchVC animated:YES];
                }
                    break;
                    
                case 2:
                {
                    VHWarmUpViewController * warmUP = [VHWarmUpViewController new];
                    warmUP.webinarInfoData = webinarInfoData;
                    warmUP.delegate = self;
                    [weakSelf.navigationController pushViewController:warmUP animated:YES];
                }
                    break;
                case 3:
                {
                    [VHProgressHud showToast:@"直播结束"];
                }
                    break;
                case 4:
                {
                    VHWatchVC * watchVC = [VHWatchVC new];
                    watchVC.webinarInfoData = webinarInfoData;
                    [weakSelf.navigationController pushViewController:watchVC animated:YES];
                }
                    break;
                case 5:
                {
                    VHWatchVC * watchVC = [VHWatchVC new];
                    watchVC.webinarInfoData = webinarInfoData;
                    [weakSelf.navigationController pushViewController:watchVC animated:YES];
                }
                    break;

                default:
                    break;
            }
        }

        // 报错
        if (error) {
            [VHProgressHud showToast:error.domain];
        }
    }];
}

#pragma mark - VHAuthAlertViewDelegate
#pragma mark - 填写的回调
- (void)changeTextWithVerifyValue:(NSString *)verifyValue
{
    __weak __typeof(self)weakSelf = self;
    // 先去校验观看权限,通过以后才可以请求
    [VHWebinarInfoData checkWatchAuthWithWebinarId:self.activityTF.text type:self.type verify_value:verifyValue complete:^(NSDictionary *responseObject, NSError *error) {
        // 有数据
        if (responseObject) {
            [weakSelf watchInit];
        }
        // 报错
        if (error) {
            [VHProgressHud showToast:error.domain];
        }
    }];}

#pragma mark - VHWarmUpViewControllerDelegate
#pragma mark - 进入房间回调
- (void)enterRoom
{
    [self clickEnterRoomBtn:nil];
}

#pragma mark - 懒加载
- (VHAuthAlertView *)authAlertView
{
    if (!_authAlertView) {
        _authAlertView = [[VHAuthAlertView alloc] initWithFrame:self.view.frame];
        _authAlertView.delegate = self;
        [self.view addSubview:self.authAlertView];
    }
    return _authAlertView;
}

@end
