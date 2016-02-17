//
//  DataBaseTool.m
//  mimamorugawaApp
//
//  Created by apple on 16/1/21.
//  Copyright © 2016年 totyu2. All rights reserved.
//
#define checkNull(__X__)   (__X__) == [NSNull null] ? @"" : [NSString stringWithFormat:@"%@", (__X__)]

#import "DataBaseTool2.h"

@interface DataBaseTool2 (){
    NSString *userid0;
    NSString *nitid;
    int usertype;
    int password;
    int type;  // 0:第一次下载数据 1:已有本地表，定时更新数据
}
@end

@implementation DataBaseTool2{
    NSMutableData *_data;
}
@synthesize _database;

-(id)init{
    //pedometer = [[CMPedometer alloc]init];
    if ([self openDB]) {
        return self;
    }else{
        return nil;
    }
}

+(DataBaseTool2*)sharedDb{
    static DataBaseTool2*sharedDb = nil;
    
    if (sharedDb == nil) {
        sharedDb = [[DataBaseTool2 alloc]init];
    }
    return sharedDb;
}

#pragma mark - OPEN数据库
//获取Document目录并返回数据库目录
-(NSString*)getDatafilepath{
    NSString *home = NSHomeDirectory();
    NSString *documentsDirector = [home stringByAppendingPathComponent:@"Documents"];
    return [documentsDirector stringByAppendingPathComponent:kFilename];
}


//创建，打开数据库
-(BOOL)openDB{
    NSString *path = [self getDatafilepath];
    NSLog(@"数据库path:%@",path);
    NSFileManager * filemanager =[NSFileManager defaultManager];
    //    判断是否存在
    BOOL find = [filemanager fileExistsAtPath:path];
    //    如果存在，直接打开 －－据说数据库不存在，sqlite3会自动创建
    if (find) {
        NSLog(@"数据库存在");
        //        注意，这里需要C语言的字符串，直接照着写就可以了!!!!!
        if (sqlite3_open([path UTF8String], &_database)!=SQLITE_OK) {
            //            打开数据库失败，关闭数据库
            NSLog(@"NG 数据库打开失败");
            return NO;
        }else{
            NSLog(@"OK 数据库正常打开");
            return YES;
        }
    }
    //    如果数据库不存在，则创建数据库
    int result = sqlite3_open([path UTF8String], &_database);
    if (result == SQLITE_OK) {
        
        
        [self createL_UserMasterTable];
        [self createL_UserInfoTable];
        [self createL_EmergencyContactsTable];
        [self createL_UserTBLTable];
        [self createL_SensorMasterTable];
        [self createL_SensorResultTable];
        [self createL_SensorDataTable];
        [self createL_ShiKiiMasterTable];
        [self createL_UpdateFlagTable];
        [self createL_ShiKiiContactsTable];
        
        NSLog(@"NG 数据库创建成功");
        
        return YES;
    }else{
        NSLog(@"NG 数据库创建失败");
        return NO;
    }
    return NO;
}


#pragma mark - 基本表（服务器获取数据）

-(BOOL)createL_UpdateFlagTable{
    char *sql ="create table if not exists L_UpdateFlag(id INTEGER PRIMARY KEY AUTOINCREMENT,updatedate text)";
    sqlite3_stmt *statement;
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    
    if (sqlReturn != SQLITE_OK) {
        return NO;
    }else{
        NSLog(@"建表成功");
    }
    //id, nitid, userid0, sensorid, sensorname, unit, graphtype, updatedate, id, id
    int success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (success != SQLITE_DONE) {
        return NO;
    }else{
        return YES;
    }
}



-(BOOL)createL_SensorDataTable{
    char *sql ="create table if not exists L_SensorData(id INTEGER PRIMARY KEY AUTOINCREMENT,nitid text,userid0 text,date text ,time text,sensorid text,value text)";
    sqlite3_stmt *statement;
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    
    if (sqlReturn != SQLITE_OK) {
        return NO;
    }else{
        NSLog(@"建表成功");
    }
    //id, nitid, userid0, sensorid, sensorname, unit, graphtype, updatedate, id, id
    int success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (success != SQLITE_DONE) {
        return NO;
    }else{
        
        return YES;
    }
}


-(BOOL)createL_SensorResultTable{
    char *sql ="create table if not exists L_SensorResult(id INTEGER PRIMARY KEY AUTOINCREMENT,nitid text,userid0 text ,userid1 text ,sensorid text,result text)";
    sqlite3_stmt *statement;
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    
    if (sqlReturn != SQLITE_OK) {
        return NO;
    }else{
        NSLog(@"建表成功");
    }
    
    int success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (success != SQLITE_DONE) {
        return NO;
    }else{
        
        return YES;
    }
}


-(BOOL)createL_ShiKiiMasterTable{
    char *sql ="create table if not exists L_ShiKiiMaster(id INTEGER PRIMARY KEY AUTOINCREMENT,nitid text,userid1 text ,userid0 text ,sensorid text,pattern1 text,time1 text,value1 text,pattern2 text,time2 text,value2 text,graphtype text)";
    sqlite3_stmt *statement;
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    
    if (sqlReturn != SQLITE_OK) {
        return NO;
    }else{
        NSLog(@"建表成功");
    }

    int success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (success != SQLITE_DONE) {
        return NO;
    }else{
        
        return YES;
    }
}

-(BOOL)createL_ShiKiiContactsTable{
    char *sql ="create table if not exists L_ShiKiiContacts(id INTEGER PRIMARY KEY AUTOINCREMENT,userid1 text,userid0 text ,sensorid text ,abnname text,abnemail text)";
    sqlite3_stmt *statement;
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    
    if (sqlReturn != SQLITE_OK) {
        return NO;
    }else{
        NSLog(@"建表成功");
    }
    //id, nitid, userid0, sensorid, sensorname, unit, graphtype, updatedate, id, id
    int success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (success != SQLITE_DONE) {
        return NO;
    }else{
        
        return YES;
    }
}



-(BOOL)createL_SensorMasterTable{
    char *sql ="create table if not exists L_SensorMaster(id INTEGER PRIMARY KEY AUTOINCREMENT,nitid text,userid0 text ,sensorid text,sensorname text,unit text)";
    sqlite3_stmt *statement;
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    
    if (sqlReturn != SQLITE_OK) {
        return NO;
    }else{
        NSLog(@"建表成功");
    }

    int success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (success != SQLITE_DONE) {
        return NO;
    }else{
        
        return YES;
    }
}


-(BOOL)createL_UserTBLTable{
    char *sql ="create table if not exists L_UserTBL(id INTEGER PRIMARY KEY AUTOINCREMENT,userid1 text,userid0 text,nickname text)";
    sqlite3_stmt *statement;
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    
    if (sqlReturn != SQLITE_OK) {
        return NO;
    }else{
        NSLog(@"建表成功");
    }
    
    int success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (success != SQLITE_DONE) {
        return NO;
    }else{
        
        return YES;
    }
}



-(BOOL)createL_EmergencyContactsTable{
    char *sql ="create table if not exists L_EmergencyContacts(id INTEGER PRIMARY KEY AUTOINCREMENT,userid0 text ,contact text,nickname text)";
    sqlite3_stmt *statement;
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    //id, userid, contact, nickname, updatedate, id, id
    if (sqlReturn != SQLITE_OK) {
        return NO;
    }else{
        NSLog(@"建表成功");
    }
    
    int success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (success != SQLITE_DONE) {
        return NO;
    }else{
        
        return YES;
    }
}



-(BOOL)createL_UserMasterTable {
    char *sql ="create table if not exists L_UserMaster(id INTEGER PRIMARY KEY AUTOINCREMENT,userid text ,usertype text ,username text,nickname text,contact text,password text,email text)";
    sqlite3_stmt *statement;
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    
    if (sqlReturn != SQLITE_OK) {
        return NO;
    }else{
        NSLog(@"建表成功");
    }
    
    int success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (success != SQLITE_DONE) {
        return NO;
    }else{
        
        return YES;
    }
}


//username, sex, birthday, address, kakaritsuke, drug, health, other, updatetime, updatename
-(BOOL)createL_UserInfoTable {
    char *sql ="create table if not exists L_UserInfo(id INTEGER PRIMARY KEY AUTOINCREMENT,userid0 text ,username text,sex text,birthday text,address text,kakaritsuke text,drug text,health text,other text,updatetime text,updatename text)";
    sqlite3_stmt *statement;
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    
    if (sqlReturn != SQLITE_OK) {
        return NO;
    }else{
        NSLog(@"建表成功");
    }
    
    int success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (success != SQLITE_DONE) {
        return NO;
    }else{
        
        return YES;
    }
}

#pragma mark - 同步GET请求


#pragma mark - 从SEVER添加数据

-(void)addDataToL_UpdateFlag:(NSString*)resDict{
    
    
    sqlite3_stmt *statement;
    char * sql = "INSERT INTO L_UpdateFlag(updatedate) VALUES(?)";
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    if (sqlReturn != SQLITE_OK) {
        
    }
    //        int id = 1;
    NSString *updatedate = [NSString stringWithFormat:@"%@",resDict];
    
    // sqlite3_bind_int(statement, 1, id);
    sqlite3_bind_text(statement, 1, [updatedate UTF8String], -1, SQLITE_TRANSIENT);
    
    
    int success = sqlite3_step(statement);
    
    sqlite3_finalize(statement);
    if (success == SQLITE_ERROR) {
        // }
        
    }
}



