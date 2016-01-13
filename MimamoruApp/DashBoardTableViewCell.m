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
    NSArray *dayarr2;
    NSArray *weekarr2;
    NSArray *montharr2;
    NSArray *yeararr2;
    
    UIPageControl* _page;
}





@end

@implementation DashBoardTableViewCell


- (void)awakeFromNib {
    _scoll.userInteractionEnabled = YES;
    _scoll.showsHorizontalScrollIndicator = NO;
    _scoll.bounces = NO;
    _scoll.delegate = self;
    
}




-(void)configUI:(NSIndexPath*)indexPath type:(int)styletype unit:(int)segmentunitnum day:(NSArray*)day week:(NSArray*)week month:(NSArray*)month{
    if (!dayarr) {
        dayarr = [[NSArray alloc]init];
    }
    if (!weekarr) {
        weekarr = [[NSArray alloc]init];
    }
    if (!montharr) {
        montharr = [[NSArray alloc]init];
    }
//    if (!yeararr) {
//        yeararr = [[NSArray alloc]init];
//    }
    if (!dayarr2) {
        dayarr2 = [[NSArray alloc]init];
    }
    if (!weekarr2) {
        weekarr2 = [[NSArray alloc]init];
    }
    if (!montharr2) {
        montharr2 = [[NSArray alloc]init];
    }
//    if (!yeararr2) {
//        yeararr2 = [[NSArray alloc]init];
//    }
    
    if (chartview) {
        [chartview removeFromSuperview];
        chartview =nil;
    }
    path = indexPath;
    type = styletype;
    xnum = segmentunitnum;
//    if (indexPath.section == 0) {
        dayarr = day;
        weekarr = week;
        montharr = month;
//        yeararr =year;
//    }else if(indexPath.section ==1){
//        dayarr2 = day;
//        weekarr2 = week;
//        montharr2 = month;
//        yeararr2 =year;
//    }
    
    //200x3＋5＋10＋10＋5＝630
    if ([self.hhh isEqualToString:@"ドア"]) {
    chartview =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(5, 15, [UIScreen mainScreen].bounds.size.width-20
                                                                   , 130) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle];
    
    chartview2 =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake([UIScreen mainScreen].bounds.size.width+10, 15, [UIScreen mainScreen].bounds.size.width-20
                                                                   , 130) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle];
    
    chartview3 =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-10)*2+35, 15, [UIScreen mainScreen].bounds.size.width-20
                                                                    , 130) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle];
    }else if([self.hhh isEqualToString:@"電気使用量"]){
        chartview =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(5, 15, [UIScreen mainScreen].bounds.size.width-20
                                                                       , 130) withSource:self withStyle:type==1?UUChartBarStyle:UUChartLineStyle];
        
        chartview2 =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake([UIScreen mainScreen].bounds.size.width+10, 15, [UIScreen mainScreen].bounds.size.width-20
                                                                        , 130) withSource:self withStyle:type==1?UUChartBarStyle:UUChartLineStyle];
        
        chartview3 =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-10)*2+35, 15, [UIScreen mainScreen].bounds.size.width-20
                                                                        , 130) withSource:self withStyle:type==1?UUChartBarStyle:UUChartLineStyle];
    }else if([self.hhh isEqualToString:@"マット"]){
        chartview =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(5, 15, [UIScreen mainScreen].bounds.size.width-20
                                                                       , 130) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle];
        
        chartview2 =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake([UIScreen mainScreen].bounds.size.width+10, 15, [UIScreen mainScreen].bounds.size.width-20
                                                                        , 130) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle];
        
        chartview3 =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-10)*2+35, 15, [UIScreen mainScreen].bounds.size.width-20
                                                                        , 130) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle];
    }
//    if ([self.hhh isEqualToString:@"ドア"]) {
//        chartview =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(5, 15, [UIScreen mainScreen].bounds.size.width-20
//                                                                       , 130) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle];
//        
//        chartview2 =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake([UIScreen mainScreen].bounds.size.width+10, 15, [UIScreen mainScreen].bounds.size.width-20
//                                                                        , 130) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle];
//        
//        chartview3 =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-10)*2+35, 15, [UIScreen mainScreen].bounds.size.width-20
//                                                                        , 130) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle];
//    }else if([self.hhh isEqualToString:@"電気使用量"]){
//        chartview =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(5, 15, [UIScreen mainScreen].bounds.size.width-20
//                                                                       , 130) withSource:self withStyle:type==1?UUChartBarStyle:UUChartLineStyle];
//        
//        chartview2 =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake([UIScreen mainScreen].bounds.size.width+10, 15, [UIScreen mainScreen].bounds.size.width-20
//                                                                        , 130) withSource:self withStyle:type==1?UUChartBarStyle:UUChartLineStyle];
//        
//        chartview3 =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-10)*2+35, 15, [UIScreen mainScreen].bounds.size.width-20
//                                                                        , 130) withSource:self withStyle:type==1?UUChartBarStyle:UUChartLineStyle];
//    }
//    UILabel*dfd = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
//    dfd.backgroundColor = [UIColor blackColor];
    //[chartview3 addSubview:dfd];
    [chartview showInView:_scoll];
    [chartview2 showInView:_scoll];
    [chartview3 showInView:_scoll];

    [_scoll setShowsHorizontalScrollIndicator:NO];
    _scoll.contentSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width-20)*3.25, 150);
    _scoll.contentOffset =CGPointMake(([UIScreen mainScreen].bounds.size.width-20)*2.17, 0) ;
    _scoll.pagingEnabled =YES;
    
    [self.contentView addSubview:_scoll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView

{
    
    int currentPage = (_scoll.contentOffset.x - _scoll.frame.size.width
                       
                       / (5)) / _scoll.frame.size.width + 1;
    
    
    if (currentPage==0) {
        if (xnum == 0) {
            _fff.text = @"おととい";
        }else if(xnum == 1){
            _fff.text = @"先先週";
        }else if(xnum == 2){
            _fff.text = @"先先月";
        }
        
        
    }
    
    else if (currentPage== 1) {
        
        if (xnum == 0) {
            _fff.text = @"昨日";
        }else if(xnum == 1){
            _fff.text = @"先週";
        }else if(xnum == 2){
            _fff.text = @"先月";
        }
        
    }else if (currentPage== 2) {
        
        
        if (xnum == 0) {
            _fff.text = @"今日";
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
    //NSLog(@"xTitles:%@",xTitles);
    return xTitles;
    
}

- (NSArray *)UUChart_xLableArray:(UUChart *)chart{
//    if (path.section ==0) {
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
//    }else{
//        switch (xnum) {
//            case 0:
//                return [self getXTitles:24];
//            case 1:
//                return [self getXTitles:7];
//            case 2:
//                return [self getXTitles:30];
//            case 3:
//                return [self getXTitles:12];
//            default:
//                break;
//        }
//    }
    return [self getXTitles:12];
}


- (NSArray *)UUChart_yValueArray:(UUChart *)chart{
//    if (path.section ==0) {
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
//    }else if (path.section ==1){
//        switch (xnum) {
//            case 0:
//                return @[dayarr2];
//                
//            case 1:
//                return @[weekarr2];
//                
//            case 2:
//                return @[montharr2];
//                
//            case 3:
//                return @[yeararr2];
//                
//            default:
//                break;
//        }
//    }
    return @[dayarr];
}



@end
