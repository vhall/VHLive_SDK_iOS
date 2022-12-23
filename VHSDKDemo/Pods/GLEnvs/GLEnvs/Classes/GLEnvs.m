//
//  GLEnvs.m
//
//  Created by liguoliang on 2018/8/10.
//

#import "GLEnvs.h"
#import "objc/message.h"
#import "GLEnvsCustomController.h"

#define kGLEnvsNameKey        @"EnvsNameKey"
#define kGLEnvsInfoKey        @"EnvsInfoKey"
#define kArchivePath          [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"GLENV.data"]
#define kGLEnvsCustomTitle    @"✍️ 自定义"
#define kGLEnvsSelectorTipStr @"*** 切换环境后,程序将自动退出 ***"

typedef void (*VIM) (id, SEL, ...);

static GLEnvs *instance;

@interface GLEnvs ()
@property (nonatomic, strong) NSArray<NSDictionary *> *envs;
@property (nonatomic) UIViewController *shortcutViewController;
@property (nonatomic) UIWindow *windowForEnvs;
@property (nonatomic) void(^handleshortCutItemCusHandle)(UIMutableApplicationShortcutItem *item);

@end

@implementation GLEnvs

+ (GLEnvs *)defaultEnvs {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GLEnvs alloc]init];
    });
    return instance;
}

- (GLEnvs *)registEnvsWithName:(NSString *)envsName Index:(NSUInteger)index Content:(NSDictionary *)content {
    if(index == self.envs.count) {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.envs];
        [arr addObject:@{envsName : content}];
        self.envs = [arr copy];
    }else{
        NSAssert(NO, @"index Not Orderly ( index 不是一个有序值 ) !!");
    }
    return self;
}

+ (GLEnvs *)defaultWithEnvironments:(NSArray<NSDictionary *> *)envs {
    if (!instance) [GLEnvs defaultEnvs];
    instance.envs = envs;
    return instance;
}

+ (NSDictionary *)current {
    NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithFile:kArchivePath];
    return dic.allValues.firstObject;
}

+ (NSDictionary *)loadEnv {
    NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithFile:kArchivePath];
    return dic.allValues.firstObject;
}

+ (NSString *)loadEnvName {
    NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithFile:kArchivePath];
    return dic.allKeys.firstObject;
}

+ (BOOL)saveEnv:(NSDictionary *)eInfo {
    return [NSKeyedArchiver archiveRootObject:eInfo toFile:kArchivePath];
}

+ (void)manualChangeEnv:(NSUInteger)index {
    if(index<[GLEnvs defaultEnvs].envs.count){
        NSDictionary *envDic = [GLEnvs defaultEnvs].envs[index];
        NSDictionary *curDict = [GLEnvs current];
        if ([GLEnvs saveEnv:envDic]) {
            if([GLEnvs defaultEnvs].handleListenerWillChange) {
                if([GLEnvs defaultEnvs].handleListenerWillChange(curDict, envDic)) {
                    exit(1);
                }
            }
            else{
                exit(1);
            }
        }
    }
}
- (void)defaultEnvIndex:(NSUInteger)index {
    NSAssert(index < self.envs.count, @"环境配置列表越界");
    if([GLEnvs current] == nil){
        [GLEnvs saveEnv:self.envs[index]];
    }
}

- (void)enableWithPasteBoardString:(NSString *)string matchSuccess:(NSUInteger)sucIndex matchFailed:(NSUInteger)fadIndex {
    NSString *pbcontent = UIPasteboard.generalPasteboard.string;
    BOOL enable = NO;
    switch (self.type) {
        case MatchPrefix:
            enable = [pbcontent hasPrefix:string];
            break;
        case MatchSuffix:
            enable = [pbcontent hasSuffix:string];
            break;
        case MatchContain:
            enable = [pbcontent containsString:string];
            break;
        default:
            enable = [pbcontent isEqualToString:string];
            break;
    }
    [self enableWithShakeMotion:enable defaultIndex:enable ? sucIndex : fadIndex];
}

