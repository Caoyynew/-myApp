//
//  DetailTableViewCell.h
//  MimamoruApp
//
//  Created by totyu3 on 16/1/13.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *danwei;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

-(void)configUI:(NSIndexPath*)indexPath type:(int)styletype day:(NSArray *)day;
@end
