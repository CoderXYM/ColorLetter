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
UITextFieldDelegate
>

@property (nonatomic, retain)UITableView *tableView;
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, retain)NSMutableArray *dataArray;
@property (nonatomic, retain)NSMutableArray *searchArray;

@end

@implementation FZY_FriendRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self create];
    [self getArray];
//    [self createTableView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
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
    

    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 70, WIDTH, 50)];
    _textField.delegate = self;
    _textField.clipsToBounds = YES;
    _textField.layer.cornerRadius = _textField.frame.size.height / 2;
    _textField.backgroundColor = [UIColor lightGrayColor];
    _textField.clearButtonMode = UITextFieldViewModeAlways;
    _textField.placeholder = @"   请输入要添加的用户名";
    [_textField setValue:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.000] forKeyPath:@"placeholderLabel.textColor"];
    [self.view addSubview:_textField];

}

- (void)getArray {
    self.dataArray = [NSMutableArray array];
    self.searchArray = [NSMutableArray array];
    
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 114, WIDTH, HEIGHT - 114) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    

    return _dataArray.count;
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    

        cell.textLabel.text = _dataArray[indexPath.row];

    
    return cell;
}

// 开始编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}


// 点击return
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //回收键盘
    //(放弃第一响应者)
    [textField resignFirstResponder];
    // 结束编辑状态
//    [textField endEditing:YES];
    NSString *searchString = textField.text;
    
    if (searchString.length == 0) {
        return YES;
    }
    NSString *loginUsername = [[EMClient sharedClient] currentUsername];
    if ([searchString isEqualToString:loginUsername]) {
        [UIView showMessage:@"can't add yourself as a friend"];
        return YES;
    }
    for (NSString *string in _array) {
        if ([searchString isEqualToString:string]) {
            [UIView showMessage:[NSString stringWithFormat:@"%@已经是你的好友啦", searchString]];
            return YES;
        }
    }
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"确定添加%@为好友?", searchString] message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"说点什么";
    }];
    //创建一个取消和一个确定按钮
    UIAlertAction *actionCancle=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    //因为需要点击确定按钮后改变文字的值，所以需要在确定按钮这个block里面进行相应的操作
    UIAlertAction *actionOk=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
         UITextField *textField = alert.textFields.firstObject;
        EMError *error = [[EMClient sharedClient].contactManager addContact:searchString message:[NSString stringWithFormat:@"%@", textField.text]];
        if (!error) {
            NSLog(@"%@, %@", textField.text, searchString);
            [UIView showMessage:@"等待对方受理你的请求"];
        }
    }];
    //将取消和确定按钮添加进弹框控制器
    [alert addAction:actionCancle];
    [alert addAction:actionOk];
    //显示弹框控制器
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
    [_tableView reloadData];
    return YES;
    
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
