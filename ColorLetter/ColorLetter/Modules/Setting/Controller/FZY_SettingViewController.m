//
//  FZY_SettingViewController.m
//  ColorLetter
//
//  Created by dllo on 16/10/21.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_SettingViewController.h"
#import "FZY_SettingTableViewCell.h"
#import "FZY_SwitchTableViewCell.h"

static NSString *const cellIdentifier = @"settingCell";
static NSString *const IdentifierCell = @"switchCell";

@interface FZY_SettingViewController ()

<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *nameArray;

@property (nonatomic, strong) NSArray *imageArray;

@end

@implementation FZY_SettingViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WhenPushPage" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"设置";
    [self goBack];
    [self createTableView];

}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT) style:UITableViewStylePlain];
    _tableView.scrollEnabled = YES;
    _tableView.separatorStyle = NO;
    _tableView.delegate = self;
    _tableView.rowHeight = HEIGHT / 16.27;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[FZY_SettingTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    [_tableView registerClass:[FZY_SwitchTableViewCell class] forCellReuseIdentifier:IdentifierCell];

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        return @"Account";
    }else if (1 == section) {
        return @"Options";
    }
    return @"ColorLetter";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == section) {
        return 1;
    }else if (1 == section) {
        return 1;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FZY_SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (0 == indexPath.section) {
        cell.cellName = @"个人账号";
    }else if (1 == indexPath.section) {
        FZY_SwitchTableViewCell *cells = [tableView dequeueReusableCellWithIdentifier:IdentifierCell];
        if (0 == indexPath.row) {
            cells.cellName = @"通知";
        }
        else if ( 1 == indexPath.row) {
            cells.cellName = @"夜间模式";
        }
        cells.selectionStyle = UITableViewCellSelectionStyleNone;
        return cells;
    }else {
        if (0 == indexPath.row) {
            cell.cellName = @"关于我们";
        }
        else if (1 == indexPath.row){
            cell.cellName = @"分享";
        }else {
            cell.cellName = @"通知";
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)goBack {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"btn-x"] forState:UIControlStateNormal];
    [button handleControlEvent:UIControlEventTouchUpInside withBlock:^{
    
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(self.view.mas_top).offset(20);
        make.height.equalTo(@50);
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
