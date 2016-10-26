//
//  FZY_FriendRequestViewController.m
//  ColorLetter
//
//  Created by dllo on 16/10/26.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_FriendRequestViewController.h"

static NSString *const cellIdentifier = @"cell";


@interface FZY_FriendRequestViewController ()

<
UITableViewDataSource,
UITableViewDelegate,
UISearchResultsUpdating
>

@property (nonatomic, retain)UITableView *tableView;
@property (nonatomic, retain)UISearchController *searchController;

@property (nonatomic, retain)NSMutableArray *dataArray;
@property (nonatomic, retain)NSMutableArray *searchArray;

@end

@implementation FZY_FriendRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self create];
    [self getArray];
    [self createTableView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.searchController.active) {
        self.searchController.active = NO;
        [self.searchController.searchBar removeFromSuperview];
    }
}

- (void)create {
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel setTitle:@"返回" forState:UIControlStateNormal];
    cancel.titleLabel.textColor = [UIColor whiteColor];
    cancel.backgroundColor = [UIColor clearColor];
    [cancel handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.view addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(self.view.mas_top).offset(25);
        make.height.equalTo(@30);
        make.width.equalTo(@50);
    }];
    
    
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, 50)];
    [self.view addSubview:myView];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = false;
    [self.searchController.searchBar sizeToFit];
//    _searchController.searchBar.frame = CGRectMake(0, 64, WIDTH, 50);
    
    [myView addSubview:_searchController.searchBar];
}

- (void)getArray {
    self.dataArray = [NSMutableArray array];
    self.searchArray = [NSMutableArray array];
    EMError *error = nil;
    NSArray *userlist = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
    if (!error) {
        NSLog(@"获取成功");
    }
    [_dataArray addObjectsFromArray:userlist];
    NSLog(@"%ld", _dataArray.count);
    NSLog(@"%ld", userlist.count);
    
    
//    for (int i = 100; i < 1000; i++) {
//        [_dataArray addObject:[NSString stringWithFormat:@"%d", i]];
//    }
//    [_dataArray addObject:@"Small Tiger"];
//    [_dataArray addObject:@"皮卡丘"];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 114, WIDTH, HEIGHT - 114) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_searchController.active) {
        return _searchArray.count;
    }
    return _dataArray.count;
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (_searchController.active) {
        cell.textLabel.text = _searchArray[indexPath.row];
    }
    else {
        cell.textLabel.text = _dataArray[indexPath.row];
    }
    
    return cell;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchString = _searchController.searchBar.text;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    // 清空原数组
    if (nil != _searchArray) {
        [_searchArray removeAllObjects];
    }
    // 筛选数据
    _searchArray = [NSMutableArray arrayWithArray:[_dataArray filteredArrayUsingPredicate:predicate]];
    // 重载 tableView
    [_tableView reloadData];
    
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
