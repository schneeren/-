//
//  PieChart.m
//  ZhuzhuangYuanbing
//
//  Created by renshen on 2017/5/9.
//  Copyright © 2017年 renshen. All rights reserved.
//

#import "PieChart.h"
#import "CustomShapeLayer.h"
@interface PieChart ()<CAAnimationDelegate>
@property(nonatomic,strong)NSMutableArray *PercentageArray;//百分比数组
@property(nonatomic,strong)NSMutableArray *CAShapeLayerArray;//圆饼的各个部分
@property(nonatomic,strong)NSMutableArray *BezerArray;//绘制圆饼的bezer
@property(nonatomic,strong)NSMutableArray *MaskLayerArray;//这招动画层的数组
@property(nonatomic,strong)UIBezierPath *Allpath;//绘制一个完整的圆，提供给点击事件的处理
@property(nonatomic)BOOL haveSelect;
@end

@implementation PieChart

-(instancetype)initWithFrame:(CGRect)frame{
    self= [super initWithFrame:frame];
    if (self) {
     _pieCenter = CGPointMake(frame.size.width/2, frame.size.height/2);
     
    }
    return self;
}
-(void)drawRect:(CGRect)rect{
    [self upDatePieChart];
}

#pragma mark -----更新数据源，变更数据以后需要调用该方法-----
-(void)upDatePieChart{
    
    for (CustomShapeLayer *shapelayer in _CAShapeLayerArray) {
        [shapelayer removeFromSuperlayer];
    }
    for (CAShapeLayer *maskLayer  in _MaskLayerArray) {
        [maskLayer removeFromSuperlayer];
    }
    _Allpath = nil;
    [self drawPieChart];
}
#pragma mark -----设置选择的圆饼-----

/**默认选择的圆饼区域,从1开始计数，当为0时候默认为没有选择的区域*/
-(void)setSelecNum:(int)selecNum{
    _selecNum = selecNum;
    [self touchShapeLayer:selecNum];
}

#pragma mark -----获取半径-----
-(CGFloat )GetPieRadius{
    
    CGFloat weith = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    //出去当前view所能容纳的最大的半径
    CGFloat maxRadius = weith/2>height/2?height/2:weith/2;
    CGFloat pieRadius = 0.0;
    if (_pieRadius > 0 ) {
        //当用户设定过半径以后，优先取用户半径，然后将设置的半径与当前所能容纳最大半径对比，取出值
        pieRadius = _pieRadius>maxRadius?maxRadius:_pieRadius;
        return pieRadius;
    }
    //当用户没有设定半径时候，默认绘制最大的圆
    return maxRadius;
}

-(void)getIrregularPiechatRadiusArray{
    _radiusArray = [NSMutableArray array];
    //根据百分比来计算当前半径
    NSArray *result = [_PercentageArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        NSLog(@"%@~%@",obj1,obj2);
        
        return [obj2 compare:obj1]; //降序
        
    }];
    
    NSLog(@"result=%@",result);
    CGFloat maxRadies = [self GetPieRadius];
    for (int i = 0; i<_PercentageArray.count; i++) {
        
        id percentage = _PercentageArray[i] ;
        
        NSInteger index = [result indexOfObject:percentage];
        
        CGFloat radiusPercentage = 1-0.15*index;
        NSLog(@"radiusPercentage---%f",radiusPercentage);
        CGFloat currentRadius = maxRadies *radiusPercentage;
        [_radiusArray addObject:@(currentRadius)];
    }
    
}

#pragma mark-----设置完数据源以后，自动计算数据源内各个部分所占百分比------
-(void)setDataSource:(NSArray *)dataSource{
    _dataSource = [NSArray arrayWithArray:dataSource];
    [self getPercentageData];
}
//获取各个部分所占取的百分比
-(void)getPercentageData{
    CGFloat totalValue = 0.0;
    _PercentageArray = [NSMutableArray array];
    for (NSDictionary *dic in _dataSource) {
        CGFloat value = [dic[dic.allKeys[0]] floatValue];
        totalValue +=value;
    }
    for (NSDictionary *dic in _dataSource) {
        CGFloat value = [dic[dic.allKeys[0]] floatValue];
        
        [_PercentageArray addObject:@(value/totalValue)];
    }
    NSLog(@"_PercentageArray-----%@",_PercentageArray);
    if (self.irregularPiechat) {
        if (!_radiusArray) {
            [self getIrregularPiechatRadiusArray];
        }
    }
}

#pragma mark-----获取数据内各个部分所占的度数------
//获取度数
-(CGFloat )getTheDegreeOfAngleWithPercentage:(CGFloat )Percentage{
    return Percentage*M_PI*2;
}


