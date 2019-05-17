//
//  ColumnarView.m
//  YGBKit
//
//  Created by renshen on 2017/5/3.
//  Copyright © 2017年 liuli. All rights reserved.
//

#import "LineChartView.h"
#import "LineItem.h"

#define Yspacing (self.frame.size.height-TopSpacing-BoomSpacing)/5//Y轴坐标间距
#define WCircle self.widthCircle//item宽度
#define RightSpacing self.rightSpacing//坐标到右边间距
#define LeftSpacing  self.leftSpacing//坐标到左边间距
#define TopSpacing 30//坐标到顶部间距
#define BoomSpacing 33//坐标到底部间距


@interface LineChartView ()

@property (nonatomic, strong) NSArray *yUnit;//Y轴单位

@property (nonatomic, strong) NSMutableArray *xUnit;//X轴单位

@property (nonatomic, strong) NSMutableArray *touchViews;//点击的按钮

@property (nonatomic )CGFloat xsapcing;

@end

@implementation LineChartView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _dataSource = [NSArray array];
        _widthCircle = 10;
        _needXYShaft = YES;
        _rightSpacing = 30;
        _leftSpacing = 30;
        _lineColor = [self loadRandomColor];
        _circleColor = [self loadRandomColor];
        _itemLabelColor = [UIColor blackColor];
        _lineLabelColor = [UIColor blackColor];
        _lineType = SolidLine;
        _touchViews = [NSMutableArray array];
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    if (_dataSource.count==0) {
        return;
    }
    if (_needXYShaft) {
        _xsapcing = (self.frame.size.width-RightSpacing -LeftSpacing- WCircle*_dataSource.count) / (_dataSource.count+1);
    }else{
        
        _xsapcing = (self.frame.size.width-RightSpacing -LeftSpacing) / (_dataSource.count-1);
        if (_dataSource.count == 1) {
            _xsapcing = RightSpacing;
        }
    }
    CGContextRef ref=UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(ref, 0.5);
   
//    //绘制Y轴内容
    [self getYunit];
//
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    if (_needXYShaft) {
        //绘制Y轴线
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
        
        
        
        for (int i=0; i<6; i++) {
            NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:13],NSParagraphStyleAttributeName:paragraph,NSForegroundColorAttributeName:_lineLabelColor};
            paragraph.alignment = NSTextAlignmentRight;
            NSString *str =[NSString stringWithFormat:@"%@",_yUnit[i]];
            [str drawInRect:CGRectMake(0,  rect.size.height-(BoomSpacing+Yspacing*i+15), LeftSpacing-5, 30) withAttributes:attribute];
        }

    }
    //    //绘制X轴内容
    [self getXunit];
    for (int i = 0 ; i<_xUnit.count; i++) {
        NSString *xStr = _xUnit[i];
        NSLog(@"xStr---%@",xStr);
        NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:13],NSParagraphStyleAttributeName:paragraph,NSForegroundColorAttributeName:_lineLabelColor};
        paragraph.alignment = NSTextAlignmentCenter;
        if (_needXYShaft) {
        [xStr drawInRect:CGRectMake(LeftSpacing+_xsapcing/2+5+i*(WCircle+_xsapcing), rect.size.height-BoomSpacing+5, WCircle+_xsapcing-10, BoomSpacing-10) withAttributes:attribute];
        }else{
        if (i == 0) {
            if (_dataSource.count==1) {
                [xStr drawInRect:CGRectMake(0, rect.size.height-BoomSpacing+5, rect.size.width, BoomSpacing-10) withAttributes:attribute];
                
            }else{
                [xStr drawInRect:CGRectMake(LeftSpacing-_xsapcing/2, rect.size.height-BoomSpacing+5, _xsapcing-10, BoomSpacing-10) withAttributes:attribute];
            }
        }else{
        [xStr drawInRect:CGRectMake(LeftSpacing+_xsapcing/2+5+(i-1)*_xsapcing, rect.size.height-BoomSpacing+5, _xsapcing-10, BoomSpacing-10) withAttributes:attribute];
        }
        }
    }
    //画折现
    [self removeLineChat];
    NSMutableArray *points = [NSMutableArray array];
    for (int i = 0; i<_dataSource.count; i++) {
        NSDictionary *dic = _dataSource[i];
        CGFloat value = [dic[dic.allKeys[0]] floatValue];
        CGFloat height = (value/_MaxValue*(self.frame.size.height-TopSpacing-BoomSpacing));
        CGRect circleRect;
        CGPoint point;
        CGFloat itemX;
   
        if (_needXYShaft) {
             circleRect = CGRectMake(LeftSpacing+_xsapcing+(WCircle+_xsapcing)*i, rect.size.height-BoomSpacing-0.5, WCircle, -height);
            itemX = LeftSpacing+_xsapcing+(WCircle+_xsapcing)*i;
            CGRectMake(circleRect.origin.x-_xsapcing/2,circleRect.origin.y+circleRect.size.height-35,WCircle+_xsapcing,30);
            point = CGPointMake(LeftSpacing+_xsapcing+(WCircle+_xsapcing)*i+WCircle/2, rect.size.height-BoomSpacing-0.5-height);
            
           
        }else{

            point = CGPointMake(LeftSpacing+i*_xsapcing, rect.size.height-BoomSpacing-0.5-height);
            itemX = LeftSpacing+i*_xsapcing-WCircle/2;
        }
        CGFloat itemHeight = _widthCircle+30;
        circleRect = CGRectMake(itemX-_xsapcing/2, rect.size.height-BoomSpacing-0.5-height-itemHeight+_widthCircle/2, WCircle+_xsapcing, itemHeight);
        NSValue *pointValue = [NSValue valueWithCGPoint:point];
        [points addObject:pointValue];
        [self draWCircleWithRect:circleRect withTag:200000+i AndColor:[self swichColorWithNumb:i]WithTitle:dic[dic.allKeys[0]]];
    }
    
    for (int i = 0; i<points.count; i++) {
        CGContextSetLineWidth(ref, 2);
        NSValue *RectValue = points[i];
        CGPoint point = [RectValue CGPointValue];
        
        switch (_lineType) {
            case SolidLine:{
                CGContextAddLineToPoint(ref,point.x,point.y );
                [_lineColor set];
                CGContextStrokePath(ref);
                CGContextMoveToPoint(ref,point.x,point.y );
            }
            break;
            case DottedLine:{
                CGContextAddLineToPoint(ref,point.x,point.y );
                CGFloat arr[] = {5,5};
                [_lineColor set];
                //  context : 上下文
                //  phase :  第一个点绘制的时候，跳过多少点
                //
                //  lengths: 数组， 如果交替绘制 @{10,10}， 这意思就是先绘制10个点， 再跳过10个点的实现，以此类推， 如果是 @{10，50，20}， 则意思变成 先绘制10个点， 再跳过50个点，再绘制20个点， 在跳过10个点，再绘制50个点，以此类推。
                //   count : lengths数组长度
                CGContextSetLineDash(ref, 0, arr, 2);
                CGContextDrawPath(ref, kCGPathStroke);
                CGContextStrokePath(ref);
                CGContextMoveToPoint(ref,point.x,point.y );
            }
            break;
            case SolidAndDottedLine:{
                if (i == 0) {
                    CGContextMoveToPoint(ref,point.x,point.y );
                }else{
                    
                    if (i == points.count-1) {
                        CGContextAddLineToPoint(ref,point.x,point.y );
                        CGFloat arr[] = {5,5};
                        [_lineColor set];
                        //  context : 上下文
                        //  phase :  第一个点绘制的时候，跳过多少点
                        //
                        //  lengths: 数组， 如果交替绘制 @{10,10}， 这意思就是先绘制10个点， 再跳过10个点的实现，以此类推， 如果是 @{10，50，20}， 则意思变成 先绘制10个点， 再跳过50个点，再绘制20个点， 在跳过10个点，再绘制50个点，以此类推。
                        //   count : lengths数组长度
                        CGContextSetLineDash(ref, 0, arr, 2);
                        CGContextDrawPath(ref, kCGPathStroke);
                        CGContextStrokePath(ref);
                    }else{
                        CGContextAddLineToPoint(ref,point.x,point.y );
                        [_lineColor set];
                        CGContextStrokePath(ref);
                        CGContextMoveToPoint(ref,point.x,point.y );
                    }
                }
            }
                break;
            default:
                break;
        }
       
    }
    
    [self selectIndex:_dataSource.count-1];
}

