//
//  FZYBaseViewController.m
//  ColorLetter
//
//  Created by dllo on 16/10/19.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZYBaseViewController.h"
#import "DrawerViewController.h"

@interface FZYBaseViewController ()

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
    [self create];
   }

- (void)createDrawer {
    self.drawerVC = [[DrawerViewController alloc] init];
    _drawerVC.view.transform = CGAffineTransformMakeTranslation(-414, 0);
    [self addChildViewController:_drawerVC];
    [self.view addSubview:_drawerVC.view];
    [self.view bringSubviewToFront:_drawerVC.view];
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
        [UIView animateWithDuration:0.1 animations:^{
            _drawerVC.view.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.5];
            _drawerVC.view.transform = CGAffineTransformMakeTranslation(0, 0);
        }];
    
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WhenPushPage" object:nil];
//        self.drawerVC = [[DrawerViewController alloc] init];
//        _drawerVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//        _drawerVC.modalPresentationStyle = UIModalPresentationCurrentContext;
//        _drawerVC.viewController = self;
//        [self presentViewController:_drawerVC animated:YES completion:nil];

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
        NSLog(@"search");
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
