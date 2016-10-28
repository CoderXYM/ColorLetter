//
//  TheContactViewController.m
//  ColorLetter
//
//  Created by dllo on 16/10/20.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "TheContactViewController.h"
#import "FZY_SliderScrollView.h"
#import "FZY_FriendRequestViewController.h"

static NSString *const leftIdentifier = @"leftCell";
static NSString *const rightIdentifier = @"rightCell";


@interface TheContactViewController ()
<
FZY_SliderScrollViewDelegate,
UIScrollViewDelegate,
UITableViewDataSource,
UITableViewDelegate,
UISearchResultsUpdating,
EMContactManagerDelegate
>

{
    CGFloat slideLength;
}

@property (nonatomic, strong) UIScrollView *downScrollView;
@property (nonatomic, strong) FZY_SliderScrollView *sliderScrollView;
@property (nonatomic, strong) UIView *upView;
@property (nonatomic, assign) CGFloat count;

@property (nonatomic, strong)UISearchController *searchController;

@property (nonatomic, strong) UITableView *leftTabeleView;
@property (nonatomic, strong) UITableView *rightTableView;

@property (nonatomic, strong) NSMutableArray *leftArray;
@property (nonatomic, retain) NSMutableArray *searchLeftArray;

@property (nonatomic, strong) NSMutableArray *rightArray;
@property (nonatomic, strong) UILabel *label;


@end

@implementation TheContactViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BackToTabBarViewController" object:nil];
    self.navigationController.navigationBar.hidden = YES;

    if (self.searchController.active) {
        self.searchController.active = NO;
        [self.searchController.searchBar removeFromSuperview];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    slideLength = (WIDTH - 120) / 2;
    self.leftArray = [NSMutableArray array];
    self.rightArray = [NSMutableArray array];
    self.searchLeftArray = [NSMutableArray array];
    [self creatDownScrollView];
    [self ChooseSingleOrGroup];
    
    EMError *error = nil;
    NSArray *userlist = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
    if (!error) {
        [_leftArray addObjectsFromArray:userlist];
    }
    
    //注册好友回调
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    //移除好友回调
   // [[EMClient sharedClient].contactManager removeDelegate:self];

    [self create];
}

- (void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername
                                       message:(NSString *)aMessage {
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];

    NSString *str = [NSString stringWithFormat:@"%@想添加你为好友\n%@", aUsername, aMessage];
    [_leftArray insertObject:str atIndex:0];
    [_leftTabeleView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationRight];
    [_leftTabeleView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];

}

#pragma mark - 创建滑块
- (void)ChooseSingleOrGroup {

    self.upView = [[UIView alloc] initWithFrame:CGRectMake(60, 25, WIDTH - 120, 30)];
    _upView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    _upView.layer.cornerRadius = 15;
    [self.view addSubview:_upView];
    
    self.sliderScrollView = [[FZY_SliderScrollView alloc] initWithFrame:CGRectMake(3, 2, _upView.frame.size.width / 2, 26)];
    _sliderScrollView.showsHorizontalScrollIndicator = YES  ;
    _sliderScrollView.showsVerticalScrollIndicator = YES;
    _sliderScrollView.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.21 alpha:1];
    _sliderScrollView.sliderDelegate = self;
    _sliderScrollView.layer.cornerRadius = 13;
    _sliderScrollView.clipsToBounds = YES;
    [_upView addSubview:_sliderScrollView];
    
    UIButton *friendsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [friendsButton setTitle:@"好友" forState:UIControlStateNormal];
    [friendsButton setTitleColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1] forState:UIControlStateNormal];
    [friendsButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        _downScrollView.contentOffset = CGPointMake(0, 0);
    }];
    [_upView addSubview:friendsButton];
    [friendsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_upView).offset(50);
        make.width.equalTo(@40);
        make.top.equalTo(_upView).offset(5);
        make.bottom.equalTo(_upView.mas_bottom).offset(-5);
    }];
    
    UIButton *groudButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [groudButton setTitle:@"群组" forState:UIControlStateNormal];
    [groudButton setTitleColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1] forState:UIControlStateNormal];
    [groudButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        NSLog(@"群组");
        _downScrollView.contentOffset = CGPointMake(WIDTH, 0);
    }];
    [_upView addSubview:groudButton];
    [groudButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_upView).offset(-50);
        make.width.equalTo(@40);
        make.top.equalTo(_upView).offset(5);
        make.bottom.equalTo(_upView.mas_bottom).offset(-5);
    }];
    
}

