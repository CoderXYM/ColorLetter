//
//  FZY_ChatViewController.m
//  ColorLetter
//
//  Created by dllo on 16/10/24.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_ChatViewController.h"

@interface FZY_ChatViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *importTextField;
@property (nonatomic, strong) UIButton *sendMessageButton;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@end

@implementation FZY_ChatViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WhenPushPage" object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = _friendName;
    [self creatChatTableViewAndTextField];
    
   // EaseMessageViewController *chatController = [[EaseMessageViewController alloc] initWithConversationChatter:@"8001" conversationType:EMConversationTypeChat];
}

- (void)creatChatTableViewAndTextField {
    self.dataSourceArray = [NSMutableArray array];
    
    // 创建 tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 50) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;

    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"chatCell"];
    
    // 创建下面的输入框
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT - 50, WIDTH, 50)];
    downView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:downView];
    
    self.importTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, WIDTH - 110, 40)];
    _importTextField.backgroundColor = [UIColor whiteColor];
    [downView addSubview:_importTextField];
    
    self.sendMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendMessageButton setTitle:@"发送" forState:UIControlStateNormal];
    _sendMessageButton.frame = CGRectMake(WIDTH - 105, 5, 100, 40);
    _sendMessageButton.backgroundColor = [UIColor cyanColor];
    [downView addSubview:_sendMessageButton];
    [_sendMessageButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        NSLog(@"发送消息");
        NSString *str = _importTextField.text;
        [_dataSourceArray addObject:str];
     //   [_tableView scrollToRowAtIndexPath:_dataSourceArray.count atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        [_tableView reloadData];
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatCell"];
    if (_dataSourceArray.count <= 0) {
        return cell;
    }
    cell.textLabel.text = _dataSourceArray[indexPath.row];
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
