//
//  VHBeautyTopView.m
//  UIModel
//
//  Created by jinbang.li on 2022/3/1.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHBeautyTopView.h"
#import "VHChangeSegmentView.h"

@interface VHBeautyTopView()
@property (nonatomic,strong) VHChangeSegmentView *segmentView;
@end
@implementation VHBeautyTopView

- (instancetype)init{
    if (self = [super init]) {
        [self setupContent];
    }
    return self;
}
#pragma mark --头部视图(美颜,滤镜切换标签)+重置+底部分割线 375*45
- (void)setupContent{
    //美颜+滤镜切换视图
    //重置视图
    //底部分割线
}
@end
