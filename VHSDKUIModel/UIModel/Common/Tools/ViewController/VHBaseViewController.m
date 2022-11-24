//
//  BaseViewController.m
//  PublishDemo
//
//  Created by liwenlong on 15/10/9.
//  Copyright (c) 2015年 vhall. All rights reserved.
//

#import "VHBaseViewController.h"
#import "MBProgressHUD.h"
@interface VHBaseViewController ()

@end

@implementation VHBaseViewController

#pragma mark - Public Method

- (instancetype)init {
    self = [super init];
    if (self) {
        _interfaceOrientation = UIInterfaceOrientationPortrait;
    }
    return self;
}


#pragma mark - Lifecycle Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void)dealloc {
    
}

-(BOOL)shouldAutorotate {
    return NO;
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
        return UIInterfaceOrientationMaskPortrait;
    }else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        return UIInterfaceOrientationMaskLandscapeRight;
    }else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
        return UIInterfaceOrientationMaskLandscapeLeft;
    }else {
        return UIInterfaceOrientationMaskLandscape;
    }
}


- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return _interfaceOrientation;
}


//强制旋转屏幕方向
- (void)forceRotateUIInterfaceOrientation:(UIInterfaceOrientation)orientation {
    VHLog(@"强制转屏开始");
    _forceRotating = YES;
    
    if (@available(iOS 16.0, *)) {
        @try {
            UIInterfaceOrientationMask oriMask = UIInterfaceOrientationMaskPortrait;
            if (orientation != UIDeviceOrientationPortrait && orientation != UIDeviceOrientationUnknown) {
                oriMask = UIInterfaceOrientationMaskLandscapeRight;
            }
            // 防止appDelegate supportedInterfaceOrientationsForWindow方法不调用
            SEL selUpdateSupportedMethod = NSSelectorFromString(@"setNeedsUpdateOfSupportedInterfaceOrientations");
            [self performSelector:selUpdateSupportedMethod];
            [self.navigationController performSelector:selUpdateSupportedMethod];
            
            NSArray *array = [[[UIApplication sharedApplication] connectedScenes] allObjects];
            UIWindowScene *ws = (UIWindowScene *)array.firstObject;
            Class GeometryPreferences = NSClassFromString(@"UIWindowSceneGeometryPreferencesIOS");
            id geometryPreferences = [[GeometryPreferences alloc] init];
            [geometryPreferences setValue:@(oriMask) forKey:@"interfaceOrientations"];
            SEL selGeometryUpdateMethod = NSSelectorFromString(@"requestGeometryUpdateWithPreferences:errorHandler:");
            void (^ErrorBlock)(NSError *error) = ^(NSError *error){
                  NSLog(@"iOS 16 转屏Error: %@",error);
            };
            if ([ws respondsToSelector:selGeometryUpdateMethod]) {
                (((void (*)(id, SEL,id,id))[ws methodForSelector:selGeometryUpdateMethod])(ws, selGeometryUpdateMethod,geometryPreferences,ErrorBlock));
            }
        } @catch (NSException *exception) {

        } @finally {
            
        }
    }else {
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
        {
            NSNumber *orientationTarget = [NSNumber numberWithInteger:orientation];
            [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
            [UIViewController attemptRotationToDeviceOrientation];
            //这行代码是关键
        }
        SEL selector=NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation =[NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = (int)orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    
    _forceRotating = NO;

    VHLog(@"强制转屏结束");
}


@end
