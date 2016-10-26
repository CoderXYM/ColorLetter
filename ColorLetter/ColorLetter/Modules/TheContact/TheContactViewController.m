//
//  TheContactViewController.m
//  ColorLetter
//
//  Created by dllo on 16/10/20.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "TheContactViewController.h"
#import "FZY_SliderScrollView.h"

@interface TheContactViewController ()
<
FZY_SliderScrollViewDelegate,
UIScrollViewDelegate
>

{
    CGFloat slideLength;
}

@property (nonatomic, retain) UIScrollView *downScrollView;
@property (nonatomic, retain) FZY_SliderScrollView *sliderScrollView;
@property (nonatomic, retain) UIView *upView;
@property (nonatomic, assign) CGFloat count;
@end

@implementation TheContactViewController

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BackToTabBarViewController" object:nil];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    slideLength = (WIDTH - 120) / 2;
    [self creatDownScrollView];
    [self ChooseSingleOrGroup];
    [super create];

}

#pragma mark - 创建滑块
- (void)ChooseSingleOrGroup {

    self.upView = [[UIView alloc] initWithFrame:CGRectMake(60, 25, WIDTH - 120, 30)];
    _upView.backgroundColor = [UIColor redColor];
    _upView.layer.cornerRadius = 15;
    [self.view addSubview:_upView];
    
    self.sliderScrollView = [[FZY_SliderScrollView alloc] initWithFrame:CGRectMake(3, 2, _upView.frame.size.width / 2, 26)];
    _sliderScrollView.showsHorizontalScrollIndicator = YES  ;
    _sliderScrollView.showsVerticalScrollIndicator = YES;
    _sliderScrollView.backgroundColor = [UIColor cyanColor];
    _sliderScrollView.sliderDelegate = self;
    _sliderScrollView.layer.cornerRadius = 13;
    _sliderScrollView.clipsToBounds = YES;
    [_upView addSubview:_sliderScrollView];
    
    UIButton *friendsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [friendsButton setTitle:@"好友" forState:UIControlStateNormal];
    [friendsButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        _downScrollView.contentOffset = CGPointMake(0, 0);
    }];
    [_upView addSubview:friendsButton];
    [friendsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_upView).offset(60);
        make.width.equalTo(@50);
        make.top.equalTo(_upView).offset(5);
        make.bottom.equalTo(_upView.mas_bottom).offset(-5);
    }];
    
    UIButton *groudButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [groudButton setTitle:@"群组" forState:UIControlStateNormal];
    [groudButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        NSLog(@"群组");
        _downScrollView.contentOffset = CGPointMake(WIDTH, 0);
    }];
    [_upView addSubview:groudButton];
    [groudButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_upView).offset(-60);
        make.width.equalTo(@50);
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
    
    self.downScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64 - 49)];
    _downScrollView.bounces = NO;
    _downScrollView.contentSize = CGSizeMake(WIDTH * 2, 0);
    _downScrollView.showsHorizontalScrollIndicator = NO;
    _downScrollView.pagingEnabled = YES;
    _downScrollView.delegate = self;
    [self.view addSubview:_downScrollView];
    
    [self addImageToDownScrollView];
}

// 测试代码 可以删除
- (void)addImageToDownScrollView {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 200, 400, 100)];
    imageView.backgroundColor = [UIColor redColor];
    [_downScrollView addSubview:imageView];
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
