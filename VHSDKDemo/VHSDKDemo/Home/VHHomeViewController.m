//
//  HomeViewController.m
//  VHallSDKDemo
//
//  Created by yangyang on 2017/2/13.
//  Copyright © 2017年 vhall. All rights reserved.
//

#import "VHHomeViewController.h"
#import "UIImageView+WebCache.h"
#import "LoginViewController.h"
#import <VHLiveSDK/VHallApi.h>

#import "PubLishLiveVC_Normal.h"
#import "PubLishLiveVC_Nodelay.h"
#import "VHHalfWatchLiveVC_Normal.h"
#import "VHHalfWatchLiveVC_Nodelay.h"
#import "VHPortraitWatchLiveVC_Normal.h"
#import "VHPortraitWatchLiveVC_Nodelay.h"
#import "WatchPlayBackViewController.h"
#import "VHFashionStyleWatchLiveVC.h"

#import "VHStystemSetting.h"
#import "VHSettingViewController.h"
#import "VHWebWatchLiveViewController.h"
#import "VHNavigationController.h"
#import "VHInteractLiveVC_New.h"
#import "WarmUpViewController.h"
#import "VHCommonViewController.h"
#import "UIModel.h"
///新增美颜依赖库
#import <VHBeautifyKit/VHBeautifyKit.h>
#import <VHBFURender/VHBFURender.h>

#define kViewProtocol @"很遗憾无法继续为您提供服务"
typedef enum : NSUInteger {
    VHWatchLiveType_HalfWatchNormal = 0, //半屏观看
    VHWatchLiveType_FullWatchNormal = 1,  //全屏观看
    VHWatchLiveType_HalfWatchNodelay = 2, //半屏无延迟观看
    VHWatchLiveType_FullWatchNodelay = 3, //全屏无延迟观看
    VHWatchLiveType_FullWatchVOD = 4,//点播房间
}VHWatchLiveType;

@interface VHHomeViewController ()<VHallApiDelegate,VHSheetActionDelegate>
@property (weak, nonatomic) IBOutlet UILabel        *deviceCategory;
@property (weak, nonatomic) IBOutlet UIButton       *loginBtn;
@property (weak, nonatomic) IBOutlet UIImageView    *headImage;//头像
@property (weak, nonatomic) IBOutlet UILabel        *nickName;//昵称
@property (weak, nonatomic) IBOutlet UILabel        *activityIdLabel;//发起活动id
@property (weak, nonatomic) IBOutlet UILabel        *watchActivityIdLabel;//观看id

@property (weak, nonatomic) IBOutlet UIButton *btn0;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
///美颜模块
@property (nonatomic,strong) VHBeautifyKit *beautKit;
///云导播机位数据
@property (nonatomic) VHDirectorModel *directorModel;
@property (nonatomic) NSInteger  seatIndex;
@end

