//
//  ColumnarView.h
//  YGBKit
//
//  Created by renshen on 2017/5/3.
//  Copyright © 2017年 非大鱼. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ColumnarViewDelegate <NSObject>

- (void)ColumnarTouchIndex:(NSUInteger )index AndData:(NSDictionary *)dataDic;

@end

@interface ColumnarView : UIView

@property (nonatomic, strong) NSArray *dataSource;//数据源

@property (nonatomic) CGFloat widthColumnar;//圆柱宽度，默认为40

@property (nonatomic, strong) NSArray *colorArry;//颜色数组，如果不给，默认随机颜色

@property (nonatomic, weak) id<ColumnarViewDelegate >delegate;

@property (nonatomic, strong) UIColor *selectColor;

-(void)updateColumnar;

@end


