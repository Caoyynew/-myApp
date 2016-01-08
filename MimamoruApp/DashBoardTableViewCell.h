//
//  DashBoardTableViewCell.h
//  Mimamoro
//
//  Created by totyu1 on 2015/12/15.
//  Copyright © 2015年 totyu1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashBoardTableViewCell : UITableViewCell
-(void)configUI:(NSIndexPath*)indexPath type:(int)styletype unit:(int)segmentunitnum day:(NSArray*)day week:(NSArray*)week month:(NSArray*)month year:(NSArray*)year;
@property (strong, nonatomic) IBOutlet UILabel *itemLabel;


@end