@implementation VHHomeViewController
///初始化
- (void)initBeautyKit{
//    static char g_auth_package[]={-4,-12,72,125,39,5,69,-4,20,100,-95,7,-69,-78,17,121,-45,76,62,-29,65,-120,94,41,-84,104,13,-19,38,-127,-106,-16,-20,106,84,25,-114,27,126,39,101,68,100,-23,-18,58,-4,-128,-75,-121,-51,121,58,-1,122,36,79,59,-56,-22,-48,76,-49,-66,-109,-44,113,-109,-20,16,111,-37,78,-100,-89,65,27,-3,-127,-49,-124,-7,-108,22,-46,82,4,-27,54,-100,16,26,-34,-17,-81,65,26,36,32,-19,41,14,-4,107,16,-42,-104,108,13,-67,73,57,-80,122,-55,52,109,74,-123,-22,-124,-64,1,-103,16,100,64,118,43,-92,-119,110,-122,-105,-44,-90,-104,61,-30,-114,-22,19,52,34,-94,125,117,76,-46,12,49,72,-43,82,-99,-81,-13,-75,61,0,89,111,-60,-77,34,-87,49,70,4,52,118,78,7,-1,55,-29,39,93,126,98,34,27,95,-48,86,-101,-42,-128,71,-43,7,-38,-122,101,-116,72,-61,-99,80,54,-122,89,-83,49,-72,91,71,7,15,-93,109,6,-13,-84,-99,66,-32,-51,3,-111,100,-30,118,-57,-9,-92,-122,-52,-65,122,105,-80,-110,38,44,90,97,-20,-68,-83,127,47,-35,43,-78,58,-3,63,86,55,9,41,-117,-74,47,126,23,102,32,21,45,-19,-121,-59,6,-92,-17,-102,10,-96,-117,97,-78,78,-115,-26,11,11,108,-25,-44,-113,-56,-91,-116,-31,-98,-81,-77,86,85,22,0,108,-29,-38,-9,97,-39,-21,105,101,85,-99,2,-86,29,-78,-124,79,-2,-24,10,-61,76,122,-97,34,11,121,-32,-68,-34,115,75,44,-100,-107,-10,-44,-13,107,-68,-67,-78,34,14,-111,-63,-1,76,88,2,31,26,122,-1,41,-23,-117,127,109,-36,80,90,-62,-2,65,67,48,74,80,-50,109,-104,-114,-37,-69,-48,5,-98,-80,73,118,-54,118,-23,-22,125,45,82,-64,42,-92,123,-58,-89,-74,52,104,32,-100,8,-1,-20,-47,-62,101,82,-49,-15,16,-44,-7,-2,14,84,-52,16,-66,-23,19,-94,53,-9,-43,-117,-34,-110,118,44,10,33,-22,83,25,73,81,110,-6,-23,-15,55,25,-20,-30,41,39,47,118,-100,-8,37,-66,-28,-11,-95,-22,-78,-26,-44,-72,93,50,77,91,-63,-126,28,-53,23,-24,-38,-31,-91,-84,20,59,-95,-101,-25,38,-4,-119,120,73,41,78,-62,-76,81,-75,79,-108,87,-113,30,31,19,-3,-107,-50,-1,71,5,78,-92,-119,68,-109,-87,-92,-89,-82,-24,-8,-34,-31,45,7,64,96,-62,25,-126,43,-19,-64,-120,-80,-21,-23,-9,-47,-59,-109,78,-83,2,-123,72,-83,-34,124,116,22,-39,93,-125,107,-65,-75,-124,-108,-70,-128,-49,60,61,-68,-58,-52,101,-5,56,-44,-93,-15,-2,105,7,19,77,77,88,-85,31,-83,14,-23,-46,-128,97,-39,-114,-25,-82,-81,125,-13,91,-98,39,113,117,27,-30,-93,-31,-91,-43,-84,117,18,-53,-9,-18,50,-42,-80,-27,-43,63,125,-96,122,-39,14,-96,119,94,46,-15,92,-93,-110,-98,111,90,-18,-89,-43,108,103,53,-35,71,-80,101,55,92,-67,-39,-4,-29,72,-4,62,-13,121,56,25,60,-9,-10,120,-88,78,12,26,-15,-33,14,46,68,121,-120,-68,89,78,-65,-99,6,16,76,11,-24,42,5,-55,-50,-21,68,43,-121,-93,105,55,-80,60,-17,40,109,-35,-44,9,-74,125,-77,59,-5,33,-92,74,123,41,84,-122,30,101,-16,-45,39,-118,-120,107,55,-27,39,83,97,-3,6,108,-109,-60,-10,56,116,17,-92,63,82,84,-76,-22,74,-23,86,-115,-88,-49,89,-1,56,-65,-125,-19,-9,-22,-64,97,44,-120,61,123,47,-75,-91,30,-35,89,6,29,116,-94,-126,-50,72,80,44,-102,14,75,45,-43,-102,2,-30,-107,-106,-48,-49,-89,15,-101,-27,25,-20,119,-17,-5,-28,29,107,-3,-105,-108,-123,60,104,22,-14,-14,-117,-107,123,-57,-50,3,-123,-44,99,-43,-87,66,-48,14,-96,117,-36,19,107,-123,75,40,14,40,-38,-1,-15,-14,-98,115,115,25,40,-33,-73,-96,67,-37,123,-92,55,34,-10,55,102,61,45,107,-4,43,-76,11,-74,-78,-92,125,-116,100,-73,-16,44,63,-80,16,-45,-5,-77,-55,-2,-71,41,62,33,76,35,3,60,-72,-99,50,113,40,93,95,5,-21,-29,42,86,-60,-34,114,-30,-14,110,-18,-24,7,-27,-107,-76,-5,38,31,-6,-4,122,69,2,-107,-113,-64,-59,3,-22,-33,-3,-117,-44,-35,-43,101,-75,116,-48,-35,70,65,0,11,-33,109,62,84,33,59,64,77,108,101,-25,115,74,87,-101,42,-26,-5,91,-26,105,-111,109,94,-15,63,-46,80,25,10,73,-35,117,16,11,19,14,-52,-93,-91,41,50,78,-35,-87,-49,-118,105,-105,-76,-18,-95,-69,-97,24,5,109,112,28,-54,75,102,33,18,69,41,50,3,-3,103,79,-97,-62,-80,-117,108,-93,110,71,123,-94,24,-91,122,111,91,-61,-82,-125,-54,-103,41,-128,-102,-104,116,117,-73,72,34,-42,44,101,108,-10,57,102,-65,92,-102,20,-16,28,-105,100,96,62,-71,-54,120,118,84,4,-126,-101,112,-52,-34,1,33,59,16,59,87,-88,84,-40,-114,63,120,-121,-84,-3,-109,52,-63,-84,-28,-36,19,-121,-35,-44,-41,-55,79,60,-124,3,71,95,75,-42,-77,119,-127,-88,54,-106,20,0,-107,14,-15,-49,-16,-126,10,112,99,27,-107,71,-15,-52,52,-49,-124,-49,88,26,-119,-37,-28,93,-107,-70,97,-105,47,-98,33,59,97,-37,-48,-15,-38,-70,49,50,-64,122,12,10,-51,-79,-84,7,33,117,25,118,79,88,57,90,-127,-81,45,82,-84,-59,-52,-92,60,-64,-123,-15,89,4,49,21,-41,-72,11,-110,-13,74,-124,127,40,-113,-118,-41,90,-46,75,-112,118,-43,90,-20,58,39,77,-103,6,62,94,97,-117,64,63,62,-67,-32,-22,9,94,-34,120,-60,11,-5,-33,-56,79,64,-29,8,-59,94,3,-122,-91,114,46,-39,99,49,-80,-16,-31,-3,76,83,-78,-41,80,-39,21,110,123,-79,42,47,64,-73,18,-110,-34,49,70,85,-101,52,-29,-91,11,71,5,102,-79,29,-17,-66,22,-38,7,76,-16,-57,113};
  //1.0.4
//    Class fuClass = [VHBFURender licenseWithKey:g_auth_package size:sizeof(g_auth_package)];
//    self.beautKit = [VHBeautifyKit kitWithRegistLicenseWithRender:fuClass];
//    [self.beautKit setEffectKey:eff_key_FU_BlurType toValue:@(1.0)];//美颜效果
    
    //1.0.5
    
//    self.beautKit = [VHBeautifyKit beautifyManagerWithModuleClass:[VHBFURender class]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self updateUI];
    
    [VHallApi registerDelegate:self];
    
    NSArray *arr =@[_btn0,_btn1,_btn2,_btn3];
    for (UIButton*btn in arr) {
        CGSize image = btn.imageView.frame.size;
        CGSize title = btn.titleLabel.frame.size;
        
        btn.titleEdgeInsets =UIEdgeInsetsMake(50, -0.5*image.width, 0, 0.5*image.width);
        btn.imageEdgeInsets =UIEdgeInsetsMake(-38, 0.5*title.width, 0, -0.5*title.width);
    }
    //初始化美颜
//    [self initBeautyKit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateUI];
}

