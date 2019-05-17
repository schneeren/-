//
//  ViewController.m
//  ZhuzhuangYuanbing
//
//  Created by renshen on 2017/5/9.
//  Copyright © 2017年 renshen. All rights reserved.
//

#import "ViewController.h"
#import "ColumnarView.h"
#import "PieChart.h"
#import "LineChartView.h"
#import "LineChartBGView.h"

@interface ViewController ()<PieChartDelegate,ColumnarViewDelegate,LineChartBGViewDelegate>

@property (nonatomic, strong) ColumnarView *columnarV;//柱状图

@property (nonatomic, strong) PieChart *pieChart;

@property (nonatomic, strong) LineChartView *lineChartView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (strong, nonatomic)  LineChartBGView *scrollViewline;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self initData];
}
-(void)creatUI{
    self.view.backgroundColor = [UIColor lightGrayColor];
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_scrollView];
    
    _columnarV = [[ColumnarView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 400)];
    [_scrollView addSubview:_columnarV];
    
     _pieChart = [[PieChart alloc]initWithFrame:CGRectMake(100, 450, 100, 150)];
    _pieChart.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_pieChart];
    
    _lineChartView = [[LineChartView alloc]initWithFrame:CGRectMake(0, 650, [UIScreen mainScreen].bounds.size.width, 150)];
    
    [_scrollView addSubview:_lineChartView];
    
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width,1100);
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50, 400, 100, 30)];
    [button setTitle:@"刷新数据" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touch:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [_scrollView addSubview:button];
    
    
    _scrollViewline = [[LineChartBGView alloc ]initWithFrame:CGRectMake(0, 850, [UIScreen mainScreen].bounds.size.width, 200)];
  
    [_scrollView addSubview:_scrollViewline];
    _scrollViewline.delegate = self;
    
}
-(void)initData{
    
    //画圆柱
    _columnarV.dataSource = @[@{@"1月":@"1"},@{@"2月":@"2"},@{@"3月":@"4"},@{@"4月":@"8"},@{@"5月":@"8"}];
    _columnarV.widthColumnar = 50;
    _columnarV.selectColor = [UIColor redColor];
    _columnarV.delegate = self;
    
    
    //画饼状图
    _pieChart.dataSource = @[@{@"1月":@"10"},@{@"2月":@"10"},@{@"3月":@"20"},@{@"1月":@"100"},@{@"2月":@"50"},@{@"3月":@"60"}];
    _pieChart.haveAnimation = YES;
    _pieChart.spaceRadius = 30;
    _pieChart.pieRadius = 50;
//    _pieChart.pieInterval = 0.01;
    _pieChart.delegate = self;
    _pieChart.canSelect = YES;
    _pieChart.AsingleAnimation = NO;
    _pieChart.offset = 20;
    _pieChart.backgroundColor = [UIColor clearColor];
    
    //画折线图
    
    _lineChartView.dataSource = @[@{@"1月":@"10"},@{@"2月":@"10"},@{@"3月":@"20"},@{@"1月":@"10"},@{@"2月":@"50"},@{@"3月":@"100000"}];
    _lineChartView.needXYShaft = NO;
    _lineChartView.lineType = DottedLine;
    _lineChartView.backgroundColor = [UIColor whiteColor];
    
    

    _scrollViewline.dataSourceArray = @[@{@"1月":@"10"},@{@"2月":@"10"},@{@"3月":@"20"},@{@"1月":@"10"},@{@"2月":@"50"},@{@"3月":@"60"}];
    
    [_scrollViewline.lineChartView updateLineChart];
    [_scrollViewline.scrollView setContentOffset:CGPointMake(6*pageW, 0) animated:YES];
    
}

- (IBAction)touch:(id)sender {
     int i ;
    static BOOL demo;
    if (demo) {
        _columnarV.dataSource = @[@{@"1月":@"100"},@{@"2月":@"200"},@{@"3月":@"400"},@{@"4月":@"1000"},@{@"5月":@"800"}];
        _columnarV.colorArry = @[[UIColor redColor],[UIColor blackColor],[UIColor yellowColor]];
        [_columnarV updateColumnar];
        i = 1;
    }else{
    _columnarV.dataSource = @[@{@"6月":@"1900"}];
        _columnarV.colorArry = @[[UIColor redColor]];
        [_columnarV updateColumnar];
        i = 3;
    }
    demo = !demo;
     _pieChart.dataSource = @[@{@"1月":@"130"},@{@"2月":@"120"},@{@"3月":@"30"}];
//    _pieChart.selecNum = i;
    _pieChart.AsingleAnimation = YES;
    [_pieChart upDatePieChart];
    
}
-(void)touchIndex:(NSInteger)index WithSelectViewArray:(NSMutableArray *)selectViewArray{
    
    NSLog(@"index---%ld",(long)index);

    
    
    [_scrollViewline.scrollView setContentOffset:CGPointMake(index*pageW, 0) animated:YES];
    
}
//饼状图代理方法
-(void)PieChartTouchIndex:(NSUInteger)index AndData:(NSDictionary *)dataDic{
    NSLog(@"index-----%lu\ndatadic---%@",(unsigned long)index,dataDic);
}
//柱状图代理方法
-(void)ColumnarTouchIndex:(NSUInteger)index AndData:(NSDictionary *)dataDic{
    NSLog(@"index-----%lu\ndatadic---%@",(unsigned long)index,dataDic);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