- (void)enableWithShakeMotion:(BOOL)enable defaultIndex:(NSUInteger)selectIndex {
    NSAssert(selectIndex < self.envs.count, @"环境配置列表越界");
    NSString *currentEnvName = [GLEnvs loadEnvName];
    NSDictionary *currentEnv = [GLEnvs current];
    NSDictionary *newEnv = nil;
    NSDictionary *envDic = self.envs[selectIndex];
    // 未找到环境(写入新环境)
    if(currentEnv == nil){
        [GLEnvs saveEnv:envDic];
    }
    // 不允许修改环境(始终使用最新环境)
    if (enable == NO) {
        [GLEnvs saveEnv:envDic];
    }else{
        for (NSDictionary *tempEnv in self.envs) {
            if([tempEnv.allKeys.firstObject isEqualToString:currentEnvName]){
                newEnv = tempEnv[currentEnvName];
            }
        }
        // 环境不同(重写保存环境，并使用最新))
        if(newEnv && ![newEnv isEqualToDictionary:currentEnv]){
            [GLEnvs saveEnv:envDic];
        }
        SEL selor = @selector(motionEnded:withEvent:);
        Method m = class_getInstanceMethod([UIResponder class], selor);
        IMP nimp = imp_implementationWithBlock(^(id self, UIEventSubtype motion, UIEvent *event) {
            if ([event isKindOfClass:[UIEvent class]]) {
                if (event.type == UIEventTypeMotion && motion == UIEventSubtypeMotionShake) {
                    GLEnvs *envs = [GLEnvs performSelector:NSSelectorFromString(@"defaultEnvs")];
                    [envs performSelector:NSSelectorFromString(@"showEnvChanger") withObject:nil afterDelay:0.0];
                }
            }
        });
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
        method_setImplementation(m, nimp);
    }
}

- (void)applicationDidBecomeActive {
    if(self.showTopLine == YES) {
        [self showEnvWindow];
    }
}

#pragma mark- 当前环境HUD
- (void)showEnvWindow {
    NSString *keystr = [GLEnvs loadEnvName];
    if (keystr) {
        NSMutableString *showStr = [NSMutableString string];
        for (int i = 0; i < 20; i++) {
            [showStr appendFormat:@"-%@", keystr];
        }
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.text = showStr;
        label.textColor = [UIColor whiteColor];
        label.lineBreakMode = NSLineBreakByClipping;
        [self.windowForEnvs addSubview:label];
        label.frame = CGRectInset(self.windowForEnvs.bounds, 0, -5);
        label.textAlignment = NSTextAlignmentLeft;
    }
}


// UI 显示环境切换列表
- (void)showEnvChanger {
    UIAlertController *ac = [self ActionSheet];
    if(ac.presentingViewController==nil) {
        UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        while (rootVC.presentedViewController) {
            rootVC = rootVC.presentedViewController;
        }
        [rootVC presentViewController:ac animated:YES completion:nil];
    }
}

// 返回app版本等信息
- (NSString *)appVersionInfo {
    NSDictionary *info = [NSBundle mainBundle].infoDictionary;
    return [NSString stringWithFormat:@"%@ | 版本:%@ | Build:%@", info[@"CFBundleDisplayName"] ? : info[@"CFBundleName"], info[@"CFBundleShortVersionString"], info[@"CFBundleVersion"]];
}

- (UIAlertController *)ActionSheet {
    NSString *title = [self appVersionInfo];
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:kGLEnvsSelectorTipStr preferredStyle:UIAlertControllerStyleAlert];
    
    // 所有环境
    for (int i = 0; i < self.envs.count; i++) {
        NSDictionary *envDic = self.envs[i];
        NSString *envName = envDic.allKeys.firstObject;
        NSString *sheetTitle = envName;
        if([[GLEnvs loadEnvName] isEqualToString:envName]){
            sheetTitle = [NSString stringWithFormat:@"-->  %@", envName];
        }
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:sheetTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
            NSDictionary *curDict = [GLEnvs loadEnv];
            if ([GLEnvs saveEnv:envDic]) {
                if([GLEnvs defaultEnvs].handleListenerWillChange) {
                    if([GLEnvs defaultEnvs].handleListenerWillChange(curDict, envDic)) {
                        exit(1);
                    }
                }
                else{
                    exit(1);
                }
            }
        }];
        alertAction.enabled = ![[GLEnvs loadEnvName] isEqualToString:envName];
        [ac addAction:alertAction];
    }
    
    // 自定义
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:kGLEnvsCustomTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        GLEnvsCustomController *controller = [GLEnvsCustomController new];
        controller.data = [[GLEnvs loadEnv] mutableCopy];
        controller.handleSave = ^(NSDictionary *_Nonnull newdata) {
            NSDictionary *curDict = [GLEnvs loadEnv];
            if ([GLEnvs saveEnv:@{kGLEnvsCustomTitle: newdata}]) {
                if([GLEnvs defaultEnvs].handleListenerWillChange) {
                    if([GLEnvs defaultEnvs].handleListenerWillChange(curDict, newdata)) {
                        exit(1);
                    }
                }
                else{
                    exit(1);
                }
            }
        };
        UINavigationController *envNav = [[UINavigationController alloc]initWithRootViewController:controller];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:envNav animated:YES completion:nil];
    }];
    alertAction.enabled = YES;
    [ac addAction:alertAction];
    
    
    // 取消
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:cancelAction];
    return ac;
}