-(void)updateUI
{
    _nickName.text              = [VHallApi currentUserNickName];
    _loginBtn.selected          = [VHallApi isLoggedIn];
    _deviceCategory.text        = [UIDevice currentDevice].name;
    _activityIdLabel.text       = [@"发起ID:" stringByAppendingString:DEMO_Setting.activityID];//发起活动id
    _watchActivityIdLabel.text  = [@"观看ID:" stringByAppendingString:DEMO_Setting.watchActivityID];//观看id
    
    [_headImage sd_setImageWithURL:[NSURL URLWithString:[VHallApi currentUserHeadUrl]] placeholderImage:[UIImage imageNamed:@"defaultHead"]];
}

#pragma mark - 发直播
//发起常规直播
- (void)publishNormalLive:(UIInterfaceOrientation)orientation
{
    if (DEMO_Setting.activityID.length <= 0) {
        VH_ShowToast(@"请在设置中输入发直播活动ID");
        return;
    }
    
    [VHWebinarBaseInfo getWebinarBaseInfoWithWebinarId:DEMO_Setting.activityID success:^(VHWebinarBaseInfo * _Nonnull baseInfo) {
        NSLog(@"当前活动%@云导播权限",baseInfo.is_director == 1?@"有":@"无");
        if(baseInfo.no_delay_webinar == 1) { //无延迟
            VH_ShowToast(@"当前直播类型为无延迟直播");
            return;
        }
        if (baseInfo.is_director == 1) {
            VH_ShowToast(@"当前直播是云导播活动请退出");
            return;
        }
        PubLishLiveVC_Normal * liveVC = [[PubLishLiveVC_Normal alloc] init];
        if (DEMO_Setting.beautifyFilterEnable) {
//            [liveVC beautyKitModule:[VHBeautifyKit beautifyManagerWithModuleClass:[VHBFURender class]]];
        }
        liveVC.videoResolution  = [DEMO_Setting.videoResolution intValue];
        liveVC.roomId           = DEMO_Setting.activityID;
        liveVC.token            = DEMO_Setting.liveToken;
        liveVC.videoBitRate     = DEMO_Setting.videoBitRate;
        liveVC.audioBitRate     = DEMO_Setting.audioBitRate;
        liveVC.videoCaptureFPS  = DEMO_Setting.videoCaptureFPS;
        liveVC.interfaceOrientation = orientation;
        liveVC.isOpenNoiseSuppresion = DEMO_Setting.isOpenNoiseSuppresion;
        liveVC.beautifyFilterEnable  = DEMO_Setting.beautifyFilterEnable;
        liveVC.isRehearsal = baseInfo.rehearsal_type;
        liveVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:liveVC animated:YES completion:nil];
    } fail:^(NSError * _Nonnull error) {
        VH_ShowToast(error.localizedDescription);
    }];
}

