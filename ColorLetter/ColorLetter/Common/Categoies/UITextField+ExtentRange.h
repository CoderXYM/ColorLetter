//
//  UITextField+ExtentRange.h
//  ColorLetter
//
//  Created by dllo on 16/11/14.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (ExtentRange)

- (NSRange)selectedRange;
- (void)setSelectedRange:(NSRange)range;

@end
