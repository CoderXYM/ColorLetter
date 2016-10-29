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
#import "FZY_KeyboardCollectionViewCell.h"

@interface FZY_ChatViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
UITextFieldDelegate,
EMChatManagerDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *downView;
@property (nonatomic, strong) UITextField *importTextField;
@property (nonatomic, strong) UIButton *sendMessageButton;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) EMConversation *conversation;
@property (nonatomic, assign) CGFloat keyboard_H;
@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, strong) UICollectionView *optionsCollectionView;;
@property (nonatomic, strong) NSArray *optionsArray;
@property (nonatomic, assign) BOOL isShow;
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
    // 载入历史聊天记录
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = _friendName;
    self.navigationController.navigationBar.translucent = NO;
    [self loadConversationHistory];
    
    [self creatChatTableViewAndTextField];
    
    // 接收消息
    // 注册消息回调
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
    // 添加 键盘弹出 通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
}

#pragma mark - 获取与好友的聊天历史记录
- (void)loadConversationHistory {
    [_dataSourceArray removeAllObjects];
    
    self.conversation = [[EMClient sharedClient].chatManager getConversation:_friendName type:EMConversationTypeChat createIfNotExist:YES];
    // 获取当前用户名
    NSString *userName = [[EMClient sharedClient] currentUsername];
    //  从数据库获取指定数量的消息，取到的消息按时间排序，并且不包含参考的消息，如果参考消息的ID为空，则从最新消息取
    [_conversation loadMessagesStartFromId:nil count:20 searchDirection:EMMessageSearchDirectionUp completion:^(NSArray *aMessages, EMError *aError) {
        
        if (!aError) {
            NSLog(@"载入历史消息成功");
            
            if (aMessages.count) {

                for (EMMessage *mes in aMessages) {
                    
                    EMMessageBody *msgBody = mes.body;
                    FZY_ChatModel * model = [[FZY_ChatModel alloc] init];
                    
                    switch (msgBody.type) {
                        case EMMessageBodyTypeText:
                        {
                            NSLog(@"文字");
                            EMTextMessageBody *textBody = (EMTextMessageBody *)msgBody;
                            
                            NSString *txt = textBody.text;
                            
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
                            model.isPhoto = NO;
                            [self.dataSourceArray addObject:model];
                            
                            if (_dataSourceArray.count > 0) {
                                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_dataSourceArray.count - 1 inSection:0];
                                [self insertMessageIntoTableViewWith:indexPath];
                            }
                        }
                            break;
                        case EMMessageBodyTypeImage:
                        {
                            NSLog(@"图片");
                            EMImageMessageBody *imageBody = (EMImageMessageBody *)msgBody;
                            model.photoName = imageBody.remotePath;
                            if ([mes.from isEqualToString:userName]) {
                                model.isSelf = YES;
                            } else{
                                model.isSelf = NO;
                            }
                            model.isPhoto = YES;
                            [_dataSourceArray addObject:model];
                            if (_dataSourceArray.count > 0) {
                                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_dataSourceArray.count - 1 inSection:0];
                                [self insertMessageIntoTableViewWith:indexPath];
                            }
                            
                        }
                            break;
                        case EMMessageBodyTypeVoice:
                        {
                            NSLog(@"语音");
                        }
                            break;
                        case EMMessageBodyTypeLocation:
                        {
                            NSLog(@"位置");
                        }
                            break;
                        default:
                            break;
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
            FZY_ChatModel *model = [[FZY_ChatModel alloc] init];
            
            switch (msgBody.type) {
                case EMMessageBodyTypeText:
                {
                    // 收到文字消息
                    EMTextMessageBody *textBody = (EMTextMessageBody *)msgBody;
                    NSString *txt = textBody.text;
                    
                    model.fromUser = message.to;
                    model.isSelf = NO;
                    model.isPhoto = NO;
                    model.context = txt;
                    [_dataSourceArray addObject:model];
                    
                    if (_dataSourceArray.count > 0) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_dataSourceArray.count - 1 inSection:0];
                        [self insertMessageIntoTableViewWith:indexPath];
                    }
                    
                }
                    break;
                case EMMessageBodyTypeImage:
                {
                    // 图片消息
                    EMImageMessageBody *body = ((EMImageMessageBody *)msgBody);
                    model.photoName = body.remotePath;
                    model.isSelf = NO;
                    model.isPhoto = YES;
                    [_dataSourceArray addObject:model];
                    // 将消息插入 UI
                    if (_dataSourceArray.count > 0) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_dataSourceArray.count - 1 inSection:0];
                        [self insertMessageIntoTableViewWith:indexPath];
                    }
                    
                }
                    break;
                default:
                    break;
            }
        }

}