//发起无延迟直播
- (void)publishNodelayLive:(UIInterfaceOrientation)orientation {
    if (DEMO_Setting.activityID.length <= 0) {
        VH_ShowToast(@"请在设置中输入发直播活动ID");
        return;
    }
    
    [VHWebinarBaseInfo getWebinarBaseInfoWithWebinarId:DEMO_Setting.activityID success:^(VHWebinarBaseInfo * _Nonnull baseInfo) {
        if(baseInfo.no_delay_webinar == 0) { //非无延迟
            VH_ShowToast(@"当前直播类型为常规直播");
            return;
        }
        if (baseInfo.is_director == 1) {
            VH_ShowToast(@"当前直播是云导播活动请退出");
            return;
        }
        PubLishLiveVC_Nodelay * liveVC = [[PubLishLiveVC_Nodelay alloc] init];
        liveVC.roomId           = DEMO_Setting.activityID;
        liveVC.nick_name = DEMO_Setting.live_nick_name;
        liveVC.interfaceOrientation = orientation;
        if(baseInfo.webinar_type == 1) { //音频直播
            liveVC.streamType = VHInteractiveStreamTypeOnlyAudio;
        }else if(baseInfo.webinar_type == 2){ //视频直播
            liveVC.streamType = VHInteractiveStreamTypeAudioAndVideo;
        }
        if (self.beautKit) {
//            [liveVC beautyKitModule:[VHBeautifyKit beautifyManagerWithModuleClass:[VHBFURender class]]];
        }else{
            liveVC.beautifyFilterEnable  = YES;
        }
        liveVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:liveVC animated:YES completion:nil];
    } fail:^(NSError * _Nonnull error) {
        VH_ShowToast(error.localizedDescription);
    }];
}

#pragma mark - 互动直播
- (void)enterInteractLiveRoomWithIsHost:(BOOL)isHost {
    if (isHost && DEMO_Setting.activityID.length<=0) {
        VH_ShowToast(@"请在设置中输入发直播活动ID");
        return;
    }
    if (!isHost && DEMO_Setting.watchActivityID.length<=0) {
        VH_ShowToast(@"请在设置中输入看直播活动ID");
        return;
    }
    if (!isHost && (DEMO_Setting.codeWord == nil||DEMO_Setting.codeWord<=0)) {
        VH_ShowToast(@"请在设置中输入口令");
        return;
    }

    NSString *webinarId = isHost ? DEMO_Setting.activityID : DEMO_Setting.watchActivityID;
    [VHWebinarBaseInfo getWebinarBaseInfoWithWebinarId:webinarId success:^(VHWebinarBaseInfo * _Nonnull baseInfo) {
        if(baseInfo.webinar_type != 3) {
            VH_ShowToast(@"只支持互动直播");
            return;
        }
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        if(isHost) { //主持人
            params[@"id"] = DEMO_Setting.activityID;
            params[@"nickname"] = self.nickName.text;
            params[@"avatar"] = [VHallApi currentUserHeadUrl];
        }else { //嘉宾
            params[@"id"] = DEMO_Setting.watchActivityID;
            params[@"nickname"] = self.nickName.text;
            params[@"password"] = DEMO_Setting.codeWord;
            params[@"avatar"] = DEMO_Setting.inva_avatar;
        }
        params[@"host"] = baseInfo.roleData.host_name;
        params[@"guest"] = baseInfo.roleData.guest_name;

        params[@"assistant"] = baseInfo.roleData.assist_name;//增加互动直播助理昵称实时刷新
        VHInteractLiveVC_New *vc = [[VHInteractLiveVC_New alloc] initWithParams:params isHost:isHost screenLandscape:baseInfo.webinar_show_type];
        vc.isRehearsal = baseInfo.rehearsal_type;
//        [vc beautyKitModule:[VHBeautifyKit beautifyManagerWithModuleClass:[VHBFURender class]]];
        vc.inav_num = baseInfo.inav_num;
        VHNavigationController *nav = [[VHNavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:nav animated:YES completion:nil];
    } fail:^(NSError * _Nonnull error) {
        VH_ShowToast(error.localizedDescription);
    }];
}

#pragma mark - 看直播
//半屏观看
- (void)halfScreenWatchLive {
    VHHalfWatchLiveVC_Normal * watchVC  = [[VHHalfWatchLiveVC_Normal alloc]init];
    watchVC.roomId      = DEMO_Setting.watchActivityID;
    watchVC.kValue      = DEMO_Setting.kValue;
    watchVC.k_id        = DEMO_Setting.k_id;
    watchVC.bufferTimes = DEMO_Setting.bufferTimes;
    watchVC.interactBeautifyEnable = DEMO_Setting.inavBeautifyFilterEnable;
    watchVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:watchVC animated:YES completion:nil];
}

