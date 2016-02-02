//
//  DataBaseTool.m
//  MimamoruApp
//
//  Created by totyu3 on 16/1/29.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "DataBaseTool.h"
#include <sqlite3.h>

#define Filename @"mydb.db" //本地db名称
@interface DataBaseTool(){
    
    sqlite3 *database;
    
    NSString *userid0;
    NSString *nitid;
    int usertype;
    int password;
    int type;  // 0:第一次下载数据 1:已有本地表，定时更新数据
}
@property(strong, nonatomic)NSMutableDictionary *userDic;
@end
@implementation DataBaseTool

//
//-(NSMutableDictionary*)userDic{
//
//    _userDic = [[NSMutableDictionary alloc]init];
//    [_userDic setValue:@"00000001" forKey:@"userid0"];
//    [_userDic setValue:@"12345678900100000001" forKey:@"nitid"];
//    [_userDic setValue:@"0" forKey:@"usertype"];
//    [_userDic setValue:@"nit0" forKey:@"password"];
//    userid0 = [_userDic valueForKey:@"userid0"];
//    nitid = [_userDic valueForKey:@"nitid"];
//    usertype = [[_userDic valueForKey:@"usertype"]intValue];
//    password = [[_userDic valueForKey:@"password"]intValue];
//    return _userDic;
//}


+(DataBaseTool*)sharedDB{
    
    static DataBaseTool *sharedDB = nil;
    if (sharedDB == nil) {
        sharedDB = [[DataBaseTool alloc]init];
    }
    return sharedDB;
}

#pragma mark - OPEN数据库

-(NSString*)getDataFilepath{
    
    NSString *home = NSHomeDirectory();
    NSString *documentsDirector = [home stringByAppendingPathComponent:@"Documents"];
    return [documentsDirector stringByAppendingPathComponent:Filename];
    
}
-(BOOL)openDB{
    NSString *path = [self getDataFilepath];
    NSLog(@"DBPath=%@",path);
    NSFileManager *filemanger =[NSFileManager defaultManager];
    BOOL find =[filemanger fileExistsAtPath:path];
    if (find) {
        NSLog(@"DB EXIST");
        if (sqlite3_open([path UTF8String], &database) != SQLITE_OK) {
            NSLog(@"DB OPEN NG!");
            return NO;
        }else{
            NSLog(@"DB OPEN!");
            return YES;
        }
    }
    int result = sqlite3_open([path UTF8String], &database);
    if (result ==SQLITE_OK) {
        //code
        type = 0;
        [self createL_ShiKiChiContactsTable];
        [self createL_EmergencyContactsTable];
        [self createL_SensorDataTable];
        [self createL_UserInfoTable];
        
        return YES;
    }
    return NO;
}


#pragma mark - 基本表（创建本地表和向服务器请求）

//L_SensorData
-(BOOL)createL_SensorDataTable{
    char *sql = "create table if not exists L_SensorData(id INTEGER PRIMARY KEY AUTOINCREMENT,nitid TEXT,userid0 TEXT,date TEXT,time TEXT,sensorid TEXT,value TEXT)";
    sqlite3_stmt *statement;
    NSInteger sqlReturn = sqlite3_prepare_v2(database, sql, -1, &statement, nil);
    if (sqlReturn != SQLITE_OK) {
        return NO;
    }
    int success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    if (success != SQLITE_DONE) {
        return NO;
    }else{
        //code
        [self startRequest:@"sensordata"];
        return YES;
    }
}
//L_ShiKiChiContacts
-(BOOL)createL_ShiKiChiContactsTable{
    char *sql = "create table if not exists L_ShiKiChiContacts(id INTEGER PRIMARY KEY AUTOINCREMENT,userid0 TEXT,sensorid TEXT,abnname TEXT,abnemail TEXT)";
    sqlite3_stmt *statement;
    NSInteger sqlReturn = sqlite3_prepare_v2(database, sql, -1, &statement, nil);
    if (sqlReturn != SQLITE_OK) {
        return NO;
    }
    int success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    if (success != SQLITE_DONE) {
        return NO;
    }else{
        //code
        [self startRequest:@"shikichicontacts"];
        return YES;
    }
}
//L_EmergencyContacts
-(BOOL)createL_EmergencyContactsTable{
    char *sql = "create table if not exists L_EmergencyContacts(id INTEGER PRIMARY KEY AUTOINCREMENT,userid0 TEXT,contact TEXT,nickname TEXT)";
    sqlite3_stmt *statement;
    NSInteger sqlReturn = sqlite3_prepare_v2(database, sql, -1, &statement, nil);
    if (sqlReturn != SQLITE_OK) {
        return NO;
    }
    int success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    if (success != SQLITE_DONE) {
        return NO;
    }else{
        //code
        [self startRequest:@"emergencycontacts"];
        return YES;
    }
}
//L_UserInfo
-(BOOL)createL_UserInfoTable{
    char *sql = "create table if not exists L_UserInfo(id INTEGER PRIMARY KEY AUTOINCREMENT,userid0 TEXT,username TEXT,sex TEXT,birthday TEXT,address TEXT,kakaritsuke TEXT,drug TEXT,health TEXT,other TEXT,updatetime TEXT,updatename TEXT)";
    sqlite3_stmt *statement;
    NSInteger sqlReturn = sqlite3_prepare_v2(database, sql, -1, &statement, nil);
    if (sqlReturn != SQLITE_OK) {
        return NO;
    }
    int success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    if (success != SQLITE_DONE) {
        return NO;
    }else{
        //code
        
        return YES;
    }
}