#pragma mark - 发送消息
- (void)sendMessageWithEMMessage:(EMMessage *)message {
    
    // 发送消息
    [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
        if (!error) {
            
            FZY_ChatModel *model = [[FZY_ChatModel alloc] init];
            EMMessageBody *msgBody = message.body;
            
            switch (msgBody.type) {
                case EMMessageBodyTypeText:
                {
                    model.fromUser = message.from;
                    model.context = _importTextField.text;
                    model.isSelf = YES;
                    model.isPhoto = NO;
                    [_dataSourceArray addObject:model];
                    // 将消息插入 UI
                    if (_dataSourceArray.count > 0) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_dataSourceArray.count - 1 inSection:0];
                        [self insertMessageIntoTableViewWith:indexPath];
                    }
                    
                }
                    break;
                case EMMessageBodyTypeImage:
                {
                    EMImageMessageBody *body = ((EMImageMessageBody *)msgBody);
                    model.photoName = body.remotePath;
                    model.isSelf = YES;
                    model.isPhoto= YES;
                    [_dataSourceArray addObject:model];
                    // 将消息插入 UI
                    if (_dataSourceArray.count > 0) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_dataSourceArray.count - 1 inSection:0];
                        [self insertMessageIntoTableViewWith:indexPath];
                    }
                    
                    NSLog(@"大图remote路径 -- %@"   ,body.remotePath);
                    NSLog(@"大图local路径 -- %@"    ,body.localPath); // // 需要使用sdk提供的下载方法后才会存在
                    NSLog(@"大图的secret -- %@"    ,body.secretKey);
                    NSLog(@"大图的W -- %f ,大图的H -- %f",body.size.width,body.size.height);
                    NSLog(@"大图的下载状态 -- %d",body.downloadStatus);
                    
                    // 缩略图sdk会自动下载
                    NSLog(@"小图remote路径 -- %@"   ,body.thumbnailRemotePath);
                    NSLog(@"小图local路径 -- %@"    ,body.thumbnailLocalPath);
                    NSLog(@"小图的secret -- %@"    ,body.thumbnailSecretKey);
                    NSLog(@"小图的W -- %f ,小图的H -- %f",body.thumbnailSize.width,body.thumbnailSize.height);
                    NSLog(@"小图的下载状态 -- %d",body.thumbnailDownloadStatus);
                }
                    break;
                default:
                    break;
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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 50 - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
   // _tableView.backgroundColor = [UIColor redColor];
    _tableView.separatorStyle = UITableViewCellAccessoryNone;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[FZY_ChatTableViewCell class] forCellReuseIdentifier:@"chatCell"];
    
    // 创建下面的输入框
    self.downView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT - 50 - 64, WIDTH, 50)];
    _downView.backgroundColor = [UIColor colorWithRed:0.53 green:0.90 blue:0.95 alpha:1.0];
    [self.view addSubview:_downView];
    
    // 语音按钮
    UIButton  *optionVioceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [optionVioceButton setBackgroundImage:[UIImage imageNamed:@"optionVioce"] forState:UIControlStateNormal];
    [_downView addSubview:optionVioceButton];
    [optionVioceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_downView).offset(10);
        make.centerY.equalTo(_downView.mas_centerY).offset(0);
        make.height.width.equalTo(@40);
    }];
    optionVioceButton.layer.cornerRadius = 20;
    optionVioceButton.clipsToBounds = YES;
    [optionVioceButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        NSLog(@"长按发送语音");
    }];

    // 切换发送消息类型
    self.sendMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendMessageButton setBackgroundImage:[UIImage imageNamed:@"optionAdd"] forState:UIControlStateNormal];
    _sendMessageButton.frame = CGRectMake(WIDTH - 100, 5, 80, 40);
    _sendMessageButton.layer.cornerRadius = 10;
    _sendMessageButton.clipsToBounds = YES;
    [_downView addSubview:_sendMessageButton];
    [_sendMessageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_downView).offset(-10);
            make.centerY.equalTo(_downView.mas_centerY).offset(0);
            make.height.width.equalTo(@40);
    }];
    [_sendMessageButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [_importTextField resignFirstResponder];
        _optionsCollectionView.frame = CGRectMake(0, HEIGHT - 80 - 64, WIDTH, 80);
        _downView.frame = CGRectMake(0, HEIGHT - 80 - 50 - 64, WIDTH, 50);
        
    }];
    
    // 输入框
    self.importTextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 5, WIDTH / 2, 40)];
    _importTextField.backgroundColor = [UIColor colorWithRed:0.99 green:0.99 blue:0.99 alpha:1.0];
    
    _importTextField.layer.cornerRadius = 10;
    _importTextField.clipsToBounds = YES;
    _importTextField.delegate = self;
    [_downView addSubview:_importTextField];
    
    [_importTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(optionVioceButton.mas_right).offset(10);
        make.right.equalTo(_sendMessageButton.mas_left).offset(-10);
        make.centerY.equalTo(_downView.mas_centerY).offset(0);
        make.height.equalTo(@40);
    }];
    // 添加手势收起键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTap:)];
    [_tableView addGestureRecognizer:tap];
    
    
    [self createOptionsCollectionView];
    
}