//全屏观看
- (void)portraitWatchLive {
    VHPortraitWatchLiveVC_Normal * watchVC = [[VHPortraitWatchLiveVC_Normal alloc]init];
    watchVC.roomId      = DEMO_Setting.watchActivityID;
    watchVC.kValue      = DEMO_Setting.kValue;
    watchVC.k_id        = DEMO_Setting.k_id;
    watchVC.interactBeautifyEnable = DEMO_Setting.inavBeautifyFilterEnable;
    watchVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:watchVC animated:YES completion:nil];
}

//无延迟观看
- (void)nodelayWatchLive:(BOOL)isHalf {
    NSString *webinarId = DEMO_Setting.watchActivityID;
    [VHWebinarBaseInfo getWebinarBaseInfoWithWebinarId:webinarId success:^(VHWebinarBaseInfo * _Nonnull baseInfo) {
        if(baseInfo.no_delay_webinar == 0 && baseInfo.webinar_type == 3) { //常规互动直播
            //如果为常规互动直播，观众需要上麦（申请上麦被同意或被邀请上麦）后再进入互动房间，否则没有上麦直接进入非无延迟互动直播间，会占用房间用户名额，可能会导致其他嘉宾进房间失败>
            VH_ShowToast(@"观众没有上麦不建议直接进入常规互动房间");
            return;
        }
        if(isHalf) { //半屏
            VHHalfWatchLiveVC_Nodelay *watchVC  = [[VHHalfWatchLiveVC_Nodelay alloc]init];
            watchVC.roomId      = webinarId;
            watchVC.kValue      = DEMO_Setting.kValue;
            watchVC.k_id        = DEMO_Setting.k_id;
            watchVC.interactBeautifyEnable = DEMO_Setting.inavBeautifyFilterEnable;
            watchVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:watchVC animated:YES completion:nil];
        }else { //全屏
            VHPortraitWatchLiveVC_Nodelay * watchVC = [[VHPortraitWatchLiveVC_Nodelay alloc]init];
            watchVC.roomId      = DEMO_Setting.watchActivityID;
            watchVC.kValue      = DEMO_Setting.kValue;
            watchVC.k_id        = DEMO_Setting.k_id;
            watchVC.interactBeautifyEnable = DEMO_Setting.inavBeautifyFilterEnable;
            watchVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:watchVC animated:YES completion:nil];
        }
    } fail:^(NSError * _Nonnull error) {
        VH_ShowToast(error.localizedDescription);
    }];
}
//极简风格
- (void)fashionWatchLive
{
    VHFashionStyleWatchLiveVC * watchVC  = [[VHFashionStyleWatchLiveVC alloc]init];
    watchVC.roomId      = DEMO_Setting.watchActivityID;
    watchVC.kValue      = DEMO_Setting.kValue;
    watchVC.interactBeautifyEnable = DEMO_Setting.inavBeautifyFilterEnable;
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:watchVC];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}
//网页观看
- (void)webViewWatchLive {
    VHWebWatchLiveViewController *watchVC = [[VHWebWatchLiveViewController alloc] init];
    if (DEMO_Setting.webLink.length <= 0) {
        watchVC.webWathType = VHWebWatchType_Live;
         watchVC.roomId = DEMO_Setting.watchActivityID;
    }else{
        watchVC.webWathType = VHWebWatchType_Protocol;
        [watchVC webViewProtocol:DEMO_Setting.webLink];
    }
    watchVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:watchVC animated:YES completion:nil];
}
//预告页
- (void)warmUpToVC
{
    WarmUpViewController * warmupVC = [[WarmUpViewController alloc] init];
    warmupVC.webinar_id = DEMO_Setting.watchActivityID;
    warmupVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:warmupVC animated:YES completion:nil];
}

