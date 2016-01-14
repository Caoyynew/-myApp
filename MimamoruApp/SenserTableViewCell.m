//
//  SenserTableViewCell.m
//  MimamoruApp
//
//  Created by totyu3 on 16/1/14.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "SenserTableViewCell.h"
@interface SenserTableViewCell()
{
    NSInteger segId;// 0:日 1:周 2:月
    NSInteger typeid;// 1:折线 2:柱状 3:面积
    NSArray *dayArr;
    NSArray *weekArr;
    NSArray *monthArr;
}
@property (weak, nonatomic) IBOutlet UILabel *scrTitle;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
@implementation SenserTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)config:(NSIndexPath*)indexPath  Segment:(NSInteger)xNum typeId:(NSInteger)type day:(NSArray*)day week:(NSArray*)week month:(NSArray*)month
{
    if (!dayArr) {
        dayArr = [[NSArray alloc]init];
    }
    if (!weekArr) {
        weekArr = [[NSArray alloc]init];
    }
    if (!monthArr) {
        monthArr = [[NSArray alloc]init];
    }
    segId = xNum;
    typeid = type;
    dayArr = day;
    weekArr = week;
    monthArr = month;
    
    
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
