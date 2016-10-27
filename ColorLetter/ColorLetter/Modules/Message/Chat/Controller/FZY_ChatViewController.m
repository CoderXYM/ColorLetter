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
UITableViewDataSource,
FZY_KeyboardShowHiddenNotificationCenterDelegate,
UITextFieldDelegate,
EMChatManagerDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *downView;
@property (nonatomic, strong) UITextField *importTextField;
@property (nonatomic, strong) UIButton *sendMessageButton;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@end

@implementation FZY_ChatViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WhenPushPage" object:nil];
    // 设置代理
    [FZY_KeyboardShowHiddenNotificationCenter defineCenter].delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = _friendName;
    [self creatChatTableViewAndTextField];
    
    // 接收消息
    // 移除消息回调
    [[EMClient sharedClient].chatManager removeDelegate:self];
    // 注册消息回调
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
}



/*!
 @method
 @brief 接收到一条及以上非cmd消息
 */
- (void)didReceiveMessages:(NSArray *)aMessages {
    
    for (EMMessage *message in aMessages) {
        EMMessageBody *msgBody = message.body;
        
        switch (msgBody.type) {
            case EMMessageBodyTypeText:
            {
                // 收到文字消息
                EMTextMessageBody *textBody = (EMTextMessageBody *)msgBody;
                NSString *txt = textBody.text;
                NSLog(@"收到的文字是 txt -- %@", txt);
                [_dataSourceArray addObject:txt];
        
                [_tableView reloadData];
            }
                break;
            default:
                break;
        }
    }
    
}

#pragma mark - 创建聊天 UI
- (void)creatChatTableViewAndTextField {
    self.dataSourceArray = [NSMutableArray array];
    
    // 创建 tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 50) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    // 除去间隔线
    _tableView.separatorStyle = UITableViewCellAccessoryNone;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"chatCell"];
    
    // 创建下面的输入框
    self.downView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT - 50, WIDTH, 50)];
    _downView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_downView];
    
    self.importTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, WIDTH - 110, 40)];
    _importTextField.backgroundColor = [UIColor whiteColor];
    _importTextField.delegate = self;
    [_downView addSubview:_importTextField];
    
    self.sendMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendMessageButton setTitle:@"发送" forState:UIControlStateNormal];
    _sendMessageButton.frame = CGRectMake(WIDTH - 105, 5, 100, 40);
    _sendMessageButton.backgroundColor = [UIColor cyanColor];
    [_downView addSubview:_sendMessageButton];
    [_sendMessageButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        NSLog(@"发送消息");
        
        // 构造文字消息
        EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:_importTextField.text];
        NSString *userName = [[EMClient sharedClient] currentUsername];
        
        // 生成 Message
        EMMessage *message = [[EMMessage alloc] initWithConversationID:_friendName from:userName to:_friendName body:body ext:nil];
        message.chatType = EMChatTypeChat; // 设置为单聊信息
        
        // 发送消息
        [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
            if (!error) {
                NSLog(@"发送成功");
            } else {
                NSLog(@"发送失败: %@", error);
            }
            
        }];
        
        NSString *str = _importTextField.text;
        [_dataSourceArray addObject:str];
        
        
        [_tableView reloadData];
    }];
    
    // 添加手势收起键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTap:)];
    [_tableView addGestureRecognizer:tap];
    
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

- (void)showOrHiddenKeyboardWithHeight:(CGFloat)height withDuration:(CGFloat)animationDuration isShow:(BOOL)isShow {
    NSLog(@"ViewController 接收到%@通知\n高度值：%f\n时间：%f",isShow ? @"弹出":@"隐藏", height,animationDuration);
    
    [UIView animateWithDuration:animationDuration animations:^{
        [_downView setFrame:CGRectMake(_downView.frame.origin.x, HEIGHT - 50 - height, _downView.frame.size.width, _downView.frame.size.height)];
    }];
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)screenTap:(UIGestureRecognizer *)tap {
    // 取消当前屏幕所有第一响应
    [self.view endEditing:YES];
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
