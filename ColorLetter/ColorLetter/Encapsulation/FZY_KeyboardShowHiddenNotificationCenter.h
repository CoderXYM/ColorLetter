//
//  FZY_KeyboardShowHiddenNotificationCenter.h
//  ColorLetter
//
//  Created by dllo on 16/10/26.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol FZY_KeyboardShowHiddenNotificationCenterDelegate <NSObject>

- (void)showOrHiddenKeyboardWithHeight:(CGFloat)height withDuration:(CGFloat)animationDuration isShow:(BOOL)isShow;

@end

@interface FZY_KeyboardShowHiddenNotificationCenter : NSObject

+ (FZY_KeyboardShowHiddenNotificationCenter *)defineCenter;

// 参数类型要求：请将作为第一响应者的控件所在的ViewController作为代理传入
// 设置位置要求：请将设置代理的代码放到ViewController的viewWillAppear:方法中
@property (nonatomic, assign) id<FZY_KeyboardShowHiddenNotificationCenterDelegate>delegate;

@end
