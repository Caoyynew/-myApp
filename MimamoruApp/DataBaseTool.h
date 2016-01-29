//
//  DataBaseTool.h
//  MimamoruApp
//
//  Created by totyu3 on 16/1/29.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBaseTool : NSObject

+(DataBaseTool*)sharedDB;
-(BOOL)openDB;
@end
