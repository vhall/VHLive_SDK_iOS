//
//  VhallSharedDur.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/10/21.
//

#import "VhallSharedDur.h"

@implementation VhallSharedDur

+ (instancetype)shareInstance
{
    static VhallSharedDur* dur;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        dur = [[VhallSharedDur alloc] init];
    });
    return dur;
}

- (NSString *)getViewToPath:(id)view
{
    NSString * path = @"";
    
    if (self.vhBool == YES)
    {
        for (UIView* next = view; next; next = next.superview) {
            
            path = [NSString stringWithFormat:@"%@_%ld_%@",next.class,[self viewInIndexToSuperView:next],path];
            
        }
        return path;
    }
    return path;
}

- (NSInteger)viewInIndexToSuperView:(UIView *)view
{
    NSInteger index = 0;
    NSArray * viewAry = [view.superview subviews];
    
    //取同类元素的index
    NSInteger j = 0;
    
    for (int i = 0; i<viewAry.count; i++)
    {
        UIView * chileView = viewAry[i];
        if ([chileView.class isEqual:view.class])
        {
            if ([chileView isEqual:view])
            {
                index = j;
            }
            j++;
        }
    }
    return index;
}

- (UIViewController *)viewControllerToView:(UIView *)view {
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (UIViewController *)vhGetCurrentVC {
    
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    if (!window) {
        return nil;
    }
    UIView *tempView;
    for (UIView *subview in window.subviews) {
        if ([[subview.classForCoder description] isEqualToString:@"UILayoutContainerView"]) {
            tempView = subview;
            break;
        }
    }
    if (!tempView) {
        tempView = [window.subviews lastObject];
    }
    
    id nextResponder = [tempView nextResponder];
    while (![nextResponder isKindOfClass:[UIViewController class]] || [nextResponder isKindOfClass:[UINavigationController class]] || [nextResponder isKindOfClass:[UITabBarController class]]) {
        tempView =  [tempView.subviews firstObject];
        
        if (!tempView) {
            return nil;
        }
        nextResponder = [tempView nextResponder];
    }
    return  (UIViewController *)nextResponder;
}

- (NSData *)pixData {
    
    NSData *data;
    
    if (self.vhBool == YES)
    {
        UIImage * image;
        //    参照视图
        UIView * view = [UIApplication sharedApplication].windows.firstObject;
        //    参照视图总大小
        CGSize size = view.bounds.size;
        //    开启上下文
        //    UIGraphicsBeginImageContext(size);//图片质量低
        //    使用参数之后,截出来的是原图（YES,0.0）质量高 0.1 - 1.0 模糊-清晰 0.0或者大于1.0是原图
        UIGraphicsBeginImageContextWithOptions(size, YES,0.5);
        //    根据参照视图的大小设置要裁剪的矩形范围
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        //    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        //iOS7以后renderInContext：由drawViewHierarchyInRect：afterScreenUpdates：替代
        [view drawViewHierarchyInRect:rect  afterScreenUpdates:NO];
        // 从上下文中,取出UIImage
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        // 结束上下文
        UIGraphicsEndImageContext();
        
        data = UIImageJPEGRepresentation(image, 0.5);
        
        return data;
    }
    return data;
}

#pragma mark - 上传数据
- (void)postUserIconImageData:(NSData *)data parameters:(NSMutableDictionary *)parameters {
    
    // 创建管理者对象
    AFHTTPSessionManager* AFManager = [AFHTTPSessionManager manager];
    AFManager.requestSerializer = [AFJSONRequestSerializer serializer];
    AFManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString* urlString = @"http://test01-cube.vhallyun.com/api/v1/hackathon/collect";
    
    NSString* fileName = [NSString stringWithFormat:@"%@%d.jpeg", [VUITool nowTimeInterval], arc4random() % 999];
    parameters[@"time"] = [VUITool nowTimeInterval];
    parameters[@"session_id"] = [VhallSharedDur shareInstance].session_id;
    
    [AFManager POST:urlString parameters:parameters headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 添加数据参数
        [formData appendPartWithFileData:data name:@"img" fileName:fileName mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];
}

@end
