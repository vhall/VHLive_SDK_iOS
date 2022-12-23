//
//  VHExamViewController.h
//  UIModel
//
//  Created by 郭超 on 2022/11/22.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHBaseViewController.h"

@interface VHExamCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel * nameLab;    ///<名称

@end

@interface VHExamViewController : VHBaseViewController

/// 活动id
@property (nonatomic, strong)   NSString *  webinar_id;

@end
