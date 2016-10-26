//
//  DrawerViewController.m
//  ColorLetter
//
//  Created by dllo on 16/10/20.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "DrawerViewController.h"
#import "DrawerTableViewCell.h"                           
#import "FZY_SettingViewController.h"
#import "FZY_LoginOrRegisterViewController.h"

static NSString *const cellIdentifier = @"drawerCell";

@interface DrawerViewController ()

<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *nameArray;

@property (nonatomic, strong) NSArray *imageArray;

@end

@implementation DrawerViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"WhenPushPage" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:_myImage];
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH / 7 * 5, 0, WIDTH / 7 * 2, HEIGHT)];
    bgView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5];
    [self.view addSubview:bgView];
    // 轻拍手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    // 视图添加一个手势
    [bgView addGestureRecognizer:tap];
    
    // 轻扫手势
    UISwipeGestureRecognizer *swipe =[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    // 设置轻扫方向
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [bgView addGestureRecognizer:swipe];
    
    [self createArray];
    [self createTableView];
}

- (void)reduction {
    //    [UIView animateWithDuration:0.001 animations:^{
    //        self.view.transform = CGAffineTransformMakeTranslation(-500, 0);
    //    }];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"BackToTabBarViewController" object:nil];
    CATransition * animation = [CATransition animation];
    animation.duration = 0.5;
//    animation.type = @"suckEffect";
    animation.type = kCATransitionFromRight;
     [self.view.window.layer addAnimation:animation forKey:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)swipeAction:(UISwipeGestureRecognizer *)swipe {
    [self reduction];
    
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    [self reduction];
}

- (void)createArray {
    self.imageArray = @[@"shezhi", @"help", @"log Out"];
    self.nameArray = @[@"Setting", @"Help", @"Log Out"];
}

- (void)createTableView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH / 7 * 5, HEIGHT)];
    [self.view addSubview:view];
    // 设置模糊效果
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    // 创建模糊效果的视图
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    // 添加到有模糊效果的控件上
    effectView.frame = view.bounds;
    [view addSubview:effectView];
    
    
    //头像
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH - WIDTH / 7 * 2 - 100) * 0.5, (HEIGHT - HEIGHT / 3 * 2 - 100) * 0.5, 100, 100)];
    imageView.image = [UIImage imageNamed:@"mood-confused"];

    [effectView addSubview:imageView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, HEIGHT / 3, WIDTH / 7 * 5, HEIGHT / 3 * 2) style:UITableViewStylePlain];
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = NO;
    _tableView.delegate = self;
    _tableView.rowHeight = 80;
    _tableView.dataSource = self;
    [view addSubview:_tableView];
    [_tableView registerClass:[DrawerTableViewCell class] forCellReuseIdentifier:cellIdentifier];

}
       

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _imageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DrawerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.cellName = _nameArray[indexPath.row];
    cell.cellImage = _imageArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            FZY_SettingViewController *setting = [[FZY_SettingViewController alloc] init];
            CATransition * animation = [CATransition animation];
            animation.duration = 0.5;
            animation.type = kCATransitionFade;
            [self.view.window.layer addAnimation:animation forKey:nil];
            [self dismissViewControllerAnimated:NO completion:^{
                [_viewController presentViewController:setting animated:YES completion:nil];
            }];
//            [self.navigationController pushViewController:setting animated:YES];
            break;
        }
        case 1:{
            
            break;
        }
        default:{
            EMError *error = [[EMClient sharedClient] logout:YES];
            if (!error) {
                NSLog(@"退出成功");
                FZY_LoginOrRegisterViewController *lorVC = [[FZY_LoginOrRegisterViewController alloc] init];
                lorVC.position = WIDTH / 4 * 3;
                lorVC.scrollPosition = WIDTH;
                self.view.window.rootViewController = lorVC;
            }
            break;
        }
    }
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
