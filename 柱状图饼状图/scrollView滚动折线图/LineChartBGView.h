//
//  LineChartBGView.h
//  ZYMirror
//
//  Created by renshen on 2018/4/15.
//  Copyright © 2018年 qiuhaixia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineChartView.h"
#define pageW 65

@protocol LineChartBGViewDelegate <NSObject>

- (void)touchIndex:(NSInteger )index WithSelectViewArray:(NSMutableArray *)selectViewArray;

@end

@interface LineChartBGView : UIView<UIScrollViewDelegate>

@property (nonatomic, strong) LineChartView *lineChartView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *dataSourceArray;

@property (nonatomic, weak) id <LineChartBGViewDelegate> delegate;

@end
