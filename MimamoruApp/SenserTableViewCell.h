//
//  SenserTableViewCell.h
//  MimamoruApp
//
//  Created by totyu3 on 16/1/14.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUChart.h"
@interface SenserTableViewCell : UITableViewCell

-(void)config:(NSIndexPath*)indexPath  Segment:(NSInteger)xNum typeId:(NSInteger)type day:(NSArray*)day week:(NSArray*)week month:(NSArray*)month;
@end
