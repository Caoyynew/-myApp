//
//  DetailTableViewCell.m
//  MimamoruApp
//
//  Created by totyu3 on 16/1/13.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "DetailTableViewCell.h"
#import "UUChart.h"
@interface DetailTableViewCell()<UUChartDataSource>
{
    UUChart *chartview;
    NSIndexPath *path ;
    int type;
    NSArray *dayarr;
}
@end

@implementation DetailTableViewCell


- (void)awakeFromNib {
   
}

-(void)configUI:(NSIndexPath *)indexPath type:(int)styletype day:(NSArray *)day
{
    if (!dayarr) {
        dayarr = [[NSArray alloc]init];
    }
    if (chartview) {
        [chartview removeFromSuperview];
        chartview = nil;
    }
    path = indexPath;
    type = styletype;
    dayarr = day;
//    if (type ==1) {
//        self.danwei.text =@"wh";
//        chartview =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(5, 30, [UIScreen mainScreen].bounds.size.width-10
//                                                                       , 120) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle];
//    }else if (type ==2){
//        self.danwei.text = @"回数";
//        chartview =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(5, 30, [UIScreen mainScreen].bounds.size.width-10
//                                                                   , 120) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle];
//    }
    NSDate *date  = [NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy年MM月dd日"];
    self.dateLabel.text =[dateformatter stringFromDate:date];
    [chartview showInView:self.contentView];
}


#pragma mark - UUChartView delegate

-(NSArray*)UUChart_xLableArray:(UUChart *)chart
{
    NSMutableArray *xTitles = [[NSMutableArray alloc]initWithCapacity:24];
    for (int i = 1; i<25; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",i];
        [xTitles addObject:str];
    }
    return xTitles;
}
-(NSArray*)UUChart_yValueArray:(UUChart *)chart
{
    return @[dayarr];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
