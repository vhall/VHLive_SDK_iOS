//
//  GLEnvs.h
//
//  Created by liguoliang on 2018/8/10.
//

/*
// ------------设置------------
GLEnvs *envs = [GLEnvs defaultWithEnvironments:@[
    @{@"TEST":@{
        @"HOST":@"<testHost>",
        @"Value":@"<testValue>"
     }},
    @{@"DEV":@{
        @"HOST":@"<devHost>",
        @"Value":@"<devValue>"
    }},
    @{@"Release":@{
        @"HOST":@"<releaseHost>",
        @"Value":@"<releaseValue>"
    }}
]];
[envs enableWithShakeMotion:YES defaultIndex:0];

// ------------使用------------
NSURL *url = [[GLEnvs loadEnv][@"HOST"] stringByAppendingPathComponent:@"xx/xx"];
NSString *key = [GLEnvs loadEnv][@"Value"];
 */
#import <UIKit/UIKit.h>
#import <GLEnvsProtocol.h>

/// 匹配模式 [完全 | 开头 | 包含 | 结尾]
typedef enum : NSUInteger {
    MatchAll,       // 完全匹配
    MatchPrefix,    // 匹配开头
    MatchSuffix,    // 匹配结尾
    MatchContain    // 包含即可
} MatchType;

@interface GLEnvs : NSObject

/// 监听环境切换，返回值: [` True 正常(直接退出app)  |  False 无需重启即刻生效(下次重启后生效) `]
@property (nonatomic) BOOL(^handleListenerWillChange)(NSDictionary *curEnv, NSDictionary *toEnv);

/// 匹配模式，默认完全匹配 (只在PasteBoard模式生效)
@property (nonatomic) MatchType type;

/// 是否开启顶栏提示条
@property (nonatomic) BOOL showTopLine;

/// GLEnvs 全局单例
+ (GLEnvs *)defaultEnvs;

/// (新)注册环境
/// @param envsName 环境名称
/// @param index 自定义环境Index (唯一)
/// @param content 该环境所使用的内容
/// @return GLEnvs实例
- (GLEnvs *)registEnvsWithName:(NSString *)envsName Index:(NSUInteger)index Content:(NSDictionary *)content;

/// GLEnvs 初始化
/// @param envs 环境配置内容 (详见 GLEnvs.h 注释)
/// @return GLEnvs实例
+ (GLEnvs *)defaultWithEnvironments:(NSArray<NSDictionary *> *)envs;

/// 通过摇一摇切换环境
/// @param enable 是否开启
/// @param index 默认的环境索引值
- (void)enableWithShakeMotion:(BOOL)enable defaultIndex:(NSUInteger)index;

/// 手动改变环境
/// @param index 环境列表索引下标
+ (void)manualChangeEnv:(NSUInteger)index;

/// 通过匹配剪切板内容来开启 摇一摇切换环境 功能
/// @param string 指定剪切板内容(默认完全匹配)
/// @param sucIndex 如匹配成功，使用的环境索引下标
/// @param fadIndex 如匹配失败，使用的环境索引下标
/// @link 匹配类型详见 (MatchType)type [完全 | 开头 | 包含 | 结尾]
- (void)enableWithPasteBoardString:(NSString *)string matchSuccess:(NSUInteger)sucIndex matchFailed:(NSUInteger)fadIndex;

/// 设置使用长按(3D Touch)App图标弹出菜单进行环境选择
/// @param title 菜单项标题
/// @param configViewController 弹出的页面名称(需要<GLEnvsProtocol>协议)
/// @param index 直接点击App图标进入的环境索引值
- (void)enableWithShortCutItemString:(NSString *)title PresentConfig:(UIViewController<GLEnvsProtocol>*)configViewController defaultIndex:(NSUInteger)index NS_UNAVAILABLE;
//OBJC_DEPRECATED("replace [-enableWithShortCutItemChooseHandle:]");

+ (NSDictionary *)current;

/// 获取当前的环境
/// @return 当前环境的配置项
+ (NSDictionary *)loadEnv OBJC_DEPRECATED("replace [+current]");

/// 获取当前环境的名称
/// @return 当前环境的名称
+ (NSString *)loadEnvName;

- (instancetype)init NS_UNAVAILABLE;
@end


@interface GLEnvs(ShortcutExt)
/// 设置使用长按切换环境
/// @param handle 自定义长按事件
- (void)enableWithShortCutItemChooseHandle:(void(^)(UIMutableApplicationShortcutItem *item))handle;
@end
