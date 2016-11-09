//
//  FZY_RequestModel.h
//  ColorLetter
//
//  Created by dllo on 16/10/29.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZYBaseModel.h"

@interface FZY_RequestModel : FZYBaseModel

@property (nonatomic, copy) NSString *aUsername;

@property (nonatomic, copy) NSString *aMessage;

@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, copy) NSString *groupDescription;

@end