//其它
- (void)commonToVC
{
    VHCommonViewController * commonVC = [[VHCommonViewController alloc] init];
    commonVC.webinar_id = DEMO_Setting.watchActivityID;
    commonVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:commonVC animated:YES completion:nil];
}
#pragma mark - 看回放
//看回放
- (void)watchPlayBack {
    if (DEMO_Setting.watchActivityID.length<=0) {
        VH_ShowToast(@"请在设置中输入活动ID");
        return;
    }
    WatchPlayBackViewController * watchVC  =[[WatchPlayBackViewController alloc]init];
    watchVC.roomId  = DEMO_Setting.watchActivityID;
    watchVC.kValue  = DEMO_Setting.kValue;
    watchVC.k_id    = DEMO_Setting.k_id;
    watchVC.timeOut = DEMO_Setting.timeOut*1000;
    watchVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:watchVC animated:YES completion:nil];
}


#pragma mark - UI事件
//横屏直播/竖屏直播/观看直播/观看回放
- (IBAction)btnClick:(UIButton*)sender
{
    _btn0.selected = _btn1.selected = _btn2.selected = _btn3.selected =NO;
    sender.selected = YES;
   
    switch (sender.tag) {
        case 0://发起直播
        {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *portraitLive_normal = [UIAlertAction actionWithTitle:@"竖屏直播" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self publishNormalLive:UIInterfaceOrientationPortrait];
            }];
            UIAlertAction *landscapeLive_normal = [UIAlertAction actionWithTitle:@"横屏直播" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self publishNormalLive:UIInterfaceOrientationLandscapeRight];
            }];
            UIAlertAction *portraitLive_nodelay = [UIAlertAction actionWithTitle:@"竖屏无延迟直播" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self publishNodelayLive:UIInterfaceOrientationPortrait];
            }];
            UIAlertAction *landscapeLive_nodelay = [UIAlertAction actionWithTitle:@"横屏无延迟直播" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self publishNodelayLive:UIInterfaceOrientationLandscapeRight];
            }];
            UIAlertAction *cloudBrocast = [UIAlertAction actionWithTitle:@"云导播" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self cloudBrocast];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:portraitLive_normal];
            [alertController addAction:landscapeLive_normal];
            [alertController addAction:portraitLive_nodelay];
            [alertController addAction:landscapeLive_nodelay];
            [alertController addAction:cloudBrocast];
            [alertController addAction:cancelAction];
            alertController.popoverPresentationController.sourceView = sender;
            alertController.popoverPresentationController.sourceRect = sender.bounds;
            [self presentViewController:alertController animated:YES completion:nil];
        }
            break;
        case 1://进入互动直播
        {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *hostJoin = [UIAlertAction actionWithTitle:@"主播进入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self enterInteractLiveRoomWithIsHost:YES];
            }];
            UIAlertAction *guestJoin = [UIAlertAction actionWithTitle:@"嘉宾进入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self enterInteractLiveRoomWithIsHost:NO];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:hostJoin];
            [alertController addAction:guestJoin];
            [alertController addAction:cancelAction];
            alertController.popoverPresentationController.sourceView = sender;
            alertController.popoverPresentationController.sourceRect = sender.bounds;
            [self presentViewController:alertController animated:YES completion:nil];
        }
            break;
        case 2://观看直播
        {
            if (DEMO_Setting.watchActivityID.length<=0) {
                VH_ShowToast(@"请在设置中输入活动ID");
                return;
            }
            
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *halfScreenWatch = [UIAlertAction actionWithTitle:@"半屏观看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self addNewProtocol:VHWatchLiveType_HalfWatchNormal];
            }];
            
            UIAlertAction *portraitWatch = [UIAlertAction actionWithTitle:@"全屏观看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self addNewProtocol:VHWatchLiveType_FullWatchNormal];
            }];
            
            UIAlertAction *halfScreen_NodelayWatch = [UIAlertAction actionWithTitle:@"半屏无延迟观看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self addNewProtocol:VHWatchLiveType_HalfWatchNodelay];
            }];
            
            UIAlertAction *portrait_NodelayWatch = [UIAlertAction actionWithTitle:@"全屏无延迟观看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self addNewProtocol:VHWatchLiveType_FullWatchNodelay];
            }];

            UIAlertAction *fashionVC = [UIAlertAction actionWithTitle:@"极简风格" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self fashionWatchLive];
            }];
            
            UIAlertAction * warmUp = [UIAlertAction actionWithTitle:@"预告页" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self warmUpToVC];
            }];

            UIAlertAction *webWatch = [UIAlertAction actionWithTitle:@"web嵌入观看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self webViewWatchLive];
            }];
            
            UIAlertAction * common = [UIAlertAction actionWithTitle:@"其它" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self commonToVC];
            }];

            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:halfScreenWatch];
            [alertController addAction:portraitWatch];
            [alertController addAction:halfScreen_NodelayWatch];
            [alertController addAction:portrait_NodelayWatch];
            [alertController addAction:fashionVC];
            [alertController addAction:warmUp];
            [alertController addAction:webWatch];
            [alertController addAction:common];
            [alertController addAction:cancelAction];
            alertController.popoverPresentationController.sourceView = sender;
            alertController.popoverPresentationController.sourceRect = sender.bounds;
            [self presentViewController:alertController animated:YES completion:nil];
        }
            break;
        case 3://观看回放
        {
            [self addNewProtocol:VHWatchLiveType_FullWatchVOD];
        }
            break;
        default:
            break;
    }
}
#pragma mark ---新增云导播

