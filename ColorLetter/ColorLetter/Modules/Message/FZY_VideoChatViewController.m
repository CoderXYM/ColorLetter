//
//  FZY_VideoChatViewController.m
//  ColorLetter
//
//  Created by dllo on 16/10/30.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_VideoChatViewController.h"


@interface FZY_VideoChatViewController ()
<
EMCallManagerDelegate
>
// 会话标识
@property (nonatomic, strong) NSString *sessionId;
// 通话本地的 userName
@property (nonatomic, strong) NSString *userName;
// 对方的 userName
@property (nonatomic, strong) NSString *remoteUserName;
// 通话的类型
@property (nonatomic, assign) EMCallType type;
// 连接类型
@property (nonatomic, assign) EMCallConnectType connectType;
// 通话状态
@property (nonatomic, assign) EMCallSessionStatus status;
// 视屏通话时,自己的图像显示区域
@property (nonatomic, strong) EMCallLocalView *localView;
// 视屏通话时,对方的图像显示区域
@property (nonatomic, strong) EMCallRemoteView *remoteView;
// 设置视频码率, 必须在通话开始前设置, 码率范围为 150-1000, 默认为600
@property (nonatomic, assign) int videoBitrate;

@end

@implementation FZY_VideoChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    
    // 注册实时通话回调
    [[EMClient sharedClient].callManager addDelegate:self delegateQueue:nil];
    
    [self createVideoChatView];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 移除实时通话回调
    [[EMClient sharedClient].callManager removeDelegate:self];

}

- (void)createUI {
    UIButton *hangUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    hangUpButton.backgroundColor = [UIColor redColor];
    [hangUpButton setTitle:@"挂断" forState:UIControlStateNormal];
    [_remoteView addSubview:hangUpButton];
    [hangUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset(0);
        make.width.equalTo(@200);
        make.height.equalTo(@50);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
    }];

    [hangUpButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        NSLog(@"挂断");
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

// 创建视屏通话页面
- (void)createVideoChatView {
    // 发起视屏会话
    [[EMClient sharedClient].callManager startVideoCall:_friendName completion:^(EMCallSession *aCallSession, EMError *aError) {
        if (!aError) {
            NSLog(@"创建视屏通话成功");
            // 对方窗口
            aCallSession.remoteVideoView = [[EMCallRemoteView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
            self.remoteView = aCallSession.remoteVideoView;
            [self.view addSubview:_remoteView];
            
            // 自己窗口
            CGFloat w = 80;
            CGFloat h = HEIGHT / WIDTH * w;
           // aCallSession.localVideoView = [[EMCallLocalView alloc] initWithFrame:CGRectMake(WIDTH - 90, 50, w, h) withSessionPreset:AVCaptureSessionPreset640x480];
            
            self.localView = aCallSession.localVideoView;
            [self.view addSubview:aCallSession.localVideoView];
            
            [self createUI];
        } else {
            NSLog(@"创建视屏通话失败");
        }
    }];
}

#pragma mark - 视屏通话相关回调

#pragma mark - 用户B 同意 用户A 拨打的通话后, 对方会受到该回调
- (void)didReceiveCallAccepted:(EMCallSession *)aSession {
    NSLog(@"用户B 同意视屏通话");
}
#pragma mark - 通话通道建立完成, 用户A 和 用户B 都会都到这个回调
- (void)didReceiveCallConnected:(EMCallSession *)aSession {
    NSLog(@"通道建立完成");
}
#pragma mark - 通话结束回调
/*!
 *  1. 用户A或用户B结束通话后，对方会收到该回调
 *  2. 通话出现错误，双方都会收到该回调
 *
 *  @param aSession  会话实例
 *  @param aReason   结束原因
 *  @param aError    错误
 */
- (void)didReceiveCallTerminated:(EMCallSession *)aSession
                          reason:(EMCallEndReason)aReason
                           error:(EMError *)aError {
    NSLog(@"通话结束原因: %u", aReason);
}
#pragma mark - 弱网检测
/*!
 *  用户A和用户B正在通话中，用户A的网络状态出现不稳定，用户A会收到该回调
 *
 *  @param aSession  会话实例
 *  @param aStatus   当前状态
 */
- (void)didReceiveCallNetworkChanged:(EMCallSession *)aSession
                              status:(EMCallNetworkStatus)aStatus {
    NSLog(@"弱网检测");
}

#pragma mark - 实时通话数据暂停恢复接口
/*!
 *  暂停语音数据传输
 *
 *  @param aSessionId   通话的ID
 */
- (void)pauseVoiceTransfer:(NSString *)aSessionId {
    NSLog(@"暂停语音数据传输");
}

/*!
 *  恢复语音数据传输
 *
 *  @param aSessionId   通话的ID
 */
- (void)resumeVoiceTransfer:(NSString *)aSessionId {
    NSLog(@"恢复语音数据传输");
}

/*!
 *  暂停视频图像数据传输
 *
 *  @param aSessionId   通话的ID
 */
- (void)pauseVideoTransfer:(NSString *)aSessionId {
    NSLog(@"暂停视频图像数据传输");
}

/*!
 *  恢复视频图像数据传输
 *
 *  @param aSessionId   通话的ID
 */
- (void)resumeVideoTransfer:(NSString *)aSessionId {
    NSLog(@"恢复视频图像数据传输");
}

/*!
 *  暂停通话语音和视频图像数据传输
 *
 *  @param aSessionId   通话的ID
 */
- (void)pauseVoiceAndVideoTransfer:(NSString *)aSessionId {
    NSLog(@"暂停通话语音和视频图像数据传输");
}

/*!
 *  恢复通话语音和视频图像数据传输
 *
 *  @param aSessionId   通话的ID
 */
- (void)resumeVoiceAndVideoTransfer:(NSString *)aSessionId {
    NSLog(@"恢复通话语音和视频图像数据传输");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