-(void)setDataSource:(NSArray *)dataSource{
    _dataSource = [NSArray arrayWithArray:dataSource];
}
-(void)updateLineChart{
    [self setNeedsDisplay];
}
//获取Y轴值
-(void)getYunit{
    if (_dataSource.count==0) {
        _MaxValue = 0;
        _yUnit = @[@0,@0,@0,@0,@0];
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
    int a = maxValue % 5 >0?maxValue/5+1:maxValue/5;
    maxValue = a*5;
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
-(void)draWCircleWithRect:(CGRect )circleRect withTag:(NSInteger)tag AndColor:(UIColor *)color WithTitle:(NSString *)NumTitle{
    
    LineItem *item = [[LineItem alloc]initWithFrame:circleRect];
    item.label.text = NumTitle;
    item.label.textColor = _itemLabelColor;
    item.circleView.backgroundColor = _circleColor;
    item.widthCircle = _widthCircle;
    [self addSubview:item];
    item.tag = tag+1;
    [item upItemsFrame];
    [item addTarget:self action:@selector(touchCircle:) forControlEvents:UIControlEventTouchUpInside];
    return;
    
    
    
    
}
-(void)selectIndex:(NSInteger)index{
    
    LineItem *item = [self viewWithTag:index+1+200000];
    [self touchCircle:item];
}
-(void)touchCircle:(LineItem *)item{

    if (item.selected) {
        
        return;
    }
    
    if (_touchViews.count == 1) {
        LineItem *beforeItem = _touchViews[0];
        
        beforeItem.selected = NO;
        beforeItem.circleView.transform = CGAffineTransformIdentity;
        beforeItem.label.font = [UIFont systemFontOfSize:10];
        [_touchViews removeAllObjects];
    }

    NSInteger index = item.tag-1-200000;
    
    if (!_touchViews) {
        _touchViews = [NSMutableArray array];
    }
    
    [_touchViews addObject:item];
    item.selected = YES;
    
    [UIView animateWithDuration:0.2 animations:^{
        item.circleView.transform = CGAffineTransformMakeScale(1.7, 1.7);
        item.label.font = [UIFont systemFontOfSize:20];
    }];
    
    if ([_delegate respondsToSelector:@selector(touchIndex:WithSelectViewArray:)]) {
        
        [_delegate touchIndex:index WithSelectViewArray:_touchViews];
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
-(void)removeLineChat{
    for (UIButton *circleBTN in self.subviews) {
        [circleBTN removeFromSuperview];
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
