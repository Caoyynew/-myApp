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
    NSArray *dayarr;
    NSArray *weekarr;
    NSArray *montharr;
    NSArray *yeararr;
    
    UIPageControl* _page;
    
}

@end

@implementation DashBoardTableViewCell


- (void)awakeFromNib {
    //    _scoll.userInteractionEnabled = YES;
    //_scoll.showsHorizontalScrollIndicator = NO;
    // _scoll.layer.shouldRasterize = YES;
    _scoll.bounces = NO; //设定是否可自由拖拽
    _scoll.delegate = self;
    
}




-(void)configUI:(NSIndexPath*)indexPath type:(int)styletype unit:(int)segmentunitnum day:(NSArray*)day week:(NSArray*)week month:(NSArray*)month{
    if (self.scoll != nil) {
        [chartview removeFromSuperview];
        [chartview2 removeFromSuperview];
        [chartview3 removeFromSuperview];
    }
    if (!dayarr) {
        dayarr = [[NSArray alloc]init];
    }
    if (!weekarr) {
        weekarr = [[NSArray alloc]init];
    }
    if (!montharr) {
        montharr = [[NSArray alloc]init];
    }
    
    if (chartview) {
        [chartview removeFromSuperview];
        chartview =nil;
    }
    path = indexPath;
    type = styletype;
    xnum = segmentunitnum;
    dayarr = day;
    weekarr = week;
    montharr = month;
    
    if ([self.hhh isEqualToString:@"ドア"]) {
        chartview =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(5, 15, [UIScreen mainScreen].bounds.size.width-20
                                                                       , 130) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle];
        
        chartview2 =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake([UIScreen mainScreen].bounds.size.width+5, 15, [UIScreen mainScreen].bounds.size.width-20
                                                                        , 130) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle];
        
        chartview3 =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width)*2+5, 15, [UIScreen mainScreen].bounds.size.width-20
                                                                        , 130) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle];
    }else if([self.hhh isEqualToString:@"電気使用量"]){
        chartview =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(5, 15, [UIScreen mainScreen].bounds.size.width-20
                                                                       , 130) withSource:self withStyle:type==1?UUChartBarStyle:UUChartLineStyle];
        
        chartview2 =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake([UIScreen mainScreen].bounds.size.width+5, 15, [UIScreen mainScreen].bounds.size.width-20
                                                                        , 130) withSource:self withStyle:type==1?UUChartBarStyle:UUChartLineStyle];
        
        chartview3 =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width)*2+5, 15, [UIScreen mainScreen].bounds.size.width-20
                                                                        , 130) withSource:self withStyle:type==1?UUChartBarStyle:UUChartLineStyle];
    }else if([self.hhh isEqualToString:@"マット"]){
        chartview =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(5, 15, [UIScreen mainScreen].bounds.size.width-20
                                                                       , 130) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle];
        
        chartview2 =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake([UIScreen mainScreen].bounds.size.width+5, 15, [UIScreen mainScreen].bounds.size.width-20
                                                                        , 130) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle];
        
        chartview3 =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width)*2+5, 15, [UIScreen mainScreen].bounds.size.width-20
                                                                        , 130) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle];
    }
    
    [chartview showInView:_scoll];
    [chartview2 showInView:_scoll];
    [chartview3 showInView:_scoll];
    
    [_scoll setShowsHorizontalScrollIndicator:NO];
    _scoll.contentSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width)*3, 150);
    _scoll.contentOffset =CGPointMake(([UIScreen mainScreen].bounds.size.width)*2, 0) ;
    _scoll.pagingEnabled =YES;
    
    //[self.contentView addSubview:_scoll];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView

{
    
    int currentPage = (_scoll.contentOffset.x - _scoll.frame.size.width/5) / _scoll.frame.size.width + 1;
    
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
        NSString *str = [NSString stringWithFormat:@"%d",i];
        [xTitles addObject:str];
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


- (NSArray *)UUChart_yValueArray:(UUChart *)chart{
    
    switch (xnum) {
        case 0:
        return @[dayarr];
        
        case 1:
        return @[weekarr];
        
        case 2:
        return @[montharr];
        
        default:
        break;
    }
    return @[dayarr];
}



@end
