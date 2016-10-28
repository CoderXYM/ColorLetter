//
//  FZY_ChatViewController.m
//  ColorLetter
//
//  Created by dllo on 16/10/24.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_ChatViewController.h"
#import "FZY_ChatTableViewCell.h"
#import "FZY_ChatModel.h"
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
@property (nonatomic, strong) EMConversation *conversation;
@end

@implementation FZY_ChatViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = NO;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WhenPushPage" object:nil];
    // 设置代理
    [FZY_KeyboardShowHiddenNotificationCenter defineCenter].delegate = self;
    
    // 载入历史聊天记录
    [self loadConversationHistory];
    [_importTextField becomeFirstResponder];
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

#pragma mark - 获取与好友的聊天历史记录
- (void)loadConversationHistory {
    self.conversation = [[EMClient sharedClient].chatManager getConversation:_friendName type:EMConversationTypeChat createIfNotExist:YES];
    
    //  从数据库获取指定数量的消息，取到的消息按时间排序，并且不包含参考的消息，如果参考消息的ID为空，则从最新消息取
    [_conversation loadMessagesStartFromId:nil count:100 searchDirection:EMMessageSearchDirectionUp completion:^(NSArray *aMessages, EMError *aError) {
        
        if (!aError) {
            NSLog(@"载入历史消息成功");
            
            if (aMessages.count) {
                for (EMMessage *mes in aMessages) {
                    
                    EMTextMessageBody *textBody = (EMTextMessageBody *)mes.body;
                    NSString *txt = textBody.text;
                    
                    // 获取当前用户名
                    NSString *userName = [[EMClient sharedClient] currentUsername];
                    
                    FZY_ChatModel * model = [[FZY_ChatModel alloc] init];
                    if ([mes.from isEqualToString:userName]) {
                        model.isSelf = YES;
                    } else{
                        model.isSelf = NO;
                    }
                    if (_friendName) {
                        model.fromUser = mes.from;
                    } else{
                        // 群聊
                        // model.fromUser = message.groupSenderName;
                    }
                    model.context = txt;
                    
                    [self.dataSourceArray addObject:model];
                    
                    if (_dataSourceArray.count > 0) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_dataSourceArray.count - 1 inSection:0];
                        [self insertMessageIntoTableViewWith:indexPath];
                    }
                    
                }
            }
            
        } else {
            NSLog(@"载入历史消息失败 : %@", aError);
        }
        
    }];
    
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
                
                FZY_ChatModel *model = [[FZY_ChatModel alloc] init];
                model.fromUser = message.to;
                model.isSelf = NO;
                model.context = txt;
                [_dataSourceArray addObject:model];
                
            }
                break;
            default:
                break;
        }
    }
    
    if (_dataSourceArray.count > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_dataSourceArray.count - 1 inSection:0];
        [self insertMessageIntoTableViewWith:indexPath];
    }
}

#pragma mark - 发送消息
- (void)sendMessage {
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
            FZY_ChatModel *model = [[FZY_ChatModel alloc] init];
            model.fromUser = message.from;
            model.context = _importTextField.text;
            model.isSelf = YES;
            [_dataSourceArray addObject:model];
            // 将消息插入 UI
            
            if (_dataSourceArray.count > 0) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_dataSourceArray.count - 1 inSection:0];
                [self insertMessageIntoTableViewWith:indexPath];
            }
            
            
        } else {
            NSLog(@"发送失败: %@", error);
        }
        
        [_importTextField setText:nil];
        
    }];

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
    [_tableView registerClass:[FZY_ChatTableViewCell class] forCellReuseIdentifier:@"chatCell"];
    
    // 创建下面的输入框
    self.downView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT - 50, WIDTH, 50)];
    _downView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
    [self.view addSubview:_downView];
    
    self.importTextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 5, WIDTH / 2, 40)];
    _importTextField.backgroundColor = [UIColor colorWithRed:0.99 green:0.99 blue:0.99 alpha:1.0];
    _importTextField.layer.cornerRadius = 10;
    _importTextField.clipsToBounds = YES;
    _importTextField.delegate = self;
    
    [_downView addSubview:_importTextField];
    
    self.sendMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendMessageButton setTitle:@"发送" forState:UIControlStateNormal];
    _sendMessageButton.frame = CGRectMake(WIDTH - 100, 5, 80, 40);
    _sendMessageButton.backgroundColor = [UIColor colorWithRed:0.77 green:0.77 blue:0.77 alpha:1.0];
    _sendMessageButton.layer.cornerRadius = 10;
    _sendMessageButton.clipsToBounds = YES;
    [_downView addSubview:_sendMessageButton];
    [_sendMessageButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        NSLog(@"发送消息");
        
        [self sendMessage];
    }];
    
    // 添加手势收起键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTap:)];
    [_tableView addGestureRecognizer:tap];
    
}


#pragma mark -  自定义 消息动态插入 tableView
- (void)insertMessageIntoTableViewWith:(NSIndexPath *)indexPath {
    [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

#pragma mark - tableView 协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FZY_ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatCell"];
    if (_dataSourceArray.count <= 0) {
        return cell;
    }
    // 取数据
    FZY_ChatModel *model = _dataSourceArray[indexPath.row];
    [cell loadDataFromModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //取数据
    FZY_ChatModel * model = _dataSourceArray[indexPath.row];
    //根据文字确定显示大小
    CGSize size = [model.context boundingRectWithSize:CGSizeMake(160, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]} context:nil].size;
    return size.height + 40;
}

#pragma mark - 获取键盘弹出隐藏的动态高度
- (void)showOrHiddenKeyboardWithHeight:(CGFloat)height withDuration:(CGFloat)animationDuration isShow:(BOOL)isShow {
    NSLog(@"ViewController 接收到%@通知\n高度值：%f\n时间：%f",isShow ? @"弹出":@"隐藏", height,animationDuration);
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, HEIGHT - 50 - height);
        
        [_downView setFrame:CGRectMake(_downView.frame.origin.x, HEIGHT - 50 - height, _downView.frame.size.width, _downView.frame.size.height)];
    }];
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self sendMessage];
    return YES;
}

#pragma mark - 轻拍手势方法
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
