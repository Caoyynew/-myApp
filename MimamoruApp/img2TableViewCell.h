//
//  img2TableViewCell.h
//  mimamorugawaApp
//
//  Created by apple on 16/1/12.
//  Copyright © 2016年 totyu2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface img2TableViewCell : UITableViewCell
-(void)configUI:(NSIndexPath*)indexPath type:(int)styletype unit:(int)segmentunitnum day:(NSArray*)day week:(NSArray*)week month:(NSArray*)month ;
@property (weak, nonatomic) IBOutlet UILabel *unitname;
@property (weak, nonatomic) IBOutlet UILabel *nowtime;
@property NSString *ppp;
@property NSString *iii;
@end
