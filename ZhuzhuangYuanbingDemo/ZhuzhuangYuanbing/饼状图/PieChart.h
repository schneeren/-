//
//  PieChart.h
//  ZhuzhuangYuanbing
//
//  Created by renshen on 2017/5/9.
//  Copyright © 2017年 renshen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PieChartDelegate <NSObject>

- (void)PieChartTouchIndex:(NSUInteger )index AndData:(NSDictionary *)dataDic;

@end


@interface PieChart : UIView

@property(nonatomic,strong)NSArray *dataSource;//数据源

@property(nonatomic)CGPoint pieCenter;//圆的圆心坐标，默认为view的中心

@property(nonatomic)CGFloat pieRadius;//半径，当没有设置值时候，默认为当前所能绘制最大半径

@property(nonatomic)CGFloat spaceRadius;//中间空白区域，当没有设定时候，默认无

@property(nonatomic)CGFloat pieInterval;//圆饼之间的间隙，圆最大是3.14，所以这个尽量给值小点，以0.0X为基准

@property(nonatomic,strong)NSArray *colorArry;//颜色数组，如果没有，默认随机颜色

@property(nonatomic)BOOL haveAnimation;//是否需要动画，默认无动画

@property(nonatomic)BOOL AsingleAnimation;//是否单个动画，默认为多个动画

@property(nonatomic)CGFloat animationTime;//动画时间,默认为2S

@property(nonatomic)BOOL canSelect;//点击圆饼时，是否需要点击偏移

@property(nonatomic)BOOL canMultiselect;//是否可以多选

@property(nonatomic)CGFloat offset;//设置点击以后偏移量

@property(nonatomic)CGFloat beginPercentage;

@property (nonatomic) BOOL irregularPiechat;//不规则圆饼

@property (nonatomic, strong) NSMutableArray *radiusArray;//不规则圆饼的话默认是10%递减，如果给这个赋值则按照这个来画半径

@property(nonatomic,weak)id<PieChartDelegate>delegate;
/**
 默认选择的圆饼区域,注意从1开始计数，当为0时候默认为没有选择的区域
 */
@property(nonatomic)int selecNum;//默认选择的圆饼区域,从1开始计数，当为0时候默认为没有选择的区域
-(void)upDatePieChart;

@end
