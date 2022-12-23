//
//  GLEnvsProtocol.h
//  GLEnvs
//
//  Created by liguoliang on 2020/12/2.
//

#import <Foundation/Foundation.h>

@protocol GLEnvsProtocol <NSObject>
/**
 仅仅是个说明：
    1. 页面进行正常的逻辑和事件定义
    2. 在某个逻辑触发的函数内增加 `[GLEnvs manualChangeEnv:<INDEX>];` 的调用
         * 其中的<INDEX>为已经定义的环境变量列表下标
    3.
 */
@end
