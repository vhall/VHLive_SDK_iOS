//
//  VHExamViewController.m
//  UIModel
//
//  Created by 郭超 on 2022/11/22.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHExamViewController.h"
#import "VHNAVTopView.h"

#import "MJExtension.h"

#import <VHLiveSDK/VHallApi.h>
#import <WebKit/WebKit.h>

@implementation VHExamCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];

        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
        
    }return self;
}
#pragma mark - 懒加载
- (UILabel *)nameLab
{
    if (!_nameLab){
        _nameLab = [[UILabel alloc] init];
        _nameLab.textColor = [UIColor blackColor];
        _nameLab.backgroundColor = [UIColor whiteColor];
        _nameLab.font = FONT_Medium(16);
        _nameLab.layer.masksToBounds = YES;
        _nameLab.layer.cornerRadius = 35/2;
        _nameLab.layer.borderColor = [UIColor redColor].CGColor;
        _nameLab.layer.borderWidth = .5;
        _nameLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_nameLab];
    }
    return _nameLab;
}
@end

@interface VHExamViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) VHNAVTopView      * topView;          ///<topView

@property (nonatomic, strong) UITextField       * paperIDTF;        ///<填写试卷id

@property (nonatomic, strong) UITextField       * phoneTF;          ///<手机号码

@property (nonatomic, strong) UITextField       * verifyCodeTF;     ///<验证码

@property (nonatomic, strong) UITextField       * switchIDTF;       ///<场次id

@property (nonatomic, strong) UITextField       * questionIDTF;     ///<题目id

@property (nonatomic, strong) UITextField       * userAnswerTF;     ///<用户答案

@property (nonatomic, strong) UICollectionView  * collectionView;   ///<cv

@property (nonatomic, strong) NSMutableArray    * dataSource;       ///<数据源

@property (nonatomic, strong) VHWebinarInfoData * webinarInfo;      ///<活动基础信息

@property (nonatomic, copy) NSString * user_detail;///<

/// 快问快答类
@property (nonatomic, strong) VHExamObject * examObject;

@end

@implementation VHExamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];

    // 获取房间详情
    [self requestWebinarInfo];

    // ui布局
    [self masonryToUI];
    
    // 添加按钮
    [self addDataSource:[NSMutableArray arrayWithObjects:@"前置条件检查",@"初始化表单",@"发送验证码",@"验证手机验证码",@"保存表单信息",@"试卷列表",@"试卷详情",@"单题提交",@"主动交卷",@"断点续答",@"榜单信息",@"个人成绩", nil]];
}

#pragma mark - 获取房间详情
- (void)requestWebinarInfo
{
    __weak __typeof(self)weakSelf = self;
    // 房间详情接口
    [VHWebinarInfoData requestWatchInitWebinarId:self.webinar_id recordId:nil email:nil nick_name:nil pass:nil k_id:nil complete:^(VHWebinarInfoData * _Nonnull webinarInfoData, NSError * _Nonnull error) {
        
        if (webinarInfoData) {
            weakSelf.webinarInfo = webinarInfoData;
                        
        }
        
        if (error) {
            // 请求失败
        }
        
    }];
}

#pragma mark - UI
- (void)masonryToUI
{
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.mas_equalTo(20);
        }
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];

    [self.paperIDTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    
    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.paperIDTF.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    
    [self.verifyCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.phoneTF.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    
    [self.switchIDTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.verifyCodeTF.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];

    [self.questionIDTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.switchIDTF.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];

    [self.userAnswerTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.questionIDTF.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userAnswerTF.mas_bottom);
        make.left.bottom.right.mas_equalTo(0);
    }];
}

