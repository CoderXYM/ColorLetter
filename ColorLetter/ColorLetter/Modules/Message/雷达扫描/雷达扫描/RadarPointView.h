//
//  RadarPointView.h
//  雷达扫描
//
//  Created by dllo on 16/10/24.
//  Copyright © 2016年 Guolefeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XYMRadarPointViewDelegate;

@interface RadarPointView : UIView

@property(nullable, nonatomic,weak) id <XYMRadarPointViewDelegate> delegate;

@end

@protocol XYMRadarPointViewDelegate <NSObject>

@optional

// 点击事件
- (void)didSelectItemRadarPointView:(nonnull XYMRadarPointView *)radarPointView;

@end
