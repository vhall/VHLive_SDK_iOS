//
//  VHCommonViewController.m
//  UIModel
//
//  Created by 郭超 on 2022/11/2.
//  Copyright © 2022 www.vhall.com. All rights reserved.
//

#import "VHCommonViewController.h"
#import <VHLiveSDK/VHallApi.h>

@interface VHCommonViewController ()

@property (nonatomic, strong) UIView            *   topView;
@property (nonatomic, strong) UIButton          *   backBtn;            ///<返回按钮
@property (nonatomic, strong) UILabel           *   titleLab;           ///<标题

@property (nonatomic, strong) UIButton * sendCodeBtn;               ///<发送短信按钮

@property (nonatomic, strong) UIButton * noticeWechatSubmitBtn;     ///<微信授权按钮


@end

@implementation VHCommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self masonryToUI];

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
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.left.mas_equalTo(22);
        make.centerY.mas_equalTo(self.topView.mas_centerY);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
    }];
    
    [self.sendCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_bottom).offset(15);
        make.left.mas_equalTo(15);
    }];
    
    [self.noticeWechatSubmitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.sendCodeBtn.mas_bottom).offset(15);
        make.left.mas_equalTo(15);
    }];
}

#pragma mark - 点击发送短信
- (void)sendCodeBtnAction
{
    [VHCommonObject sendCode:@"15652117934" type:1 sendId:8 complete:^(NSString *msg, NSError *error) {
        if (msg) {
            VH_ShowToast(msg);
        }
        
        if (error) {
            VH_ShowToast(@"失败");
        }
    }];
}

#pragma mark - 点击微信授权
- (void)noticeWechatSubmitBtnAction
{
    [VHCommonObject noticeWechatSubmit:self.webinar_id phone:@"15652117934" visitor_id:@"123546321" code:@"" complete:^(NSDictionary *data, NSError *error) {
        
        if (data) {
            VH_ShowToast(@"成功");
        }
        
        if (error) {
            VH_ShowToast(@"失败");
        }

    }];
}

#pragma mark - 退出房间
- (void)backBtnClick {[self dismissViewControllerAnimated:YES completion:nil];}

#pragma mark - 懒加载

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor colorWithHex:@"#EDEDED"];
        [self.view addSubview:_topView];
    }
    return _topView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        [_backBtn setImage:BundleUIImage(@"关闭") forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:_backBtn];
    }
    return _backBtn;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = [UIColor colorWithHex:@"#222222"];
        _titleLab.font = FONT_Medium(16);
        _titleLab.text = @"其它功能示例";
        [self.topView addSubview:_titleLab];
    }
    return _titleLab;
}

- (UIButton *)sendCodeBtn {
    if (!_sendCodeBtn) {
        _sendCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendCodeBtn.titleLabel.font = FONT_FZZZ(12);
        _sendCodeBtn.backgroundColor = [UIColor blackColor];
        _sendCodeBtn.layer.masksToBounds = YES;
        _sendCodeBtn.layer.cornerRadius = 5;
        [_sendCodeBtn setTitle:@"发送短信" forState:UIControlStateNormal];
        [_sendCodeBtn addTarget:self action:@selector(sendCodeBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_sendCodeBtn];
    }
    return _sendCodeBtn;
}

- (UIButton *)noticeWechatSubmitBtn {
    if (!_noticeWechatSubmitBtn) {
        _noticeWechatSubmitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _noticeWechatSubmitBtn.titleLabel.font = FONT_FZZZ(12);
        _noticeWechatSubmitBtn.backgroundColor = [UIColor blackColor];
        _noticeWechatSubmitBtn.layer.masksToBounds = YES;
        _noticeWechatSubmitBtn.layer.cornerRadius = 5;
        [_noticeWechatSubmitBtn setTitle:@"微信授权" forState:UIControlStateNormal];
        [_noticeWechatSubmitBtn addTarget:self action:@selector(noticeWechatSubmitBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_noticeWechatSubmitBtn];
    }
    return _noticeWechatSubmitBtn;
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
