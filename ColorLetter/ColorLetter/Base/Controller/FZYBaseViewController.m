//
//  FZYBaseViewController.m
//  ColorLetter
//
//  Created by dllo on 16/10/19.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZYBaseViewController.h"
#import "DrawerViewController.h"
#import "FZY_FriendRequestViewController.h"
#import "FZY_AgreeVideoCallViewController.h"

@interface FZYBaseViewController ()
<
EMCallManagerDelegate
>
@end

@implementation FZYBaseViewController

- (void)viewWillAppear:(BOOL)animated {
//    self.navigationController.navigationBar.subviews.firstObject.alpha = 0;
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
   
//     背景图片
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Default-736"]];
    self.view.userInteractionEnabled = YES;
    
    // 注册实时通话回调
    [[EMClient sharedClient].callManager addDelegate:self delegateQueue:nil];

}

#pragma mark - 用户A 拨打 用户B, 用户B 会收到这个回调
- (void)didReceiveCallIncoming:(EMCallSession *)aSession{
    NSLog(@"有人呼叫你");
    
    // 同意视屏通话
    EMError *error = nil;
    error = [[EMClient sharedClient].callManager answerIncomingCall:aSession.sessionId];
    if (!error) {
        NSLog(@"同意视屏通话成功");
    } else {
        NSLog(@"同意视屏通话失败, 错误信息: %@", error);
    }
    
    FZY_AgreeVideoCallViewController *videoVC = [[FZY_AgreeVideoCallViewController alloc] init];
    videoVC.remoteView = aSession.remoteVideoView;
    videoVC.localView = aSession.localVideoView;
    [self presentViewController:videoVC animated:YES
                     completion:nil];
}

- (void)create {
    self.titleLabel = [[UILabel alloc] init];
    [_titleLabel sizeToFit];
    _titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(25);
        make.height.equalTo(@25);
    }];
    
    self.drawerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_drawerButton setImage:[UIImage imageNamed:@"btn-profile"] forState:UIControlStateNormal];
    [_drawerButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WhenPushPage" object:nil];
        DrawerViewController *drawerVC = [[DrawerViewController alloc] init];
         drawerVC.myImage = [UIImage captureImageFromView: self.view];
        CATransition * animation = [CATransition animation];
        animation.duration = 0.5;
        animation.type = kCATransitionPush;
        drawerVC.viewController = self;
         [self.view.window.layer addAnimation:animation forKey:nil];      
        [self presentViewController:drawerVC animated:YES completion:nil];
        
    }];
    [self.view addSubview:_drawerButton];
    [_drawerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(self.view.mas_top).offset(25);
        make.height.equalTo(@30);
        make.width.equalTo(@30);
    }];
    
    self.searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_searchButton setImage:[UIImage imageNamed:@"btn-search"] forState:UIControlStateNormal];
    [_searchButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        FZY_FriendRequestViewController *friend = [[FZY_FriendRequestViewController alloc] init];
        [self presentViewController:friend animated:YES completion:nil];
    }];
    [self.view addSubview:_searchButton];
    [_searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(self.view.mas_top).offset(25);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
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
