//
//  FZY_ChatTableViewCell.m
//  ColorLetter
//
//  Created by dllo on 16/10/27.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_ChatTableViewCell.h"
#import "FZY_ChatModel.h"
#import "NSData+Categories.h"
#import "UIImageAvatarBrowser.h"

@interface FZY_ChatTableViewCell ()

// 左头像
@property (nonatomic, strong) UIImageView *leftIconImageView;
// 右头像
@property (nonatomic, strong) UIImageView *rightIconImageView;
// 左昵称
@property (nonatomic, strong) UILabel *leftName;
// 右昵称
@property (nonatomic, strong) UILabel *rightName;
// 左气泡
@property (nonatomic, strong) UIImageView *leftBubble;
// 右气泡
@property (nonatomic, strong) UIImageView *rightBubble;
// 左label
@property (nonatomic, strong) UILabel *leftLabel;
// 右label
@property (nonatomic, strong) UILabel *rightLabel;
// 左图片
@property (nonatomic, strong) UIButton *leftPhotoImageView;
// 右图片
@property (nonatomic, strong) UIButton *rightPhotoImageView;
// 时间
@property (nonatomic, strong) UILabel *leftTimeLabel;
@property (nonatomic, strong) UILabel *rightTimeLabel;

// 语音
@property (nonatomic, strong) UIButton *leftVoiceButton;
@property (nonatomic, strong) UIButton *rightVoiceButton;

// 正在播放语音
@property (nonatomic, assign) BOOL isPlayVoice;
@end

@implementation FZY_ChatTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 左头像
        self.leftIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
        _leftIconImageView.image = [UIImage imageNamed:@"mood-confused"];
        _leftIconImageView.layer.cornerRadius = 5;
        _leftIconImageView.clipsToBounds = YES;
        [self.contentView addSubview:_leftIconImageView];
        
        // 右头像
        self.rightIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - 45, 5, 40, 40)];
        _rightIconImageView.image = [UIImage imageNamed:@"mood-unhappy"];
        _rightIconImageView.layer.cornerRadius = 5;
        _rightIconImageView.clipsToBounds = YES;
        [self.contentView addSubview:_rightIconImageView];
        
        // 左名字
        self.leftName = [[UILabel alloc]initWithFrame:CGRectMake(5, 46, 40, 10)];
        _leftName.text = @"左用户";
        _leftName.textAlignment = NSTextAlignmentCenter;
        _leftName.font = [UIFont systemFontOfSize:8];
        _leftName.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_leftName];
        
        // 右名字
        self.rightName = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH - 45, 46, 40, 10)];
        _rightName.text = @"右用户";
        _rightName.textAlignment = NSTextAlignmentCenter;
        _rightName.font = [UIFont systemFontOfSize:8];
        _rightName.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_rightName];
        
        // 1、得到图片信息
        UIImage * leftImage = [UIImage imageNamed:@"chatfrom_bg_normal"];
        UIImage * rightImage = [UIImage imageNamed:@"chatto_bg_normal"];

        // 2、抓取像素拉伸
        leftImage = [leftImage stretchableImageWithLeftCapWidth:15 topCapHeight:17];
        rightImage = [rightImage stretchableImageWithLeftCapWidth:15 topCapHeight:17];
        
        // 左气泡
        self.leftBubble = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 180, 40)];
        _leftBubble.image = leftImage;
        _leftBubble.userInteractionEnabled = YES;
        [self.contentView addSubview:_leftBubble];
        // 右气泡
        self.rightBubble = [[UIImageView alloc]initWithFrame:CGRectMake(190, 5, 180, 40)];
        _rightBubble.image = rightImage;
        _rightBubble.userInteractionEnabled = YES;
        [self.contentView addSubview:_rightBubble];
        
        // 气泡上的文字
        self.leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 160, 30)];
        _leftLabel.numberOfLines = 0;
        [_leftBubble addSubview:_leftLabel];
        
        self.rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 160, 30)];
        _rightLabel.numberOfLines = 0;
        [_rightBubble addSubview:_rightLabel];
        
        // 左图片
        self.leftPhotoImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftPhotoImageView.frame = CGRectMake(10, 10, 200, 200);
        [_leftBubble addSubview:_leftPhotoImageView];
        [_leftPhotoImageView handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            NSLog(@"fjsdf"); 
        }];
        
        // 右图片
        self.rightPhotoImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightPhotoImageView.frame = CGRectMake(10, 10, 200, 200);
        [_rightBubble addSubview:_rightPhotoImageView];
      
        [_rightPhotoImageView handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            NSLog(@"sb"); 
        }];
        
        
        // 时间Label
        self.leftTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _leftTimeLabel.textAlignment = NSTextAlignmentCenter;
        _leftTimeLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:_leftTimeLabel];
        
        self.rightTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _rightTimeLabel.textAlignment = NSTextAlignmentCenter;
        _rightTimeLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:_rightTimeLabel];
        
        // 左语音
        self.leftVoiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftVoiceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_leftVoiceButton];
        
        // 右语音
        self.rightVoiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightVoiceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_rightVoiceButton];
        
        
    }
    
    return self;
}

