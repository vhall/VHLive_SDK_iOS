//
//  VHBeautyAdjustController.m
//  UIModel
//
//  Created by jinbang.li on 2022/2/17.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHBeautyAdjustController.h"
#import "VHBeautyEffectCell.h"
#import "VHBeautyFilterCell.h"
#import "VHSwitchCell.h"
#import "VHBeautyModel.h"
#import "VHSlider.h"
#import "VHSaveBeautyTool.h"
#import "UIButton+VHConvenient.h"
#import "VHChangeSegmentView.h"
#import "UIColor+VUI.h"
#import "UILabel+VHConvenient.h"
#import "VHBFURender/VHBeautifyEffectList.h"
#import "VHAlertView.h"

static NSString * const effectCell = @"VHBeautyEffectCell";
static NSString *const filterCell = @"VHBeautyFilterCell";
static NSString * const switchEffectCell = @"VHSwitchCell";
@interface VHBeautyAdjustController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIViewControllerTransitioningDelegate>
@property (nonatomic,strong) VHBeautifyKit *beautyModule;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic, strong) UICollectionView * collectionView;//美颜，滤镜选择
@property (nonatomic,strong) UIView *topView;//头部视图含切换和重置
@property (nonatomic,strong) VHSlider *sliderView;//滑动块视图
@property (nonatomic,assign) BOOL  isEnable;//美颜单元格初始化为YES
@property (nonatomic,strong) NSArray<NSArray <VHBeautyModel *> *> *beautyEffectArray;//展示视图数组
@property (nonatomic,strong) NSMutableDictionary <NSString *,VHBeautyModel *> *beautyConfig;//美颜+滤镜配置字典
@property (nonatomic,strong) UIButton *switchEnable;//美颜开关
@property (nonatomic,strong) VHChangeSegmentView *segmentView;
//记录美颜的Index、、、、
@property (nonatomic,assign) NSInteger  beauty_Index;
//记录滤镜的Index
@property (nonatomic,assign) NSInteger filter_Index;
///中间点视图
@property (nonatomic,strong) UIView *midDotView;
///可调整的view
@property (nonatomic,strong) UIView *adjustView;
@end

@implementation VHBeautyAdjustController

- (void)refreshEffect:(VHBeautifyKit *)beautyModule{
    self.beautyModule = beautyModule;
    ///根据是否有预设实时渲染 实时调整实时渲染
}
- (void)setupDataSource{
    self.beautyEffectArray = [VHSaveBeautyTool beautyViewModelArray];
    self.beautyConfig = [VHSaveBeautyTool readLastBeautyEffectConfig];
}

- (instancetype)init {
    if((self = [super init])) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([VHSaveBeautyTool readSaveCacheStatus]) {
        //有缓存去缓存状态
        self.isEnable = [VHSaveBeautyTool readBeautyEnableStatus];
        self.filter_Index = [VHSaveBeautyTool readFilterIndex];
        ///根据索引值生效对应的值
        [VHSaveBeautyTool applyFilterCacheBeautifyKit:self.beautyModule];
    }else{
        self.isEnable = YES;
        self.beauty_Index = 1;
        self.filter_Index = 1;//默认选中滤镜
    }
    [self setupDataSource];
    [self setupBackgorundEvent];
    [self setupContentView];
   //分有无缓存的历史数据,有美颜全部开启，读取归档数据值，滤镜同样如此，无直接读取默认数据 需要存储最后的滤镜索引及美颜开关状态
    if (self.isEnable) {
        self.beauty_Index = 1;
        [self hiddenSliderOperation:NO];
        [self updateSliderProgressValue];
    }
     
    [VHSaveBeautyTool closeBeauty:self.beautyEffectArray[self.beautyType] beautifyKit:self.beautyModule closeBeautyEffect:!self.isEnable];
  
}
- (void)setupContentView{
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    if (!VH_KScreenIsLandscape) {
        self.contentView.layer.cornerRadius = 15;
    }
    self.contentView.userInteractionEnabled = YES;
    [self.view addSubview:self.contentView];
    
    //基准 横屏布局 292*375 竖屏布局 375*206
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);;
        make.right.offset(0);
        make.width.mas_equalTo(VH_KScreenIsLandscape?kAdaptScale*292:SCREEN_WIDTH);
        if (VH_KScreenIsLandscape) {
            make.top.offset(0);
        }else{
            make.left.offset(0);
            make.height.mas_equalTo(kAdaptScale*206);
        }
    }];
    [self setupTopView];
    [self setupSliderView];
    [self addContentSubView];
    [self adjustLeftRightSliderView];
}

