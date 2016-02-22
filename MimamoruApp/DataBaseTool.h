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
//请求下载数据
-(void)startRequest:(NSString *)userid;
//L_UserInfoTable
//查询接口
-(NSMutableDictionary*)selectL_UserInfoTableuserid:(NSString*)userid;
//更新接口
-(void)updateL_UserInfoTable:(NSDictionary*)itemDict userid:(NSString*)userid;
//检验是否取回数据
-(NSDictionary*)backdic;

//更新L_SensorData
-(BOOL)createL_SensorDataTable;
//L_EmergencyContactsTable
//查询接口
-(NSMutableArray*)selectL_EmergencyContactsTableuserid:(NSString *)userid;
//删除接口
-(void)deleteL_EmergencyContactsTable:(NSDictionary*)itemDict userid:(NSString *)userid;
//新增接口
-(void)insertL_EmergencyContactsTable:(NSDictionary*)itemDict userid:(NSString *)userid;
//更新接口
-(void)updateL_EmergencyContactsTable:(NSDictionary *)itemDict userid:(NSString *)userid;

//L_SensorData数据查询
//查询3天数据
-(NSMutableArray*)selectL_SensorDayData:(NSString*)userid Sensorid:(NSString*)sensorid;
//查询3周数据
-(NSMutableArray*)selectL_SensorWeekData:(NSString*)userid Sensorid:(NSString*)sensorid;
//查询3月数据
-(NSMutableArray*)selectL_SensorMounthData:(NSString*)userid Sensorid:(NSString*)sensorid;

//L_SensorMaster数据查询
-(NSMutableArray*)selectL_SensorMaster:(NSString *)userid; //用于进入B-2页面 获取用户传感器个数和图表显示类型

//L_SensoridData 查询当天数据
-(NSMutableArray*)selectL_SensorTodayData:(NSString *)userid Sensorid:(NSString *)sensorid;
//L_ShiKiChiContacts 查询数据
-(NSMutableArray*)selectL_ShiKiChiContacts:(NSString*)userid;



@end
