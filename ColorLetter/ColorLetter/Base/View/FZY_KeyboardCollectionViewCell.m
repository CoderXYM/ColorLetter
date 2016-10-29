//
//  FZY_KeyboardCollectionViewCell.m
//  ColorLetter
//
//  Created by dllo on 16/10/29.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_KeyboardCollectionViewCell.h"

@implementation FZY_KeyboardCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backImageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:_backImageView];
    }
    return self;
}

@end