- (void)setModel:(FZY_ChatModel *)model {
    if (_model != model) {
        _model = model;
        
        //根据文字确定显示大小
        CGSize size = [model.context boundingRectWithSize:CGSizeMake(160, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]} context:nil].size;
        if (model.isSelf) {
            //只显示右侧气泡
            self.leftBubble.hidden = YES;
            self.rightBubble.hidden = NO;
            self.leftIconImageView.hidden = YES;
            self.rightIconImageView.hidden = NO;
            self.leftName.hidden = YES;
            self.rightName.hidden = NO;
            self.leftTimeLabel.hidden = YES;
            self.rightTimeLabel.hidden = NO;
            
            // 图片
            if (model.isPhoto) {
                
                self.leftPhotoImageView.hidden = YES;
                self.rightPhotoImageView.hidden = NO;
                self.leftVoiceButton.hidden = YES;
                self.rightVoiceButton.hidden = YES;
                NSURL *url = [NSURL URLWithString:model.photoName];
                NSData *imageData = [NSData dataWithContentsOfURL:url];
                UIImage *image = [UIImage imageWithData:imageData];
                [_rightPhotoImageView setImage:image forState:UIControlStateNormal];
                
                [_rightPhotoImageView handleControlEvent:UIControlEventTouchUpInside withBlock:^{
                    
                    [UIImageAvatarBrowser showImage:_rightPhotoImageView.imageView];
                }];               
                self.rightBubble.frame = CGRectMake(WIDTH - 200 - 30 - 50, 0, 220, 220);
                
                
            }
            else {
                
                // 语音
                if (model.isVoice) {
                    self.leftPhotoImageView.hidden = YES;
                    self.rightPhotoImageView.hidden = YES;
                    
                    self.leftVoiceButton.hidden = YES;
                    self.rightVoiceButton.hidden = NO;
                    
                    int w = (WIDTH / 60) * model.voiceDuration;
                    
                    _rightVoiceButton.frame = CGRectMake(WIDTH - 100 - 80, 10, 100, 40);
                    [_rightVoiceButton setTitle:[NSString stringWithFormat:@"%d秒", model.voiceDuration] forState:UIControlStateNormal];
                    self.rightBubble.frame = CGRectMake(WIDTH - 100 - 90, 5, 100 + 20, 50);
                    
                    [_rightVoiceButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
                        NSLog(@"%@", model.localVoicePath);
                        [self playVoiceWithPath:model.localVoicePath];
                    }];
                    
                } else {
                    // 文字
                    self.leftPhotoImageView.hidden = YES;
                    self.rightPhotoImageView.hidden = YES;
                    self.leftVoiceButton.hidden = YES;
                    self.rightVoiceButton.hidden = YES;
                    //调整坐标 根据label文字自适应
                    self.rightLabel.frame = CGRectMake(10, 10, size.width, size.height);
                    self.rightBubble.frame = CGRectMake(WIDTH - size.width - 30 - 50, 0, size.width + 30, size.height + 30);
                }
                
            }
            
            self.rightLabel.text = model.context;
            self.rightName.text = model.fromUser;
            self.rightTimeLabel.text = [NSData intervalSinceNow:model.time];
            [_rightTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_rightBubble.mas_centerX).offset(0);
                make.top.equalTo(_rightBubble.mas_bottom).offset(0);
                make.width.equalTo(@100);
                make.height.equalTo(@10);
            }];

        }else{
            
            //只显示左侧气泡
            self.leftBubble.hidden = NO;
            self.rightBubble.hidden = YES;
            self.leftIconImageView.hidden = NO;
            self.rightIconImageView.hidden = YES;
            self.leftName.hidden = NO;
            self.rightName.hidden = YES;
            self.leftTimeLabel.hidden = NO;
            self.rightTimeLabel.hidden = YES;
            
            // 图片
            if (model.isPhoto) {
                self.leftPhotoImageView.hidden = NO;
                self.rightPhotoImageView.hidden = YES;
                self.leftVoiceButton.hidden = YES;
                self.rightVoiceButton.hidden = YES;
                
                NSURL *url = [NSURL URLWithString:model.photoName];
                NSData *imageData = [NSData dataWithContentsOfURL:url];
                UIImage *image = [UIImage imageWithData:imageData];
                [_leftPhotoImageView setImage:image forState:UIControlStateNormal];
                
                [_leftPhotoImageView handleControlEvent:UIControlEventTouchUpInside withBlock:^{
                    
                    [UIImageAvatarBrowser showImage:_leftPhotoImageView.imageView];
                }];
                self.leftBubble.frame = CGRectMake(50, 10, 220, 220);
            
            } else {
                
                // 语音
                if (model.isVoice) {
                    self.leftPhotoImageView.hidden = YES;
                    self.rightPhotoImageView.hidden = YES;
                    
                    self.leftVoiceButton.hidden = NO;
                    self.rightVoiceButton.hidden = YES;
                    
                    int w = (WIDTH / 60) * model.voiceDuration;
                    
                    _leftVoiceButton.frame = CGRectMake(60, 10, 100, 40);
                    [_leftVoiceButton setTitle:[NSString stringWithFormat:@"%d秒", model.voiceDuration] forState:UIControlStateNormal];
                    self.leftBubble.frame = CGRectMake(50, 5, 120, 50);
                    
                    [_leftVoiceButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
                        NSLog(@"%@", model.remoteVoicePath);
                        [self playVoiceWithPath:model.remoteVoicePath];
                    }];
                    
                } else {
                    // 文字
                    self.leftVoiceButton.hidden = YES;
                    self.rightVoiceButton.hidden = YES;
                    self.leftPhotoImageView.hidden = YES;
                    self.rightPhotoImageView.hidden = YES;
                    self.leftLabel.frame = CGRectMake(10, 10, size.width, size.height);
                    self.leftBubble.frame = CGRectMake(50, 0, size.width + 30, size.height + 30);
                }
            }
            self.leftLabel.text = model.context;
            self.leftName.text = model.fromUser;
            self.leftTimeLabel.text = [NSData intervalSinceNow:model.time];
            [_leftTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_leftBubble.mas_centerX).offset(0);
                make.top.equalTo(_leftBubble.mas_bottom).offset(0);
                make.width.equalTo(@100);
                make.height.equalTo(@10);
            }];
        }
        
    }
}

- (void)playVoiceWithPath:(NSString *)voicePath {
   
    NSURL *url = [[NSURL alloc] init];
    // 将路径字符串转化成 url, 从本地读取文件, 需要使用 fileURL
    if (_model.isSelf) {
        url = [NSURL fileURLWithPath:voicePath];
    } else {
        url = [NSURL URLWithString:voicePath];
    }
    
    // 初始化音频播放器
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [player setVolume:1];
    // 设置循环播放 0 -> 语音只会播放一次
    [player setNumberOfLoops:0];
        
    [player prepareToPlay];
    [player play];
    
}

@end
