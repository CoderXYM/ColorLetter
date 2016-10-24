//
//  RadarIndictorView.h
//  雷达扫描
//
//  Created by dllo on 16/10/24.
//  Copyright © 2016年 Guolefeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadarIndictorView : UIView

// 半径
@property (nonatomic, assign) CGFloat radius;
// 渐变开始颜色
@property (nonatomic, strong) UIColor *startColor;
// 渐变结束颜色和
@property (nonatomic, strong) UIColor *endColor;
// 扫描角度
@property (nonatomic, assign) CGFloat angle;
// 是否顺时针
@property (nonatomic, assign) BOOL clockwise;

@end