- (void)cloudBrocast{
    [VHWebinarBaseInfo getWebinarBaseInfoWithWebinarId:DEMO_Setting.activityID success:^(VHWebinarBaseInfo * _Nonnull baseInfo) {
        if (baseInfo.is_director == 1) {
            //webinar_show_type; ///横竖屏 0竖屏 1横屏
            [self cloudBrocastStatus:(baseInfo.webinar_show_type == 1)?YES:NO];
        }else{
            VH_ShowToast(@"当前直播不是云导播活动请退出");
        }
    } fail:^(NSError * _Nonnull error) {
        VH_ShowToast(error.localizedDescription);
    }];
   
}
#pragma mark ---云导播活动--获取云导播台开启状态
- (void)cloudBrocastStatus:(BOOL)landscape{
    [VHWebinarBaseInfo getDirectorStatusWithWebinarId:DEMO_Setting.activityID success:^(BOOL director_status) {
        if (director_status) {
            //云导播台已开启
            [self openCloudBrocast:SheetType_BrocastEnabled lanscape:landscape];
        }else{
            [self openCloudBrocast:SheetType_BrocastDisable lanscape:landscape];
        }
    } fail:^(NSError * _Nonnull error) {
        VH_ShowToast(error.localizedDescription);
    }];
}
- (void)openCloudBrocast:(SheetType)sheetType lanscape:(BOOL)landcape{
    VHSheetActionViewController *sheet = [[VHSheetActionViewController alloc] init];
    sheet.delegate = self;
    sheet.sheetType = sheetType;
    sheet.screenLandscape = landcape;
    [self presentViewController:sheet animated:true completion:nil];
}
#pragma mark ----测试机位仅推流
- (void)sheetSelectAction:(NSInteger)selectIndex sheetType:(SheetType)sheetType screenLandsCape:(BOOL)landscape{
    NSLog(@"selectIndex==== %ld",(long)selectIndex);
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (sheetType) {
        case SheetType_BrocastEnabled:{
            //两种方式可主持人发起+ 推流方式推到云导播 获取机位列表
            [VHWebinarBaseInfo getSeatList:DEMO_Setting.activityID success:^(VHDirectorModel * _Nonnull directorModel) {
                self.directorModel = directorModel;
                if (selectIndex == 1) {
                    VHSheetActionViewController *sheet = [[VHSheetActionViewController alloc] init];
                    sheet.sheetType = SheetType_Seat;
                    sheet.seatArray = directorModel.seatList;
                    sheet.delegate = self;
                    sheet.webinar_id = DEMO_Setting.activityID;
                    sheet.screenLandscape = landscape;
                    [self presentViewController:sheet animated:true completion:nil];
                }else{
                    [self enterCloudBroadcast:VHLiveVideoDirectorHostEnter landscape:landscape director:YES];
                }
            } fail:^(NSError * _Nonnull error) {
                VH_ShowToast(error.localizedDescription);
            }];
            
        }
            break;
        case SheetType_BrocastDisable:{
           ///云导播台未开启  主持人进入
            [self enterCloudBroadcast:VHLiveVideoDirectorHostEnter landscape:landscape director:NO];
        }
            break;
        case SheetType_Seat:{
            //选择机位 初始化
            NSLog(@"选择机位");
            self.seatIndex = selectIndex;
            [self enterCloudBroadcast:VHLiveVideoDirectorSeatPushStream landscape:landscape director:YES];
        }
            break;
        default:
            break;
    }
}
#pragma mark --- 模拟云导播往主房间推流
- (void)enterCloudBroadcast:(VHLiveVideoType)videoType landscape:(BOOL)landscape director:(BOOL)directorIsOpen{
    PubLishLiveVC_Normal * liveVC = [[PubLishLiveVC_Normal alloc] init];
    liveVC.directorOpen = directorIsOpen;//云导播台是否开启
    liveVC.liveVideoType = videoType;//机位推流进入
    liveVC.videoResolution  = [DEMO_Setting.videoResolution intValue];
    liveVC.roomId           = DEMO_Setting.activityID;
    liveVC.token            = DEMO_Setting.liveToken;
    liveVC.videoBitRate     = DEMO_Setting.videoBitRate;
    liveVC.audioBitRate     = DEMO_Setting.audioBitRate;
    liveVC.videoCaptureFPS  = DEMO_Setting.videoCaptureFPS;
    liveVC.interfaceOrientation = landscape?UIInterfaceOrientationLandscapeRight:UIInterfaceOrientationPortrait;
    if (videoType == VHLiveVideoDirectorSeatPushStream) {
        liveVC.seatModel = self.directorModel.seatList[self.seatIndex];
    }
    liveVC.isOpenNoiseSuppresion = DEMO_Setting.isOpenNoiseSuppresion;
    liveVC.beautifyFilterEnable  = DEMO_Setting.beautifyFilterEnable;
    liveVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:liveVC animated:YES completion:nil];
}
//参数设置
- (IBAction)systemSettingClick:(id)sender
{
    VHSettingViewController *settingVc=[[VHSettingViewController alloc] init];
    settingVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:settingVc animated:YES completion:nil];
}

