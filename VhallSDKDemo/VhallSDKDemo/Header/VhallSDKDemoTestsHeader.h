//
//  VhallSDKDemoTestsHeader.h
//  VhallSDKDemo
//
//  Created by 郭超 on 2023/5/11.
//

#ifndef VhallSDKDemoTestsHeader_h
#define VhallSDKDemoTestsHeader_h

// 自动化测试通知
#define VHTestsNotificationCenter     @"VHTestsNotificationCenter"

// 应用消息的通知
#define VHTests_EnterRoom             @"VHTests_EnterRoom" // 进入房间
#define VHTests_Lottery_Start         @"VHTests_Lottery_Start" // 收到开始抽奖消息
#define VHTests_Lottery_End_Result    @"VHTests_Lottery_End_Result" // 结束抽奖,中奖了
#define VHTests_Lottery_End_Losing    @"VHTests_Lottery_End_Losing" // 结束抽奖,未中奖
#define VHTests_Lottery_FillInSubmit  @"VHTests_Lottery_FillInSubmit" // 填写领奖信息
#define VHTests_Lottery_Private       @"VHTests_Lottery_Private" // 私信领奖
#define VHTests_Lottery_CheckWinList  @"VHTests_Lottery_CheckWinList" // 查看中奖名单
#define VHTests_SignIn                @"VHTests_SignIn" // 开始签到消息
#define VHTests_NC_MicroInvitation    @"VHTests_Inav_MicroInvitation" // 收到主持人邀请上麦消息
#define VHTests_Inav_Participate      @"VHTests_Inav_Participate" // 参与互动
#define VHTests_END                   @"VHTests_END" // 结束自动化测试

// 控件标识

// Base
#define VHTest_Base_BackBtn           @"VHTest_Base_BackBtn" // 返回按钮

// 设置
#define VHTests_SignSet_Save          @"VHTests_SignSet_Save" // 设置界面保存按钮

// 登录
#define VHTests_Login_SignSetBtn      @"VHTests_Login_SignSetBtn" // 点击进入设置界面的按钮
#define VHTests_Login_ThirdId         @"VHTests_Login_ThirdId" // 填写三方id登录
#define VHTests_Login_ThirdName       @"VHTests_Login_ThirdName" // 填写昵称
#define VHTests_Login_LoginBtn        @"VHTests_Login_LoginBtn" // 点击登录按钮

// 首页
#define VHTests_Home_RoomId           @"VHTests_Home_RoomId" // 输入房间号码
#define VHTests_Home_EnterRoomBtn     @"VHTests_Home_EnterRoomBtn" // 点击进入房间

// 播放器
#define VHTests_Watch_StartBtn        @"VHTests_Watch_StartBtn" // 播放器的播放
#define VHTests_Watch_RateBtn         @"VHTests_Watch_RateBtn"   // 播放器的倍速
#define VHTests_Watch_DefinitionBtn   @"VHTests_Watch_DefinitionBtn"   // 播放器的分辨率
#define VHTests_Watch_FullBtn         @"VHTests_Watch_FullBtn"   // 播放器的全屏

// 聊天
#define VHTests_Chat_Btn              @"VHTests_Chat_Btn" // 点击唤起聊天输入框
#define VHTests_Chat_Import           @"VHTests_Chat_Import" // 聊天输入框输入内容
#define VHTests_Chat_SendMsg          @"VHTests_Chat_SendMsg" // 点击发送按钮

// 问答
#define VHTests_QA_Btn                @"VHTests_QA_Btn" //点击唤起问答输入框

// 礼物
#define VHTests_Gift_Btn              @"VHTests_Gift_Btn" // 点击唤起礼物弹窗
#define VHTests_Gift_CollectionId     @"VHTests_Gift_CollectionId" // 礼物列表的标识,获取指定列表
#define VHTests_Gift_SendGift         @"VHTests_Gift_SendGift" // 点击发送礼物

// 点赞
#define VHTests_Like_Click            @"VHTests_Like_Click" // 进行点赞

// 简介
#define VHTests_Intro_Click           @"VHTests_Intro_Click" // 点击简介标签

// 公告
#define VHTests_Announcement_Show     @"VHTests_Announcement_Show" // 显示公告跑马灯功能

// 更多工具
#define VHTests_Fold_ClickBtn         @"VHTests_Fold_ClickBtn" // 点击更多按钮
#define VHTests_Fold_Survey           @"VHTests_Fold_Survey" // 点击问卷按钮
#define VHTests_Fold_Announcement     @"VHTests_Fold_Announcement" // 点击公告按钮

// 文档
#define VHTests_Doc_ClickFull         @"VHTests_Doc_ClickFull" //点击文档全屏按钮

// 抽奖
#define VHTests_Lottery_SendCode      @"VHTests_Lottery_SendCode" // 点击发送抽奖口令
#define VHTests_Lottery_NowPrize      @"VHTests_Lottery_NowPrize" // 点击立即领奖
#define VHTests_Lottery_Check         @"VHTests_Lottery_Check" // 点击查看中奖名单
#define VHTests_Lottery_SubmitName    @"VHTests_Lottery_SubmitName" // 填写奖品邮寄人姓名
#define VHTests_Lottery_SubmitPhone   @"VHTests_Lottery_SubmitPhone" // 填写奖品邮寄手机号
#define VHTests_Lottery_SubmitAddress @"VHTests_Lottery_SubmitAddress" // 填写奖品邮寄地址
#define VHTests_Lottery_SubmitBtn     @"VHTests_Lottery_SubmitBtn" // 点击填写领奖信息
#define VHTests_Lottery_PrivateClose  @"VHTests_Lottery_PrivateClose" // 私信领奖的关闭按钮
#define VHTests_Lottery_LosingCheck   @"VHTests_Lottery_LosingCheck" // 未中奖查看中奖名单
#define VHTests_Lottery_WinListClose  @"VHTests_Lottery_WinListClose" // 中奖名单关闭按钮

// 签到
#define VHTests_SignIn_Btn            @"VHTests_SignIn_Btn" // 点击签到按钮

// 互动
#define VHTest_Inav_Btn               @"VHTest_Inav_Btn" // 互动连麦按钮
#define VHTests_Inav_AgreeInav        @"VHTests_Inav_AgreeInav" // 点击同意互动按钮
#define VHTests_Inav_CameraBtn        @"VHTests_Inav_CameraBtn" // 点击摄像头
#define VHTests_Inav_MicBtn           @"VHTests_Inav_MicBtn" // 点击麦克风
#define VHTests_Inav_OverturnBtn      @"VHTests_Inav_OverturnBtn"   // 点击翻转
#define VHTests_Inav_UnApplyBtn       @"VHTests_Inav_UnApplyBtn"  // 点击下麦

// 章节
#define VHTests_Back_RecordChapter    @"VHTests_WatchBack_RecordChapter"  // 章节列表

// 精彩时刻
#define VHTests_Back_VideoPoint       @"VHTests_WatchBack_VideoPoint"  // 精彩时刻列表

#endif /* VhallSDKDemoTestsHeader_h */
