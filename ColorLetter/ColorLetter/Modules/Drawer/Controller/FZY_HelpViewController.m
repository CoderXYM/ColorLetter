//
//  FZY_HelpViewController.m
//  ColorLetter
//
//  Created by dllo on 16/11/9.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_HelpViewController.h"
#import "UIButton+Block.h"
@interface FZY_HelpViewController ()

@end

@implementation FZY_HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    upView.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.21 alpha:1.0];
    [self.view addSubview:upView];
    
    UIButton *backImage = [UIButton buttonWithType:UIButtonTypeCustom];
    [backImage setBackgroundImage:[UIImage imageNamed:@"btn-x"] forState:UIControlStateNormal];
    [backImage handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [upView addSubview:backImage];
   
    [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(5);
            make.top.equalTo(self.view.mas_top).offset(35                                                             );
            make.height.equalTo(@15);
            make.width.equalTo(@15);
    }];
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, 50, 50)];
    [backButton setTitle:@"Help" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];    
    [upView addSubview:backButton];
   [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
       make.centerX.equalTo(self.view.mas_left).offset(WIDTH / 2);
       make.top.equalTo(self.view.mas_top).offset(30);
       make.height.equalTo(@30);
       make.width.equalTo(@50);
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
