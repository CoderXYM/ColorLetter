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

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"Setting";
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
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        return @"Options";
    }
    return @"ColorLetter";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == section) {
        return 1;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FZY_SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (0 == indexPath.section) {
        FZY_SwitchTableViewCell *cells = [tableView dequeueReusableCellWithIdentifier:IdentifierCell];
        if (0 == indexPath.row) {
            cells.cellName = @"Notifications";
        }
               
        cells.selectionStyle = UITableViewCellSelectionStyleNone;
        return cells;
    }else {
        if (0 == indexPath.row) {
            cell.cellName = @"About";
        }
        else if (1 == indexPath.row){
            cell.cellName = @"Share";
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

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
