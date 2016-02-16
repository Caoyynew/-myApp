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

//本地接口

//L_UserInfoTable
//查询接口
-(NSMutableDictionary*)selectL_UserInfoTableuserid:(NSString*)userid;
//更新接口
-(void)updateL_UserInfoTable:(NSDictionary*)itemDict userid:(NSString*)userid;

//L_EmergencyContactsTable
//查询接口
-(NSMutableArray*)selectL_EmergencyContactsTableuserid:(NSString *)userid;
//删除接口
-(void)deleteL_EmergencyContactsTable:(NSDictionary*)itemDict userid:(NSString *)userid;
//新增接口
-(void)insertL_EmergencyContactsTable:(NSDictionary*)itemDict userid:(NSString *)userid;
//更新接口
-(void)updateL_EmergencyContactsTable:(NSDictionary *)itemDict userid:(NSString *)userid;

//L_SensorData 数据查询
-(NSMutableArray*)selectL_SensorData:(NSString*)userid;

//L_ShiKiChiContacts 查询数据
-(NSMutableArray*)selectL_ShiKiChiContacts:(NSString*)userid;

@end
