//
//  LineChartBGView.m
//  ZYMirror
//
//  Created by renshen on 2018/4/15.
//  Copyright © 2018年 qiuhaixia. All rights reserved.
//
#define  UISCreenW  [UIScreen mainScreen].bounds.size.width

#define  UISCreenH  [UIScreen mainScreen].bounds.size.height
#import "LineChartBGView.h"

#define selfH 206

@interface LineChartBGView()<LineChartViewDelegate>


@end
@implementation LineChartBGView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self creatUI];
    
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}
-(void) creatUI{
    
//    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event:)];
    
//    [self addGestureRecognizer:tapGesture];
//
//    [tapGesture setNumberOfTapsRequired:1];
    
    
    CGFloat H = selfH-33;
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(UISCreenW/2-pageW/2, 33, pageW,H )];
    
    
    _scrollView.pagingEnabled = YES;
    _scrollView.clipsToBounds = NO;
    
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(pageW*5, H);
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator =NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    UIView *maskView = [[UIView alloc]initWithFrame:CGRectMake(UISCreenW/2-45/2, 33, 45, H)];
    maskView.backgroundColor = [UIColor whiteColor];
    maskView.alpha = 0.2;
    maskView.userInteractionEnabled = NO;
    [self addSubview:maskView];
    
    _lineChartView = [[LineChartView alloc]initWithFrame:CGRectMake(0, 0, pageW*5, H)];
    _lineChartView.delegate = self;

    _lineChartView.lineType = 0;
    _lineChartView.needXYShaft = NO;
//    _lineChartView.lineColor = [UIColor colorWithHexString:@"#98DCD2"];
    _lineChartView.circleColor = [UIColor whiteColor];
    _lineChartView.widthCircle = 10;
    _lineChartView.rightSpacing = pageW/2;
    _lineChartView.MaxValue = 100;
    _lineChartView.leftSpacing = pageW/2;
    [_scrollView addSubview:_lineChartView];
    
   
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
////    gradientLayer.colors = @[(__bridge id)HEXColor(@"6575f7").CGColor, (__bridge id)HEXColor(@"23adcf").CGColor];
//    gradientLayer.startPoint = CGPointMake(0, 1);
//    gradientLayer.endPoint = CGPointMake(1, 0);
//    gradientLayer.frame = CGRectMake(0, 0, UISCreenW, self.size.height);
//    [self.layer insertSublayer:gradientLayer atIndex:0];
    
    
}
-(void)setDataSourceArray:(NSArray *)dataSourceArray{
    
    _dataSourceArray = dataSourceArray;
    _lineChartView.frame = CGRectMake(0, 0, pageW*dataSourceArray.count, selfH-33);
    _scrollView.contentSize = CGSizeMake(pageW*dataSourceArray.count, selfH-33);
    _lineChartView.dataSource = dataSourceArray;
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isEqual:self]){
        for (UIView *subview in _scrollView.subviews){
            CGPoint offset = CGPointMake(point.x - _scrollView.frame.origin.x + _scrollView.contentOffset.x - subview.frame.origin.x, point.y - _scrollView.frame.origin.y + _scrollView.contentOffset.y - subview.frame.origin.y);
            
            if ((view = [subview hitTest:offset withEvent:event])){
                return view;
            }
        }
        return _scrollView;
    }
    return view;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (_dataSourceArray.count==0) {
        return;
    }
    NSInteger index = scrollView.contentOffset.x/pageW;
    
    [_lineChartView selectIndex:index];
}
-(void)touchIndex:(NSInteger)index WithSelectViewArray:(NSMutableArray *)selectViewArray{
    
    
    [_scrollView setContentOffset:CGPointMake(index*pageW, 0) animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(touchIndex:WithSelectViewArray:)]) {
        [self.delegate touchIndex:index WithSelectViewArray:selectViewArray];
    }
    
}
//-(void)event:(UITapGestureRecognizer *)gesture{

//    CGPoint point1 = [gesture locationInView:_scrollView];

//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
