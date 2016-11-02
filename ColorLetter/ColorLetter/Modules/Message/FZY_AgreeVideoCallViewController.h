//
//  FZY_AgreeVideoCallViewController.h
//  ColorLetter
//
//  Created by dllo on 16/10/31.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZYBaseViewController.h"

@interface FZY_AgreeVideoCallViewController : FZYBaseViewController

// 视屏通话时,自己的图像显示区域
@property (nonatomic, strong) EMCallLocalView *localView;
// 视屏通话时,对方的图像显示区域
@property (nonatomic, strong) EMCallRemoteView *remoteView;
// 会话标识
@property (nonatomic, strong) NSString *sessionId;
@end
