//
//  FZY_LoginAndRegisterViewController.m
//  ColorLetter
//
//  Created by dllo on 16/10/20.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_LoginAndRegisterViewController.h"
#import "FZY_LoginOrRegisterViewController.h"

@interface FZY_LoginAndRegisterViewController ()

@end

@implementation FZY_LoginAndRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatHomepage];
    
}

- (void)creatHomepage {    
    // app 代表图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT * 0.5)];
    imageView.image = [UIImage imageNamed:@"0.jpeg"];
    [self.view addSubview:imageView];
    
    // app 名字 label
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    headLabel.text = @"彩笺";
    headLabel.textColor = [UIColor redColor];
    headLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:headLabel];
   
    // app 介绍图片
    UILabel *bottomLabel = [[UILabel alloc] init];
    bottomLabel.text = @"欲寄彩笺兼尺素, 山长水阔知何处";
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:bottomLabel];
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
       make.height.equalTo(@(HEIGHT * 0.5 * 0.2));
    }];
    
    // 注册button
    UIButton *registerButton = [[UIButton alloc]init];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [registerButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        FZY_LoginOrRegisterViewController *registerVC = [[FZY_LoginOrRegisterViewController alloc] init];
        registerVC.position = WIDTH / 4;
        registerVC.scrollPosition = 0;
        registerVC.VC = self;
        [self presentViewController:registerVC animated:YES completion:nil];
    }];
    
    [self.view addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomLabel.mas_bottom).offset(60);
        make.right.equalTo(self.view.mas_centerX).offset(-40);
        make.width.equalTo(@80);
        make.height.equalTo(@50);
    }];
    
    // 登录button
    UIButton *loginButton = [[UIButton alloc]init];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal]; 
    
    [loginButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        FZY_LoginOrRegisterViewController *LoginVC = [[FZY_LoginOrRegisterViewController alloc] init];
        LoginVC.VC = self;
        LoginVC.position = WIDTH / 4 * 3;
        LoginVC.scrollPosition = WIDTH;

        [self presentViewController:LoginVC animated:YES completion:nil];
    }];
    
    [self.view addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomLabel.mas_bottom).offset(60);
        make.left.equalTo(self.view.mas_centerX).offset(40);
        make.width.equalTo(@80);
        make.height.equalTo(@50);
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
