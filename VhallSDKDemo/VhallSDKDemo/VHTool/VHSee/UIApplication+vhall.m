//
//  UIApplication+vhall.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/10/21.
//

#import "UIApplication+vhall.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "VhallSharedDur.h"

//开始坐标
static CGPoint beginPoint;
//结束坐标
static CGPoint endPoint;
//移动坐标
static CGPoint movedPoint;
//事件触发在会话开始的第几秒
static CGFloat eventFloat = 0.0;
//移动有效坐标倍数 用于减少上传坐标数量 20像素上传一次
static NSInteger directionNum = 1;
//存储坐标数组
static NSMutableArray * pointArray;
//存储拖动方向
static NSString * directionStr = @"";
//存储开始截图
static NSData * imageData;
//viewPath
static NSString * viewPath = @"";
//操作时间
static NSDate * rdDate;

@implementation UIApplication (vhall)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL origilaSEL = @selector(sendEvent:);
        
        SEL hook_SEL = @selector(gc_sendEvent:);
        
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
- (void)zg_TimerTest:(NSTimer *)timer
{
    eventFloat++;
}
- (void)gc_sendEvent:(UIEvent *)event
{
    
    if (event.type==UIEventTypeTouches) {
        //响应触摸事件（手指刚刚放上屏幕）
        UITouch *touch=[event.allTouches anyObject];
        
        
        UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
        
        if ([[event.allTouches anyObject] phase]==UITouchPhaseBegan) {
            
            //初始化坐标数组
            pointArray = [NSMutableArray array];
            
            //记录开始触摸的点
            beginPoint = [touch locationInView:window];
            
            //坐标
            viewPath = [[VhallSharedDur shareInstance] getViewToPath:touch.view];
            
            //添加坐标
            [pointArray addObject:@[@((int)beginPoint.x),@((int)beginPoint.y)]];
            
            //操作开始时间
            rdDate = [NSDate date];
            
            //动作开始时 截图
            imageData = [[VhallSharedDur shareInstance] pixData];
            
        }
        if ([[event.allTouches anyObject] phase]==UITouchPhaseMoved) {
            
            //移动Point
            movedPoint = [touch locationInView:window];
            
            //计算移动Point
            CGPoint deltaPoint = CGPointMake((int)(beginPoint.x - movedPoint.x), (int)(beginPoint.y - movedPoint.y));
            
            [self commitTranslation:deltaPoint movedPoint:movedPoint];
            
        }
        if ([[event.allTouches anyObject] phase]==UITouchPhaseStationary) {
            
            
        }
        if ([[event.allTouches anyObject] phase]==UITouchPhaseEnded) {
            
            //结束Point
            endPoint = [touch locationInView:window];
            
            //上传数据
            [self taskData];
            
            //清空有效移动倍数
            directionNum = 1;
        }
        if ([[event.allTouches anyObject] phase]==UITouchPhaseCancelled) {
            
        }
    }
    [self gc_sendEvent:event];
}

//整理并上传数据
- (void)taskData
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"points"] = [pointArray mj_JSONString];
    parameters[@"wh"] = [@[@((int)[UIScreen mainScreen ].bounds.size.width), @((int)[UIScreen mainScreen ].bounds.size.height)] mj_JSONString];

    if (pointArray.count > 1) {
        parameters[@"eid"] = directionStr;
    } else {
        parameters[@"eid"] = @"点击";
    }

    if ([VhallSharedDur shareInstance].vhBool == YES) {
        // 上传数据
        [[VhallSharedDur shareInstance] postUserIconImageData:imageData parameters:parameters];
    }
}

#pragma mark --- 拖动手势方向
/** 判断手势方向  */
- (void)commitTranslation:(CGPoint)translation movedPoint:(CGPoint)movedPoint{
    
    CGFloat absX = fabs(translation.x);
    CGFloat absY = fabs(translation.y);
    
    //算法-滑动有效距离倍数
    NSInteger  directionInt = 50*directionNum;
    //上下滑动
    if(absY > absX)
    {
        //向上滑动
        if (translation.y > directionInt)   //有效滑动距离 MINDISTANCE
        {
            [self directionName:@"向上滑动" movedPoint:movedPoint];
        }
        //向下滑动
        else if (translation.y < -directionInt)
        {
            [self directionName:@"向下滑动" movedPoint:movedPoint];
        }
    }
    //左右滑动
    else if(absX > absY)
    {
        //向左滑动
        if (translation.x > directionInt)
            
        {
            [self directionName:@"向左滑动" movedPoint:movedPoint];
        }
        //向右滑动
        else if (translation.x < -directionInt)
            
        {
            [self directionName:@"向右滑动" movedPoint:movedPoint];
        }
    }
    
}

- (void)directionName:(NSString *)directionName movedPoint:(CGPoint)movedPoint
{
    directionNum++;
    directionStr = directionName;
    //添加坐标
    [pointArray addObject:@[@(movedPoint.x),@(movedPoint.y)]];
}


@end
