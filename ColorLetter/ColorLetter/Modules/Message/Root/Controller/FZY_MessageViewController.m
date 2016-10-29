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
#import "FZY_FriendsModel.h"
@interface FZY_MessageViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *conversationArray;
@end

@implementation FZY_MessageViewController

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BackToTabBarViewController" object:nil];
    self.navigationController.navigationBar.hidden = YES;
    // 载入所有会话
    [self loadAllConversations];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self creatTableView];
    [super create];    
}

#pragma mark - 获取全部会话
- (void)loadAllConversations {
    
    [_conversationArray removeAllObjects];
    
    NSArray *conversationArray = [[EMClient sharedClient].chatManager getAllConversations];
    
    for (EMConversation *con in conversationArray) {
        
        FZY_FriendsModel *model = [[FZY_FriendsModel alloc] init];
        if (con.type == EMConversationTypeChat) {
            model.name = con.conversationId;
        } else{
            // 群聊
            model.groupID = con.conversationId;
        }
        
        // 最新一条信息
        EMMessage *latestMess = con.latestMessage;
        EMTextMessageBody *textBody = (EMTextMessageBody *)latestMess.body;
        NSString *txt = nil;
        if (textBody.type == EMMessageBodyTypeImage) {
            txt = nil;
        } else {
            txt = textBody.text;
        }
        
        // 最新消息
        model.latestMessage = txt;
        
        // 客户端发送/收到此消息的时间
        model.time = latestMess.localTime;
        
        // 会话未读消息总数
        model.unReadMessageNum = con.unreadMessagesCount;
        
        [_conversationArray addObject:model];
        [_tableView reloadData];
    }
}

#pragma mark - 创建 tableView
- (void)creatTableView {
    
    FZY_FriendsModel *model = [[FZY_FriendsModel alloc] init];
    model.name = @"777";
    self.conversationArray = [[NSMutableArray alloc] initWithObjects:model, nil];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64 - 44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 80;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[FZY_MessageTableViewCell class] forCellReuseIdentifier:@"messageCell"];
    
}

#pragma mark - tableView 协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _conversationArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FZY_MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell"];
    
    FZY_FriendsModel *model = _conversationArray[indexPath.row];
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FZY_ChatViewController *chatVC = [[FZY_ChatViewController alloc] init];
    
    FZY_FriendsModel *model = _conversationArray[indexPath.row];
    chatVC.friendName = model.name;
    
    // 设置消息为已读
    EMConversation *con = [[EMClient sharedClient].chatManager getConversation:model.name type:EMConversationTypeChat createIfNotExist:YES];
    if (con.unreadMessagesCount) {
        EMError *err = nil;
        [con markAllMessagesAsRead:&err];
        // UI 去掉红点
        FZY_MessageTableViewCell *cell = (FZY_MessageTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
        [cell displayNumberOfUnreadMessagesWith:NO];
    }
    
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
