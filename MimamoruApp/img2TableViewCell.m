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
    // Initialization code
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
    //    if (indexPath.section == 0) {
    dayarr = day;
    weekarr = week;
    montharr = month;
    //yeararr =year;
    //    }else if(indexPath.section ==1){
    //        dayarr2 = day;
    //        weekarr2 = week;
    //        montharr2 = month;
    //        yeararr2 =year;
    //    }
    
    //200x3＋5＋10＋10＋5＝630
    if ([self.ppp isEqualToString:@"ドア"]) {
        chartview =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20
                                                                       , 130) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle];
        
    }else if([self.ppp isEqualToString:@"電気使用量"]){
        chartview =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(10, 10, 300
                                                                       , 130) withSource:self withStyle:type==1?UUChartBarStyle:UUChartLineStyle];
        
    }else if([self.ppp isEqualToString:@"マット"]){
        chartview =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20
                                                                       , 130) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle];
        
    }
    [chartview showInView:self.contentView];



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
        case 3:
            return [self getXTitles:12];
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
            
        case 3:
            return @[yeararr];
            
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



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
