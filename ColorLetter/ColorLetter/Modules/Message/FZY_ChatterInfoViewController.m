//
//  FZY_ChatterInfoViewController.m
//  ColorLetter
//
//  Created by dllo on 16/11/10.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_ChatterInfoViewController.h"

@interface FZY_ChatterInfoViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *tableViwe;

@end

@implementation FZY_ChatterInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yellowColor];
    
    [self createTableView];
}

- (void)createTableView {
    
    self.tableViwe = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableViwe.delegate = self;
    _tableViwe.dataSource = self;
    [_tableViwe registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableViwe];
    
    UIView *upView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 200)];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image =  [UIImage imageNamed:@"tab-home"];
    [upView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(upView.mas_centerY).offset(-20);
        make.centerX.equalTo(upView.mas_centerX).offset(0);
        make.width.height.equalTo(@100);
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = _friendName;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [upView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(upView.mas_bottom).offset(-20);
        make.centerX.equalTo(upView.mas_centerX).offset(0);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
    }];
    _tableViwe.tableHeaderView = upView;
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    return cell;
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
