//
//  DashBoardTableViewCell.m
//  Mimamoro
//
//  Created by totyu1 on 2015/12/15.
//  Copyright © 2015年 totyu1. All rights reserved.
//

#import "DashBoardTableViewCell.h"
#import "UUChart.h"

@interface DashBoardTableViewCell()<UUChartDataSource,UIScrollViewDelegate>{
    NSIndexPath *path;
    int type;
    int xnum; //0:1~24時 1:1~7日 2:１〜３０日 　3:１〜１２月
    UUChart *chartview;
    UUChart *chartview2;
    UUChart *chartview3;
    NSArray *dayArr1;
    NSArray *dayArr2;
    NSArray *dayArr3;
    NSMutableArray *weekArr1;
    NSMutableArray *weekArr2;
    NSMutableArray *weekArr3;
    NSMutableArray *monthArr1;
    NSMutableArray *monthArr2;
    NSMutableArray *monthArr3;
    UIPageControl* _page;
 
    
}

@end

@implementation DashBoardTableViewCell
@synthesize currentNo;

- (void)awakeFromNib {
    
    _scoll.bounces = YES; //设定是否可自由拖拽
    _scoll.delegate = self;
    
}

-(void)configUI:(NSIndexPath*)indexPath type:(int)styletype unit:(int)segmentunitnum day1:(NSArray*)day1 week1:(NSMutableArray*)week1 month1:(NSMutableArray*)month1 day2:(NSArray*)day2 week2:(NSMutableArray*)week2 month2:(NSMutableArray*)month2 day3:(NSArray*)day3 week3:(NSMutableArray*)week3 month3:(NSMutableArray*)month3{
    if (self.scoll != nil) {
        [chartview removeFromSuperview];
        [chartview2 removeFromSuperview];
        [chartview3 removeFromSuperview];
    }
    if (!dayArr1) {
        dayArr1 = [[NSArray alloc]init];
    }
    if (!weekArr1) {
        weekArr1 = [[NSMutableArray alloc]init];
    }
    if (!monthArr1) {
        monthArr1 = [[NSMutableArray alloc]init];
    }
    if (!dayArr2) {
        dayArr2 = [[NSArray alloc]init];
    }
    if (!weekArr2) {
        weekArr2 = [[NSMutableArray alloc]init];
    }
    if (!monthArr2) {
        monthArr2 = [[NSMutableArray alloc]init];
    }
    if (!dayArr3) {
        dayArr3 = [[NSArray alloc]init];
    }
    if (!weekArr3) {
        weekArr3 = [[NSMutableArray alloc]init];
    }
    if (!monthArr3) {
        monthArr3 = [[NSMutableArray alloc]init];
    }
    
    if (chartview) {
        [chartview removeFromSuperview];
        chartview =nil;
    }
    NSLog(@"hh=%@",_hhh);
    path = indexPath;
    type = styletype;
    xnum = segmentunitnum;
    dayArr1 = day1;
    dayArr2 = day2;
    dayArr3 = day3;
    weekArr1 = week1;
    weekArr2 = week2;
    weekArr3 = week3;
    monthArr1 = month1;
    monthArr2 = month2;
    monthArr3 = month3;
    NSLog(@"month= %@",monthArr1);
    path = indexPath;
    type = styletype;
    xnum = segmentunitnum;
    
    CGRect frame = CGRectMake(0, self.fff.frame.size.height-13, self.frame.size.width, self.frame.size.height);
    _scoll.frame = frame;
    _scoll.userInteractionEnabled = YES;
    _scoll.showsHorizontalScrollIndicator = NO;
    
    _scoll.contentSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width)*3, 140);
    
    _scoll.contentOffset = CGPointMake(([UIScreen mainScreen].bounds.size.width)*2, 0);
    
    _scoll.pagingEnabled =YES;
    //_scoll.gestureRecognizers
    [self.contentView addSubview:_scoll];
    
    if ([self.hhh isEqualToString:@"ドア"]) {
        if ([self.rrr isEqualToString:@"1"]) {
            chartview =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(5, 5, [UIScreen mainScreen].bounds.size.width-10
                                                                           , 155) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle withid:@"1"];
            
            chartview2 =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake([UIScreen mainScreen].bounds.size.width+5, 5, [UIScreen mainScreen].bounds.size.width-10
                                                                            , 155) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle withid:@"2"];
            
            chartview3 =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width)*2+5, 5, [UIScreen mainScreen].bounds.size.width-10
                                                                            , 155) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle withid:@"3"];
        }else{
            chartview =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(5, 15, [UIScreen mainScreen].bounds.size.width-10
                                                                           , 155) withSource:self withStyle:type==1?UUChartBarStyle:UUChartLineStyle withid:@"1"];
            
            chartview2 =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake([UIScreen mainScreen].bounds.size.width+5, 5, [UIScreen mainScreen].bounds.size.width-10
                                                                            , 155) withSource:self withStyle:type==1?UUChartBarStyle:UUChartLineStyle withid:@"2"];
            
            chartview3 =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width)*2+5, 5, [UIScreen mainScreen].bounds.size.width-10
                                                                            , 155) withSource:self withStyle:type==1?UUChartBarStyle:UUChartLineStyle withid:@"3"];
        }
    }else if([self.hhh isEqualToString:@"電気使用量"]){

        if ([self.rrr isEqualToString:@"1"]) {
            chartview =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(5, 5, [UIScreen mainScreen].bounds.size.width-10
                                                                           , 155) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle withid:@"1"];
            
            chartview2 =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake([UIScreen mainScreen].bounds.size.width+5, 5, [UIScreen mainScreen].bounds.size.width-10
                                                                            , 155) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle withid:@"2"];
            
            chartview3 =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width)*2+5, 5, [UIScreen mainScreen].bounds.size.width-10
                                                                            , 155) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle withid:@"3"];
        }else{
            chartview =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(5, 5, [UIScreen mainScreen].bounds.size.width-10
                                                                           , 155) withSource:self withStyle:type==1?UUChartBarStyle:UUChartLineStyle withid:@"1"];
            
            chartview2 =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake([UIScreen mainScreen].bounds.size.width+5, 5, [UIScreen mainScreen].bounds.size.width-10
                                                                            , 155) withSource:self withStyle:type==1?UUChartBarStyle:UUChartLineStyle withid:@"2"];
            
            chartview3 =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width)*2+5, 5, [UIScreen mainScreen].bounds.size.width-10
                                                                            , 155) withSource:self withStyle:type==1?UUChartBarStyle:UUChartLineStyle withid:@"3"];
            
        }
    }else if([self.hhh isEqualToString:@"マット"]){

        if ([self.rrr isEqualToString:@"1"]) {
            chartview =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(5, 5, [UIScreen mainScreen].bounds.size.width-10
                                                                           , 155) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle withid:@"1"];
            
            chartview2 =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake([UIScreen mainScreen].bounds.size.width+5, 5, [UIScreen mainScreen].bounds.size.width-10
                                                                            , 155) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle withid:@"2"];
            
            chartview3 =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width)*2+5, 5, [UIScreen mainScreen].bounds.size.width-10
                                                                            , 155) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle withid:@"3"];
        }else{
            chartview =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(5, 5, [UIScreen mainScreen].bounds.size.width-10
                                                                           , 155) withSource:self withStyle:type==1?UUChartBarStyle:UUChartLineStyle withid:@"1"];
            
            chartview2 =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake([UIScreen mainScreen].bounds.size.width+5, 5, [UIScreen mainScreen].bounds.size.width-10
                                                                            , 155) withSource:self withStyle:type==1?UUChartBarStyle:UUChartLineStyle withid:@"2"];
            
            chartview3 =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width)*2+5, 5, [UIScreen mainScreen].bounds.size.width-10
                                                                            , 155) withSource:self withStyle:type==1?UUChartBarStyle:UUChartLineStyle withid:@"3"];
            
        }
    }else if([self.hhh isEqualToString:@"照度"]){

        if ([self.rrr isEqualToString:@"1"]) {
            chartview =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(5, 5, [UIScreen mainScreen].bounds.size.width-10
                                                                           , 155) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle withid:@"1"];
            
            chartview2 =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake([UIScreen mainScreen].bounds.size.width+5, 5, [UIScreen mainScreen].bounds.size.width-10
                                                                            , 155) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle withid:@"2"];
            
            chartview3 =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width)*2+5, 5, [UIScreen mainScreen].bounds.size.width-10
                                                                            , 155) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle withid:@"3"];
        }else{
            chartview =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(5, 5, [UIScreen mainScreen].bounds.size.width-10
                                                                           , 155) withSource:self withStyle:type==1?UUChartBarStyle:UUChartLineStyle withid:@"1"];
            
            chartview2 =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake([UIScreen mainScreen].bounds.size.width+5, 5, [UIScreen mainScreen].bounds.size.width-10
                                                                            , 155) withSource:self withStyle:type==1?UUChartBarStyle:UUChartLineStyle withid:@"2"];
            
            chartview3 =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width)*2+5, 5, [UIScreen mainScreen].bounds.size.width-10
                                                                            , 155) withSource:self withStyle:type==1?UUChartBarStyle:UUChartLineStyle withid:@"3"];
            
        }
    }
    
    [chartview showInView:_scoll];
    [chartview2 showInView:_scoll];
    [chartview3 showInView:_scoll];

