//
//  DrawerViewController.m
//  ColorLetter
//
//  Created by dllo on 16/10/20.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "DrawerViewController.h"
#import "DrawerTableViewCell.h"                           
#import "FZY_SettingViewController.h"
#import "FZY_LoginOrRegisterViewController.h"
#import "FZY_BmobObject.h"
//#import <BmobSDK/Bmob.h>
//#import <BmobSDK/BmobFile.h>
//#import <BmobSDK/BmobProFile.h>
static NSString *const cellIdentifier = @"drawerCell";

@interface DrawerViewController ()

<
UITableViewDelegate,
UITableViewDataSource,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *nameArray;

@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, retain) UIImageView *imageView;
@end

@implementation DrawerViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"WhenPushPage" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:_myImage];
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH / 7 * 5, 0, WIDTH / 7 * 2, HEIGHT)];
    bgView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5];
    [self.view addSubview:bgView];
    // 轻拍手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    // 视图添加一个手势
    [bgView addGestureRecognizer:tap];
    
    // 轻扫手势
    UISwipeGestureRecognizer *swipe =[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    // 设置轻扫方向
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [bgView addGestureRecognizer:swipe];
    
    [self createArray];
    [self createTableView];
}

- (void)reduction {
    //    [UIView animateWithDuration:0.001 animations:^{
    //        self.view.transform = CGAffineTransformMakeTranslation(-500, 0);
    //    }];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"BackToTabBarViewController" object:nil];
    CATransition * animation = [CATransition animation];
    animation.duration = 0.5;
//    animation.type = @"suckEffect";
    animation.type = kCATransitionFromRight;
     [self.view.window.layer addAnimation:animation forKey:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)swipeAction:(UISwipeGestureRecognizer *)swipe {
    [self reduction];
    
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    [self reduction];
}

- (void)createArray {
    self.imageArray = @[@"shezhi", @"help", @"log Out"];
    self.nameArray = @[@"Setting", @"Help", @"Log Out"];
}

- (void)createTableView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH / 7 * 5, HEIGHT)];
    [self.view addSubview:view];
    // 设置模糊效果
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    // 创建模糊效果的视图
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    // 添加到有模糊效果的控件上
    effectView.frame = view.bounds;
    [view addSubview:effectView];
    
    
    //头像
   self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH - WIDTH / 7 * 2 - 100) * 0.5, (HEIGHT - HEIGHT / 3 * 2 - 100) * 0.5, 100, 100)];
   _imageView.image = [UIImage imageNamed:@"mood-confused"];

    [effectView addSubview:_imageView];
  
   
    //把头像设置成圆形
    _imageView.layer.cornerRadius = _imageView.frame.size.width / 2;
    
    //隐藏裁剪掉的部分
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.borderColor = [UIColor whiteColor].CGColor;
     
    //给头像加一个圆形边框
    _imageView.layer.borderWidth = 1.5f;
    //允许用户交互
    _imageView.userInteractionEnabled = YES;
    //初始化一个手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(alertImageView:)];
   //给imageView添加手势
    [_imageView addGestureRecognizer:singleTap];
    
    
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, HEIGHT / 3, WIDTH / 7 * 5, HEIGHT / 3 * 2) style:UITableViewStylePlain];
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = NO;
    _tableView.delegate = self;
    _tableView.rowHeight = 80;
    _tableView.dataSource = self;
    [view addSubview:_tableView];
    [_tableView registerClass:[DrawerTableViewCell class] forCellReuseIdentifier:cellIdentifier];

}
-(void)alertImageView:(UITapGestureRecognizer *)gesture{
    /**
     *  弹出提示框
     */
    //初始化提示框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
         //允许编辑，即放大裁剪
        PickerImage.allowsEditing = YES;
        //自代理
        PickerImage.delegate = self;
         //页面跳转
        [self presentViewController:PickerImage animated:YES completion:nil];
        
    }]];   
    
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
       //获取方式:通过相机
        PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        PickerImage.allowsEditing = YES;
        PickerImage.delegate = self;
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
}
//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    //定义一个newPhoto，用来存放我们选择的图片
    UIImage *newPhoto = [info objectForKey:UIImagePickerControllerEditedImage];
                    
    //把newPhono设置成头像
    _imageView.image = newPhoto;
    //关闭当前界面，即回到主界面去
    [self dismissViewControllerAnimated:YES completion:^{
            BmobObject  *photoAlbum = [BmobObject objectWithClassName:@"PhotoAlbum"];
         NSData *imageData = UIImageJPEGRepresentation(newPhoto, 0.5);
       // NSLog(@"iiiiii :%@", imageData);
        [photoAlbum setObject:[[NSString alloc] initWithData:imageData encoding:NSUTF8StringEncoding] forKey:@"Avatar"];
        [photoAlbum setObject:[[EMClient sharedClient] currentUsername] forKey:@"userName"];
        [photoAlbum saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                //创建成功后会返回objectId，updatedAt，createdAt等信息
                //创建对象成功，打印对象值
                NSLog(@"%@",photoAlbum);
            } else if (error){
                [UIView showMessage:@"头像保存失败"];
                NSLog(@"%@",error);
            } else {
                NSLog(@"Unknow error");
            }
        }];
    }];
    
    
}

//- (void)creatNSDictionary {
//    NSBundle *mainBundle = [NSBundle mainBundle];
//    NSString *path = [mainBundle bundlePath];
//    NSString *path1 = [path stringByAppendingPathComponent:@"abc.jpg"];
//    NSString *path2 = [path stringByAppendingPathComponent:@"abc.zip"];
//    NSString *path3 = [path stringByAppendingPathComponent:@"abc.text"];
//    NSData *data1 = [NSData dataWithContentsOfFile:path1];
//    NSData *data2 = [NSData dataWithContentsOfFile:path2];
//    NSData *data3 = [NSData dataWithContentsOfFile:path3];
//    
//    NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"abc.jpg",@"filename",data1,@"data",nil];
//    NSDictionary *dic2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"abc.zip",@"filename",data2,@"data",nil];
//    NSDictionary *dic3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"abc.txt",@"filename",data3,@"data",nil];
//    
//    NSArray *array = @[dic1,dic2,dic3];    
//
//    [Bmobpro]
//
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _imageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DrawerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.cellName = _nameArray[indexPath.row];
    cell.cellImage = _imageArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            FZY_SettingViewController *setting = [[FZY_SettingViewController alloc] init];
            CATransition * animation = [CATransition animation];
            animation.duration = 0.5;
            animation.type = kCATransitionFade;
            [self.view.window.layer addAnimation:animation forKey:nil];
            [self dismissViewControllerAnimated:NO completion:^{
                [_viewController presentViewController:setting animated:YES completion:nil];
            }];
//            [self.navigationController pushViewController:setting animated:YES];
            break;
        }
        case 1:{
            
            break;
        }
        default:{
            EMError *error = [[EMClient sharedClient] logout:YES];
            if (!error) {
                NSLog(@"退出成功");
                FZY_LoginOrRegisterViewController *lorVC = [[FZY_LoginOrRegisterViewController alloc] init];
                lorVC.position = WIDTH / 4 * 3;
                lorVC.scrollPosition = WIDTH;
                self.view.window.rootViewController = lorVC;
            }
            break;
        }
    }
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