#pragma mark-----绘制圆饼-----
-(void)drawPieChart{
    _CAShapeLayerArray = [NSMutableArray array];
    _BezerArray = [NSMutableArray array];
    CGFloat radius =  [self GetPieRadius];//绘制的圆半径
    CGFloat beginPercentage = self.beginPercentage;

    for (int i = 0; i<_PercentageArray.count; i++) {
        
        CGFloat Percentage = [_PercentageArray[i] floatValue];
        
        UIColor *color = [self swichColorWithNumb:i];//获取颜色
        CGFloat angleValue = [self getTheDegreeOfAngleWithPercentage:Percentage];//获取角度
        CGFloat endAngle = beginPercentage + angleValue;//结束角度
        //绘制圆饼路径
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:_pieCenter];
        CGFloat currentRadius = radius;
        if (_irregularPiechat) {
            currentRadius = [_radiusArray[i] floatValue];
        }
        
        [bezierPath addArcWithCenter:_pieCenter radius:currentRadius startAngle:beginPercentage+_pieInterval endAngle:endAngle-_pieInterval clockwise:YES];
        [bezierPath addArcWithCenter:_pieCenter radius:_spaceRadius startAngle:endAngle-_pieInterval endAngle:beginPercentage+_pieInterval clockwise:NO];
        //添加到圆心直线
        [bezierPath addLineToPoint:_pieCenter];
        //路径闭合
        [bezierPath closePath];
        //绘制基于上面bezer路径圆饼的layer
        CustomShapeLayer *layer = [CustomShapeLayer layer];
        layer.radius = currentRadius;
        layer.spaceRadius = _spaceRadius;
        layer.pieInterval = _pieInterval;
        layer.beginPercentage = beginPercentage;
        layer.endPercentage = endAngle;
        layer.centerPoint = _pieCenter;
        layer.path = bezierPath.CGPath;
        layer.offset = _offset;
        layer.fillColor = CGColorCreateCopyWithAlpha(color.CGColor, 1.0);
        [self.layer addSublayer:layer];
        [_CAShapeLayerArray addObject:layer];
        //遮罩层的bezer
        UIBezierPath *coverPath = [UIBezierPath bezierPathWithArcCenter:_pieCenter radius:radius startAngle:beginPercentage endAngle:endAngle clockwise:YES];
        [_BezerArray addObject:coverPath];
        beginPercentage = endAngle;
    }
    _Allpath = [UIBezierPath bezierPathWithArcCenter:_pieCenter radius:radius+_offset startAngle:0 endAngle:M_PI*2 clockwise:YES];

    _MaskLayerArray = [NSMutableArray array];
    if (self.haveAnimation) {
        if (_AsingleAnimation) {
            //单个动画事件
            UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:_pieCenter radius:radius startAngle:_beginPercentage endAngle:M_PI*2+_beginPercentage clockwise:YES];;
            CAShapeLayer *layer = [CAShapeLayer layer];
            layer.lineWidth = [self GetPieRadius]*2;
            layer.strokeStart = 0;
            layer.strokeEnd = 0;
            layer.strokeColor = [UIColor blackColor].CGColor;
            layer.fillColor = [UIColor clearColor].CGColor;
            layer.path = path.CGPath;
            self.layer.mask = layer;
            [_MaskLayerArray addObject:layer];
            [self doMultipleAnimationWithMaskLayer:layer];
        }else{
            //多个动画事件
        for (int i = 0 ; i<_CAShapeLayerArray.count; i++) {
            //设置遮罩层，并开始动画
            CAShapeLayer *shapeLayer = _CAShapeLayerArray[i];
            
            UIBezierPath *path = _BezerArray[i];
            CAShapeLayer *layer = [CAShapeLayer layer];
            layer.lineWidth = [self GetPieRadius]*2;
            layer.strokeStart = 0;
            layer.strokeEnd = 0;
            layer.strokeColor = [UIColor blackColor].CGColor;
            layer.fillColor = [UIColor clearColor].CGColor;
            layer.path = path.CGPath;
            shapeLayer.mask = layer;
             [_MaskLayerArray addObject:layer];
            [self doMultipleAnimationWithMaskLayer:layer];
        }
        }
        if (!(_selecNum == 0)) {
            //设置默认选择的圆饼
                if (_animationTime==0) {
                    _animationTime = 2;
                }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_animationTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self touchShapeLayer:_selecNum];
            });
        }
    }
}


#pragma mark-------动画------
-(void)doMultipleAnimationWithMaskLayer:(CAShapeLayer * )layer{
    CABasicAnimation *pathAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    if (_animationTime>0) {
       pathAnima.duration = _animationTime;
    }else{
        pathAnima.duration = 2.0f;
    }
    pathAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnima.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnima.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnima.removedOnCompletion = NO;
    pathAnima.delegate = self;
    [layer addAnimation:pathAnima forKey:@"strokeEndAnimation"];
    layer.strokeEnd = 1;
}

#pragma mark------点击事件------
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_canSelect) {
        CGPoint touchPoint = [[touches anyObject] locationInView:self];
        [self touchPoint:touchPoint];
    }
    
}
//点击时候的调用方法
-(void)touchPoint:(CGPoint )touchPoint {
    
    if (!CGPathContainsPoint(_Allpath.CGPath, 0, touchPoint, YES)) {
        //圆饼以外不触发点击事件，如果需要，注销这个判断
        return;
    }
    for (CustomShapeLayer *shapeLayer in _CAShapeLayerArray) {
        if (CGPathContainsPoint(shapeLayer.path, 0, touchPoint, YES)) {
            [self selectShareLayer:shapeLayer];
        }
    }
}
//直接设定某个选择区域的调用方法
-(void)touchShapeLayer:(int )selecNum{
    if (_selecNum>0) {
        CustomShapeLayer *shapeLayer = _CAShapeLayerArray[selecNum-1];
        [self selectShareLayer:shapeLayer];
    }else{
        [self selectShareLayer:nil];
    }
}
//具体选中区域圆饼的动画实现方法
-(void)selectShareLayer:(CustomShapeLayer *)shapeLayer{

    for (CustomShapeLayer *Layer in _CAShapeLayerArray) {
        if (Layer == shapeLayer) {
            NSUInteger index = [_CAShapeLayerArray indexOfObject:shapeLayer];
            if (_canSelect) {
                shapeLayer.isSelect = !shapeLayer.isSelect;
            }
            if ([_delegate respondsToSelector:@selector(PieChartTouchIndex:AndData:)]) {
                [_delegate PieChartTouchIndex:index AndData:_dataSource[index]];
            }
        }else{
            //判断是否允许多选
            if (!_canMultiselect) {
                Layer.isSelect = NO;
            }
            if (shapeLayer == nil) {
                Layer.isSelect = NO;
            }
        }
    }
}
#pragma mark-----获取颜色------
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

@end
