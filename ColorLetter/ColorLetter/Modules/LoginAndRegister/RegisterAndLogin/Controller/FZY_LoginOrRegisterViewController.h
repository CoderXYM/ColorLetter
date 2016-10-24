//
//  FZY_LoginOrRegisterViewController.h
//  ColorLetter
//
//  Created by dllo on 16/10/20.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZYBaseViewController.h"

@protocol FZY_LoginOrRegisterViewControllerDelegate <NSObject>

- (void)dismissViewController;

@end

@interface FZY_LoginOrRegisterViewController : FZYBaseViewController

@property (nonatomic, assign) CGFloat position;

@property (nonatomic, assign) CGFloat scrollPosition;

@property (nonatomic, assign) id<FZY_LoginOrRegisterViewControllerDelegate>delegate;

@end
