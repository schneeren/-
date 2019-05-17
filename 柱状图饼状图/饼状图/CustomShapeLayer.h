//
//  CustomShapeLayer.h
//  ZhuzhuangYuanbing
//
//  Created by renshen on 2017/5/10.
//  Copyright © 2017年 renshen. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CustomShapeLayer : CAShapeLayer
@property(nonatomic)CGPoint centerPoint;//中心点

@property(nonatomic)CGFloat radius;//半径

@property(nonatomic)CGFloat spaceRadius;//中间空白区域，当没有设定时候，默认无

@property(nonatomic)CGFloat beginPercentage;//起始角度

@property(nonatomic)CGFloat endPercentage;//结束角度

@property(nonatomic)BOOL isSelect;//是否选中状态

@property(nonatomic)CGFloat offset;//设置点击以后偏移量

@property(nonatomic)CGFloat pieInterval;//圆饼之间的间隙，圆最大是3.14，所以这个尽量给值小点，以0.0X为基准

@end