//登录/退出
- (IBAction)loginOrloginOutClick:(id)sender
{
    if(self.loginBtn.selected) { //退出登录
        [ProgressHud showLoading];
        [VHallApi logout:^{
            [ProgressHud hideLoading];
            [self dismissViewControllerAnimated:YES completion:nil];
        } failure:^(NSError *error) {
            VH_ShowToast(error.localizedDescription);
        }];
    }
}

//头像
- (IBAction)headBtnClicked:(id)sender
{
    if (![VHallApi isLoggedIn])
        return;
    
    Class class= objc_getClass("VHListViewController");
    if(class)
    {
        UIViewController* vc = ((UIViewController*)[[class alloc] init]);
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }
}

#pragma mark - VHallApiDelegate
- (void)vHallApiTokenDidError:(NSError *)error {
    if (self.presentedViewController) {
        [self.presentedViewController dismissViewControllerAnimated:NO completion:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark -
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
#pragma mark ----新增观看端观看协议
- (void)addNewProtocol:(VHWatchLiveType)videoIndex{
    [VHWebinarBaseInfo fetchViewProtocol:DEMO_Setting.watchActivityID success:^(VHViewProtocolModel * _Nonnull protocolModel) {
        if (protocolModel.is_agree == 1) {
            [self jump:videoIndex];
            return;
        }
        if (protocolModel.is_open == 1) {
            //开启观看协议
            [VHViewProtocolView showViewProtocolView:protocolModel.title content:protocolModel.content statement_status:protocolModel.statement_status rule:protocolModel.rule statement_content:protocolModel.statement_content info:protocolModel.statement_info click:^(NSInteger index) {
                if (index == 2) {
                    //关闭或者退出
                    VH_ShowToast(kViewProtocol);
                }else if (index == 1){
                    //进入
                    [VHWebinarBaseInfo agreeViewProtocol:DEMO_Setting.watchActivityID success:^{
                        [self jump:videoIndex];
                    } fail:^(NSError * _Nonnull error) {
                        VH_ShowToast(kViewProtocol);
                    }];
                  
                }else if (index == 0){
                    //fix：右上角关闭有去掉提示
                }
            }];
        }else{
            //未开启观看协议
            [self jump:videoIndex];
        }
    } fail:^(NSError * _Nonnull error) {
        VH_ShowToast(error.localizedDescription);
    }];
}
#pragma mark ---根据直播类型跳原有方法
- (void)jump:(VHWatchLiveType)videoType{
    switch (videoType) {
        case VHWatchLiveType_HalfWatchNormal:{
            [self halfScreenWatchLive];
        }
            break;
        case VHWatchLiveType_FullWatchNormal:{
            [self portraitWatchLive];
        }
            break;
        case VHWatchLiveType_HalfWatchNodelay:{
            [self nodelayWatchLive:YES];
        }
            break;
        case VHWatchLiveType_FullWatchNodelay:{
            [self nodelayWatchLive:NO];
        }
            break;
        case VHWatchLiveType_FullWatchVOD:{
            [self watchPlayBack];
        }
            break;
        default:
            break;
    }
}
@end