#pragma mark - 实现自定义协议 获取滑块位置
- (void)getSliderPostionX:(CGFloat)x {
    
    [UIView animateWithDuration:0.1 animations:^{
        _downScrollView.contentOffset = CGPointMake(x * WIDTH / slideLength, 0);
    }];
    
}

#pragma mark - scrollView 关联滑块
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger i = 0;
    if (scrollView.contentOffset.x > _count) {
        i = -3;
    } else {
        i = 3;
    }
    _sliderScrollView.frame = CGRectMake(scrollView.contentOffset.x * (slideLength / WIDTH) + i, 2, _upView.frame.size.width / 2, 26);
    self.count = scrollView.contentOffset.x ;

//    [UIView animateWithDuration:0.1 animations:^{
//        _sliderScrollView.transform = CGAffineTransformMakeTranslation(scrollView.contentOffset.x * (slideLength / WIDTH) + i, 0);
//    }];
}

#pragma mark - 创建 downScrollView
- (void)creatDownScrollView {
    
    self.downScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64 + 50, WIDTH, HEIGHT - 64 - 49 - 50)];
    _downScrollView.bounces = NO;
    _downScrollView.scrollEnabled = YES;
    _downScrollView.contentSize = CGSizeMake(WIDTH * 2, 0);
    _downScrollView.showsHorizontalScrollIndicator = NO;
    _downScrollView.pagingEnabled = YES;
    _downScrollView.delegate = self;
    [self.view addSubview:_downScrollView];
    
    self.leftTabeleView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64 - 49 - 50 ) style:UITableViewStylePlain];
    _leftTabeleView.delegate = self;
    _leftTabeleView.dataSource = self;
    _leftTabeleView.rowHeight = 100;
    _leftTabeleView.separatorStyle = UITableViewCellAccessoryNone;
    [_downScrollView addSubview:_leftTabeleView];
    [_leftTabeleView registerClass:[UITableViewCell class] forCellReuseIdentifier:leftIdentifier];
    
    self.rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(WIDTH, 0, WIDTH, HEIGHT - 64 - 49 - 50) style:UITableViewStylePlain];
    _rightTableView.backgroundColor = [UIColor blueColor];
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
    _rightTableView.separatorStyle = UITableViewCellAccessoryNone;
    [_downScrollView addSubview:_rightTableView];
    [_rightTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:rightIdentifier];
    
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, 50)];
    [self.view addSubview:myView];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = false;
    [_searchController.searchBar sizeToFit];
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.obscuresBackgroundDuringPresentation = NO;
    [myView addSubview:_searchController.searchBar];

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:_leftTabeleView]) {
        if (_searchController.active) {
            return _searchLeftArray.count;
        }
        return _leftArray.count;
    }else {
       
        
        return _rightArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_leftTabeleView]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:leftIdentifier];
        if (_searchController.active) {
            cell.textLabel.text = _searchLeftArray[indexPath.row];
        }
        else {
            cell.textLabel.text = _leftArray[indexPath.row];
            cell.textLabel.numberOfLines = 2;
        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rightIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchString = _searchController.searchBar.text;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    // 清空原数组
    if (nil != _searchLeftArray) {
        [_searchLeftArray removeAllObjects];
    }
    // 筛选数据
    _searchLeftArray = [NSMutableArray arrayWithArray:[_leftArray filteredArrayUsingPredicate:predicate]];
    // 重载 tableView
    [_leftTabeleView reloadData];
    
}

#pragma mark - delete 

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [_leftTabeleView setEditing:editing animated:animated];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *name = _leftArray[indexPath.row];
    // 删除好友
    EMError *error = [[EMClient sharedClient].contactManager deleteContact:name];
    if (!error) {
        NSLog(@"删除成功");
    }
    [_leftArray removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
}

#pragma mark - 重写父类方法传值

- (void)create {
    [super create];
    [self.searchButton  handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        FZY_FriendRequestViewController *friend = [[FZY_FriendRequestViewController alloc] init];
        friend.array = [NSMutableArray arrayWithArray:_leftArray];
        [self presentViewController:friend animated:YES completion:nil];
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
