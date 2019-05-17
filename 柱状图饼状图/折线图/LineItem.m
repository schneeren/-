//
//  LineItem.m
//  ZhuzhuangYuanbing
//
//  Created by renshen on 2018/7/20.
//  Copyright © 2018年 renshen. All rights reserved.
//

#import "LineItem.h"

@implementation LineItem

-(instancetype)init{
    
    self = [super init];
    if (self) {
        [self creatUI];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
        
    }
    return self;
}
-(void)creatUI{

    
//    self.backgroundColor = [UIColor redColor];
    self.circleView = [[UIView alloc]init];
    self.circleView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.circleView.layer.borderWidth = 2;
    [self addSubview:self.circleView];
    
    self.label = [[UILabel alloc]init];
    self.label.font = [UIFont systemFontOfSize:10];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_label];
    
}



-(void)upItemsFrame{
    
    _label.frame = CGRectMake(0, 0, self.frame.size.width, 30);
    _circleView.frame = CGRectMake(0, 0, _widthCircle, _widthCircle);
    _circleView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height-_widthCircle/2);
    _circleView.layer.cornerRadius = _widthCircle/2;
 
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