//    [_scoll setShowsHorizontalScrollIndicator:NO];
//    //设置可滑动的宽度 3*width
//    _scoll.contentSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width)*3, 0);
//    //设置显示当前区域位置 2*width
//    _scoll.contentOffset =CGPointMake([UIScreen mainScreen].bounds.size.width*2, 0);
//    _scoll.pagingEnabled =YES;
    
}



#pragma mark - UIScroll View delegate
//开始拖拽调用
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    NSLog(@"start");
}
//滚动某个位置调用
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    currentNo = _scoll.contentOffset.x/_scoll.frame.size.width;
    float current = _scoll.contentOffset.x/_scoll.frame.size.width;
    NSLog(@"running = %d",currentNo);
    [self passCurrent:current indexPath:path];
}

-(void)passCurrent:(float)current indexPath:(NSIndexPath *)row
{
    
}


// 停止拖拽调用方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView

{
    
    NSLog(@"end");
    int currentPage = (_scoll.contentOffset.x - _scoll.frame.size.width) / _scoll.frame.size.width +1;
    
    //today
    
    NSDate *pickerDate = [NSDate date];
    NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc] init];
    [pickerFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *today = [pickerFormatter stringFromDate:pickerDate];
    
    //yesterday
    
    NSDate *pickerDate2 = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
    NSDateFormatter *pickerFormatter2 = [[NSDateFormatter alloc] init];
    [pickerFormatter2 setDateFormat:@"yyyy年MM月dd日"];
    NSString *yesterday = [pickerFormatter2 stringFromDate:pickerDate2];
    
    //the day before yesterday
    
    NSDate *pickerDate3 = [NSDate dateWithTimeIntervalSinceNow:-(2*24*60*60)];
    NSDateFormatter *pickerFormatter3 = [[NSDateFormatter alloc] init];
    [pickerFormatter3 setDateFormat:@"yyyy年MM月dd日"];
    NSString *byesterday = [pickerFormatter3 stringFromDate:pickerDate3];
    
    
    if (currentPage==0) {
        if (xnum == 0) {
            _fff.text = byesterday;
        }else if(xnum == 1){
            _fff.text = @"先先週";
        }else if(xnum == 2){
            _fff.text = @"先先月";
        }
    }
    else if (currentPage== 1) {
        
        if (xnum == 0) {
            _fff.text = yesterday;
        }else if(xnum == 1){
            _fff.text = @"先週";
        }else if(xnum == 2){
            _fff.text = @"先月";
        }
        
    }else if (currentPage== 2) {
        
        
        if (xnum == 0) {
            _fff.text = today;
        }else if(xnum == 1){
            _fff.text = @"今週";
        }else if(xnum == 2){
            _fff.text = @"今月";
        }
        
    }
    
}



