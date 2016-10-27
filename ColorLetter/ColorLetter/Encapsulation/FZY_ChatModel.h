//
//  FZY_ChatModel.h
//  ColorLetter
//
//  Created by dllo on 16/10/27.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZYBaseModel.h"

@interface FZY_ChatModel : FZYBaseModel

@property (nonatomic,copy) NSString * fromUser;

@property (nonatomic,copy) NSString * context;

@property (nonatomic,assign) BOOL isSelf;

@end
