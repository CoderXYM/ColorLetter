//
//  FZY_VideoChatViewController.m
//  ColorLetter
//
//  Created by dllo on 16/10/30.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_VideoChatViewController.h"
#import <EMSDKFull.h>

@interface FZY_VideoChatViewController ()

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
    
    [self createVideoChatView];
    
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

    [[EMClient sharedClient].callManager startVideoCall:@"666" completion:^(EMCallSession *aCallSession, EMError *aError) {
        if (!aError) {
            NSLog(@"创建视屏通话成功");
            // 对方窗口
            aCallSession.remoteVideoView = [[EMCallRemoteView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
            self.remoteView = aCallSession.remoteVideoView;
            [self.view addSubview:_remoteView];
            
            // 自己窗口
//            CGFloat w = 80;
//            CGFloat h = HEIGHT / WIDTH * w;
//            aCallSession.localVideoView = [[EMCallLocalView alloc] initWithFrame:CGRectMake(WIDTH - 90, 50, w, h)];
//            [self.view addSubview:aCallSession.localVideoView];
            
            [self createUI];
        } else {
            NSLog(@"创建视屏通话失败");
        }
    }];
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
