//
//  DataWebService.h
//  MimamoruApp
//
//  Created by totyu3 on 16/1/21.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define kFilename @"mydb.db"
@interface DataWebService : NSObject

+(DataWebService*)shareDB;




-(void)reloadView:(NSDictionary*)res;
-(void)startRequest:(NSString *)getid;


@end
