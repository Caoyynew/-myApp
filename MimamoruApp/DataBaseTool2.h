//
//  DataBaseTool.h
//  mimamorugawaApp
//
//  Created by apple on 16/1/21.
//  Copyright © 2016年 totyu2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#define kFilename @"Mydb.db"
@interface DataBaseTool2 : NSObject
{
    sqlite3 *_database;//sqlite3成员变量
}
@property (nonatomic) sqlite3* _database;
+(DataBaseTool2*)sharedDb;
//本地接口

-(NSMutableDictionary*)getUserInfoData:(NSString*)userId;
-(BOOL)updateUserInfoData:(NSMutableDictionary*)userinfo :(NSString*)userId;
//-(NSDictionary *)startRequest:(NSString *)userid :(NSString *)strDate;
-(void)addDataToL_ShiKiiContacts:(NSArray*)resDict;
-(void)addDataToL_UpdateFlag:(NSString*)resDict;
-(void)addDataToL_SensorData:(NSArray*)resDict;
-(void)addDataToL_SensorResult:(NSArray*)resDict;
-(void)addDataToL_ShiKiiMaster:(NSArray*)resDict;
-(void)addDataToL_SensorMaster:(NSArray*)resDict;
-(void)addDataToL_UserTBL:(NSArray*)resDict;
-(void)addDataToL_EmergencyContacts:(NSArray*)resDict;
-(void)addDataToL_UserMasterTable:(NSArray*)resDict;
-(void)addDataToL_UserInfoTable:(NSArray*)resDict;
//生活
-(NSMutableArray*)getL_SensorResult1;
//見守り対象者の設定
-(NSMutableArray*)getL_UserTBL1;

//自分
-(NSMutableDictionary*)getUserMasterData;

-(NSMutableArray*)getL_SensorMaster1:(NSString*)userid0;

-(BOOL)updateUserMasterData:(NSMutableDictionary*)userMaster;

//緊急連絡
-(NSMutableArray*)getL_EmergencyContacts1:(NSString*)userid0;

-(NSMutableArray*)getL_ShiKiiContacts1:(NSString*)userid0 :(NSString*)sensorid ;

-(void)addDataToL_EmergencyContacts1:(NSMutableDictionary*)resDict :(NSString*)userid01 :(NSString*)contact1;

-(void)addDataToL_ShiKiiContacts1:(NSMutableDictionary*)resDict :(NSString*)userid1 :(NSString*)userid0 :(NSString*)sensorid :(NSString*)abnemail;

-(BOOL)deleteL_EmergencyContacts1:(NSString*)userid0 :(NSString*)contact;

-(BOOL)deleteL_ShiKiiContacts1:(NSString*)userid0 :(NSString*)sensorid :(NSString*)abnemail;

//-(NSMutableArray*)getL_ShiKiiMaster1:(NSString*)userid0;
-(NSMutableArray*)getL_ShiKiiMaster:(NSString*)nitid :(NSString*)userid0  :(NSString*)sensorid;

//-(void)addDataToL_ShiKiiMaster1:(NSMutableDictionary*)resDict :(NSString*)nitid;

-(BOOL)updateL_ShiKiiMaster:(NSMutableDictionary*)L_ShiKiiMaster1 :(NSString*)nitid :(NSString*)userid0 :(NSString*)sensorid;

//-(BOOL)updateL_SensorMaster1:(NSString*)graphtype :(NSString*)nitid;

//-(NSString*)getL_SensorMaster2:(NSString*)nitid :(NSString*)userid0;

-(void)addDataToL_SensorMaster1:(NSString*)nitid :(NSString*)userid0  :(NSString*)sensorid :(NSString*)sensorname  :(NSString*)unit;
-(void)addDataToL_ShiKiiMaster1:(NSString*)nitid :(NSString*)userid1 :(NSString*)userid0  :(NSString*)sensorid  :(NSString*)pattern1  :(NSString*)time1  :(NSString*)value1  :(NSString*)pattern2  :(NSString*)time2  :(NSString*)value2  :(NSString*)graphtype;

-(NSMutableArray*)getTodaySensorData:(NSString*)userid0 :(NSString*)sensorid :(NSString*)date;

-(NSMutableArray*)getL_SensorMaster2:(NSString*)userid0;

-(NSString*)getL_SensorMaster3 :(NSString*)sensorid;

-(NSMutableArray*)getL_ShiKiiMaster1:(NSString*)userid0  :(NSString*)sensorid;

-(NSString*)getL_ShiKiiMaster2:(NSString*)userid0  :(NSString*)sensorid;

-(NSString*)getUserMasterData1:(NSString*)userid  :(NSString*)usertype;
@end