#pragma mark - 添加数据
- (void)addDataSource:(NSMutableArray *)addDataSource
{
    [self.dataSource addObjectsFromArray:addDataSource];
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VHExamCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VHExamCollectionViewCell" forIndexPath:indexPath];
    cell.nameLab.text = self.dataSource[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * name = self.dataSource[indexPath.row];
    
    if ([name isEqualToString:@"前置条件检查"]) {
        [self examUserFormCheck];
    }
    if ([name isEqualToString:@"初始化表单"]) {
        [self examGetUserFormInfo];
    }
    if ([name isEqualToString:@"发送验证码"]) {
        [self examSendVerifyCode];
    }
    if ([name isEqualToString:@"验证手机验证码"]) {
        [self examVerifyCode];
    }
    if ([name isEqualToString:@"保存表单信息"]) {
        [self examSaveUserForm];
    }
    if ([name isEqualToString:@"试卷列表"]) {
        [self examGetPushedPaperList];
    }
    if ([name isEqualToString:@"试卷详情"]) {
        [self examGetPaperInfoForWatch];
    }
    if ([name isEqualToString:@"单题提交"]) {
        [self examAnswerQuestion];
    }
    if ([name isEqualToString:@"主动交卷"]) {
        [self examInitiativeSubmitPaper];
    }
    if ([name isEqualToString:@"断点续答"]) {
        [self examGetUserAnswerPaperHistory];
    }
    if ([name isEqualToString:@"榜单信息"]) {
        [self examGetSimpleRankList];
    }
    if ([name isEqualToString:@"个人成绩"]) {
        [self examPersonScoreInfo];
    }
}

#pragma mark - 前置条件检查
- (void)examUserFormCheck
{
    [self.examObject examUserFormCheckWithWebinar_id:self.webinar_id user_name:@"" head_img:@"" mobile:@"" complete:^(VHExamUserFormCheckModel *examUserFormCheckModel, NSError *error) {
        
        if (examUserFormCheckModel) {
            VH_ShowToast([examUserFormCheckModel.responseObject mj_JSONString]);
        }
        
        if (error) {
            VH_ShowToast(error.localizedDescription);
        }

    }];
}

#pragma mark - 初始化用户表单
- (void)examGetUserFormInfo
{
    [self.examObject examGetUserFormInfoWithWebinar_id:self.webinar_id paper_id:self.paperIDTF.text complete:^(VHExamGetUserFormInfoModel *examGetUserFormInfoModel, NSError *error) {
        
        if (examGetUserFormInfoModel) {
            VH_ShowToast([examGetUserFormInfoModel.responseObject mj_JSONString]);
            self.user_detail = examGetUserFormInfoModel.form_data;
        }
        
        if (error) {
            VH_ShowToast(error.localizedDescription);
        }
        
    }];
}

#pragma mark - 发送验证码
- (void)examSendVerifyCode
{
    [self.examObject examSendVerifyCodeWithWebinar_id:self.webinar_id paper_id:self.paperIDTF.text phone:self.phoneTF.text country_code:@"" complete:^(VHExamSendVerifyCodeModel *examSendVerifyCodeModel, NSError *error) {
        
        if (examSendVerifyCodeModel) {
            VH_ShowToast([examSendVerifyCodeModel.responseObject mj_JSONString]);
        }
        
        if (error) {
            VH_ShowToast(error.localizedDescription);
        }

    }];
}

#pragma mark - 验证手机验证码
- (void)examVerifyCode
{
    [self.examObject examVerifyCodeWithWebinar_id:self.webinar_id paper_id:self.paperIDTF.text phone:self.phoneTF.text verify_code:self.verifyCodeTF.text country_code:@"" complete:^(VHExamVerifyCodeModel * examVerifyCodeModel, NSError *error) {
        
        if (examVerifyCodeModel) {
            VH_ShowToast([examVerifyCodeModel.responseObject mj_JSONString]);
        }
        
        if (error) {
            VH_ShowToast(error.localizedDescription);
        }

    }];
}

#pragma mark - 保存表单信息
- (void)examSaveUserForm
{
    [self.examObject examSaveUserFormWithWebinar_id:self.webinar_id user_detail:self.user_detail verify_code:self.verifyCodeTF.text complete:^(NSDictionary * responseObject, NSError *  error) {
        
        if (responseObject) {
            VH_ShowToast([responseObject mj_JSONString]);
        }

        if (error) {
            VH_ShowToast(error.localizedDescription);
        }

    }];
}

#pragma mark - 试卷列表
- (void)examGetPushedPaperList
{
    [self.examObject examGetPushedPaperListWithWebinar_id:self.webinar_id switch_id:@"1" complete:^(NSArray<VHExamGetPushedPaperListModel *> *examGetPushedPaperList, NSError *error) {
        
        if (examGetPushedPaperList.count > 0) {
            VHExamGetPushedPaperListModel * examGetPushedPaperListModel = [examGetPushedPaperList firstObject];
            NSString * content = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %d %d %d %ld %ld ",examGetPushedPaperListModel.paper_id,examGetPushedPaperListModel.title,examGetPushedPaperListModel.push_time,examGetPushedPaperListModel.right_rate,examGetPushedPaperListModel.question_num,examGetPushedPaperListModel.limit_time_switch,examGetPushedPaperListModel.status,examGetPushedPaperListModel.is_end,examGetPushedPaperListModel.limit_time,examGetPushedPaperListModel.total_score];
            VH_ShowToast(content);
        }

        if (error) {
            VH_ShowToast(error.localizedDescription);
        }

    }];
}

#pragma mark - 试卷详情
- (void)examGetPaperInfoForWatch
{
    [self.examObject examGetPaperInfoForWatchWithWebinar_id:self.webinar_id paper_id:self.paperIDTF.text complete:^(VHExamGetPaperInfoForWatchModel *examGetPaperInfoForWatchModel, NSError *error) {
        
        if (examGetPaperInfoForWatchModel) {
            VH_ShowToast([examGetPaperInfoForWatchModel.responseObject mj_JSONString]);
        }
        
        if (error) {
            VH_ShowToast(error.localizedDescription);
        }

    }];
}

#pragma mark - 单题提交
- (void)examAnswerQuestion
{
    [self.examObject examAnswerQuestionWithWebinar_id:self.webinar_id paper_id:self.paperIDTF.text question_id:self.questionIDTF.text user_answer:self.userAnswerTF.text complete:^(NSDictionary * responseObject, NSError *  error) {
        
        if (responseObject) {
            VH_ShowToast([responseObject mj_JSONString]);
        }

        if (error) {
            VH_ShowToast(error.localizedDescription);
        }

    }];
}

#pragma mark - 主动交卷
- (void)examInitiativeSubmitPaper
{
    [self.examObject examInitiativeSubmitPaperWithWebinar_id:self.webinar_id paper_id:self.paperIDTF.text complete:^(NSDictionary *responseObject, NSError *error) {
        
        if (responseObject) {
            VH_ShowToast([responseObject mj_JSONString]);
        }

        if (error) {
            VH_ShowToast(error.localizedDescription);
        }

    }];
}

#pragma mark - 获取已答题记录断点续答
- (void)examGetUserAnswerPaperHistory
{
    [self.examObject examGetUserAnswerPaperHistoryWithWebinar_id:self.webinar_id paper_id:self.paperIDTF.text complete:^(NSArray<VHExamGetUserAnswerPaperHistoryModel *> *examGetUserAnswerPaperHistoryList, NSError *error) {
        
        if (examGetUserAnswerPaperHistoryList.count > 0) {
            VHExamGetUserAnswerPaperHistoryModel * examGetUserAnswerPaperHistoryModel = [examGetUserAnswerPaperHistoryList firstObject];
            NSString * content = [NSString stringWithFormat:@"%@ %@ ",examGetUserAnswerPaperHistoryModel.question_id,examGetUserAnswerPaperHistoryModel.answer];
            VH_ShowToast(content);
        }

        if (error) {
            VH_ShowToast(error.localizedDescription);
        }

    }];
}

#pragma mark - 获取榜单信息
- (void)examGetSimpleRankList
{
    [self.examObject examGetSimpleRankListWithWebinar_id:self.webinar_id paper_id:self.paperIDTF.text pageNum:1 pageSize:20 complete:^(NSArray<VHExamGetSimpleRankListModel *> *examGetSimpleRankList, NSError *error) {
        
        if (examGetSimpleRankList.count > 0) {
            VHExamGetSimpleRankListModel * examGetSimpleRankListModel = [examGetSimpleRankList firstObject];
            NSString * content = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ %d %d %ld ",examGetSimpleRankListModel.name,examGetSimpleRankListModel.head_img,examGetSimpleRankListModel.score,examGetSimpleRankListModel.rank_no,examGetSimpleRankListModel.right_rate,examGetSimpleRankListModel.account_id,examGetSimpleRankListModel.status,examGetSimpleRankListModel.is_initiative,examGetSimpleRankListModel.use_time];
            VH_ShowToast(content);
        }

        if (error) {
            VH_ShowToast(error.localizedDescription);
        }

    }];
}

#pragma mark - 获取个人成绩
- (void)examPersonScoreInfo
{
    [self.examObject examPersonScoreInfoWithWebinar_id:self.webinar_id paper_id:self.paperIDTF.text complete:^(VHExamPersonScoreInfoModel *examPersonScoreInfoModel, NSError *error) {
        
        if (examPersonScoreInfoModel) {
            VH_ShowToast([examPersonScoreInfoModel.responseObject mj_JSONString]);
        }
        
        if (error) {
            VH_ShowToast(error.localizedDescription);
        }

    }];
}

#pragma mark - 懒加载
- (VHNAVTopView *)topView
{
    if (!_topView) {
        _topView = [[VHNAVTopView alloc] init];
        _topView.backgroundColor = [UIColor colorWithHex:@"#EDEDED"];
        __weak __typeof(self)weakSelf = self;
        _topView.clickBackBlock = ^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };
        [self.view addSubview:_topView];
    }
    return _topView;
}

