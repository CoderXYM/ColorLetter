//
//  FZY_AgreeVideoCallViewController.m
//  ColorLetter
//
//  Created by dllo on 16/10/31.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_AgreeVideoCallViewController.h"

@interface FZY_AgreeVideoCallViewController ()
<
EMCallManagerDelegate
>
@end

@implementation FZY_AgreeVideoCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    
    // 注册实时通话回调
    [[EMClient sharedClient].callManager addDelegate:self delegateQueue:nil];
    
    // 对方窗口
    self.remoteView = [[EMCallRemoteView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    [self.view addSubview:_remoteView];
    
    // 自己窗口
//     CGFloat w = 80;
//     CGFloat h = HEIGHT / WIDTH * w;
//    self.localView = [[EMCallLocalView alloc] initWithFrame:CGRectMake(WIDTH - 90, 50, w, h) withSessionPreset:AVCaptureSessionPreset640x480];
//    [self.view addSubview:_localView];
    
    [self createUI];
    
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
