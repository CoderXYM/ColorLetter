//
//  FZY_MessageViewController.m
//  ColorLetter
//
//  Created by dllo on 16/10/24.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_MessageViewController.h"
#import "FZY_MessageTableViewCell.h"
#import "FZY_ChatViewController.h"
#import "FZY_LoginAndRegisterViewController.h"

@interface FZY_MessageViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, retain) UITableView *tableView;

@end

@implementation FZY_MessageViewController

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BackToTabBarViewController" object:nil];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    FZY_LoginAndRegisterViewController *VC = [[FZY_LoginAndRegisterViewController alloc] init];
    [self presentViewController:VC animated:YES completion:nil];
    
    [self creatTableView];
    [super createDrawer];
    
}

// 关闭侧滑手势
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    return NO;
//}

- (void)creatTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64 - 44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 120;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[FZY_MessageTableViewCell class] forCellReuseIdentifier:@"messageCell"];
    
}

#pragma mark - tableView 协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FZY_MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FZY_ChatViewController *chatVC = [[FZY_ChatViewController alloc] init];
    [self.navigationController pushViewController:chatVC animated:YES];
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