- (UIWindow *)windowForEnvs {
    if(!_windowForEnvs) {
        _windowForEnvs = [[UIWindow alloc] initWithFrame:[UIApplication sharedApplication].statusBarFrame];
        _windowForEnvs.hidden = NO;
        _windowForEnvs.windowLevel = UIWindowLevelStatusBar+1;
        _windowForEnvs.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:.3];
        _windowForEnvs.userInteractionEnabled = NO;
    }
    return _windowForEnvs;
}
@end

/*
 * --------Extension---------
 */
NSString * const GLENV_SHORTCUT_TITLE = @"com.glenv.shortcut";

@implementation GLEnvs(ShortcutExt)

// 与系统的shortcut点击方法进行交换的原始方法
- (void)_glenv_application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    if([shortcutItem.type hasPrefix:GLENV_SHORTCUT_TITLE]) {
        if([GLEnvs defaultEnvs].handleshortCutItemCusHandle){
            [GLEnvs defaultEnvs].handleshortCutItemCusHandle(shortcutItem);
        }else{
            [GLEnvs manualChangeEnv:[shortcutItem.type componentsSeparatedByString:@"."].lastObject.intValue];
        }
    }
    if([self respondsToSelector:@selector(application:performActionForShortcutItem:completionHandler:)]){
        [[GLEnvs defaultEnvs] _glenv_application:application performActionForShortcutItem:shortcutItem completionHandler:completionHandler];
    }
}

// 开启切换环境 模式：shortcut
- (void)enableWithShortCutItemChooseHandle:(void(^)(UIMutableApplicationShortcutItem *item))handle {
    NSLog(@">-> GLEnvs : %@", [GLEnvs loadEnvName]);
    self.handleshortCutItemCusHandle = handle;
    NSMutableArray<UIMutableApplicationShortcutItem *> *shortcuts = [NSMutableArray array];
    for (int i=0;i<self.envs.count;i++) {
        NSDictionary *dict = self.envs[i];
        NSString *itemTitle = dict.allKeys.firstObject;
        if([itemTitle isEqualToString:[GLEnvs loadEnvName]]) {
            itemTitle = [NSString stringWithFormat:@"🔍 > %@", itemTitle];
        }
        UIMutableApplicationShortcutItem *item = [[UIMutableApplicationShortcutItem alloc]
                                                  initWithType:[NSString stringWithFormat:@"%@.%d", GLENV_SHORTCUT_TITLE, i]
                                                  localizedTitle:itemTitle];
        [shortcuts addObject:item];
    }
    UIMutableApplicationShortcutItem *item = [[UIMutableApplicationShortcutItem alloc]
                                              initWithType:@"Version"
                                              localizedTitle:[self appVersionInfo]];
    [shortcuts addObject:item];
    [UIApplication sharedApplication].shortcutItems = [shortcuts copy];
    
    Method method1 = class_getInstanceMethod([UIApplication sharedApplication].delegate.class, @selector(application:performActionForShortcutItem:completionHandler:));
    Method method2 = class_getInstanceMethod(self.class, @selector(_glenv_application:performActionForShortcutItem:completionHandler:));
    if(method1 == NULL){
        class_addMethod([UIApplication sharedApplication].delegate.class, @selector(application:performActionForShortcutItem:completionHandler:), method_getImplementation(method2), method_getTypeEncoding(method2));
    }else{
        method_exchangeImplementations(method1, method2);
    }
}
@end
