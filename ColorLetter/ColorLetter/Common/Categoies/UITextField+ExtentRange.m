//
//  UITextField+ExtentRange.m
//  ColorLetter
//
//  Created by dllo on 16/11/14.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "UITextField+ExtentRange.h"

@implementation UITextField (ExtentRange)

- (NSRange)selectedRange {
    UITextPosition *beginning = self.beginningOfDocument;
    UITextRange *selectedRange = self.selectedTextRange;
    
    UITextPosition *selectionStart = selectedRange.start;
    UITextPosition *selectionEnd = selectedRange.end;
    
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
    
}

// 备注: UITextField 必须称为第一响应者才有效
- (void)setSelectedRange:(NSRange)range {
    UITextPosition *beginning = self.beginningOfDocument;
    UITextPosition *startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition *endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    UITextRange *selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    
    [self setSelectedTextRange:selectionRange];
}

@end
