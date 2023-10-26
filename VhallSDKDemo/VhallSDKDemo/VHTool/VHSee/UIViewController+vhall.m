//
//  UIViewController+vhall.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/10/21.
//

#import "UIViewController+vhall.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "VhallSharedDur.h"

static NSData * imageData;
NSString * const gc_VCKey = nil;

@implementation UIViewController (vhall)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL origilaSEL = @selector(viewDidAppear:);
        
        SEL hook_SEL = @selector(gc_viewDidAppear:);
        
        //交换方法
        Method origilalMethod = class_getInstanceMethod(self, origilaSEL);
        
        
        Method hook_method = class_getInstanceMethod(self, hook_SEL);
        
        
        class_addMethod(self,
                        origilaSEL,
                        class_getMethodImplementation(self, origilaSEL),
                        method_getTypeEncoding(origilalMethod));
        
        class_addMethod(self,
                        hook_SEL,
                        class_getMethodImplementation(self, hook_SEL),
                        method_getTypeEncoding(hook_method));
        
        method_exchangeImplementations(class_getInstanceMethod(self, origilaSEL), class_getInstanceMethod(self, hook_SEL));
        
    });
    
}
- (void)gc_viewDidAppear:(BOOL)animated{
    
    
    if ([self isKindOfClass:[UIViewController class]] && ![self isKindOfClass:[UITabBarController class]] && ![self isKindOfClass:[UINavigationController class]])
    {
        //页面变化的时候初始化date
        imageData = [[VhallSharedDur shareInstance] pixData];
        [self taskData:[[VhallSharedDur shareInstance] getViewToPath:self.view]];
        
    }
    
    [self gc_viewDidAppear:animated];
    
}
//整理并上传数据
- (void)taskData:(NSString *)viewPath
{
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    parameters[@"wh"] = [@[@((int)[UIScreen mainScreen ].bounds.size.width), @((int)[UIScreen mainScreen ].bounds.size.height)] mj_JSONString];
    parameters[@"eid"] = @"页面变化";
    
    if ([VhallSharedDur shareInstance].vhBool == YES) {
        // 上传数据
        [[VhallSharedDur shareInstance] postUserIconImageData:imageData parameters:parameters];
    }
}

- (void)postUserIconImageData:(NSData *)data parameters:(NSMutableDictionary *)parameters {
    
    // 创建管理者对象
    AFHTTPSessionManager* AFManager = [AFHTTPSessionManager manager];
    AFManager.requestSerializer = [AFJSONRequestSerializer serializer];
    AFManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString* urlString = @"http://test01-cube.vhallyun.com/api/v1/hackathon/collect";
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString* string = [formatter stringFromDate:[NSDate date]];
    NSString* fileName = [NSString stringWithFormat:@"%@%d.jpeg", string, arc4random() % 99999];
    parameters[@"session_id"] = [NSString stringWithFormat:@"%@%d", string, arc4random() % 99999];

    [AFManager POST:urlString parameters:parameters headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 添加数据参数
        [formData appendPartWithFileData:data name:@"img" fileName:fileName mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];
}
@end