- (void)setupTopView{
    self.topView = [[UIView alloc] init];
    [self.contentView addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kVHBeautyTopHeight);
        make.top.left.right.offset(0);
    }];
    VHChangeSegmentView *segementView = [[VHChangeSegmentView alloc] initWithFrame:CGRectMake(22*kAdaptScale, 0, kAdaptScale*110, kAdaptScale *45) titles:@[@"美颜",@"滤镜"] clickBlick:^(NSInteger index) {
        NSLog(@"点击的第%ld个",(long)index);
        [self changeSegment:index -1];
    }];
    [self.topView addSubview:segementView];
    UILabel *line = [UILabel speratorLineColor:@"#E2E2E2"];
    [self.topView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.mas_equalTo(0.5);
    }];
    
    UIButton *reset = [UIButton creatWithTitle:@"重置" titleFont:14 titleColor:@"#666666" backgroundColor:@"#FFFFFF"];
    
    [self.topView addSubview:reset];
    [reset addTarget:self action:@selector(alert) forControlEvents:UIControlEventTouchUpInside];
    [reset mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-22*kAdaptScale);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(33);
        make.centerY.offset(0);
    }];
    //[reset setImage:BundleUIImage(@"clockwiserotation") forState:UIControlStateNormal];
    //[reset setDefaultImageTitleStyleWithSpacing:5];
    
    UIImageView *resetIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clockwiserotation"]];
    [self.topView addSubview:resetIcon];
    [resetIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(reset.mas_left).offset(-5);
        make.centerY.offset(0);
        make.width.height.mas_equalTo(15*kAdaptScale);
    }];
    
}
- (void)changeSegment:(NSInteger)index{
    self.beautyType = index;
    switch (self.beautyType) {
        case BeautyType_Beauty:{
            //
            if (self.beauty_Index != 0) {
                [self hiddenSliderOperation:NO];
            }else{
                [self hiddenSliderOperation:YES];
            }
            
        }
            break;
        case BeautyType_Filter:{
            if (self.filter_Index != 0) {
                if (self.filter_Index >= 3 && !VH_KScreenIsLandscape) {
                    self.collectionView.contentOffset = CGPointMake(60*(self.filter_Index - 3), 0);
                }
                [self hiddenSliderOperation:NO];
            }else{
                
                [self hiddenSliderOperation:YES];
               
            }
        }
            break;
        default:
            break;
    }
    [self updateSliderProgressValue];
    [self.collectionView reloadData];
}
- (void)alert{
    [VHAlertView showAlertWithTitle:kDefaultEffect content:@"" cancelText:@"取消" cancelBlock:^{
        
    } confirmText:@"确定" confirmBlock:^{
        if (self.isEnable == NO) {
            self.isEnable = YES;
            self.beauty_Index = 1;
            [self hiddenSliderOperation:NO];
        }
        self.filter_Index = 1;//重置重新回到自然滤镜
        if (self.beautyType == BeautyType_Filter) {
            [self hiddenSliderOperation:NO];
        }
        [self.beautyModule setEffectKey:eff_key_FU_FilterName toValue:eff_Filter_Value_FU_ziran1];
        [self.beautyModule setEffectKey:eff_key_FU_FilterLevel toValue:@(0.4)];
        [self.collectionView reloadData];
        //恢复默认值
        self.beautyConfig = [VHSaveBeautyTool resetConfig:self.beautyConfig];
        [VHSaveBeautyTool closeBeauty:self.beautyEffectArray[0] beautifyKit:self.beautyModule closeBeautyEffect:!self.isEnable];
        //更新显示值与进度条
        [self updateSliderProgressValue];
    }];
}
- (void)setupBackgorundEvent {
    UIView *bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:bgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapBgView)];
    [bgView addGestureRecognizer:tap];
    [self.view sendSubviewToBack:bgView];
}
- (void)setupSliderView{
    self.sliderView = [[VHSlider alloc] init];
    self.sliderView.hidden = YES;
    self.sliderView.minimumValue = 0.0;
    self.sliderView.maximumValue = 100.0;
    
    [self.sliderView setThumbImage:[UIImage imageNamed:@"full-brush"] forState:UIControlStateNormal];
    [self.sliderView setThumbImage:[UIImage imageNamed:@"full-brush"] forState:UIControlStateHighlighted];;
    self.sliderView.minimumTrackTintColor = [UIColor colorWithHex:@"#FB3A32"];
    self.sliderView.maximumTrackTintColor = [UIColor colorWithHex:@"#D8D8D8"];
    [self.contentView addSubview:self.sliderView];
     __weak typeof(self) weak_self = self;
    self.sliderView.valueChanged = ^(VHSlider *slider) {
        if ([slider.valueText floatValue] > 0) {
            slider.valueText = [NSString stringWithFormat:@"+%.0f", slider.value];
        }else{
            slider.valueText = [NSString stringWithFormat:@"%.0f", slider.value];
        }
        [weak_self sliderValueChange:slider.value];
        [weak_self updateLeftRightSliderView:slider.value];
    };
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kVHBeautyTopHeight+kAdaptScale*14);
        make.height.mas_equalTo(kVHSliderHeight);
        make.left.offset(30);
        make.right.offset(-60);
        make.height.mas_equalTo(kAdaptScale * 20);
    }];
}
#pragma mark ---滑块值
- (void)sliderValueChange:(float)value{
    
    switch (self.beautyType) {
        case BeautyType_Beauty:{
            VHBeautyModel *model = self.beautyConfig[self.beautyEffectArray[self.beautyType][self.beauty_Index].name];
            NSString *clickName = self.beautyEffectArray[self.beautyType][self.beauty_Index].name;
            if ([clickName isEqual:VH_Effect_BlurLevel]) {
                // 磨皮为[0,6]:显示[0,100]
                model.currentValue = value/100 *6;
            } else if ([clickName isEqual:VH_Effect_ColorLevel] || [clickName isEqual:VH_Effect_RedLevel]){
                // 美白 红润
                model.currentValue = value/100 *2;
            } else if ([clickName isEqual:VH_Effect_IntensityChin] || [clickName isEqual:VH_Effect_IntensityForeheadV2] || [clickName isEqual:VH_Effect_IntensityMouthV2] || [clickName isEqual:VH_Effect_IntensityEyeSpace]  || [clickName isEqual:VH_Effect_IntensityEyeRotate]  || [clickName isEqual:VH_Effect_IntensityLongNose]  || [clickName isEqual:VH_Effect_IntensityPhiltrum]  || [clickName isEqual:VH_Effect_BrowHeight] || [clickName isEqual:VH_Effect_BrowSpace] || [clickName isEqual:VH_Effect_IntensityLipThick] || [clickName isEqual:VH_Effect_BrowThick] || [clickName isEqual:VH_Effect_EyeHeight] || [clickName isEqual:VH_Effect_IntensityNoseV2]){
                // 额头,鼻子，嘴巴[0,1]，显示是[-100,100],0.5
                model.currentValue = (value + 100)/200;
            } else {
                model.currentValue = value / 100;//更新模型里面的值
            }

            [self.beautyModule setEffectKey:model.effectName toValue:@(model.currentValue)];
        }
            break;
        case BeautyType_Filter:{
            VHBeautyModel *model = self.beautyConfig[self.beautyEffectArray[self.beautyType][self.filter_Index].name];
            model.currentValue = value/100;//更新模型里面的值
            [self.beautyModule setEffectKey:VH_Filter_Name toValue:model.effectName];
            [self.beautyModule setEffectKey:VH_Filter_Level toValue:@(value/100)];
        }
            break;
        default:
            break;
    }
}
- (void)onTapBgView {
    [self dismiss];
}
- (void)dismiss {
    if(self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)addContentSubView{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = VH_KScreenIsLandscape?UICollectionViewScrollDirectionVertical:UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = VH_KScreenIsLandscape?20:20;//滚动方向相同的间距为
    layout.minimumInteritemSpacing = VH_KScreenIsLandscape?10:20;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.alwaysBounceHorizontal = VH_KScreenIsLandscape?NO:YES;
    self.collectionView.alwaysBounceVertical = VH_KScreenIsLandscape?YES:NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.bounces = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.contentView addSubview:self.collectionView];
    [self.collectionView registerClass:[VHBeautyEffectCell class] forCellWithReuseIdentifier:effectCell];
    [self.collectionView registerClass:[VHSwitchCell class] forCellWithReuseIdentifier:switchEffectCell];
    [self.collectionView registerClass:[VHBeautyFilterCell class] forCellWithReuseIdentifier:filterCell];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, kAdaptScale * 22, 0, kAdaptScale * 22);
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.top.offset(kVHBeautyTopHeight+(14*kAdaptScale));
        VH_KScreenIsLandscape?make.bottom.offset(0):make.height.offset(kAdaptScale * 46);
    }];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.beautyEffectArray[self.beautyType].count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.beautyType == BeautyType_Beauty) {
        if (indexPath.row == 0) {
            //美颜开关
            VHSwitchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:switchEffectCell forIndexPath:indexPath];
            cell.cellSwitch.on = self.isEnable;
            cell.beautyEnable = ^(BOOL isEnable) {
                //开启或关闭美颜
                [self beautyStatus:isEnable];
            };
            return cell;
        }else{
            VHBeautyEffectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:effectCell forIndexPath:indexPath];
            cell.userInteractionEnabled = self.isEnable;
            [cell beautyModel:self.beautyEffectArray[self.beautyType][indexPath.row] isSelect:(indexPath.row==self.beauty_Index)?YES:NO];
            return cell;
        }
    }else{
        VHBeautyFilterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:filterCell forIndexPath:indexPath];
        
        [cell beautyModel:self.beautyEffectArray[self.beautyType][indexPath.row] isSelect:(indexPath.row==self.filter_Index)?YES:NO index:indexPath.row];
        return cell;
    }
}