#pragma mark - 创建 键盘 选择发送消息的类型
- (void)createOptionsCollectionView {
    
    self.optionsArray = @[@"optionPhoto", @"optionCamera", @"optionPostion", @"optionVideo"];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((WIDTH - 10 * 5) / 5 , 60);
    layout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
    self.optionsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, 0) collectionViewLayout:layout];
    _optionsCollectionView.backgroundColor = [UIColor whiteColor];
    _optionsCollectionView.delegate = self;
    _optionsCollectionView.dataSource = self;
    [self.view addSubview:_optionsCollectionView];
    [_optionsCollectionView registerClass:[FZY_KeyboardCollectionViewCell class] forCellWithReuseIdentifier:@"optionCell"];
}

#pragma mark - collectionView 协议
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _optionsArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FZY_KeyboardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"optionCell" forIndexPath:indexPath];
    NSString *imgName = _optionsArray[indexPath.item];
    cell.backImageView.image = [UIImage imageNamed:imgName];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.item) {
        case 0:
        {
            NSLog(@"图片");
            UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
            PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //自代理
            PickerImage.delegate = self;
            PickerImage.allowsEditing = YES;
            //页面跳转
            [self presentViewController:PickerImage animated:YES completion:nil];
        }
            break;
        case 1:
        {
            NSLog(@"相机");
            UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
            //获取方式:通过相机
            PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
            PickerImage.allowsEditing = YES;
            PickerImage.delegate = self;
            [self presentViewController:PickerImage animated:YES completion:nil];
        }
            break;
        case 2:
        {
            NSLog(@"位置");
        }
            break;
        case 3:
        {
            NSLog(@"视频");
        }
            break;
        default:
            break;
    }
}