-(NSArray*)getXTitles:(int)num{
    NSMutableArray *xTitles = [[NSMutableArray alloc]initWithCapacity:0];
    
    for (int i =1; i<=num; i++) {
        if (num >8&&num<24) {
            NSString *str = [NSString stringWithFormat:@"%d",i];
            [xTitles addObject:str];
        }else{
            NSString *str = [NSString stringWithFormat:@"%d",i];
            [xTitles addObject:str];
        }
        
    }
    return xTitles;
    
}

- (NSArray *)UUChart_xLableArray:(UUChart *)chart{
    switch (xnum) {
        case 0:
            return [self getXTitles:24];
        case 1:
            return [self getXTitles:7];
        case 2:
            return [self getXTitles:30];
            
        default:
            break;
    }
    return [self getXTitles:12];
}
- (NSArray *)UUChart_xLableArray2:(UUChart *)chart{
    switch (xnum) {
        case 0:
            return [self getXTitles:24];
        case 1:
            return [self getXTitles:7];
        case 2:
            return [self getXTitles:30];
            
        default:
            break;
    }
    return [self getXTitles:12];
}
- (NSArray *)UUChart_xLableArray3:(UUChart *)chart{
    switch (xnum) {
        case 0:
            return [self getXTitles:24];
        case 1:
            return [self getXTitles:7];
        case 2:
            return [self getXTitles:30];
            
        default:
            break;
    }
    return [self getXTitles:12];
}


- (NSArray *)UUChart_yValueArray:(UUChart *)chart{
    switch (xnum) {
        case 0:
            return @[dayArr1];
            
        case 1:
            return @[weekArr1];
            
        case 2:
            return @[monthArr2];
            
        default:
            break;
    }
    return @[dayArr1];
}
- (NSArray *)UUChart_yValueArray2:(UUChart *)chart{
    //    if (path.section ==0) {
    switch (xnum) {
        case 0:
            return @[dayArr2];
            
        case 1:
            return @[weekArr2];
            
        case 2:
            return @[monthArr2];
            
        default:
            break;
    }
    return @[dayArr2];
}
- (NSArray *)UUChart_yValueArray3:(UUChart *)chart{
    //    if (path.section ==0) {
    switch (xnum) {
        case 0:
            return @[dayArr3];
            
        case 1:
            return @[weekArr3];
            
        case 2:
            return @[monthArr3];
            
        default:
            break;
    }
    return @[dayArr3];
}



@end
