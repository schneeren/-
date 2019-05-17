//
//  ColumnarView.m
//  YGBKit
//
//  Created by renshen on 2017/5/3.
//  Copyright © 2017年 非大鱼. All rights reserved.
//

#import "ColumnarView.h"
#define Yspacing (self.frame.size.height-TopSpacing-BoomSpacing)/5//Y轴坐标间距
#define Xspacing (self.frame.size.width-RightSpacing -LeftSpacing- Wzhuzhuang*_dataSource.count) / (_dataSource.count+1)//柱状图间距
#define Wzhuzhuang self.widthColumnar//柱状图宽度
#define RightSpacing 25//坐标到右边间距
#define LeftSpacing  50//坐标到左边间距
#define TopSpacing 50//坐标到顶部间距
#define BoomSpacing 50//坐标到底部间距
@interface ColumnarView ()
@property (nonatomic,strong)NSArray *yUnit;//Y轴单位
@property (nonatomic,strong)NSMutableArray *xUnit;
@property (nonatomic)CGFloat MaxValue;
@end
@implementation ColumnarView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _dataSource = [NSArray array];
        _widthColumnar = 40;
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    
    CGContextRef ref=UIGraphicsGetCurrentContext();
    //绘制Y轴线
    CGContextSetLineWidth(ref, 0.5);
    [[UIColor blackColor]set];
    CGContextMoveToPoint(ref, LeftSpacing, TopSpacing-15);
    CGContextAddLineToPoint(ref, LeftSpacing,self.frame.size.height-BoomSpacing);
    CGContextAddLineToPoint(ref, self.frame.size.width -RightSpacing , rect.size.height-BoomSpacing);
    CGContextStrokePath(ref);
    //画X轴三角
    CGContextMoveToPoint(ref, self.frame.size.width -RightSpacing, rect.size.height-BoomSpacing-4);
    CGContextAddLineToPoint(ref, self.frame.size.width -RightSpacing+4,rect.size.height-BoomSpacing);
    CGContextAddLineToPoint(ref, self.frame.size.width -RightSpacing , rect.size.height-BoomSpacing+4);
    [[UIColor blackColor]set];
    CGContextStrokePath(ref);
    
    //绘制Y轴内容
    [self getYunit];
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
   
    
    for (int i=0; i<6; i++) {
        NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSParagraphStyleAttributeName:paragraph,NSForegroundColorAttributeName:[UIColor grayColor]};
        paragraph.alignment = NSTextAlignmentRight;
        NSString *str =[NSString stringWithFormat:@"%@",_yUnit[i]];
        [str drawInRect:CGRectMake(0,  rect.size.height-(BoomSpacing+Yspacing*i+15), LeftSpacing-5, 30) withAttributes:attribute];
    }
    //绘制X轴内容
    [self getXunit];
    for (int i = 0 ; i<_xUnit.count; i++) {
        NSString *xStr = _xUnit[i];
        NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:paragraph,NSForegroundColorAttributeName:[UIColor grayColor]};
         paragraph.alignment = NSTextAlignmentCenter;
        [xStr drawInRect:CGRectMake(LeftSpacing+Xspacing/2+5+i*(Wzhuzhuang+Xspacing), rect.size.height-BoomSpacing+5, Wzhuzhuang+Xspacing-10, BoomSpacing-10) withAttributes:attribute];
    }
    //画圆柱
    [self removeZhuzhuang];
    for (int i = 0; i<_dataSource.count; i++) {
        NSDictionary *dic = _dataSource[i];
        CGFloat value = [dic[dic.allKeys[0]] floatValue];
        CGFloat height = (value/_MaxValue*(self.frame.size.height-TopSpacing-BoomSpacing));
        CGRect Zhuzhuangrect = CGRectMake(LeftSpacing+Xspacing+(Wzhuzhuang+Xspacing)*i, rect.size.height-BoomSpacing-0.5, Wzhuzhuang, -height);
        
        [self drawZhuZhuangWithRect:Zhuzhuangrect withTag:200000+i AndColor:[self swichColorWithNumb:i]WithTitle:dic[dic.allKeys[0]]];
    }
    
    
    
}
-(void)setDataSource:(NSArray *)dataSource{
    _dataSource = [NSArray arrayWithArray:dataSource];
}
-(void)updateColumnar{
    [self setNeedsDisplay];
}
//获取Y轴值
-(void)getYunit{
    if (_dataSource.count==0) {
        _MaxValue = 0;
        _yUnit = @[@0,@0,@0,@0,@0,@0];
        return;
    }
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in _dataSource) {
        NSString *key = dic.allKeys[0];
        [array addObject:dic[key]];
    }
    //通过比较获取最大值
    int maxValue = [array[0] intValue];
    for(int i = 1 ; i < array.count ; i++){
        
        int compareValue = [array[i] intValue];
        if(maxValue < compareValue){
            maxValue = compareValue;
        }
    }
    int a = maxValue/100+1;
    maxValue = a*100;
    _MaxValue = (CGFloat )maxValue;
    int average  = maxValue/5;
    _yUnit = @[@0,@(average*1),@(average*2),@(average*3),@(average*4),@(average*5)];
}
-(void)getXunit{
    if (_dataSource.count == 0) {
        _xUnit = [NSMutableArray array];
        return;
    }
    _xUnit = [NSMutableArray array];
    for (NSDictionary *dic in _dataSource) {
        [_xUnit addObject:dic.allKeys[0]];
    }
}
-(void)drawZhuZhuangWithRect:(CGRect )Zhuzhuangrect withTag:(NSInteger)tag AndColor:(UIColor *)color WithTitle:(NSString *)NumTitle{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = color;
    button.frame = CGRectMake(Zhuzhuangrect.origin.x, Zhuzhuangrect.origin.y,Wzhuzhuang, 0);
    button.tag = tag;
    [button addTarget:self action:@selector(touchZhuzhuang:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(Zhuzhuangrect.origin.x-Xspacing/2,Zhuzhuangrect.origin.y-30,Wzhuzhuang+Xspacing,30)];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.tag = tag*100;
    label.text = NumTitle;
    [self addSubview:label];
    [self addSubview:button];
    [UIView animateWithDuration:1.0 animations:^{
        button.frame = Zhuzhuangrect;
        label.frame = CGRectMake(Zhuzhuangrect.origin.x-Xspacing/2,Zhuzhuangrect.origin.y+Zhuzhuangrect.size.height-30,Wzhuzhuang+Xspacing,30);
    }];
    
}

-(void)touchZhuzhuang:(UIButton *)button{
    NSInteger num = button.tag - 200000;
    if ([_delegate respondsToSelector:@selector(ColumnarTouchIndex:AndData:)]) {
        [_delegate ColumnarTouchIndex:num AndData:_dataSource[num]];
    }
}

//获取颜色，如果没有设置颜色数组，则为随机颜色
-(UIColor *)swichColorWithNumb:(int )num{
    if (_colorArry.count>num) {
        return _colorArry[num];
    }
    return [self loadRandomColor];
}
- (UIColor *)loadRandomColor
{
    CGFloat red = [self getRandomNumber:1 to:255];
    CGFloat green = [self getRandomNumber:1 to:255];
    CGFloat blue = [self getRandomNumber:1 to:255];
    
    UIColor *color = [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1.0];
    
    return color;
}

- (int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from)));
}
-(void)removeZhuzhuang{
    for (UIButton *zhuzhuangBTN in self.subviews) {
        [zhuzhuangBTN removeFromSuperview];
    }
    for (UILabel *label in self.subviews) {
        [label removeFromSuperview];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
