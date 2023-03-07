//
//  VHQAView.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2022/12/22.
//

#import <UIKit/UIKit.h>

@interface VHQAViewListCell : UITableViewCell

/// 提问数据
@property (nonatomic, strong) VHallQuestionModel * vhQuestionModel;

/// 回答数据
@property (nonatomic, strong) VHallAnswerModel * vhAnswerModel;


+ (VHQAViewListCell *)createCellWithTableView:(UITableView *)tableView;

@end

@protocol VHQAViewDelegate <NSObject>

/// 是否打开问答
- (void)vhQAIsOpen:(BOOL)isOpen;

@end

@interface VHQAView : UIView<JXCategoryListContentViewDelegate>

@property (nonatomic, weak) id <VHQAViewDelegate> delegate;

/// 问答类
@property (nonatomic, strong) VHallQAndA * vhQA;

/// 初始化
/// - Parameter frame: frame
/// - Parameter obj: 播放器
- (instancetype)initQAWithFrame:(CGRect)frame obj:(NSObject *)obj webinarInfoData:(VHWebinarInfoData *)webinarInfoData;

/// 发送提问 （在收到播放器"播放连接成功回调"或"视频信息预加载成功回调"以后使用）
/// - Parameter msg: 文本
- (void)sendQAMsg:(NSString *)msg;

@end

