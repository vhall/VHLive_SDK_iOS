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
#import "VHCodeVC.h"
#import "VHPublishVC.h"

@interface VHHomeViewController ()<VHallApiDelegate,VHWarmUpViewControllerDelegate,VHAuthAlertViewDelegate>

/// 退出登录
@property (weak, nonatomic) IBOutlet UIButton * outLoginBtn;
/// 头像
@property (weak, nonatomic) IBOutlet UIImageView * headImage;
/// 昵称
@property (weak, nonatomic) IBOutlet UILabel * nickName;
/// 容器
@property (weak, nonatomic) IBOutlet UIView *contentView;
/// 活动id
@property (weak, nonatomic) IBOutlet UITextField * activityTF;
/// 点击扫码
@property (nonatomic, strong) UIButton * codeBtn;
/// 是否开启权限校验
@property (weak, nonatomic) IBOutlet UISwitch * authSwitch;
/// 进入按钮
@property (weak, nonatomic) IBOutlet UIButton * enterRoomBtn;
/// 观看权限弹窗
@property (nonatomic, strong) VHAuthAlertView * authAlertView;
/// 观看权限类型
@property (nonatomic, copy) NSString * type;
/// 发起直播按钮
@property (weak, nonatomic) IBOutlet UIButton *livePublishBtn;
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
    self.nickName.text = [VHallApi currentUserNickName];
    
    self.activityTF.text = [VUITool isBlankString:DEMO_Setting.activityID] ? @"305821089" : DEMO_Setting.activityID;
    
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:[VHallApi currentUserHeadUrl]] placeholderImage:[UIImage imageNamed:@"defaultHead"]];

}
#pragma mark - 设置样式
- (void)setWithUI
{
    self.activityTF.clearButtonMode = UITextFieldViewModeNever;
    
    self.authSwitch.onTintColor = VHMainColor;
    
    self.enterRoomBtn.layer.masksToBounds = YES;
    self.enterRoomBtn.layer.cornerRadius = 40/2;
    
    self.livePublishBtn.layer.masksToBounds = YES;
    self.livePublishBtn.layer.cornerRadius = 40/2;
    
    [self.contentView addSubview:self.codeBtn];
    [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.activityTF.mas_centerY);
        make.right.mas_equalTo(0);
        make.width.height.mas_equalTo(30);
    }];
}

#pragma mark - 点击退出登录
- (IBAction)clickOutLoginBtn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [VHallApi logout:^{
        [VHProgressHud showToast:@"退出登录成功"];
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
    // 查询活动详情
    [VHWebinarBaseInfo getWebinarBaseInfoWithWebinarId:self.activityTF.text success:^(VHWebinarBaseInfo * _Nonnull baseInfo) {
        
        // 防止重复点击
        weakSelf.enterRoomBtn.userInteractionEnabled = YES;
        
        [VHProgressHud hideLoading];

        //1-直播中，2-预约，3-结束，4-点播，5-回放
        switch (baseInfo.type) {
            case 1:
            {
                VHWatchVC * watchVC = [VHWatchVC new];
                watchVC.webinar_id = baseInfo.ID;
                watchVC.type = baseInfo.type;
                [weakSelf.navigationController pushViewController:watchVC animated:YES];
            }
                break;
                
            case 2:
            {
                VHWarmUpViewController * warmUP = [VHWarmUpViewController new];
                warmUP.webinarId = baseInfo.ID;
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
                watchVC.webinar_id = baseInfo.ID;
                watchVC.type = baseInfo.type;
                [weakSelf.navigationController pushViewController:watchVC animated:YES];
            }
                break;
            case 5:
            {
                VHWatchVC * watchVC = [VHWatchVC new];
                watchVC.webinar_id = baseInfo.ID;
                watchVC.type = baseInfo.type;
                [weakSelf.navigationController pushViewController:watchVC animated:YES];
            }
                break;

            default:
                break;
        }
    } fail:^(NSError * _Nonnull error) {
        // 防止重复点击
        weakSelf.enterRoomBtn.userInteractionEnabled = YES;
        [VHProgressHud showToast:error.domain];
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
    }];
}

#pragma mark - VHWarmUpViewControllerDelegate
#pragma mark - 进入房间回调
- (void)enterRoom
{
    [self clickEnterRoomBtn:nil];
}

#pragma mark - 点击发起直播
- (IBAction)clickLivePublish:(UIButton *)sender
{
    if (self.activityTF.text.length <= 0) {
        [VHProgressHud showToast:@"请输入活动ID"];
        return;
    }
        
    // 记录房间号
    DEMO_Setting.activityID = self.activityTF.text;

    VHPublishVC * publishVC = [VHPublishVC new];
    publishVC.webinar_id = self.activityTF.text;
    publishVC.screenLandscape = NO;
    [self.navigationController pushViewController:publishVC animated:YES];
}

#pragma mark - 扫描二维码
- (void)clickCodeBtn
{
    VHCodeVC * codeVC = [VHCodeVC new];
    codeVC.codeType = VHCodeENUM_WebinarID;
    __weak __typeof(self)weakSelf = self;
    codeVC.scanWebianrIDWithData = ^(NSString *webinarId) {
        weakSelf.activityTF.text = webinarId;
    };
    [self.navigationController pushViewController:codeVC animated:YES];
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

- (UIButton *)codeBtn
{
    if (!_codeBtn) {
        _codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _codeBtn.userInteractionEnabled = YES;
        [_codeBtn setImage:[UIImage imageNamed:@"vh_signSet_code_b"] forState:UIControlStateNormal];
        [_codeBtn addTarget:self action:@selector(clickCodeBtn) forControlEvents:UIControlEventTouchUpInside];
    } return _codeBtn;
}

@end
