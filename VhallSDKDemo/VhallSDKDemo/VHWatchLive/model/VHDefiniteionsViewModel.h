//
//  VHDefiniteionsViewModel.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/26.
//

#import <Foundation/Foundation.h>


@interface VHDefiniteionsViewModel : NSObject
/// 画质
@property (nonatomic, assign) VHMovieDefinition def;
/// 文案
@property (nonatomic, copy) NSString *title;
/// 选中
@property (nonatomic, assign) BOOL isSelect;

@end