-(void)addDataToL_SensorData:(NSArray*)resDict{
    for (int i = 0; i < resDict.count; i++) {
        NSMutableDictionary*sensorMaster = [[NSMutableDictionary alloc]initWithDictionary:resDict[i]];
        NSMutableDictionary*sensorMaster1 = [[NSMutableDictionary alloc]initWithDictionary:[self getL_SensorData:[sensorMaster valueForKey:@"time"] :[sensorMaster valueForKey:@"date"]]];
        
        if (sensorMaster1.count <= 0) {
        sqlite3_stmt *statement;
        char * sql = "INSERT INTO L_SensorData(nitid,userid0, date, time, sensorid, value) VALUES(?,?,?,?,?,?)";
        NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
        if (sqlReturn != SQLITE_OK) {
            
        }
        //        int id = 1;
        NSString *nitid = checkNull([sensorMaster valueForKey:@"nitid"]);
        NSString *userid0 = checkNull([sensorMaster valueForKey:@"userid0"]);
        //NSString *dateid = checkNull([sensorMaster valueForKey:@"dateid"]);
        NSString *date = checkNull([sensorMaster valueForKey:@"date"]);
        NSString * time = checkNull([sensorMaster valueForKey:@"time"]);
        NSString * sensorid = checkNull([sensorMaster valueForKey:@"sensorid"]);
        NSString *value = checkNull([sensorMaster valueForKey:@"value"]);
        
        
        // sqlite3_bind_int(statement, 1, id);
        sqlite3_bind_text(statement, 1, [nitid UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [userid0 UTF8String], -1, SQLITE_TRANSIENT);
        
        sqlite3_bind_text(statement, 3, [date UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 4, [time UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 5, [sensorid UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 6, [value UTF8String], -1, SQLITE_TRANSIENT);
        
        
        int success = sqlite3_step(statement);
        
        sqlite3_finalize(statement);
        if (success == SQLITE_ERROR) {
            // }
            
        }
        }else{
            [self updateL_SensorData:sensorMaster :[sensorMaster valueForKey:@"time"] :[sensorMaster valueForKey:@"date"]];
        }
    }
}

//取得しきい値状态
-(NSMutableDictionary*)getL_SensorData:(NSString*)time :(NSString*)date{
    NSMutableDictionary *L_SensorResultData = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    sqlite3_stmt *statement;
    char * sql ="SELECT nitid,userid0, date, time, sensorid, value FROM L_SensorData where date = ? and time = ?";
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    if (sqlReturn != SQLITE_OK) {
        
    }else{
        sqlite3_bind_text(statement,1, [date UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement,2, [time UTF8String], -1, SQLITE_TRANSIENT);
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            char* tmpdata =(char*) sqlite3_column_text(statement, 0);
            [L_SensorResultData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"nitid"];
            tmpdata =(char*) sqlite3_column_text(statement, 1);
            [L_SensorResultData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"userid0"];
            tmpdata =(char*) sqlite3_column_text(statement, 2);
            [L_SensorResultData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"date"];
            tmpdata =(char*) sqlite3_column_text(statement, 3);
            [L_SensorResultData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"time"];
            tmpdata =(char*) sqlite3_column_text(statement, 4);
            [L_SensorResultData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"sensorid"];
            tmpdata =(char*) sqlite3_column_text(statement, 5);
            [L_SensorResultData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"value"];
   
        }
        
    }
    sqlite3_finalize(statement);
    
    return L_SensorResultData;
}

//更新しきい値状态
-(BOOL)updateL_SensorData:(NSMutableDictionary*)L_SensorData :(NSString*)time :(NSString*)date{
    
    sqlite3_stmt *statement;
    char * sql = "update L_SensorData set nitid =? ,userid0 =? ,date =?,time =?,sensorid =?,value =? where time = ? and date =?";
    
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    if (sqlReturn != SQLITE_OK) {
        return NO;
    }
    
    NSString *nitid = checkNull([L_SensorData valueForKey:@"nitid"]);
    NSString *userid0 = checkNull([L_SensorData valueForKey:@"userid0"]);
    NSString *date1 = checkNull([L_SensorData valueForKey:@"date"]);
    NSString * time1 = checkNull([L_SensorData valueForKey:@"time"]);
    NSString * sensorid = checkNull([L_SensorData valueForKey:@"sensorid"]);
    NSString * value = checkNull([L_SensorData valueForKey:@"value"]);
    sqlite3_bind_text(statement, 1, [nitid UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 2, [userid0 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 3, [date1 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 4, [time1 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 5, [sensorid UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 6, [value UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 7, [time UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 8, [date UTF8String], -1, SQLITE_TRANSIENT);
    
    int success = sqlite3_step(statement);
    
    sqlite3_finalize(statement);
    if (success != SQLITE_DONE) {
        
    }
    return YES;
}


//添加更新しきい値状态
-(void)addDataToL_SensorResult:(NSArray*)resDict{
    for (int i = 0; i < resDict.count; i++) {
        NSMutableDictionary*sensorMaster = [[NSMutableDictionary alloc]initWithDictionary:resDict[i]];
        NSMutableDictionary*sensorMaster1 = [[NSMutableDictionary alloc]initWithDictionary:[self getL_SensorResult:[sensorMaster valueForKey:@"userid0"]]];
        
        if (sensorMaster1.count <= 0) {
            sqlite3_stmt *statement;
            char * sql = "INSERT INTO L_SensorResult(nitid, userid0, userid1,sensorid, result) VALUES(?,?,?,?,?)";
            NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
            if (sqlReturn != SQLITE_OK) {
                
            }
            //        int id = 1;
            NSString *nitid = checkNull([sensorMaster valueForKey:@"nitid"]);
            NSString *userid0 = checkNull([sensorMaster valueForKey:@"userid0"]);
            NSString *userid1 = checkNull([sensorMaster valueForKey:@"userid1"]);
            NSString * sensorid = checkNull([sensorMaster valueForKey:@"sensorid"]);
            NSString * result = checkNull([sensorMaster valueForKey:@"result"]);
            
            
            // sqlite3_bind_int(statement, 1, id);
            sqlite3_bind_text(statement, 1, [nitid UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [userid0 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [userid1 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 4, [sensorid UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 5, [result UTF8String], -1, SQLITE_TRANSIENT);
            
            
            int success = sqlite3_step(statement);
            
            sqlite3_finalize(statement);
            if (success == SQLITE_ERROR) {
                // }
                
            }
        }else{
            [self updateL_SensorResult:sensorMaster :[sensorMaster valueForKey:@"userid0"]];
        }
    }
}


//取得しきい値状态
-(NSMutableDictionary*)getL_SensorResult:(NSString*)userid0{
    NSMutableDictionary *L_SensorResultData = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    sqlite3_stmt *statement;
    char * sql ="SELECT nitid, userid1, sensorid, result FROM L_SensorResult where userid0 = ?";
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    if (sqlReturn != SQLITE_OK) {
        
    }else{
        sqlite3_bind_text(statement,1, [userid0 UTF8String], -1, SQLITE_TRANSIENT);
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            char* tmpdata =(char*) sqlite3_column_text(statement, 0);
            [L_SensorResultData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"nitid"];
            tmpdata =(char*) sqlite3_column_text(statement, 1);
            [L_SensorResultData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"userid1"];
            tmpdata =(char*) sqlite3_column_text(statement, 2);
            [L_SensorResultData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"sensorid"];
            tmpdata =(char*) sqlite3_column_text(statement, 3);
            [L_SensorResultData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"result"];
            
            
        }
        
    }
    sqlite3_finalize(statement);
    
    return L_SensorResultData;
}

//更新しきい値状态
-(BOOL)updateL_SensorResult:(NSMutableDictionary*)L_SensorResult :(NSString*)userid0{
    
    sqlite3_stmt *statement;
    char * sql = "update L_SensorResult set nitid =? ,userid1 =? ,sensorid =?,result =? where userid0 = ? ";
    
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    if (sqlReturn != SQLITE_OK) {
        return NO;
    }
    
    NSString *nitid = checkNull([L_SensorResult valueForKey:@"nitid"]);
    NSString *userid1 = checkNull([L_SensorResult valueForKey:@"userid1"]);
    NSString * sensorid = checkNull([L_SensorResult valueForKey:@"sensorid"]);
    NSString * result = checkNull([L_SensorResult valueForKey:@"result"]);
    sqlite3_bind_text(statement, 1, [nitid UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 2, [userid1 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 3, [sensorid UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 4, [result UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(statement, 5, [userid0 UTF8String], -1, SQLITE_TRANSIENT);
    
    
    int success = sqlite3_step(statement);
    
    sqlite3_finalize(statement);
    if (success != SQLITE_DONE) {
        
    }
    return YES;
}

//添加更新異常通知先详情
-(void)addDataToL_ShiKiiContacts:(NSArray*)resDict{
    for (int i = 0; i < resDict.count; i++) {
        NSMutableDictionary*sensorMaster = [[NSMutableDictionary alloc]initWithDictionary:resDict[i]];
        NSMutableArray*sensorMaster1 = [[NSMutableArray alloc]initWithArray:[self getL_ShiKiiContacts:[sensorMaster valueForKey:@"userid1"] :[sensorMaster valueForKey:@"userid0"] :[sensorMaster valueForKey:@"sensorid"]  :[sensorMaster valueForKey:@"abnemail"]]];
        
        if (sensorMaster1.count <= 0){
            sqlite3_stmt *statement;
            char * sql = "INSERT INTO L_ShiKiiContacts(userid1,userid0,sensorid,abnname,abnemail) VALUES(?,?,?,?,?)";
            NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
            if (sqlReturn != SQLITE_OK) {
                
            }
            //        int id = 1;
            NSString *userid1 = checkNull([sensorMaster valueForKey:@"userid1"]);
            NSString *userid0 = checkNull([sensorMaster valueForKey:@"userid0"]);
            NSString *sensorid = checkNull([sensorMaster valueForKey:@"sensorid"]);
            NSString * abnname = checkNull([sensorMaster valueForKey:@"abnname"]);
            NSString * abnemail = checkNull([sensorMaster valueForKey:@"abnemail"]);
            
            // sqlite3_bind_int(statement, 1, id);
            sqlite3_bind_text(statement, 1, [userid1 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [userid0 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [sensorid UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 4, [abnname UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 5, [abnemail UTF8String], -1, SQLITE_TRANSIENT);
            
            
            
            int success = sqlite3_step(statement);
            
            sqlite3_finalize(statement);
            if (success == SQLITE_ERROR) {
                // }
                
            }
        }else{
            [self updateL_ShiKiiContacts:sensorMaster :[sensorMaster valueForKey:@"userid1"] :[sensorMaster valueForKey:@"userid0"] :[sensorMaster valueForKey:@"sensorid"] :[sensorMaster valueForKey:@"abnemail"]];
        }
    }
}

//取得異常通知先详情
-(NSMutableArray*)getL_ShiKiiContacts:(NSString*)userid1 :(NSString*)userid0 :(NSString*)sensorid  :(NSString*)abnemail{
    NSMutableArray *L_ShiKiiContactsArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    sqlite3_stmt *statement;
    char * sql ="SELECT userid1,userid0,sensorid,abnname,abnemail FROM L_ShiKiiContacts where userid1 =? and userid0 =? and sensorid =? and abnemail =? ";
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    if (sqlReturn != SQLITE_OK) {
        
    }else{
        sqlite3_bind_text(statement,1, [userid1 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement,2, [userid0 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement,3, [sensorid UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement,4, [abnemail UTF8String], -1, SQLITE_TRANSIENT);
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableDictionary *L_ShiKiiContactsData = [[NSMutableDictionary alloc]initWithCapacity:0];
            char* tmpdata =(char*) sqlite3_column_text(statement, 0);
            [L_ShiKiiContactsData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"userid1"];
            tmpdata =(char*) sqlite3_column_text(statement, 1);
            [L_ShiKiiContactsData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"userid0"];
            tmpdata =(char*) sqlite3_column_text(statement, 2);
            [L_ShiKiiContactsData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"sensorid"];
            tmpdata =(char*) sqlite3_column_text(statement, 3);
            [L_ShiKiiContactsData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"abnname"];
            tmpdata =(char*) sqlite3_column_text(statement, 4);
            [L_ShiKiiContactsData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"abnemail"];
            [L_ShiKiiContactsArr addObject:L_ShiKiiContactsData];
            
        }
        
    }
    sqlite3_finalize(statement);
    
    return L_ShiKiiContactsArr;
}

//更新異常通知先详情
-(BOOL)updateL_ShiKiiContacts:(NSMutableDictionary*)L_ShiKiiMaster :(NSString*)userid1 :(NSString*)userid0 :(NSString*)sensorid :(NSString*)abnemail{
    
    sqlite3_stmt *statement;
    char * sql = "update L_ShiKiiContacts set userid1 =? ,userid0 =? ,sensorid =?,abnname =?,abnemail =? where userid1 =? and userid0 =? and sensorid =? and abnemail =?";
    
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    if (sqlReturn != SQLITE_OK) {
        return NO;
    }
    
    NSString *userid11 = checkNull([L_ShiKiiMaster valueForKey:@"userid1"]);
    NSString *userid01 = checkNull([L_ShiKiiMaster valueForKey:@"userid0"]);
    NSString * sensorid1 = checkNull([L_ShiKiiMaster valueForKey:@"sensorid"]);
    NSString * abnname = checkNull([L_ShiKiiMaster valueForKey:@"abnname"]);
    NSString * abnemail1 = checkNull([L_ShiKiiMaster valueForKey:@"abnemail"]);
    
    sqlite3_bind_text(statement, 1, [userid11 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 2, [userid01 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 3, [sensorid1 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 4, [abnname UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 5, [abnemail1 UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(statement, 6, [[NSString stringWithFormat:@"%@",userid1] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 7, [[NSString stringWithFormat:@"%@",userid0] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 8, [[NSString stringWithFormat:@"%@",sensorid] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 9, [[NSString stringWithFormat:@"%@",abnemail] UTF8String], -1, SQLITE_TRANSIENT);
    
    
    int success = sqlite3_step(statement);
    
    sqlite3_finalize(statement);
    if (success != SQLITE_DONE) {
        
    }
    return YES;
}


//添加更新しきい値详情
-(void)addDataToL_ShiKiiMaster:(NSArray*)resDict{
    for (int i = 0; i < resDict.count; i++) {
        NSMutableDictionary*sensorMaster = [[NSMutableDictionary alloc]initWithDictionary:resDict[i]];
        NSMutableArray*sensorMaster1 = [[NSMutableArray alloc]initWithArray:[self getL_ShiKiiMaster:[sensorMaster valueForKey:@"nitid"] :[sensorMaster valueForKey:@"userid0"]  :[sensorMaster valueForKey:@"sensorid"]]];
        
        if (sensorMaster1.count <= 0) {
            sqlite3_stmt *statement;
            char * sql = "INSERT INTO L_ShiKiiMaster(nitid, userid1, userid0,sensorid, pattern1, time1, value1 , pattern2, time2, value2, graphtype) VALUES(?,?,?,?,?,?,?,?,?,?,?)";
            NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
            if (sqlReturn != SQLITE_OK) {
                
            }
            //        int id = 1;
            NSString *nitid = checkNull([sensorMaster valueForKey:@"nitid"]);
            NSString *userid1 = checkNull([sensorMaster valueForKey:@"userid1"]);
            NSString *userid0 = checkNull([sensorMaster valueForKey:@"userid0"]);
            NSString *sensorid = checkNull([sensorMaster valueForKey:@"sensorid"]);
            NSString * pattern1 = checkNull([sensorMaster valueForKey:@"pattern1"]);
            NSString * time1 = checkNull([sensorMaster valueForKey:@"time1"]);
            NSString *value1 = checkNull([sensorMaster valueForKey:@"value1"]);
            NSString * pattern2 = checkNull([sensorMaster valueForKey:@"pattern2"]);
            NSString * time2 = checkNull([sensorMaster valueForKey:@"time2"]);
            NSString *value2 = checkNull([sensorMaster valueForKey:@"value2"]);
            NSString *graphtype = checkNull([sensorMaster valueForKey:@"graphtype"]);
            
            
            
            // sqlite3_bind_int(statement, 1, id);
            sqlite3_bind_text(statement, 1, [nitid UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [userid1 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [userid0 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 4, [sensorid UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 5, [pattern1 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 6, [time1 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 7, [value1 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 8, [pattern2 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 9, [time2 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 10, [value2 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 11, [graphtype UTF8String], -1, SQLITE_TRANSIENT);
            
            
            int success = sqlite3_step(statement);
            
            sqlite3_finalize(statement);
            if (success == SQLITE_ERROR) {
                // }
            }
        }else{
            [self updateL_ShiKiiMaster:sensorMaster :[sensorMaster valueForKey:@"nitid"] :[sensorMaster valueForKey:@"userid0"] :[sensorMaster valueForKey:@"sensorid"]];
        }
    }
}

//取得しきい値详情
-(NSMutableArray*)getL_ShiKiiMaster:(NSString*)nitid :(NSString*)userid0  :(NSString*)sensorid{
    
    NSMutableArray *L_ShiKiiMastersArr = [[NSMutableArray alloc]initWithCapacity:0];
    sqlite3_stmt *statement;
    char * sql ="SELECT userid1, pattern1, time1, value1, pattern2, time2, value2, graphtype FROM L_ShiKiiMaster where nitid = ? and userid0 = ? and sensorid = ?";
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    if (sqlReturn != SQLITE_OK) {
        
    }else{
        sqlite3_bind_text(statement,1, [nitid UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement,2, [userid0 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement,3, [sensorid UTF8String], -1, SQLITE_TRANSIENT);
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableDictionary *L_ShiKiiMasterData = [[NSMutableDictionary alloc]initWithCapacity:0];
            char* tmpdata =(char*) sqlite3_column_text(statement, 0);
            [L_ShiKiiMasterData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"userid1"];
            
            tmpdata =(char*) sqlite3_column_text(statement, 1);
            [L_ShiKiiMasterData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"pattern1"];
            
            tmpdata =(char*) sqlite3_column_text(statement, 2);
            [L_ShiKiiMasterData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"time1"];
            
            tmpdata =(char*) sqlite3_column_text(statement, 3);
            [L_ShiKiiMasterData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"value1"];
            
            tmpdata =(char*) sqlite3_column_text(statement, 4);
            [L_ShiKiiMasterData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"pattern2"];
            
            tmpdata =(char*) sqlite3_column_text(statement, 5);
            [L_ShiKiiMasterData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"time2"];
            
            tmpdata =(char*) sqlite3_column_text(statement, 6);
            [L_ShiKiiMasterData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"value2"];
            
            tmpdata =(char*) sqlite3_column_text(statement, 7);
            [L_ShiKiiMasterData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"graphtype"];
            
            [L_ShiKiiMastersArr addObject:L_ShiKiiMasterData];
            
        }
        
    }
    sqlite3_finalize(statement);
    
    return L_ShiKiiMastersArr;
}

//更新しきい値详情
-(BOOL)updateL_ShiKiiMaster:(NSMutableDictionary*)L_ShiKiiMaster1 :(NSString*)nitid :(NSString*)userid0  :(NSString*)sensorid{
    
    sqlite3_stmt *statement;
    char * sql = "update L_ShiKiiMaster set nitid = ?, userid1 = ?, userid0 = ?,sensorid = ?,  pattern1 =? , time1 =? , value1 =? , pattern2 =? , time2 =? , value2 =? , graphtype = ? where nitid = ? and userid0 =? and sensorid =? ";

    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    if (sqlReturn != SQLITE_OK) {
        return NO;
    }
    NSString *nitid1 = checkNull([L_ShiKiiMaster1 valueForKey:@"nitid"]);
    NSString *userid1 = checkNull([L_ShiKiiMaster1 valueForKey:@"userid1"]);
    NSString *userid01 = checkNull([L_ShiKiiMaster1 valueForKey:@"userid0"]);
    //NSString *sensorid1 = checkNull([L_ShiKiiMaster1 valueForKey:@"sensorid"]);
    NSString * pattern1 = checkNull([L_ShiKiiMaster1 valueForKey:@"pattern1"]);
    NSString * time1 = checkNull([L_ShiKiiMaster1 valueForKey:@"time1"]);
    NSString *value1 = checkNull([L_ShiKiiMaster1 valueForKey:@"value1"]);
    NSString * pattern2 = checkNull([L_ShiKiiMaster1 valueForKey:@"pattern2"]);
    NSString * time2 = checkNull([L_ShiKiiMaster1 valueForKey:@"time2"]);
    NSString *value2 = checkNull([L_ShiKiiMaster1 valueForKey:@"value2"]);
    NSString *graphtype = checkNull([L_ShiKiiMaster1 valueForKey:@"graphtype"]);
    sqlite3_bind_text(statement, 1, [nitid1 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 2, [userid1 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 3, [userid01 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 4, [sensorid UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 5, [pattern1 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 6, [time1 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 7, [value1 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 8, [pattern2 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 9, [time2 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 10, [value2 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 11, [graphtype UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 12, [[NSString stringWithFormat:@"%@",nitid] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 13, [[NSString stringWithFormat:@"%@",userid0] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 14, [[NSString stringWithFormat:@"%@",sensorid] UTF8String], -1, SQLITE_TRANSIENT);
    
    
    int success = sqlite3_step(statement);
    
    sqlite3_finalize(statement);
    if (success != SQLITE_DONE) {
        
    }
    return YES;
}


//添加更新传感器详情
-(void)addDataToL_SensorMaster:(NSArray*)resDict{
    
    for (int i = 0; i < resDict.count; i++) {
        NSMutableDictionary*sensorMaster = [[NSMutableDictionary alloc]initWithDictionary:resDict[i]];
        NSMutableArray*sensorMaster1 = [[NSMutableArray alloc]initWithArray:[self getL_SensorMaster:[sensorMaster valueForKey:@"nitid"]]];
        
        if (sensorMaster1.count <= 0) {
            sqlite3_stmt *statement;
            char * sql = "INSERT INTO L_SensorMaster(nitid, userid0, sensorid, sensorname, unit) VALUES(?,?,?,?,?)";
            NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
            if (sqlReturn != SQLITE_OK) {
                
            }
            //        int id = 1;
            NSString *nitid = checkNull([sensorMaster valueForKey:@"nitid"]);
            NSString *userid0 = checkNull([sensorMaster valueForKey:@"userid0"]);
            NSString * sensorid = checkNull([sensorMaster valueForKey:@"sensorid"]);
            NSString * sensorname = checkNull([sensorMaster valueForKey:@"sensorname"]);
            NSString *unit = checkNull([sensorMaster valueForKey:@"unit"]);

            
            // sqlite3_bind_int(statement, 1, id);
            sqlite3_bind_text(statement, 1, [nitid UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [userid0 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [sensorid UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 4, [sensorname UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 5, [unit UTF8String], -1, SQLITE_TRANSIENT);

            
            int success = sqlite3_step(statement);
            
            sqlite3_finalize(statement);
            if (success == SQLITE_ERROR) {
                // }
                
            }
        }else{
            [self updateL_SensorMaster:sensorMaster :[sensorMaster valueForKey:@"nitid"]];
        }
    }
}


//取得传感器详情
-(NSMutableArray*)getL_SensorMaster:(NSString*)nitid{
    NSMutableArray *L_SensorMasterArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    sqlite3_stmt *statement;
    char * sql ="SELECT nitid,userid0, sensorid, sensorname, unit FROM L_SensorMaster where nitid = ?";
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    if (sqlReturn != SQLITE_OK) {
        
    }else{
        sqlite3_bind_text(statement,1, [[NSString stringWithFormat:@"%@",nitid] UTF8String], -1, SQLITE_TRANSIENT);
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableDictionary *L_SensorMasterData = [[NSMutableDictionary alloc]initWithCapacity:0];
            char* tmpdata =(char*) sqlite3_column_text(statement, 0);
            [L_SensorMasterData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"nitid"];
            tmpdata =(char*) sqlite3_column_text(statement, 1);
            [L_SensorMasterData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"userid0"];
            tmpdata =(char*) sqlite3_column_text(statement, 2);
            [L_SensorMasterData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"sensorid"];
            tmpdata =(char*) sqlite3_column_text(statement, 3);
            [L_SensorMasterData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"sensorname"];
            tmpdata =(char*) sqlite3_column_text(statement, 4);
            [L_SensorMasterData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"unit"];

            [L_SensorMasterArr addObject:L_SensorMasterData];
            
        }
        
    }
    sqlite3_finalize(statement);
    
    return L_SensorMasterArr;
}

//更新传感器详情
-(BOOL)updateL_SensorMaster:(NSMutableDictionary*)L_SensorMaster :(NSString*)nitid{
    
    sqlite3_stmt *statement;
    char * sql = "update L_SensorMaster set nitid =? ,userid0 = ? ,sensorid =? ,sensorname =?,unit =? where nitid = ? ";
    
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    if (sqlReturn != SQLITE_OK) {
        return NO;
    }
    
    NSString *nitid1 = checkNull([L_SensorMaster valueForKey:@"nitid"]);
    NSString *userid0 = checkNull([L_SensorMaster valueForKey:@"userid0"]);
    NSString * sensorid = checkNull([L_SensorMaster valueForKey:@"sensorid"]);
    NSString * sensorname = checkNull([L_SensorMaster valueForKey:@"sensorname"]);
    NSString *unit = checkNull([L_SensorMaster valueForKey:@"unit"]);

    sqlite3_bind_text(statement, 1, [nitid1 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 2, [userid0 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 3, [sensorid UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 4, [sensorname UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 5, [unit UTF8String], -1, SQLITE_TRANSIENT);

    
    sqlite3_bind_text(statement, 5, [[NSString stringWithFormat:@"%@",nitid] UTF8String], -1, SQLITE_TRANSIENT);
    
    
    int success = sqlite3_step(statement);
    
    sqlite3_finalize(statement);
    if (success != SQLITE_DONE) {
        
    }
    return YES;
}


//添加更新用户管理
-(void)addDataToL_UserTBL:(NSArray*)resDict{
    for (int i = 0; i < resDict.count; i++) {
        NSMutableDictionary*sensorMaster = [[NSMutableDictionary alloc]initWithDictionary:resDict[i]];
        NSMutableArray*sensorMaster1 = [[NSMutableArray alloc]initWithArray:[self getL_UserTBL:[sensorMaster valueForKey:@"userid1"] :[sensorMaster valueForKey:@"userid0"]]];
        
        if (sensorMaster1.count <= 0) {
            
            sqlite3_stmt *statement;
            char * sql = "INSERT INTO L_UserTBL(userid1,userid0,nickname) VALUES(?,?,?)";
            NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
            if (sqlReturn != SQLITE_OK) {
                
            }
            //        int id = 1;
            NSString *userid1 = checkNull([sensorMaster valueForKey:@"userid1"]);
            NSString *userid0 = checkNull([sensorMaster valueForKey:@"userid0"]);
            NSString *nickname = checkNull([sensorMaster valueForKey:@"nickname"]);
            
            sqlite3_bind_text(statement, 1, [userid1 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [userid0 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [nickname UTF8String], -1, SQLITE_TRANSIENT);
            
            
            
            int success = sqlite3_step(statement);
            
            sqlite3_finalize(statement);
            if (success == SQLITE_ERROR) {
                // }
                
            }
        }else{
            [self updateL_UserTBL:sensorMaster :[sensorMaster valueForKey:@"userid1"] :[sensorMaster valueForKey:@"userid0"]];
        }
    }
}

//取得用户管理
-(NSMutableArray*)getL_UserTBL:(NSString*)userid1 :(NSString*)userid0{
    NSMutableArray *L_UserTBLArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    sqlite3_stmt *statement;
    char * sql ="SELECT userid1,userid0, nickname  FROM L_UserTBL where userid1 = ? and userid0 = ?";
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    if (sqlReturn != SQLITE_OK) {
        
    }else{
        sqlite3_bind_text(statement,1, [userid1 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement,2, [userid0 UTF8String], -1, SQLITE_TRANSIENT);
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableDictionary *L_UserTBLData = [[NSMutableDictionary alloc]initWithCapacity:0];
            char* tmpdata =(char*) sqlite3_column_text(statement, 0);
            [L_UserTBLData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"userid1"];
            tmpdata =(char*) sqlite3_column_text(statement, 1);
            [L_UserTBLData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"userid0"];
            tmpdata =(char*) sqlite3_column_text(statement, 2);
            [L_UserTBLData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"nickname"];
            [L_UserTBLArr addObject:L_UserTBLData];
        }
        
    }
    sqlite3_finalize(statement);
    
    return L_UserTBLArr;
}

//更新用户管理
-(BOOL)updateL_UserTBL:(NSMutableDictionary*)L_UserTBL :(NSString*)userid1 :(NSString*)userid0{
    
    sqlite3_stmt *statement;
    char * sql = "update L_UserTBLData set nickname =? where userid1 = ? and userid0 = ?";
    
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    if (sqlReturn != SQLITE_OK) {
        return NO;
    }
    NSString *nickname = checkNull([L_UserTBL valueForKey:@"nickname"]);
    sqlite3_bind_text(statement, 1, [nickname UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(statement, 6, [[NSString stringWithFormat:@"%@",userid1] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 7, [[NSString stringWithFormat:@"%@",userid0] UTF8String], -1, SQLITE_TRANSIENT);
    
    int success = sqlite3_step(statement);
    
    sqlite3_finalize(statement);
    if (success != SQLITE_DONE) {
        
    }
    return YES;
}

//添加更新紧急联络
-(void)addDataToL_EmergencyContacts:(NSArray*)resDict{
    for (int i = 0; i < resDict.count; i++) {
        NSMutableDictionary*sensorMaster = [[NSMutableDictionary alloc]initWithDictionary:resDict[i]];
        NSMutableArray*sensorMaster1 = [[NSMutableArray alloc]initWithArray:[self getL_EmergencyContacts:[sensorMaster valueForKey:@"userid0"] :[sensorMaster valueForKey:@"contact"]]];
        if (sensorMaster1.count <= 0) {
            sqlite3_stmt *statement;
            char * sql = "INSERT INTO L_EmergencyContacts(userid0,contact,nickname) VALUES(?,?,?)";
            NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
            if (sqlReturn != SQLITE_OK) {
                
            }

            NSString *userid0 = checkNull([sensorMaster valueForKey:@"userid0"]);
            NSString *contact = checkNull([sensorMaster valueForKey:@"contact"]);
            NSString * nickname = checkNull([sensorMaster valueForKey:@"nickname"]);

            sqlite3_bind_text(statement, 1, [userid0 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [contact UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [nickname UTF8String], -1, SQLITE_TRANSIENT);

            int success = sqlite3_step(statement);
            
            sqlite3_finalize(statement);
            if (success == SQLITE_ERROR) {

            }
        }else{
            [self updateL_EmergencyContacts:sensorMaster :[sensorMaster valueForKey:@"userid0"] :[sensorMaster valueForKey:@"contact"]];
        }
    }
}

//取得紧急联络
-(NSMutableArray*)getL_EmergencyContacts:(NSString*)userid0 :(NSString*)contact{
    
    NSMutableArray *emergencyContactsArr = [[NSMutableArray alloc]initWithCapacity:0];
    sqlite3_stmt *statement;
    char * sql ="SELECT userid0, contact, nickname FROM L_EmergencyContacts where userid0 = ? and contact = ?";
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    if (sqlReturn != SQLITE_OK) {
        
    }else{
        sqlite3_bind_text(statement,1, [userid0 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement,2, [contact UTF8String], -1, SQLITE_TRANSIENT);
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableDictionary *emergencyContactsData = [[NSMutableDictionary alloc]init];
            char* tmpdata =(char*) sqlite3_column_text(statement, 0);
            [emergencyContactsData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"userid0"];
            tmpdata =(char*) sqlite3_column_text(statement, 1);
            [emergencyContactsData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"contact"];
            tmpdata =(char*) sqlite3_column_text(statement, 2);
            [emergencyContactsData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"nickname"];
            [emergencyContactsArr addObject:emergencyContactsData];
        }
    }
    sqlite3_finalize(statement);
    
    return emergencyContactsArr;
}

//更新紧急联络
-(BOOL)updateL_EmergencyContacts:(NSMutableDictionary*)emergencyContacts :(NSString*)userid0 :(NSString*)contact{
    
    sqlite3_stmt *statement;
    char * sql = "update L_EmergencyContacts set userid0 =? , contact =? ,nickname =? where userid0 = ?  and  contact = ?";
    
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    if (sqlReturn != SQLITE_OK) {
        return NO;
    }
    NSString *contact1 = checkNull([emergencyContacts valueForKey:@"contact"]);
    NSString * nickname = checkNull([emergencyContacts valueForKey:@"nickname"]);
    sqlite3_bind_text(statement, 1, [[NSString stringWithFormat:@"%@",userid0] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 2, [contact1 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 3, [nickname UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(statement, 4, [[NSString stringWithFormat:@"%@",userid0] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 5, [[NSString stringWithFormat:@"%@",contact] UTF8String], -1, SQLITE_TRANSIENT);
    
    int success = sqlite3_step(statement);
    
    sqlite3_finalize(statement);
    if (success != SQLITE_DONE) {
        
    }
    return YES;
}


//添加更新管理用户详情
-(void)addDataToL_UserMasterTable:(NSArray*)resDict{
    NSMutableDictionary*sensorMaster1 = [[NSMutableDictionary alloc]initWithDictionary:[self getUserMasterData]];
    for (int i = 0; i < resDict.count; i++) {
        NSMutableDictionary*sensorMaster = [[NSMutableDictionary alloc]initWithDictionary:resDict[i]];
        
        
        if (sensorMaster1.count <= 0) {
            sqlite3_stmt *statement;
            char * sql = "INSERT INTO L_UserMaster(userid, usertype, username, nickname, contact, password, email) VALUES(?,?,?,?,?,?,?)";
            NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
            if (sqlReturn != SQLITE_OK) {
                
            }
            //        int id = 1;
            NSString *userid = checkNull([sensorMaster valueForKey:@"userid"]);
            NSString *usertype = checkNull([sensorMaster valueForKey:@"usertype"]);
            NSString * username = checkNull([sensorMaster valueForKey:@"username"]);
            NSString * nickname = checkNull([sensorMaster valueForKey:@"nickname"]);
            NSString *contact = checkNull([sensorMaster valueForKey:@"contact"]);
            NSString * password = checkNull([sensorMaster valueForKey:@"password"]);
            NSString * email = checkNull([sensorMaster valueForKey:@"email"]);
        
            sqlite3_bind_text(statement, 1, [userid UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [usertype UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [username UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 4, [nickname UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 5, [contact UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 6, [password UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 7, [email UTF8String], -1, SQLITE_TRANSIENT);
            
            
            int success = sqlite3_step(statement);
            
            sqlite3_finalize(statement);
            if (success == SQLITE_ERROR) {
  
            }
        }else{
            [self updateUserMasterData:sensorMaster];
        }
    }
}

//取得管理用户详情
-(NSMutableDictionary*)getUserMasterData{
    NSMutableDictionary *UserMasterData = [[NSMutableDictionary alloc]initWithCapacity:0];
    sqlite3_stmt *statement;
    char * sql ="SELECT userid,usertype, username, nickname, contact, password, email  FROM L_UserMaster ";
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    if (sqlReturn != SQLITE_OK) {
        
    }else{
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            char* tmpdata =(char*) sqlite3_column_text(statement, 0);
            [UserMasterData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"userid"];
            tmpdata =(char*) sqlite3_column_text(statement, 1);
            [UserMasterData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"usertype"];
            tmpdata =(char*) sqlite3_column_text(statement, 2);
            [UserMasterData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"username"];
            tmpdata =(char*) sqlite3_column_text(statement, 3);
            [UserMasterData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"nickname"];
            tmpdata =(char*) sqlite3_column_text(statement, 4);
            [UserMasterData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"contact"];
            tmpdata =(char*) sqlite3_column_text(statement, 5);
            [UserMasterData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"password"];
            tmpdata =(char*) sqlite3_column_text(statement, 6);
            [UserMasterData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"email"];
            
        }
        
    }
    sqlite3_finalize(statement);
    
    return UserMasterData;
}

//更新管理用户详情
-(BOOL)updateUserMasterData:(NSMutableDictionary*)userMaster{
    
    sqlite3_stmt *statement;
    char * sql = "update L_UserMaster set userid=? ,usertype=? , username =? ,nickname =?,contact =? ,password =?,email =? ";
    
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    if (sqlReturn != SQLITE_OK) {
        return NO;
    }
    sqlite3_bind_text(statement, 1, [[NSString stringWithFormat:@"%@",[userMaster valueForKey:@"userid"]] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 2, [[NSString stringWithFormat:@"%@",[userMaster valueForKey:@"usertype"]] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 3, [[NSString stringWithFormat:@"%@",[userMaster valueForKey:@"username"]] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 4, [[NSString stringWithFormat:@"%@",[userMaster valueForKey:@"nickname"]] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 5, [[NSString stringWithFormat:@"%@",[userMaster valueForKey:@"contact"]] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 6, [[NSString stringWithFormat:@"%@",[userMaster valueForKey:@"password"]] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 7, [[NSString stringWithFormat:@"%@",[userMaster valueForKey:@"email"]] UTF8String], -1, SQLITE_TRANSIENT);
    
    
    int success = sqlite3_step(statement);
    
    sqlite3_finalize(statement);
    if (success != SQLITE_DONE) {
        
    }
    return YES;
}


//添加更新用户详情
-(void)addDataToL_UserInfoTable:(NSArray*)resDict{
    
    for (int i = 0; i < resDict.count; i++) {
        NSMutableDictionary*sensorMaster = [[NSMutableDictionary alloc]initWithDictionary:resDict[i]];
        NSMutableDictionary*sensorMaster1 = [[NSMutableDictionary alloc]initWithDictionary:[self getUserInfoData:[sensorMaster valueForKey:@"userid0"]]];
        //NSLog(@"%@",ddd);
        
        if (sensorMaster1.count <= 0) {
            sqlite3_stmt *statement;
            char * sql = "INSERT INTO L_UserInfo(userid0, username, sex, birthday, address, kakaritsuke, drug, health, other, updatetime, updatename) VALUES(?,?,?,?,?,?,?,?,?,?,?)";
            NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
            if (sqlReturn != SQLITE_OK) {
            }
            
            NSString *userid0 = checkNull([sensorMaster valueForKey:@"userid0"]);
            
            NSString *username = checkNull([sensorMaster valueForKey:@"username"]);
            NSString *sex = checkNull([sensorMaster valueForKey:@"sex"]);
            NSString *birthday = checkNull([sensorMaster valueForKey:@"birthday"]);
            NSString *address = checkNull([sensorMaster valueForKey:@"address"]);
            
            NSString *kakaritsuke = checkNull([sensorMaster valueForKey:@"kakaritsuke"]);
            
            NSString *drug = checkNull([sensorMaster valueForKey:@"drug"]);
            NSString *health = checkNull([sensorMaster valueForKey:@"health"]);
            NSString *other = checkNull([sensorMaster valueForKey:@"other"]);
            NSString *updatetime = checkNull([sensorMaster valueForKey:@"updatetime"]);
            NSString *updatename = checkNull([sensorMaster valueForKey:@"updatename"]);
            
            sqlite3_bind_text(statement, 1, [userid0 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [username UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [sex UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 4, [birthday UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 5, [address UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 6, [kakaritsuke UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 7, [drug UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 8, [health UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 9, [other UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 10, [updatetime UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 11, [updatename UTF8String], -1, SQLITE_TRANSIENT);
            
            int success = sqlite3_step(statement);
            
            sqlite3_finalize(statement);
            if (success == SQLITE_ERROR) {
                // }
            }
        }else{
            [self updateUserInfoData:sensorMaster :[sensorMaster valueForKey:@"userid0"]];
        }
    }
}


//取得用户详情
-(NSMutableDictionary*)getUserInfoData:(NSString*)userid0{
    NSMutableDictionary *UserInfoData = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    sqlite3_stmt *statement;
    char * sql ="SELECT userid0, username, sex, birthday, address, kakaritsuke, drug, health, other, updatetime, updatename  FROM L_userinfo where userid0 = ?";
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    if (sqlReturn != SQLITE_OK) {
        
    }else{
        sqlite3_bind_text(statement,1, [userid0 UTF8String], -1, SQLITE_TRANSIENT);
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            char* tmpdata =(char*) sqlite3_column_text(statement, 0);
            [UserInfoData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"userid0"];
            tmpdata =(char*) sqlite3_column_text(statement, 1);
            [UserInfoData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"username"];
            tmpdata =(char*) sqlite3_column_text(statement, 2);
            [UserInfoData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"sex"];
            tmpdata =(char*) sqlite3_column_text(statement, 3);
            [UserInfoData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"birthday"];
            tmpdata =(char*) sqlite3_column_text(statement, 4);
            [UserInfoData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"address"];
            tmpdata =(char*) sqlite3_column_text(statement, 5);
            [UserInfoData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"kakaritsuke"];
            tmpdata =(char*) sqlite3_column_text(statement, 6);
            [UserInfoData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"drug"];
            tmpdata =(char*) sqlite3_column_text(statement, 7);
            [UserInfoData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"health"];
            tmpdata =(char*) sqlite3_column_text(statement, 8);
            [UserInfoData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"other"];
            tmpdata =(char*) sqlite3_column_text(statement, 9);
            [UserInfoData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"updatetime"];
            tmpdata =(char*) sqlite3_column_text(statement, 10);
            [UserInfoData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"updatename"];
            
            
        }
        
    }
    sqlite3_finalize(statement);
    
    return UserInfoData;
}

//更新用户详情
-(BOOL)updateUserInfoData:(NSMutableDictionary*)userinfo :(NSString*)userId{
    
    sqlite3_stmt *statement;
    char * sql = "update L_userinfo set userid0 =?, username =? ,sex =?,birthday =? ,address =?,kakaritsuke =?,drug =?,health =?,other =?,updatetime =?,updatename =? where userid0 = ?";
    
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    if (sqlReturn != SQLITE_OK) {
        return NO;
    }
    
    NSString *userid0 = checkNull([userinfo valueForKey:@"userid0"]);
    NSString *username = checkNull([userinfo valueForKey:@"username"]);
    NSString *sex = checkNull([userinfo valueForKey:@"sex"]);
    NSString *birthday = checkNull([userinfo valueForKey:@"birthday"]);
    NSString *address = checkNull([userinfo valueForKey:@"address"]);
    NSString *kakaritsuke = checkNull([userinfo valueForKey:@"kakaritsuke"]);
    NSString *drug = checkNull([userinfo valueForKey:@"drug"]);
    NSString *health = checkNull([userinfo valueForKey:@"health"]);
    NSString *other = checkNull([userinfo valueForKey:@"other"]);
    NSString *updatetime = checkNull([userinfo valueForKey:@"updatetime"]);
    NSString *updatename = checkNull([userinfo valueForKey:@"updatename"]);
    sqlite3_bind_text(statement, 1, [userid0 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 2, [username UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 3, [sex UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 4, [birthday UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 5, [address UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 6, [kakaritsuke UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 7, [drug UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 8, [health UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 9, [other UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 10, [updatetime UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 11,[updatename UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 12, [userid0 UTF8String], -1, SQLITE_TRANSIENT);
    
    int success = sqlite3_step(statement);
    
    sqlite3_finalize(statement);
    if (success != SQLITE_DONE) {
        
    }
    return YES;
}

//生活
-(NSMutableArray*)getL_SensorResult1{
    
    NSMutableArray *L_SensorResultArr1 = [[NSMutableArray alloc]initWithCapacity:0];
    sqlite3_stmt *statement;
    
    char *sql = "SELECT u.userid1,u.userid0,u.nickname,s.sensorid,s.nitid,s.result FROM L_UserTBL u LEFT JOIN L_SensorResult s ON u.userid0=s.userid0";
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    if (sqlReturn != SQLITE_OK) {
        
    }else{
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableDictionary *L_SensorResultData1 = [[NSMutableDictionary alloc]init];
            char* tmpdata =(char*) sqlite3_column_text(statement, 0);
            [L_SensorResultData1 setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"userid1"];
            tmpdata =(char*) sqlite3_column_text(statement, 1);
            [L_SensorResultData1 setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"userid0"];
            tmpdata =(char*) sqlite3_column_text(statement, 2);
            [L_SensorResultData1 setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"nickname"];
            tmpdata =(char*) sqlite3_column_text(statement, 3);
            [L_SensorResultData1 setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"sensorid"];
            tmpdata =(char*) sqlite3_column_text(statement, 4);
            [L_SensorResultData1 setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"nitid"];
            tmpdata =(char*) sqlite3_column_text(statement, 5);
            [L_SensorResultData1 setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"result"];
            [L_SensorResultArr1 addObject:L_SensorResultData1];
        }
    }
    sqlite3_finalize(statement);
    
    return L_SensorResultArr1;
}
//緊急連絡
-(NSMutableArray*)getL_UserTBL1{
    
    NSMutableArray *L_UserTBLArr1 = [[NSMutableArray alloc]initWithCapacity:0];
    sqlite3_stmt *statement;
    
    char *sql = "SELECT userid1,userid0,nickname FROM L_UserTBL";
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    if (sqlReturn != SQLITE_OK) {
        
    }else{
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableDictionary *L_UserTBLData1 = [[NSMutableDictionary alloc]init];
            char* tmpdata =(char*) sqlite3_column_text(statement, 0);
            [L_UserTBLData1 setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"userid1"];
            tmpdata =(char*) sqlite3_column_text(statement, 1);
            [L_UserTBLData1 setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"userid0"];
            tmpdata =(char*) sqlite3_column_text(statement, 2);
            [L_UserTBLData1 setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"nickname"];
            [L_UserTBLArr1 addObject:L_UserTBLData1];
        }
        
    }
    sqlite3_finalize(statement);
    
    return L_UserTBLArr1;
}

//添加更新紧急联络
-(void)addDataToL_EmergencyContacts1:(NSMutableDictionary*)resDict :(NSString*)userid01 :(NSString*)contact1{
    
    NSMutableArray*sensorMaster1 = [[NSMutableArray alloc]initWithArray:[self getL_EmergencyContacts:userid01 :contact1]];
    if (sensorMaster1.count <= 0 ) {
        sqlite3_stmt *statement;
        char * sql = "INSERT INTO L_EmergencyContacts(userid0,contact,nickname) VALUES(?,?,?)";
        NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
        if (sqlReturn != SQLITE_OK) {
            
        }
        //   int id = 1;
        NSString *userid0 = checkNull([resDict valueForKey:@"userid0"]);
        NSString *contact = checkNull([resDict valueForKey:@"contact"]);
        NSString * nickname = checkNull([resDict valueForKey:@"nickname"]);
        
        
        sqlite3_bind_text(statement, 1, [userid0 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [contact UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [nickname UTF8String], -1, SQLITE_TRANSIENT);
        
        
        
        int success = sqlite3_step(statement);
        
        sqlite3_finalize(statement);
        if (success == SQLITE_ERROR) {
            // }
            
        }
    }else{
        [self updateL_EmergencyContacts:resDict :[resDict valueForKey:@"userid0"] :[resDict valueForKey:@"contact"]];
    }
}



//删除紧急联络
-(BOOL)deleteL_EmergencyContacts1:(NSString*)userid0 :(NSString*)contact{
    
    char *sql ="delete from L_EmergencyContacts where userid0 = ? and contact = ? ";
    
    sqlite3_stmt *statement;
    
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    
    
    if (sqlReturn != SQLITE_OK) {
        return NO;
    }else{
        sqlite3_bind_text(statement,1, [userid0 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement,2, [contact UTF8String], -1, SQLITE_TRANSIENT);
        
    }
    int success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (success != SQLITE_DONE) {
        return NO;
    }else{
        return YES;
    }
    
}

//取得紧急联络
-(NSMutableArray*)getL_EmergencyContacts1:(NSString*)userid0{
    
    NSMutableArray *emergencyContactsArr = [[NSMutableArray alloc]initWithCapacity:0];
    sqlite3_stmt *statement;
    char * sql ="SELECT userid0, contact, nickname FROM L_EmergencyContacts where userid0 = ?";
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    if (sqlReturn != SQLITE_OK) {
        
    }else{
        sqlite3_bind_text(statement,1, [userid0 UTF8String], -1, SQLITE_TRANSIENT);
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableDictionary *emergencyContactsData = [[NSMutableDictionary alloc]init];
            char* tmpdata =(char*) sqlite3_column_text(statement, 0);
            [emergencyContactsData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"userid0"];
            tmpdata =(char*) sqlite3_column_text(statement, 1);
            [emergencyContactsData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"contact"];
            tmpdata =(char*) sqlite3_column_text(statement, 2);
            [emergencyContactsData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"nickname"];
            [emergencyContactsArr addObject:emergencyContactsData];
        }
    }
    sqlite3_finalize(statement);
    
    return emergencyContactsArr;
}

//添加更新しきい値详情
//-(void)addDataToL_ShiKiiMaster1:(NSMutableDictionary*)resDict :(NSString*)nitid{
//
//        NSMutableArray*sensorMaster1 = [[NSMutableArray alloc]initWithArray:[self getL_ShiKiiMaster:nitid]];
//        
//        if (sensorMaster1.count <= 0) {
//            sqlite3_stmt *statement;
//            char * sql = "INSERT INTO L_ShiKiiMaster(nitid, userid1, userid0, pattern1, time1, value1 , pattern2, time2, value2) VALUES(?,?,?,?,?,?,?,?,?)";
//            NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
//            if (sqlReturn != SQLITE_OK) {
//                
//            }
//            //        int id = 1;
//            NSString *nitid = checkNull([resDict valueForKey:@"nitid"]);
//            NSString *userid1 = checkNull([resDict valueForKey:@"userid1"]);
//            NSString *userid0 = checkNull([resDict valueForKey:@"userid0"]);
//            NSString * pattern1 = checkNull([resDict valueForKey:@"pattern1"]);
//            NSString * time1 = checkNull([resDict valueForKey:@"time1"]);
//            NSString *value1 = checkNull([resDict valueForKey:@"value1"]);
//            NSString * pattern2 = checkNull([resDict valueForKey:@"pattern2"]);
//            NSString * time2 = checkNull([resDict valueForKey:@"time2"]);
//            NSString *value2 = checkNull([resDict valueForKey:@"value2"]);
//            
//            
//            
//            
//            // sqlite3_bind_int(statement, 1, id);
//            sqlite3_bind_text(statement, 1, [nitid UTF8String], -1, SQLITE_TRANSIENT);
//            sqlite3_bind_text(statement, 2, [userid1 UTF8String], -1, SQLITE_TRANSIENT);
//            sqlite3_bind_text(statement, 3, [userid0 UTF8String], -1, SQLITE_TRANSIENT);
//            sqlite3_bind_text(statement, 4, [pattern1 UTF8String], -1, SQLITE_TRANSIENT);
//            sqlite3_bind_text(statement, 5, [time1 UTF8String], -1, SQLITE_TRANSIENT);
//            sqlite3_bind_text(statement, 6, [value1 UTF8String], -1, SQLITE_TRANSIENT);
//            sqlite3_bind_text(statement, 7, [pattern2 UTF8String], -1, SQLITE_TRANSIENT);
//            sqlite3_bind_text(statement, 8, [time2 UTF8String], -1, SQLITE_TRANSIENT);
//            sqlite3_bind_text(statement, 9, [value2 UTF8String], -1, SQLITE_TRANSIENT);
//            
//            
//            int success = sqlite3_step(statement);
//            
//            sqlite3_finalize(statement);
//            if (success == SQLITE_ERROR) {
//                // }
//                
//            }
//        }else{
//            [self updateL_ShiKiiMaster:resDict :nitid];
//        }
//}
-(void)addDataToL_ShiKiiMaster1:(NSString*)nitid :(NSString*)userid1 :(NSString*)userid0  :(NSString*)sensorid  :(NSString*)pattern1  :(NSString*)time1  :(NSString*)value1  :(NSString*)pattern2  :(NSString*)time2  :(NSString*)value2  :(NSString*)graphtype{
    sqlite3_stmt *statement;
    char * sql = "INSERT INTO L_ShiKiiMaster(nitid, userid1, userid0, sensorid ,pattern1, time1, value1, pattern2, time2, value2, graphtype ) VALUES(?,?,?,?,?,?,?,?,?,?,?)";
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    if (sqlReturn != SQLITE_OK) {
        
    }

    sqlite3_bind_text(statement, 1, [nitid UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 2, [userid1 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 3, [userid0 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 4, [sensorid UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 5, [pattern1 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 6, [time1 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 7, [value1 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 8, [pattern2 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 9, [time2 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 10, [value2 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 11, [graphtype UTF8String], -1, SQLITE_TRANSIENT);



    
    
    int success = sqlite3_step(statement);
    
    sqlite3_finalize(statement);
    if (success == SQLITE_ERROR) {
        // }
        
    }
}
-(void)addDataToL_SensorMaster1:(NSString*)nitid :(NSString*)userid0 :(NSString*)sensorid :(NSString*)sensorname  :(NSString*)unit{
    sqlite3_stmt *statement;
    char * sql = "INSERT INTO L_SensorMaster(nitid, userid0, sensorid, sensorname,unit) VALUES(?,?,?,?,?)";
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    if (sqlReturn != SQLITE_OK) {
        
    }

    
    
    // sqlite3_bind_int(statement, 1, id);
    sqlite3_bind_text(statement, 1, [nitid UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 2, [userid0 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 3, [sensorid UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 4, [sensorname UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 5, [unit UTF8String], -1, SQLITE_TRANSIENT);
    
    
    int success = sqlite3_step(statement);
    
    sqlite3_finalize(statement);
    if (success == SQLITE_ERROR) {
        // }
        
    }
}
//添加更新異常通知先联络
-(void)addDataToL_ShiKiiContacts1:(NSMutableDictionary*)resDict :(NSString*)userid1 :(NSString*)userid0 :(NSString*)sensorid  :(NSString*)abnemail{
    
    NSMutableArray*sensorMaster1 = [[NSMutableArray alloc]initWithArray:[self getL_ShiKiiContacts:userid1 :userid0 :sensorid  :abnemail]];
    if (sensorMaster1.count <= 0 ) {
        sqlite3_stmt *statement;
        char * sql = "INSERT INTO L_ShiKiiContacts(userid1,userid0,sensorid,abnname,abnemail) VALUES(?,?,?,?,?)";
        NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
        if (sqlReturn != SQLITE_OK) {
            
        }
        //        int id = 1;
        NSString *userid1 = checkNull([resDict valueForKey:@"userid1"]);
        NSString *userid0 = checkNull([resDict valueForKey:@"userid0"]);
        NSString *sensorid = checkNull([resDict valueForKey:@"sensorid"]);
        NSString * abnname = checkNull([resDict valueForKey:@"abnname"]);
        NSString * abnemail = checkNull([resDict valueForKey:@"abnemail"]);
        
        // sqlite3_bind_int(statement, 1, id);
        sqlite3_bind_text(statement, 1, [userid1 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [userid0 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [sensorid UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 4, [abnname UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 5, [abnemail UTF8String], -1, SQLITE_TRANSIENT);
        
        
        
        int success = sqlite3_step(statement);
        
        sqlite3_finalize(statement);
        if (success == SQLITE_ERROR){
            // }
        }
    }else{
        [self updateL_ShiKiiContacts:resDict :[resDict valueForKey:@"userid1"] :[resDict valueForKey:@"userid0"] :[resDict valueForKey:@"sensorid"]  :[resDict valueForKey:@"abnemail"]];
    }
}



//删除異常通知先联络
-(BOOL)deleteL_ShiKiiContacts1:(NSString*)userid0 :(NSString*)sensorid  :(NSString*)abnemail{
    
    char *sql ="delete from L_ShiKiiContacts where userid0 = ? and sensorid = ? and abnemail = ?";
    
    sqlite3_stmt *statement;
    
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    
    if (sqlReturn != SQLITE_OK) {
        return NO;
    }else{
        sqlite3_bind_text(statement,1, [userid0 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement,2, [sensorid UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement,3, [abnemail UTF8String], -1, SQLITE_TRANSIENT);
        
    }
    
    //id, nitid, userid0, sensorid, sensorname, unit, graphtype, updatedate, id, id
    int success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (success != SQLITE_DONE) {
        return NO;
    }else{
        return YES;
    }
}

//取得異常通知先联络
-(NSMutableArray*)getL_ShiKiiContacts1:(NSString*)userid0 :(NSString*)sensorid{
    
    NSMutableArray *L_ShiKiiContactsArr = [[NSMutableArray alloc]initWithCapacity:0];
    sqlite3_stmt *statement;
    char * sql ="SELECT userid1,abnname,abnemail FROM L_ShiKiiContacts where userid0 = ? and sensorid = ? ";
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    if (sqlReturn != SQLITE_OK) {
        
    }else{
        sqlite3_bind_text(statement,1, [userid0 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement,2, [sensorid UTF8String], -1, SQLITE_TRANSIENT);
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableDictionary *L_ShiKiiContactsData = [[NSMutableDictionary alloc]init];
            char* tmpdata =(char*) sqlite3_column_text(statement, 0);
            [L_ShiKiiContactsData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"userid1"];
            tmpdata =(char*) sqlite3_column_text(statement, 1);
            [L_ShiKiiContactsData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"abnname"];
            tmpdata =(char*) sqlite3_column_text(statement, 2);
            [L_ShiKiiContactsData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"abnemail"];
            [L_ShiKiiContactsArr addObject:L_ShiKiiContactsData];
        }
    }
    sqlite3_finalize(statement);
    
    return L_ShiKiiContactsArr;
}

//取得传感器详情
-(NSMutableArray*)getL_SensorMaster1:(NSString*)userid0{
    NSMutableArray *L_SensorMasterArr1 = [[NSMutableArray alloc]initWithCapacity:0];
    
    sqlite3_stmt *statement;
    char * sql ="SELECT nitid, sensorid, sensorname, unit FROM L_SensorMaster where userid0 = ? ";
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    if (sqlReturn != SQLITE_OK) {
        
    }else{
        sqlite3_bind_text(statement,1, [userid0 UTF8String], -1, SQLITE_TRANSIENT);
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableDictionary *L_SensorMasterData = [[NSMutableDictionary alloc]init];
            
            char* tmpdata =(char*) sqlite3_column_text(statement, 0);
            [L_SensorMasterData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"nitid"];
            tmpdata =(char*) sqlite3_column_text(statement, 1);
            [L_SensorMasterData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"sensorid"];
            tmpdata =(char*) sqlite3_column_text(statement, 2);
            [L_SensorMasterData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"sensorname"];
            tmpdata =(char*) sqlite3_column_text(statement, 3);
            [L_SensorMasterData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"unit"];

            [L_SensorMasterArr1 addObject:L_SensorMasterData];
        }
        
    }
    sqlite3_finalize(statement);
    
    return L_SensorMasterArr1;
}
//更新传感器详情
//-(BOOL)updateL_SensorMaster1:(NSString*)graphtype :(NSString*)nitid{
//    
//    sqlite3_stmt *statement;
//    char * sql = "update L_SensorMaster set graphtype =? where nitid = ? ";
//    
//    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
//    if (sqlReturn != SQLITE_OK) {
//        return NO;
//    }
//
//    sqlite3_bind_text(statement, 1, [graphtype UTF8String], -1, SQLITE_TRANSIENT);
//    
//    sqlite3_bind_text(statement, 2, [[NSString stringWithFormat:@"%@",nitid] UTF8String], -1, SQLITE_TRANSIENT);
//    
//    
//    int success = sqlite3_step(statement);
//    
//    sqlite3_finalize(statement);
//    if (success != SQLITE_DONE) {
//        
//    }
//    return YES;
//}
//-(NSString*)getL_SensorMaster2:(NSString*)nitid :(NSString*)userid0{
//    NSString*graphtype8;
//    sqlite3_stmt *statement;
//    char * sql ="SELECT  graphtype FROM L_SensorMaster where nitid = ? and userid0 = ? ";
//    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
//    if (sqlReturn != SQLITE_OK) {
//        
//    }else{
//        sqlite3_bind_text(statement,1, [nitid UTF8String], -1, SQLITE_TRANSIENT);
//        sqlite3_bind_text(statement,2, [userid0 UTF8String], -1, SQLITE_TRANSIENT);
//        while (sqlite3_step(statement) == SQLITE_ROW) {
//            
//            char* tmpdata =(char*) sqlite3_column_text(statement, 0);
//            graphtype8 = [NSString stringWithUTF8String:tmpdata];
//        }
//        
//    }
//    sqlite3_finalize(statement);
//    
//    return graphtype8;
//}


//today data

-(NSMutableArray*)getTodaySensorData:(NSString*)userid0 :(NSString*)sensorid :(NSString*)date{
    
    NSMutableArray *resultArr = [[NSMutableArray alloc]initWithCapacity:0];

    sqlite3_stmt *statement;
    
    char *sql = "SELECT time,value FROM L_SensorData WHERE userid0=? AND sensorid=? AND date=? ORDER BY time";
    
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    
    if (sqlReturn != SQLITE_OK) {
        
        NSLog(@"sqlite_ok");
        
    }else{
        
        sqlite3_bind_text(statement, 1, [userid0 UTF8String], -1, SQLITE_TRANSIENT);
        
        sqlite3_bind_text(statement, 2, [sensorid UTF8String], -1, SQLITE_TRANSIENT);
        
        sqlite3_bind_text(statement, 3, [date UTF8String], -1, SQLITE_TRANSIENT);
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            NSMutableDictionary* dict = [[NSMutableDictionary alloc]initWithCapacity:0];

            char* time =(char*) sqlite3_column_text(statement, 0);
            
            char* value =(char*) sqlite3_column_text(statement, 1);
            
            [dict setValue:[NSString stringWithUTF8String:time] forKey:@"time"];
            
            [dict setValue:[NSString stringWithUTF8String:value] forKey:@"value"];

            [resultArr addObject:dict];
            
        }
 
    }
    
    sqlite3_finalize(statement);

    return resultArr;
    
}


-(NSMutableArray *)getMonthSensorData:(NSString*)userid0{
    
    NSMutableArray *resultArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    sqlite3_stmt *statement;
    
    char *sql = "SELECT time,value FROM L_SensorData WHERE date>=datetime('now','start of month','+0 month','-0 day') AND date < datetime('now','start of month','+1 month','0 day')  AND userid0=? ORDER BY time";
    
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    
    if (sqlReturn != SQLITE_OK) {
        
        NSLog(@"sqlite_ok");
        
    }else{
        
        sqlite3_bind_text(statement, 1, [userid0 UTF8String], -1, SQLITE_TRANSIENT);
        
        
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            NSMutableDictionary* dict = [[NSMutableDictionary alloc]initWithCapacity:0];
            
            
            
            char* time =(char*) sqlite3_column_text(statement, 0);
            
            char* value =(char*) sqlite3_column_text(statement, 1);
            
            [dict setValue:[NSString stringWithUTF8String:time] forKey:@"time"];
            
            [dict setValue:[NSString stringWithUTF8String:value] forKey:@"value"];
            
            
            
            [resultArr addObject:dict];
            
        }
        
        
        
    }
    
    sqlite3_finalize(statement);
    
    
    
    return resultArr;
    
}




-(NSMutableArray*)getL_SensorMaster2:(NSString*)userid0 {
    NSMutableArray *L_SensorMasterArr2 = [[NSMutableArray alloc]initWithCapacity:0];
    //SELECT u.userid1,u.userid0,u.nickname,s.sensorid,s.nitid,s.result FROM L_UserTBL u LEFT JOIN L_SensorResult s ON u.userid0=s.userid0
    sqlite3_stmt *statement;
    char * sql ="SELECT nitid, sensorid, sensorname, unit FROM L_SensorMaster  where userid0 = ? ";
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    if (sqlReturn != SQLITE_OK) {
        
    }else{
        sqlite3_bind_text(statement,1, [userid0 UTF8String], -1, SQLITE_TRANSIENT);
     
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableDictionary *L_SensorMasterData = [[NSMutableDictionary alloc]init];
            
            char* tmpdata =(char*) sqlite3_column_text(statement, 0);
            [L_SensorMasterData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"nitid"];
            tmpdata =(char*) sqlite3_column_text(statement, 1);
            [L_SensorMasterData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"sensorid"];
            tmpdata =(char*) sqlite3_column_text(statement, 2);
            [L_SensorMasterData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"sensorname"];
            tmpdata =(char*) sqlite3_column_text(statement, 3);
            [L_SensorMasterData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"unit"];

            
            [L_SensorMasterArr2 addObject:L_SensorMasterData];
        }
        
    }
    sqlite3_finalize(statement);
    
    return L_SensorMasterArr2;
}

-(NSString*)getL_SensorMaster3 :(NSString*)sensorid{
    NSString*unit;
    //SELECT u.userid1,u.userid0,u.nickname,s.sensorid,s.nitid,s.result FROM L_UserTBL u LEFT JOIN L_SensorResult s ON u.userid0=s.userid0
    sqlite3_stmt *statement;
    char * sql ="SELECT unit FROM L_SensorMaster where sensorid = ?";
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    if (sqlReturn != SQLITE_OK) {
        
    }else{

        sqlite3_bind_text(statement,1, [sensorid UTF8String], -1, SQLITE_TRANSIENT);
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            char* tmpdata =(char*) sqlite3_column_text(statement, 0);
            
            unit = [NSString stringWithUTF8String:tmpdata];

        }
        
    }
    sqlite3_finalize(statement);
    
    return unit;
}

-(NSMutableArray*)getL_ShiKiiMaster1:(NSString*)userid0  :(NSString*)sensorid{
    
    NSMutableArray *L_ShiKiiMastersArr = [[NSMutableArray alloc]initWithCapacity:0];
    sqlite3_stmt *statement;
    char * sql ="SELECT userid1, pattern1, time1, value1, pattern2, time2, value2, graphtype FROM L_ShiKiiMaster where userid0 = ? and sensorid = ?";
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    if (sqlReturn != SQLITE_OK) {
        
    }else{

        sqlite3_bind_text(statement,1, [userid0 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement,2, [sensorid UTF8String], -1, SQLITE_TRANSIENT);
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableDictionary *L_ShiKiiMasterData = [[NSMutableDictionary alloc]initWithCapacity:0];
            char* tmpdata =(char*) sqlite3_column_text(statement, 0);
            [L_ShiKiiMasterData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"userid1"];
            
            tmpdata =(char*) sqlite3_column_text(statement, 1);
            [L_ShiKiiMasterData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"pattern1"];
            
            tmpdata =(char*) sqlite3_column_text(statement, 2);
            [L_ShiKiiMasterData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"time1"];
            
            tmpdata =(char*) sqlite3_column_text(statement, 3);
            [L_ShiKiiMasterData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"value1"];
            
            tmpdata =(char*) sqlite3_column_text(statement, 4);
            [L_ShiKiiMasterData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"pattern2"];
            
            tmpdata =(char*) sqlite3_column_text(statement, 5);
            [L_ShiKiiMasterData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"time2"];
            
            tmpdata =(char*) sqlite3_column_text(statement, 6);
            [L_ShiKiiMasterData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"value2"];
            
            tmpdata =(char*) sqlite3_column_text(statement, 7);
            [L_ShiKiiMasterData setValue:[NSString stringWithUTF8String:tmpdata] forKey:@"graphtype"];
            
            [L_ShiKiiMastersArr addObject:L_ShiKiiMasterData];
            
        }
        
    }
    sqlite3_finalize(statement);
    
    return L_ShiKiiMastersArr;
}
-(NSString*)getL_ShiKiiMaster2:(NSString*)userid0  :(NSString*)sensorid{
    
    NSString*graphtype;
    sqlite3_stmt *statement;
    char * sql ="SELECT graphtype FROM L_ShiKiiMaster where userid0 = ? and sensorid = ?";
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    if (sqlReturn != SQLITE_OK) {
        
    }else{
        
        sqlite3_bind_text(statement,1, [userid0 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement,2, [sensorid UTF8String], -1, SQLITE_TRANSIENT);
        while (sqlite3_step(statement) == SQLITE_ROW) {

            char* tmpdata =(char*) sqlite3_column_text(statement, 0);
            graphtype = [NSString stringWithUTF8String:tmpdata];
            
            
        }
        
    }
    sqlite3_finalize(statement);
    
    return graphtype;
}
-(NSString*)getUserMasterData1:(NSString*)userid  :(NSString*)usertype{
    NSString*nameee;
    sqlite3_stmt *statement;
    char * sql ="SELECT  username  FROM L_UserMaster where userid = ? and usertype = ?";
    NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql , -1, &statement, nil);
    if (sqlReturn != SQLITE_OK) {
        
    }else{
        sqlite3_bind_text(statement,1, [userid UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement,2, [usertype UTF8String], -1, SQLITE_TRANSIENT);
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            char* tmpdata =(char*) sqlite3_column_text(statement, 0);

            nameee=[NSString stringWithUTF8String:tmpdata];

        }
        
    }
    sqlite3_finalize(statement);
    
    return nameee;
}



@end

