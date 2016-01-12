//
//  DashBoardTableViewCell.h
//  Mimamoro
//
//  Created by totyu1 on 2015/12/15.
//  Copyright © 2015年 totyu1. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UIScrollViewTouchDelegate

-(void)scrollViewTouchs:(NSSet *)touchs withEvent:(UIEvent*)event whichView:(id)scrollView;
@end


@interface DashBoardTableViewCell : UITableViewCell
-(void)configUI:(NSIndexPath*)indexPath type:(int)styletype unit:(int)segmentunitnum day:(NSArray*)day week:(NSArray*)week month:(NSArray*)month;
@property (strong, nonatomic) IBOutlet UILabel *itemLabel;

@property(nonatomic,strong)id<UIScrollViewDelegate>delegate;
@end
