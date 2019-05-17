//
//  LineItem.h
//  ZhuzhuangYuanbing
//
//  Created by renshen on 2018/7/20.
//  Copyright © 2018年 renshen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineItem : UIButton

@property (nonatomic, strong)UILabel *label;

@property (nonatomic, strong)UIView *circleView;

@property(nonatomic) CGFloat widthCircle; //圆点宽度，默认为10


-(void)upItemsFrame;


@end
