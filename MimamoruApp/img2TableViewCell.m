//
//  img2TableViewCell.m
//  mimamorugawaApp
//
//  Created by apple on 16/1/12.
//  Copyright © 2016年 totyu2. All rights reserved.
//

#import "img2TableViewCell.h"
#import "UUChart.h"



@interface img2TableViewCell()<UUChartDataSource>{
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

@end





@implementation img2TableViewCell
- (void)awakeFromNib {


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

    if ([self.ppp isEqualToString:@"ドア"]) {

        if ([self.iii isEqualToString:@"1"]) {
            chartview =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(5, 15, [UIScreen mainScreen].bounds.size.width-10
                                                                       , 130) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle withid:@"1"];
        }else{
            chartview =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(5, 15, [UIScreen mainScreen].bounds.size.width-10
                                                                           , 130) withSource:self withStyle:type==1?UUChartBarStyle:UUChartLineStyle withid:@"1"];
        }
        
    }else if([self.ppp isEqualToString:@"電気"]){

        if ([self.iii isEqualToString:@"1"]) {
            chartview =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(5, 15, [UIScreen mainScreen].bounds.size.width-10
                                                                           , 130) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle withid:@"1"];
        }else{
            chartview =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(5, 15, [UIScreen mainScreen].bounds.size.width-10
                                                                           , 130) withSource:self withStyle:type==1?UUChartBarStyle:UUChartLineStyle withid:@"1"];
        }
    }else if([self.ppp isEqualToString:@"マット"]){

        if ([self.iii isEqualToString:@"1"]) {
            chartview =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(5, 15, [UIScreen mainScreen].bounds.size.width-10
                                                                           , 130) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle withid:@"1"];
        }else{
            chartview =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(5, 15, [UIScreen mainScreen].bounds.size.width-10
                                                                           , 130) withSource:self withStyle:type==1?UUChartBarStyle:UUChartLineStyle withid:@"1"];
        }
    }else if([self.ppp isEqualToString:@"照度"]){
        dayarr = day;
        weekarr = week;
        montharr = month;
        if ([self.iii isEqualToString:@"1"]) {
            chartview =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(5, 15, [UIScreen mainScreen].bounds.size.width-10
                                                                           , 130) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle withid:@"1"];
            
        }else{
            chartview =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(5, 15, [UIScreen mainScreen].bounds.size.width-10
                                                                           , 130) withSource:self withStyle:type==1?UUChartBarStyle:UUChartLineStyle withid:@"1"];
            
        }
    }
    [chartview showInView:self.contentView];



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
            return [self getXTitles:29];
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
- (NSArray *)UUChart_yValueArray2:(UUChart *)chart{

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
- (NSArray *)UUChart_yValueArray3:(UUChart *)chart{

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
