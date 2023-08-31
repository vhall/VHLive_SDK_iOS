//
//  VHGoodsList.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/8/9.
//

#import <UIKit/UIKit.h>

/// 立即购买
typedef void(^ClickPayBtnBlock)(VHGoodsListItem *item);

@interface VHGoodsListCell : UITableViewCell

@property (nonatomic, strong) YYLabel *numLab;          ///<时间
@property (nonatomic, strong) UILabel *titleLab;        ///<标题
@property (nonatomic, strong) UILabel *infoLab;         ///<描述
@property (nonatomic, strong) UILabel *discountTagLab;  ///<优惠标签
@property (nonatomic, strong) UILabel *discountPriceLab;///<优惠价格
@property (nonatomic, strong) YYLabel *priceLab;        ///<原价格
@property (nonatomic, strong) UIButton *payBtn;         ///<购买
@property (nonatomic, strong) UIImageView *img;         ///<图片

@property (nonatomic, strong) VHGoodsListItem *item;
@property (nonatomic, assign) NSInteger index;

/// 立即购买
@property (nonatomic, copy) ClickPayBtnBlock clickPayBtnBlock;

+ (VHGoodsListCell *)createCellWithTableView:(UITableView *)tableView;

@end

@protocol VHGoodsListDelegate <NSObject>

/// 是否有商品
- (void)isHaveGoods:(BOOL)isHaveGoods;

/// 推送商品
- (void)pushGoodsCardModel:(VHGoodsPushMessageItem *)model;

@end

@interface VHGoodsList : UIView<JXCategoryListContentViewDelegate>

@property (nonatomic, weak) id <VHGoodsListDelegate> delegate; ///<代理

/// 初始化
/// - Parameters:
///   - frame: frame
///   - object: 播放器类
- (instancetype)initWithFrame:(CGRect)frame object:(NSObject *)object;

/// 在线活动商品列表(发起/观看端)
- (void)requestGoodsGetList;

/// 点击查看商品详情页
/// - Parameter item: 商品详情
- (void)clickCheckDetail:(VHGoodsListItem *)item;

@end
