//
//  CustomShapeLayer.m
//  ZhuzhuangYuanbing
//
//  Created by renshen on 2017/5/10.
//  Copyright © 2017年 renshen. All rights reserved.
//

#import "CustomShapeLayer.h"
#import <UIKit/UIKit.h>
@implementation CustomShapeLayer
-(void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    CGPoint newCenterPoint = _centerPoint;
        if (_offset==0) {
            _offset = 10;
        }
        if (_isSelect) {
        newCenterPoint = CGPointMake(_centerPoint.x + cosf((_beginPercentage + _endPercentage) / 2)*_offset , _centerPoint.y + sinf((_beginPercentage + _endPercentage) / 2)*_offset);
        }
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:newCenterPoint];
        [bezierPath addArcWithCenter:newCenterPoint radius:_radius startAngle:_beginPercentage+_pieInterval endAngle:_endPercentage-_pieInterval clockwise:YES];
        [bezierPath addArcWithCenter:newCenterPoint radius:_spaceRadius startAngle:_endPercentage-_pieInterval endAngle:_beginPercentage+_pieInterval clockwise:NO];
    
        //添加到圆心直线
        [bezierPath addLineToPoint:newCenterPoint];
        //路径闭合
        [bezierPath closePath];
        self.path = bezierPath.CGPath;
        //添加动画
        CABasicAnimation *animation = [CABasicAnimation animation];
        //keyPath内容是对象的哪个属性需要动画
        animation.keyPath = @"path";
        //所改变属性的结束时的值
        animation.toValue = bezierPath;
        //动画时长
        animation.duration = 0.35;
        //添加动画
        [self addAnimation:animation forKey:nil];
}
@end
