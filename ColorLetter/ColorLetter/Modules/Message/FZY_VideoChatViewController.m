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
EMCallManagerDelegate,
AVCaptureMetadataOutputObjectsDelegate
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

// 设备
@property (nonatomic, strong) AVCaptureDevice *device;
// 输入流
@property (nonatomic, strong) AVCaptureDeviceInput *input;
// 输出流
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
// 输出中间桥梁
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;

@end

@implementation FZY_VideoChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 注册实时通话回调
    [[EMClient sharedClient].callManager addDelegate:self delegateQueue:nil];
    
    [self createVideoChatView];
    
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 移除实时通话回调
   // [[EMClient sharedClient].callManager removeDelegate:self];

}

// 创建视屏通话页面
- (void)createVideoChatView {
    // 发起视屏会话
    [[EMClient sharedClient].callManager startVideoCall:_friendName completion:^(EMCallSession *aCallSession, EMError *aError) {
        if (!aError) {
            NSLog(@"创建视屏通话成功, sessionID: %@", aCallSession.sessionId);
            self.sessionId = aCallSession.sessionId;
            // 对方窗口
            aCallSession.remoteVideoView = [[EMCallRemoteView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
            self.remoteView = aCallSession.remoteVideoView;
            [self.view addSubview:_remoteView];
            
            //2.自己窗口
//            CGFloat width = 80;
//            CGFloat height = self.view.frame.size.height / self.view.frame.size.width * width;
//            aCallSession.localVideoView = [[EMCallLocalView alloc] initWithFrame:CGRectMake(WIDTH - 100, 64, 100, 100) withSessionPreset:AVCaptureSessionPresetLow];
//            [self.view addSubview:aCallSession.localVideoView];
            
            // 自己窗口
//            [self setupCamera:(EMCallSession *)aCallSession];
            
            [self createUI];
        } else {
            NSLog(@"创建视屏通话失败");
        }
    }];
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
        
        [[EMClient sharedClient].callManager endCall:_sessionId reason:EMCallEndReasonHangup];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark - 视屏通话相关回调
#pragma mark - 用户B 同意 用户A 拨打的通话后, 对方会受到该回调
- (void)didReceiveCallAccepted:(EMCallSession *)aSession {
    NSLog(@"对方同意视屏通话");
}



- (void)callDidEnd:(EMCallSession *)aSession reason:(EMCallEndReason)aReason error:(EMError *)aError {
    [[EMClient sharedClient].callManager endCall:_sessionId reason:EMCallEndReasonHangup];
    [self dismissViewControllerAnimated:YES completion:nil];
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

// 设置摄像头
// 设置相机
- (void)setupCamera:(EMCallSession *)aCallSession {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 获取摄像设备
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        _device = [self cameraWithPosition:AVCaptureDevicePositionFront];
        
        // 创建输入流
        _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
        
        // 创建输出流
        _output = [[AVCaptureMetadataOutput alloc] init];
        // 设置代理 在主线程中刷新
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        // 初始化链接对象
//        _session = [[AVCaptureSession alloc] init];
        
        // 高质量采集率
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        
        if ([_session canAddInput:self.input])
        {
            [_session addInput:self.input];
        }
        
        if ([_session canAddOutput:self.output])
        {
            [_session addOutput:self.output];
        }
        
        // 条码类型 AVMetadataObjectTypeQRCode
        _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            aCallSession.localVideoView = [[EMCallLocalView alloc] initWithFrame:CGRectMake(WIDTH - 50, 64, 100, 100) withSessionPreset:AVCaptureSessionPresetLow];
            [self.view addSubview:aCallSession.localVideoView];

            
            _preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
            _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
            _preview.frame = CGRectMake(WIDTH - 120, 50, 100, 100);
            
            [self.view.layer insertSublayer:self.preview atIndex:0];
//             Start
            [_session startRunning];
        });
    });
}

// 前后置位置拿到相应的摄像头
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position ){
            return device;
        }
    return nil;
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