#pragma mark - Requrest(请求服务器)
-(void)startRequest:(NSString *)table
{
    
    NSString *updatedate = @"2000-2-1 9:30:00";
    userid0 = @"00000001";
    nitid = @"12345678900100000001";
    NSURL *url = [NSURL URLWithString:@"http://mimamorihz.azurewebsites.net/mimamonanenuUpdate.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"post"];
    NSString *content = [NSString stringWithFormat:@"userid0=%@&nitid=%@&updatedate=%@&table=%@",userid0,nitid,updatedate,table];
    [request setHTTPBody:[content dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"dict=%@",dic);
        [self addtoDBname:table backData:dic];
    }];
    [task resume];
    
}
#pragma mark - 返回数据添加到本地表
-(void)addtoDBname:(NSString*)table backData:(NSDictionary*)dic{
    
    
    if ([table isEqualToString:@"sensordata"]) {
        NSArray *itemArr = [dic valueForKey:@"sensordata"];
        for (int i = 0; i <itemArr.count; i++) {
            sqlite3_stmt *statement;
            char *sql = "insert into L_SensorData(nitid,userid0,date,time,sensorid,value) values(?,?,?,?,?,?)";
            NSInteger sqlReturn = sqlite3_prepare_v2(database, sql, -1, &statement, nil);
            if (sqlReturn !=SQLITE_OK) {
            }
            NSDictionary *itemDict = [itemArr objectAtIndex:i];
            NSString *date = [itemDict valueForKey:@"date"];
            NSString *time = [itemDict valueForKey:@"time"];
            NSString *sensorid = [itemDict valueForKey:@"sensorid"];
            NSString *value = [itemDict valueForKey:@"value"];
            
            sqlite3_bind_text(statement, 1, [nitid UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [userid0 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [date UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 4, [time UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 5, [sensorid UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 6, [value UTF8String], -1, SQLITE_TRANSIENT);
            
            int success = sqlite3_step(statement);
            sqlite3_finalize(statement);
            if (success == SQLITE_ERROR) {
                
            }
        }
    }
    if ([table isEqualToString:@"shikichicontacts"]) {
        NSArray *itemArr = [dic valueForKey:@"shikichicontacts"];
        for (int i = 0; i <itemArr.count; i++) {
            sqlite3_stmt *statement;
            char *sql = "insert into L_ShiKiChiContacts(userid0,sensorid,abnname,abnemail) values(?,?,?,?)";
            NSInteger sqlReturn = sqlite3_prepare_v2(database, sql, -1, &statement, nil);
            if (sqlReturn !=SQLITE_OK) {
                NSLog(@"sql error!");
            }
            NSDictionary *itemDict = [itemArr objectAtIndex:i];
            NSString *sensorid = [itemDict valueForKey:@"sensorid"];
            NSString *abnname = [itemDict valueForKey:@"abnname"];
            NSString *abnemail = [itemDict valueForKey:@"abnemail"];
            sqlite3_bind_text(statement, 1, [userid0 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [sensorid UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [abnname UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 4, [abnemail UTF8String], -1, SQLITE_TRANSIENT);
            
            int success = sqlite3_step(statement);
            sqlite3_finalize(statement);
            if (success == SQLITE_ERROR) {
                NSLog(@"insert NG!");
            }
        }
    }
    if ([table isEqualToString:@"emergencycontacts"]) {
        NSArray *itemArr = [dic valueForKey:@"emergencycontacts"];
        for (int i = 0; i <itemArr.count; i++) {
            sqlite3_stmt *statement;
            char *sql = "insert into L_EmergencyContacts(userid0,contact,nickname) values(?,?,?)";
            NSInteger sqlReturn = sqlite3_prepare_v2(database, sql, -1, &statement, nil);
            if (sqlReturn !=SQLITE_OK) {
                
            }
            NSDictionary *itemDict = [itemArr objectAtIndex:i];
            NSString *contact = [itemDict valueForKey:@"contact"];
            NSString *nickname = [itemDict valueForKey:@"nickname"];
            sqlite3_bind_text(statement, 1, [userid0 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [contact UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [nickname UTF8String], -1, SQLITE_TRANSIENT);
            
            int success = sqlite3_step(statement);
            sqlite3_finalize(statement);
            if (success == SQLITE_ERROR) {
                
            }
        }
        
    }
    
}

#pragma mark - L_UserInfoTable 更新和查询
// ---------------------更新------------------
-(void)updateL_UserInfoTable:(NSDictionary*)itemDict userid:(NSString*)userid
{
    sqlite3_stmt *statement;
    char *sql = "insert into L_UserInfo(userid0,username,sex,birthday,address,kakaritsuke,drug,health,other,updatetime,updatename) values(?,?,?,?,?,?,?,?,?,?,?)";
    NSInteger sqlReturn = sqlite3_prepare_v2(database, sql, -1, &statement, nil);
    if (sqlReturn !=SQLITE_OK) {
        NSLog(@"sql error!");
    }else{
    NSString *username = [itemDict valueForKey:@"username"];
    NSString *sex = [itemDict valueForKey:@"sex"];
    NSString *birthday = [itemDict valueForKey:@"birthday"];
    NSString *address = [itemDict valueForKey:@"address"];
    NSString *kakaritsuke = [itemDict valueForKey:@"kakaritsuke"];
    NSString *drug = [itemDict valueForKey:@"drug"];
    NSString *health = [itemDict valueForKey:@"health"];
    NSString *other = [itemDict valueForKey:@"other"];
    NSString *updatetime = [itemDict valueForKey:@"updatetime"];
    //更新者为用户自己存入数据库
    NSString *updatename = [itemDict valueForKey:@"username"];
    sqlite3_bind_text(statement, 1, [userid UTF8String], -1, SQLITE_TRANSIENT);
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
        NSLog(@"insert NG");
    }
    }
    
}
//------------------------查询---------------------------
-(NSMutableDictionary*)selectL_UserInfoTableuserid:(NSString*)userid
{
    sqlite3_stmt *statement;
    char *sql = "select username,sex,birthday,address,kakaritsuke,drug,health,other,updatetime,updatename from L_UserInfo where userid0 =?";
    NSInteger sqlReturn = sqlite3_prepare_v2(database, sql, -1, &statement, nil);
    if (sqlReturn !=SQLITE_OK) {
        NSLog(@"sql error!");
    }
    sqlite3_bind_text(statement, 1, [userid UTF8String], -1, SQLITE_TRANSIENT);
    NSMutableDictionary *selectDic = [[NSMutableDictionary alloc]init];
    while (sqlite3_step(statement) == SQLITE_ROW) {
        char *username = (char*) sqlite3_column_text(statement, 0);
        char *sex = (char*) sqlite3_column_text(statement, 1);
        char *birthday = (char*) sqlite3_column_text(statement, 2);
        char *address = (char*) sqlite3_column_text(statement, 3);
        char *kakaritsuke = (char*) sqlite3_column_text(statement, 4);
        char *drug = (char*) sqlite3_column_text(statement, 5);
        char *health = (char*) sqlite3_column_text(statement, 6);
        char *other = (char*) sqlite3_column_text(statement, 7);
        char *updatetime = (char*) sqlite3_column_text(statement, 8);
        char *updatename = (char*) sqlite3_column_text(statement, 9);

        [selectDic setValue:[NSString stringWithUTF8String:username] forKey:@"username"];
        [selectDic setValue:[NSString stringWithUTF8String:sex] forKey:@"sex"];
        [selectDic setValue:[NSString stringWithUTF8String:birthday] forKey:@"birthday"];
        [selectDic setValue:[NSString stringWithUTF8String:address] forKey:@"address"];
        [selectDic setValue:[NSString stringWithUTF8String:kakaritsuke] forKey:@"kakaritsuke"];
        [selectDic setValue:[NSString stringWithUTF8String:drug] forKey:@"drug"];
        [selectDic setValue:[NSString stringWithUTF8String:health] forKey:@"health"];
        [selectDic setValue:[NSString stringWithUTF8String:other] forKey:@"other"];
        [selectDic setValue:[NSString stringWithUTF8String:updatetime] forKey:@"updatetime"];
        [selectDic setValue:[NSString stringWithUTF8String:updatename] forKey:@"updatename"];
        
    }
    sqlite3_finalize(statement);
    return selectDic;
}

#pragma mark - L_EmergencyContacts 新增，更新，查询，删除
//----------------------------新增-------------------------
-(void)insertL_EmergencyContactsTable:(NSDictionary *)itemDict userid:(NSString *)userid
{
    sqlite3_stmt *statement;
    char *sql = "insert into L_EmergencyContacts(userid0,contact,nickname)values(?,?,?)";
    NSInteger sqlReturn = sqlite3_prepare_v2(database, sql, -1, &statement, nil);
    if (sqlReturn !=SQLITE_OK) {
        NSLog(@"sql error!");
    }else{
        NSString *contact = [itemDict valueForKey:@"contact"];
        NSString *nickname = [itemDict valueForKey:@"nickname"];
        sqlite3_bind_text(statement, 1, [userid UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [contact UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [nickname UTF8String], -1, SQLITE_TRANSIENT);
        int success = sqlite3_step(statement);
        sqlite3_finalize(statement);
        if (success == SQLITE_ERROR) {
            NSLog(@"insert NG");
        }
    }
}
//----------------------------更新--------------------------
-(void)updateL_EmergencyContactsTable:(NSDictionary *)itemDict userid:(NSString *)userid
{
    sqlite3_stmt *statement;
    char *sql="update L_EmergencyContacts set nickname=? where contact = ?";
    NSInteger sqlReturn = sqlite3_prepare_v2(database, sql, -1, &statement, nil);
    if (sqlReturn !=SQLITE_OK) {
        NSLog(@"sql error!");
    }else{
        NSString *contact = [itemDict valueForKey:@"contact"];
        NSString *nickname = [itemDict valueForKey:@"nickname"];
        sqlite3_bind_text(statement, 1, [nickname UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [contact UTF8String], -1, SQLITE_TRANSIENT);
        int success = sqlite3_step(statement);
        sqlite3_finalize(statement);
        if (success == SQLITE_ERROR) {
            NSLog(@"insert NG");
        }

    }
}
//----------------------------查询--------------------------
-(NSMutableArray*)selectL_EmergencyContactsTableuserid:(NSString *)userid
{
    sqlite3_stmt *statement;
    char *sql = "select contact,nickname from L_EmergencyContacts where userid0=?";
    NSInteger sqlReturn = sqlite3_prepare_v2(database, sql, -1, &statement, nil);
    if (sqlReturn !=SQLITE_OK) {
        NSLog(@"sql error!");
    }
    sqlite3_bind_text(statement, 1, [userid UTF8String], -1, SQLITE_TRANSIENT);
    NSMutableArray *contactArr = [[NSMutableArray alloc]init];
    while (sqlite3_step(statement)==SQLITE_ROW) {
        char *contact = (char*) sqlite3_column_text(statement, 0);
        char *nickname = (char*) sqlite3_column_text(statement, 1);
        NSMutableDictionary *value = [[NSMutableDictionary alloc]init];
        [value setValue:[NSString stringWithUTF8String:contact] forKey:@"contact"];
        [value setValue:[NSString stringWithUTF8String:nickname] forKey:@"nickname"];
        [contactArr addObject:value];
    }
    int success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    if (success == SQLITE_ERROR) {
        NSLog(@"insert NG");
    }
    return contactArr;
}
//----------------------------删除--------------------------
-(void)deleteL_EmergencyContactsTable:(NSDictionary *)itemDict userid:(NSString *)userid
{
    sqlite3_stmt *statement;
    char *sql = "delete from L_EmergencyContacts where contact=?";
    NSInteger sqlReturn = sqlite3_prepare_v2(database, sql, -1, &statement, nil);
    if (sqlReturn !=SQLITE_OK) {
        NSLog(@"sql error!");
    }
    NSString *contact = [itemDict valueForKey:@"contact"];
    sqlite3_bind_text(statement, 1,[contact UTF8String] , -1, SQLITE_TRANSIENT);
    int success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    if (success == SQLITE_ERROR) {
        NSLog(@"delete NG");
    }
}

@end
