//
//  FZY_ChatTableViewCell.h
//  ColorLetter
//
//  Created by dllo on 16/10/27.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_BaseTableViewCell.h"
@class FZY_ChatModel;

@interface FZY_ChatTableViewCell : FZY_BaseTableViewCell

//左头像
@property (nonatomic,strong) UIImageView * leftIconImageView;
//右头像
@property (nonatomic,strong) UIImageView * rightIconImageView;
//左昵称
@property (nonatomic,strong) UILabel * leftName;
//右昵称
@property (nonatomic,strong) UILabel * rightName;
//左气泡
@property (nonatomic,strong) UIImageView * leftBubble;
//右气泡
@property (nonatomic,strong) UIImageView * rightBubble;
//左label
@property (nonatomic,strong) UILabel * leftLabel;
//右label
@property (nonatomic,strong) UILabel * rightLabel;

- (void)loadDataFromModel:(FZY_ChatModel*)model;

@end
