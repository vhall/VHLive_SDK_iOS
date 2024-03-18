//
//  VHDanmu.m
//  VhallSDKDemo
//
//  Created by 郭超 on 2024/2/1.
//

#import "VHDanmu.h"
#import <BarrageRenderer/BarrageRenderer.h>

@interface VHDanmu ()

/// 弹幕工具
@property (nonatomic, strong) BarrageRenderer *renderer;

@end

@implementation VHDanmu

#pragma mark - 初始化
- (instancetype)init {
    if ([super init]) {
        
    }
    return self;
}

#pragma mark - 发送弹幕
- (void)sendWithMsgModel:(VHallChatModel *)msgModel superView:(UIView *)superView{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    descriptor.params[@"text"] = msgModel.text; // 文本内容
    descriptor.params[@"textColor"] = [UIColor whiteColor]; // 文本颜色
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50); // 随机速度
    descriptor.params[@"direction"] = @(BarrageWalkDirectionR2L); // 方向
    descriptor.params[@"side"] = @(BarrageWalkSideDefault); // 悬浮弹幕默认
    descriptor.params[@"clickAction"] = ^(NSDictionary *params){
        NSLog(@"点击弹幕 => %@",params[@"text"]);
    };
    [self.renderer receive:descriptor]; // 添加弹幕
    
    // 判断是否已添加到视图,执行后续操作
    if (![self.renderer.view isEqual:superView]) {
        self.renderer.canvasMargin = UIEdgeInsetsMake(20, 10, 30, 10);
        [superView addSubview:self.renderer.view];
    }
}

#pragma mark - 启动弹幕, 内部时钟从0开始;
- (void)start {
    [self.renderer start];
}

#pragma mark - 暂停, 已经渲染上去的保持不变, 此时发送弹幕无效, 内部时钟暂停;
- (void)pause {
    [_renderer pause];
}

#pragma mark - 停止弹幕渲染, 会清空所有; 再发弹幕就无效了; 一切都会停止;
- (void)stop {
    [_renderer stop];
}

- (BarrageRenderer *)renderer {
    if (!_renderer) {
        _renderer = [[BarrageRenderer alloc]init];
        // 弹幕可点击
        _renderer.view.userInteractionEnabled = YES;
    }
    return _renderer;
}
@end
