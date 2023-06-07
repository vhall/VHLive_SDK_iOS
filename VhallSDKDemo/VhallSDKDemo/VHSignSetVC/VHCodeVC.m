//
//  VHCodeVC.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/4/6.
//

#import <AVFoundation/AVFoundation.h>
#import "AES.h"
#import "VHCodeVC.h"

@interface VHCodeVC ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *session;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preLayer;

@property (nonatomic, strong) dispatch_queue_t sessionQueue;

@end

@implementation VHCodeVC

- (void)dealloc
{
    NSLog(@"VHCodeVC正常销毁");
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self sessionStopRunning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"扫码";

    // 启动一个队列
    [self createQueue];

    self.session = [[AVCaptureSession alloc] init];

    //创建一个普通设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    //根据普通设备创建一个输入设备
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];

    //将输入设备关联到会话
    if ([self.session canAddInput:input]) {
        [self.session addInput:input];
    }

    // 创建一个输出对象
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];

    // 输出对象关联到会话
    if ([self.session canAddOutput:output]) {
        [self.session addOutput:output];
    }

    if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
        // 设置元数据类型，是QR二维码
        output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
        // 设置代理，得到解析结果
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];

        // 创建一个特殊的层
        self.preLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        // 设置尺寸并添加到视图树
        [self.preLayer setFrame:self.view.bounds];
        [self.preLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [self.view.layer addSublayer:self.preLayer];
        // 启动
        [self sessionStartRunning];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请开启像机权限" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"知道了"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *_Nonnull action) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url
                                               options:@{}
                                     completionHandler:nil];
        }];
        [alertAction setValue:VHMainColor forKey:@"titleTextColor"];
        [alertController addAction:alertAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - 创建一个队列,防止阻塞主线程
- (void)createQueue {
    dispatch_queue_t sessionQueue = dispatch_queue_create("vh code session queue", DISPATCH_QUEUE_SERIAL);

    self.sessionQueue = sessionQueue;
}

#pragma mark - 启动
- (void)sessionStartRunning
{
    __weak __typeof(self) weakSelf = self;
    dispatch_async(self.sessionQueue, ^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;

        if (!strongSelf.session.running) {
            [strongSelf.session startRunning];
        }
    });
}

#pragma mark - 关闭
- (void)sessionStopRunning
{
    __weak __typeof(self) weakSelf = self;
    dispatch_async(self.sessionQueue, ^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;

        if (strongSelf.session.running) {
            [strongSelf.session stopRunning];
        }
    });
}

#pragma mark - 获取二维码信息
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *object = [metadataObjects firstObject];

        if (object.stringValue.length <= 0) {
            [VHProgressHud showToast:@"请扫描正确的二维码"];
            return;
        }

        if (self.codeType == VHCodeENUM_Setting) {
            // 获取app注册的设置信息
            [self scanSettingComplete:object.stringValue];
        } else {
            // 获取活动id
            [self scanWebinarIDComplete:object.stringValue];
        }
    }
}

#pragma mark - 获取app注册的设置信息
- (void)scanSettingComplete:(NSString *)valueString {
    /**
       a = appkey s = secretkey,as = appsecretkey,i = ios bundle id  ar = Android 包名  s1= SHA1

       {"a":"d3eaaff63bcb4d499420ff7684840495","as":"d299022acf4f812d13b347024ce2d5fa","s":"acaf01de7d9fdc65641b3671b295870f","i":"com.vhall.live","ar":"com.vhall.live","s1":"F4:E7:21:0F:0F:A1:FC:49:0A:6E:3C:83:33:23:D3:3F:86:2A:3F:05"}

     */

    valueString = [valueString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    valueString = [AES AES128Decrypt:valueString key:@"EDaaff63bcB4d4M9"];
    valueString = [valueString stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];

    if (valueString.length <= 0) {
        [VHProgressHud showToast:@"请扫描正确的二维码"];
        return;
    }

    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:[valueString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];

    if (result) {
        NSString *appKey = result[@"a"];
        NSString *appSecretKey = result[@"as"];

        if ([VUITool isBlankString:appKey] || [VUITool isBlankString:appSecretKey]) {
            [VHProgressHud showToast:@"请扫描正确的二维码"];
        } else {
            if (self.scanSettingWithData) {
                self.scanSettingWithData(appKey, appSecretKey);
            }

            [self.navigationController popViewControllerAnimated:NO];
        }
    } else {
        [VHProgressHud showToast:@"请扫描正确的二维码"];
    }
}

#pragma mark - 获取活动id
- (void)scanWebinarIDComplete:(NSString *)valueString {
    if (![valueString containsString:@"watch/"]) {
        [VHProgressHud showToast:@"请扫描正确的二维码"];
        return;
    }

    // 获取字符在原始字符串中的位置
    NSRange range = [valueString rangeOfString:@"watch/"];

    if (range.location != NSNotFound) {
        // 获取字符之后的子字符串
        NSString *webinarId = [valueString substringFromIndex:(range.location + range.length)];

        if (self.scanWebianrIDWithData) {
            self.scanWebianrIDWithData(webinarId);
        }

        [self.navigationController popViewControllerAnimated:NO];
    } else {
        [VHProgressHud showToast:@"请扫描正确的二维码"];
    }
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