// 返回每个item的大小 height 15+55+8+20  width 44
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.beautyType == BeautyType_Beauty) {
        return CGSizeMake(kVHCellBeautyWidth, kVHCellBeautyHeight);
    }else{
        return CGSizeMake(kVHCellFilterWidth, kVHCellFilterHeight);
    }
}
#pragma mark ---开启或关闭美颜
- (void)beautyStatus:(BOOL)isEnable{
    [self hiddenSliderOperation:YES];
    if (isEnable) {
        //开启美颜恢复默认值(重置都要更新值)
        [VHSaveBeautyTool closeBeauty:self.beautyEffectArray[self.beautyType] beautifyKit:self.beautyModule closeBeautyEffect:NO];
        self.beauty_Index = 1;
        [self hiddenSliderOperation:NO];
        [self updateSliderProgressValue];
    }else{
        //关闭美颜把值全置为0
        self.beauty_Index = 0;
        [VHSaveBeautyTool closeBeauty:self.beautyEffectArray[self.beautyType] beautifyKit:self.beautyModule closeBeautyEffect:YES];
    }
    self.isEnable = isEnable;
    [self.collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.beautyType == BeautyType_Beauty && indexPath.row == 0) {
        return;
    }
    VHBeautyModel *model = self.beautyConfig[self.beautyEffectArray[self.beautyType][indexPath.row].name];
    NSLog(@"点击的是%@-效果:%@",self.beautyType==BeautyType_Beauty?@"美颜":@"滤镜",model.effectName);
    switch (self.beautyType) {
        case BeautyType_Beauty:{
            self.beauty_Index = indexPath.row;
            if (indexPath.row != 0) {
                [self hiddenSliderOperation:NO];
            }
        }
            break;
        case BeautyType_Filter:{
            self.filter_Index = indexPath.row;
            if (self.filter_Index == 0) {
                [self hiddenSliderOperation:YES];
            }else{
                [self hiddenSliderOperation:NO];
            }
        }
            break;
        default:
            break;
    }
    [self updateSliderProgressValue];
    [self.collectionView reloadData];
}
#pragma mark ----根据配置值更新进度条和显示值
- (void)updateSliderProgressValue{
    VHBeautyModel *model =  self.beautyConfig[self.beautyEffectArray[self.beautyType][(self.beautyType == BeautyType_Beauty)?self.beauty_Index:self.filter_Index].name];
    NSString *clickName = self.beautyEffectArray[self.beautyType][(self.beautyType == BeautyType_Beauty)?self.beauty_Index:self.filter_Index].name;
    if ([clickName isEqual:VH_Effect_BlurLevel]) {
        self.sliderView.minimumTrackTintColor = [UIColor colorWithHex:@"#FB3A32"];
        self.sliderView.maximumTrackTintColor = [UIColor colorWithHex:@"#D8D8D8"];
        self.midDotView.hidden = YES;
        self.adjustView.hidden = YES;
        //磨皮为[0,6]:显示[0,100]
        self.sliderView.minimumValue = model.minValue * 100;
        self.sliderView.maximumValue = model.maxValue * 50/3;
        self.sliderView.value = model.currentValue * 50/3;
    } else if ([clickName isEqual:VH_Effect_ColorLevel]  || [clickName isEqual:VH_Effect_RedLevel]) {
        self.sliderView.minimumTrackTintColor = [UIColor colorWithHex:@"#FB3A32"];
        self.sliderView.maximumTrackTintColor = [UIColor colorWithHex:@"#D8D8D8"];
        self.midDotView.hidden = YES;
        self.adjustView.hidden = YES;
        //磨皮为[0,6]:显示[0,100]
        self.sliderView.minimumValue = model.minValue * 100;
        self.sliderView.maximumValue = model.maxValue * 50;
        self.sliderView.value = model.currentValue * 50;
    } else if ([clickName isEqual:VH_Effect_IntensityChin] || [clickName isEqual:VH_Effect_IntensityForeheadV2] || [clickName isEqual:VH_Effect_IntensityMouthV2] || [clickName isEqual:VH_Effect_IntensityEyeSpace]  || [clickName isEqual:VH_Effect_IntensityEyeRotate]  || [clickName isEqual:VH_Effect_IntensityLongNose]  || [clickName isEqual:VH_Effect_IntensityPhiltrum]  || [clickName isEqual:VH_Effect_BrowHeight] || [clickName isEqual:VH_Effect_BrowSpace] || [clickName isEqual:VH_Effect_IntensityLipThick] || [clickName isEqual:VH_Effect_BrowThick] || [clickName isEqual:VH_Effect_EyeHeight] || [clickName isEqual:VH_Effect_IntensityNoseV2]){
        self.sliderView.minimumTrackTintColor = [UIColor colorWithHex:@"#D8D8D8"];
        self.sliderView.maximumTrackTintColor = [UIColor colorWithHex:@"#D8D8D8"];
        self.midDotView.hidden = NO;
        self.adjustView.hidden = NO;
        // 额头,鼻子，嘴巴[0,1]，显示是[-100,100],0.5
        self.sliderView.minimumValue = model.minValue * 100 - 100;
        self.sliderView.maximumValue = model.maxValue * 100;
        self.sliderView.value = (model.currentValue - 0.5) * 200;

    } else {
        self.midDotView.hidden = YES;
        self.adjustView.hidden = YES;
        self.sliderView.minimumTrackTintColor = [UIColor colorWithHex:@"#FB3A32"];
        self.sliderView.maximumTrackTintColor = [UIColor colorWithHex:@"#D8D8D8"];
        self.sliderView.minimumValue = model.minValue * 100;
        self.sliderView.maximumValue = model.maxValue * 100;
        self.sliderView.value = model.currentValue * 100;
    }
    
    if (model.currentValue > 0 && self.sliderView.value >0) {
        self.sliderView.valueText = [NSString stringWithFormat:@"+%.0f",self.sliderView.value];
    } else {
        self.sliderView.valueText = [NSString stringWithFormat:@"%.0f",self.sliderView.value];
    }
    switch (self.beautyType) {
        case BeautyType_Beauty:{
            VHBeautyModel *model = self.beautyConfig[self.beautyEffectArray[self.beautyType][self.beauty_Index].name];
          
            [self.beautyModule setEffectKey:model.effectName toValue:@(model.currentValue)];
        }
            break;
        case BeautyType_Filter:{
            VHBeautyModel *model = self.beautyConfig[self.beautyEffectArray[self.beautyType][self.filter_Index].name];
            [self.beautyModule setEffectKey:VH_Filter_Name toValue:model.effectName];
            [self.beautyModule setEffectKey:VH_Filter_Level toValue:@(model.currentValue)];
        }
        default:
            break;
    }
}