//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    //定义一个newPhoto，用来存放我们选择的图片
    UIImage *libraryPhoto = [info objectForKey:UIImagePickerControllerEditedImage];
    
    // 可以在上传时使用当前系统时间作为文件名
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyy-MM-dd-HH-mm-ss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    
    // 将图片转为 data 数据
    NSData *imageData = UIImageJPEGRepresentation(libraryPhoto, 0.5);
    // 构造图片信息
    EMImageMessageBody *body = [[EMImageMessageBody alloc] initWithData:imageData displayName:str];
    NSString *from = [[EMClient sharedClient] currentUsername];
    
    //生成Message
    EMMessage *message = [[EMMessage alloc] initWithConversationID:_friendName from:from to:_friendName body:body ext:nil];
    message.chatType = EMChatTypeChat;// 设置为单聊消息
    //关闭当前界面，即回到主界面去
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 发送消息
    [self sendMessageWithEMMessage:message];
    
}

#pragma mark -  自定义 消息动态插入 tableView
- (void)insertMessageIntoTableViewWith:(NSIndexPath *)indexPath {
    [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
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
    cell.model = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //取数据
    FZY_ChatModel * model = _dataSourceArray[indexPath.row];
    if (model.isPhoto) {
        return 240;
    } else {
        //根据文字确定显示大小
        CGSize size = [model.context boundingRectWithSize:CGSizeMake(160, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]} context:nil].size;
        return size.height + 40;
    }
    
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    // 构造文字消息
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:_importTextField.text];
    NSString *userName = [[EMClient sharedClient] currentUsername];
    
    // 生成 Message
    EMMessage *message = [[EMMessage alloc] initWithConversationID:_friendName from:userName to:_friendName body:body ext:nil];
    message.chatType = EMChatTypeChat; // 设置为单聊信息
    [self sendMessageWithEMMessage:message];
    return YES;
}

#pragma mark - 轻拍手势方法
- (void)screenTap:(UIGestureRecognizer *)tap {
    
    // 取消当前屏幕所有第一响应
    if (_isShow) {
        [self keyboardWillHide];
        [self.view endEditing:YES];
        _downView.frame = CGRectMake(0, HEIGHT - 50 - 64, WIDTH, 50);
        _optionsCollectionView.frame = CGRectMake(0, HEIGHT, WIDTH, 0);
    }
    if (_optionsCollectionView.frame.size.height > 0) {
        _downView.frame = CGRectMake(0, HEIGHT - 50 - 64, WIDTH, 50);
        _optionsCollectionView.frame = CGRectMake(0, HEIGHT, WIDTH, 0);
    }
    
}

#pragma mark - 获取键盘弹出隐藏的动态高度
- (void)keyboardWillShow:(NSNotification *)notification {
    
    self.isShow = YES;
    // 获取通知的信息字典
    NSDictionary *userInfo = [notification userInfo];
    // 获取键盘弹出后的rect
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat h = keyboardRect.size.height;
    
    // 获取键盘弹出动画时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    self.keyboard_H = h;
    self.animationDuration = animationDuration;
    
    [UIView animateWithDuration:animationDuration animations:^{
        _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, HEIGHT - 50 - h);
        _tableView.contentOffset = CGPointMake(0, h);
        [_downView setFrame:CGRectMake(_downView.frame.origin.x, HEIGHT - 50 - h - 64, _downView.frame.size.width, _downView.frame.size.height)];
    }];
    
    
}
- (void)keyboardWillHide {
    
    self.isShow = NO;
    [UIView animateWithDuration:_animationDuration animations:^{
        
        _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, HEIGHT - 50);
        _tableView.contentOffset = CGPointMake(0, -_keyboard_H);
        [_downView setFrame:CGRectMake(_downView.frame.origin.x, HEIGHT - 50 - 64, _downView.frame.size.width, _downView.frame.size.height)];
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