- (UITextField *)paperIDTF
{
    if (!_paperIDTF) {
        _paperIDTF = [UITextField new];
        _paperIDTF.text = @"63";
        _paperIDTF.placeholder = @"请填写试卷id";
        _paperIDTF.font = FONT_Medium(16);
        _paperIDTF.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_paperIDTF];
    }return _paperIDTF;
}

- (UITextField *)phoneTF
{
    if (!_phoneTF) {
        _phoneTF = [UITextField new];
        _phoneTF.text = @"13261699658";
        _phoneTF.placeholder = @"请输入手机号码";
        _phoneTF.font = FONT_Medium(16);
        _phoneTF.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_phoneTF];
    }return _phoneTF;
}

- (UITextField *)verifyCodeTF
{
    if (!_verifyCodeTF) {
        _verifyCodeTF = [UITextField new];
        _verifyCodeTF.text = @"";
        _verifyCodeTF.placeholder = @"请输入短信验证码";
        _verifyCodeTF.font = FONT_Medium(16);
        _verifyCodeTF.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_verifyCodeTF];
    }return _verifyCodeTF;
}

- (UITextField *)switchIDTF
{
    if (!_switchIDTF) {
        _switchIDTF = [UITextField new];
        _switchIDTF.text = @"1";
        _switchIDTF.placeholder = @"请输入场次id";
        _switchIDTF.font = FONT_Medium(16);
        _switchIDTF.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_switchIDTF];
    }return _switchIDTF;
}

- (UITextField *)questionIDTF
{
    if (!_questionIDTF) {
        _questionIDTF = [UITextField new];
        _questionIDTF.text = @"554470";
        _questionIDTF.placeholder = @"请输入题目id";
        _questionIDTF.font = FONT_Medium(16);
        _questionIDTF.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_questionIDTF];
    }return _questionIDTF;
}

- (UITextField *)userAnswerTF
{
    if (!_userAnswerTF) {
        _userAnswerTF = [UITextField new];
        _userAnswerTF.text = @"@{value:key}";
        _userAnswerTF.placeholder = @"请输入用户答案";
        _userAnswerTF.font = FONT_Medium(16);
        _userAnswerTF.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_userAnswerTF];
    }return _userAnswerTF;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.itemSize = CGSizeMake(self.view.width / 2, 35);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[VHExamCollectionViewCell class] forCellWithReuseIdentifier:@"VHExamCollectionViewCell"];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }return _dataSource;
}
- (VHExamObject *)examObject
{
    if (!_examObject) {
        _examObject = [VHExamObject new];
    }return _examObject;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