- (void)adjustLeftRightSliderView{
    //可动态的宽的view
    self.adjustView = [[UIView alloc] init];
    self.adjustView.backgroundColor = [UIColor colorWithHex:@"#FB3A32"];
    [self.sliderView addSubview:self.adjustView];
    
    self.adjustView.hidden = YES;
    [self.adjustView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.height.mas_equalTo(kAdaptScale*2);
        make.width.mas_equalTo(0);
        make.centerY.offset(0.5*kAdaptScale);
    }];
    //固定小红点
    self.midDotView = [[UIView alloc] init];
    self.midDotView.layer.backgroundColor = [UIColor colorWithHex:@"#FB3A32"].CGColor;
    self.midDotView.hidden = YES;
    [self.midDotView radiusTool:kAdaptScale*3 borderWidth:kAdaptScale*3 borderColor:[UIColor colorWithHex:@"#FB3A32"]];
    [self.sliderView addSubview:self.midDotView];
    [self.midDotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kAdaptScale*6);
        make.center.offset(0.5*kAdaptScale);
    }];
    
}

- (void)updateLeftRightSliderView:(float)value{
    [self.sliderView bringSubviewToFront:self.midDotView];
    [self.sliderView bringSubviewToFront:self.adjustView];
    [self.adjustView mas_remakeConstraints:^(MASConstraintMaker *make) {
        //根据左滑动(right+width),右滑动(left+width)
        if (value < 0.0f) {
            make.width.mas_equalTo(self.sliderView.width *0.5 *fabsf(value/100) - 5*kAdaptScale);
            make.right.equalTo(self.midDotView.mas_left).offset(0);
        }else{
            make.width.mas_equalTo(self.sliderView.width * 0.5 *fabsf(value/100) - 5*kAdaptScale);
            make.left.equalTo(self.midDotView.mas_right).offset(0);
        }
        make.height.mas_equalTo(kAdaptScale * 2);
        make.centerY.offset(0.5*kAdaptScale);
    }];
}

#pragma mark ----根据选择的美颜进行UI布局的调整
- (void)hiddenSliderOperation:(BOOL)isHidden{
    self.sliderView.hidden = isHidden;
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(isHidden?(kVHBeautyTopHeight+(20*kAdaptScale)):(kVHBeautyTopHeight+kVHSliderHeight+kAdaptScale*28));//
        make.left.offset(kAdaptScale * 0);
        make.right.offset(-kAdaptScale *0);
        VH_KScreenIsLandscape?make.bottom.offset(0): make.height.mas_equalTo((self.beautyType == BeautyType_Beauty)?kAdaptScale * 46:kAdaptScale * 85);
    }];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self saveBeautyConfigModel];
}
// 写入缓存
- (void)saveBeautyConfigModel{
    [VHSaveBeautyTool writeCurrentBeautyEffectConfig:self.beautyConfig];
    //记录美颜和滤镜的值
    [VHSaveBeautyTool saveBeautyStatus:self.isEnable filterIndex:self.filter_Index];
}

- (void)dealloc {
    
    NSLog(@"%s", __FUNCTION__);
}
@end
