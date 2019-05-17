//
//  ColumnarView.h
//  YGBKit
//
//  Created by renshen on 2017/5/3.
//  Copyright © 2017年 liuli. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LineChartViewDelegate <NSObject>

- (void)touchIndex:(NSInteger )index WithSelectViewArray:(NSMutableArray *)selectViewArray;

@end

typedef NS_ENUM(NSInteger, LineType) {
    
    SolidLine = 0,  //实心线
    
    DottedLine =1,   //虚线
    
    SolidAndDottedLine = 2, //最后一条为虚线，其他为实现
};

@interface LineChartView : UIView

@property(nonatomic, strong) NSArray *dataSource; //数据源

@property (nonatomic) CGFloat MaxValue;//最大值

@property(nonatomic) CGFloat widthCircle; //圆点宽度，默认为10

@property(nonatomic, strong) NSArray *colorArry; //颜色数组，如果不给，默认随机颜色

@property(nonatomic) BOOL needXYShaft; //是否需要XY轴，默认yes需要

@property (nonatomic) CGFloat rightSpacing; //右边距，默认25

@property (nonatomic) CGFloat leftSpacing; //左边距，默认50

@property (nonatomic, strong) UIColor *lineColor; //连线颜色

@property (nonatomic, strong) UIColor *circleColor; //圆点颜色

@property (nonatomic, strong) UIColor *itemLabelColor; //

@property (nonatomic) LineType lineType; //连线方式

@property (nonatomic, weak) id <LineChartViewDelegate> delegate;

@property (nonatomic, strong) UIColor *lineLabelColor;//折现的文字颜色

-(void)updateLineChart;

-(void)selectIndex:(NSInteger )index;
@end


