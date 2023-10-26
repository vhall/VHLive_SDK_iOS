//
//  NSObject+vhall.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/10/21.
//

#import "NSObject+vhall.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "VhallSharedDur.h"

static NSData * imageData;

@implementation NSObject (vhall)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL origilaSEL = @selector(scrollViewDidEndDecelerating:);
        
        SEL hook_SEL = @selector(gc_scrollViewDidEndDecelerating:);
        
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
        
        
        SEL draOrigilaSEL = @selector(scrollViewDidEndDragging: willDecelerate:);
        
        SEL draHook_SEL = @selector(gc_scrollViewDidEndDragging: willDecelerate:);
        
        //交换方法
        Method draOrigilalMethod = class_getInstanceMethod(self, draOrigilaSEL);
        
        
        Method draHook_method = class_getInstanceMethod(self, draHook_SEL);
        
        
        class_addMethod(self,
                        draOrigilaSEL,
                        class_getMethodImplementation(self, draOrigilaSEL),
                        method_getTypeEncoding(draOrigilalMethod));
        
        class_addMethod(self,
                        draHook_SEL,
                        class_getMethodImplementation(self, draHook_SEL),
                        method_getTypeEncoding(draHook_method));
        
        method_exchangeImplementations(class_getInstanceMethod(self, draOrigilaSEL), class_getInstanceMethod(self, draHook_SEL));
    });
    
}

- (void)gc_scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    imageData = [[VhallSharedDur shareInstance] pixData];
    [self taskData:[[VhallSharedDur shareInstance] getViewToPath:scrollView] eid:@"滑动结束" viewC:[[VhallSharedDur shareInstance] viewControllerToView:scrollView]];
    
}

- (void)gc_scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    if (decelerate == NO)
    {
        imageData = [[VhallSharedDur shareInstance] pixData];
        [self taskData:[[VhallSharedDur shareInstance] getViewToPath:scrollView] eid:@"拖动结束" viewC:[[VhallSharedDur shareInstance] viewControllerToView:scrollView]];
    }
    
}

//整理并上传数据
- (void)taskData:(NSString *)viewPath eid:(NSString *)eid viewC:(UIViewController *)vc
{
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    parameters[@"wh"] = [@[@((int)[UIScreen mainScreen ].bounds.size.width), @((int)[UIScreen mainScreen ].bounds.size.height)] mj_JSONString];
    parameters[@"eid"] = eid;

    if ([VhallSharedDur shareInstance].vhBool == YES) {
        // 上传数据
        [[VhallSharedDur shareInstance] postUserIconImageData:imageData parameters:parameters];
    }
}

@end
