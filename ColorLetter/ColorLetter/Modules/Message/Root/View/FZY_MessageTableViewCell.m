//
//  FZY_MessageTableViewCell.m
//  ColorLetter
//
//  Created by dllo on 16/10/24.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_MessageTableViewCell.h"
#import "FZY_FriendsModel.h"

@interface FZY_MessageTableViewCell ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation FZY_MessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.headImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _headImageView.image = [UIImage imageNamed:@"mood-happy"];
        _headImageView.layer.cornerRadius = WIDTH / 10;
        _headImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_headImageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_nameLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_timeLabel];
        
    }
    return self;
}

- (void)setModel:(FZY_FriendsModel *)model {
    if (_model != model) {
        _model = model;
        
        _nameLabel.text = model.name;
        _timeLabel.text = model.time;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(self.contentView.frame.size.width / 5));
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(10);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView.mas_right).offset(10);
        make.width.equalTo(@(self.contentView.frame.size.width / 2));
        make.centerY.equalTo(_headImageView.mas_centerY).offset(0);
        make.height.equalTo(@50);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_right).offset(0);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.equalTo(@50);
        make.centerY.equalTo(_headImageView.mas_centerY).offset(0);
    }];
    
}

@end
