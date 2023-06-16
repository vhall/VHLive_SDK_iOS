//
//  VHRecordListModel.h
//  VHLiveSDK
//
//  Created by 郭超 on 2023/5/26.
//  Copyright © 2023 vhall. All rights reserved.
//

#import "VHallRawBaseModel.h"

@interface VHRecordListModel : VHallRawBaseModel

/// 回放id
@property (nonatomic, copy) NSString *record_id;
/// 所属活动id
@property (nonatomic, assign) NSInteger webinar_id;
/// 回放名称
@property (nonatomic, copy) NSString *name;
/// 用户id
@property (nonatomic, assign) NSInteger user_id;
/// 类别，0为新版数据，1为旧自助版数据，2为旧客户端数据，3为旧插播视频，4为新版上传，5为旧app活动，6默认回放
@property (nonatomic, assign) NSInteger type;
/// 图片地址
@property (nonatomic, copy) NSString *img_url;
/// 创建时间
@property (nonatomic, copy) NSString *created_at;
/// 更新时间
@property (nonatomic, copy) NSString *updated_at;
/// 视频时长
@property (nonatomic, copy) NSString *duration;
/// 0 回放 1 录制 2 上传 3 打点录制
@property (nonatomic, assign) NSInteger source;
/// 清晰度
@property (nonatomic, assign) NSInteger quality;
/// 转码状态:0新增排队中 1转码成功 2转码失败 3转码中
@property (nonatomic, assign) NSInteger transcode_status;
/// 转码进度百分比
@property (nonatomic, copy) NSString *percent;
/// 回放对应的场次id
@property (nonatomic, assign) NSInteger switch_id;
/// 0:未加密 1:加密中 2:加密成功
@property (nonatomic, assign) NSInteger encrypt_status;
/// 是否彩排 1 ：是 0 ：否
@property (nonatomic, assign) NSInteger is_rehearsal;
/// 1:有章节 0:没有章节
@property (nonatomic, assign) NSInteger doc_status;
/// 是否融屏 1:是 0 否
@property (nonatomic, assign) NSInteger is_union_screen;
/// 课件重置进度 生成进度 如88 初始为0
@property (nonatomic, assign) NSInteger remake_doc_progress;

@end



