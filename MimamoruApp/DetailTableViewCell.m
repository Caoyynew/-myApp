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
    if (type ==1) {
        chartview =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20
                                                                       , 150) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle];
    }else if (type ==2){
        chartview =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20
                                                                   , 150) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle];
    }
    [chartview showInView:self.contentView];
//    chartview2 =[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width*2-20
//                                                                   , 130) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle];
//    chartview3=[[UUChart alloc]initwithUUChartDataFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width*3-20
//                                                                   , 130) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle];
   
   // [chartview showInView:self.scrollview];
    //[chartview2 showInView:self.scrollview];
    //[chartview3 showInView:self.scrollview];
   // [self.contentView addSubview:self.scrollview];
  //  [self.scrollview setShowsHorizontalScrollIndicator:NO];
//    self.scrollview.contentSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width-20)*3.25, 150);
//    self.scrollview.contentOffset =CGPointMake(([UIScreen mainScreen].bounds.size.width-20)*2.17, 0) ;
//    self.scrollview.pagingEnabled = YES;
}

#pragma mark - Scrollview delegate

//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    int currentPage = (self.scrollview.contentOffset.x - self.scrollview.frame.size.width
//                       
//                       / (5)) / self.scrollview.frame.size.width + 1;
//    
//    if (currentPage == 2 ) {
//        self.titileName.text = @"今日";
//    }else if (currentPage == 1){
//        self.titileName.text = @"昨日";
//    }else if (currentPage == 0){
//        self.titileName.text = @"おととい";
//    }
//}
#pragma mark - UUChartView delegate

-(NSArray*)UUChart_xLableArray:(UUChart *)chart
{
    NSMutableArray *xTitles = [[NSMutableArray alloc]initWithCapacity:24];
    for (int i = 0; i<=24; i++) {
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
