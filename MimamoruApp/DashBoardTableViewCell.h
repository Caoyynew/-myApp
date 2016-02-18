//
//  DashBoardTableViewCell.h
//  Mimamoro
//
//  Created by totyu1 on 2015/12/15.
//  Copyright © 2015年 totyu1. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DashBoardTableViewCell : UITableViewCell
-(void)configUI:(NSIndexPath*)indexPath type:(int)styletype unit:(int)segmentunitnum day1:(NSArray*)day1 week1:(NSMutableArray*)week1 month1:(NSMutableArray*)month1 day2:(NSArray*)day2 week2:(NSMutableArray*)week2 month2:(NSMutableArray*)month2 day3:(NSArray*)day3 week3:(NSMutableArray*)week3 month3:(NSMutableArray*)month3 sendNmonth:(int)Nmonth Bmonth:(int)Bmonth BBmonth:(int)BBmonth ;

-(void)passCurrent:(float)current indexPath:(NSIndexPath*)row;
@property (weak, nonatomic) IBOutlet UILabel *fff;
@property (weak, nonatomic) IBOutlet UILabel *danwei;
@property NSString *hhh;
@property NSString *rrr;
@property (weak, nonatomic) IBOutlet UIScrollView *scoll;
@property int currentNo;
@end
