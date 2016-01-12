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
    NSArray *dayarr;
    NSArray *weekarr;
    NSArray *montharr;
    NSArray *yeararr;
    NSArray *dayarr2;
    NSArray *weekarr2;
    NSArray *montharr2;
    NSArray *yeararr2;
}

@property (strong , nonatomic) UIScrollView *scrollview;
@end

@implementation DashBoardTableViewCell

- (void)awakeFromNib {
    
}

-(void)configUI:(NSIndexPath*)indexPath type:(int)styletype unit:(int)segmentunitnum day:(NSArray*)day week:(NSArray*)week month:(NSArray*)month {
    if (!dayarr) {
        dayarr = [[NSArray alloc]init];
    }
    if (!weekarr) {
        weekarr = [[NSArray alloc]init];
    }
    if (!montharr) {
        montharr = [[NSArray alloc]init];
    }
    if (!dayarr2) {
        dayarr2 = [[NSArray alloc]init];
    }
    if (!weekarr2) {
        weekarr2 = [[NSArray alloc]init];
    }
    if (!montharr2) {
        montharr2 = [[NSArray alloc]init];
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
    
    
    if (indexPath.section == 0) {
        chartview =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-25
                                                                           , 140) withSource:self withStyle:type==1?UUChartBarStyle:UUChartLineStyle];
    }else if (indexPath.section == 1){
        chartview =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-25
                                                                   , 140) withSource:self withStyle:type==1?UUChartBarStyle:UUChartLineStyle];
    }else if (indexPath.section == 2){
        chartview =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(10,10, [UIScreen mainScreen].bounds.size.width-25
                                                                       , 140) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle];
    }else if (indexPath.section == 3){
        chartview =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-25
                                                                       , 140) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle];
    }
    
//    self.scrollview = [[UIScrollView alloc]initWithFrame:self.bounds];
//    [chartview showInView:self.scrollview];
//    self.scrollview.canCancelContentTouches = YES;
//    self.scrollview.delegate = self;
//    [self addSubview:self.scrollview];
    [chartview showInView:self];
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
