//
//  FZY_CreateGroupViewController.m
//  ColorLetter
//
//  Created by dllo on 16/11/7.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_CreateGroupViewController.h"

@interface FZY_CreateGroupViewController ()

@property (weak, nonatomic) IBOutlet UITextField *groupName;
@property (weak, nonatomic) IBOutlet UITextField *groupDescription;
@property (nonatomic, strong) NSMutableArray *groupMembersArray;
@end

@implementation FZY_CreateGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self completeButton];
}

#pragma mark - 完成按钮
- (void)completeButton {
    UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    completeButton.frame = CGRectMake(WIDTH - 100, 20, 80, 40);
    [completeButton setTitle:@"完成" forState:UIControlStateNormal];
    [completeButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        if (_groupMembersArray.count) {
            [self createGroup];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"创建群组提示" message:@"群成员数不能为空" preferredStyle:UIAlertControllerStyleAlert];
            ///UIAlertAction *alertAction = [UIAlertAction ]
        }
    }];
    [self.view addSubview:completeButton];
}

#pragma mark - 创建群组
- (void)createGroup {
    EMError *error = nil;
    EMGroupOptions *setting = [[EMGroupOptions alloc] init];
    setting.maxUsersCount = 500;
    setting.style = EMGroupStylePublicJoinNeedApproval; //  公开群组，Owner可以邀请用户加入; 非群成员用户发送入群申请，经Owner同意后才能入组
    EMGroup *group = [[EMClient sharedClient].groupManager createGroupWithSubject:self.groupName.text description:self.groupDescription.text invitees:self.groupMembersArray message:@"邀请您加入群组" setting:setting error:&error];
    if (!error) {
        NSLog(@"创建成功--- %@", group);
    } else {
        NSLog(@"创建群组失败--- %@", error);
    }
    
}

#pragma mark - 邀请群成员
- (IBAction)inviteGroupMembers:(id)sender {
    self.groupMembersArray = [NSMutableArray arrayWithObjects:@"666", @"777", nil];
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
