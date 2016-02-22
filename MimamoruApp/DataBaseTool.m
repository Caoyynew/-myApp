//
//  DataBaseTool.m
//  MimamoruApp
//
//  Created by totyu3 on 16/1/29.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "DataBaseTool.h"
#include <sqlite3.h>

#define Filename @"Mydb.db" //本地db名称
@interface DataBaseTool(){
    
    sqlite3 *database;
    
//    NSString *userid0;
//    NSString *nitid;
    int usertype;
    int password;
    int type;  // 0:第一次下载数据 1:已有本地表，定时更新数据
    
}
@property(strong, nonatomic)NSMutableDictionary *userDic;
@end
@implementation DataBaseTool


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
        
        [self createL_ShiKiChiContactsTable];
        [self createL_EmergencyContactsTable];
        [self createL_SensorDataTable];
        [self createL_UserInfoTable];
        [self createL_SensorMasterTable];
        return YES;
    }
    return NO;
}


#pragma mark - 基本表（创建本地表和向服务器请求）
//L_SensorData
-(BOOL)createL_SensorDataTable{
    char *sql = "create table if not exists L_SensorData(id INTEGER PRIMARY KEY AUTOINCREMENT ,userid0 TEXT,date TEXT,time TEXT,sensorid TEXT,value TEXT)";
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
        //[self startRequest:@"shikichicontacts"];
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
        return YES;
    }
}
//L_SensorMaster
-(BOOL)createL_SensorMasterTable
{
    char *sql = "create table if not exists L_SensorMaster(id INTEGER PRIMARY KEY AUTOINCREMENT,userid0 TEXT,sensorid TEXT,sensorname TEXT)";
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
        return YES;
    }
    
}

#pragma mark - Requrest(请求服务器)
-(void)startRequest:(NSString *)userid
{
    
    NSString *updatedate = @"2000-2-1 9:30:00";
    //userid0 = [[NSUserDefaults standardUserDefaults]valueForKey:@"userid0"];
    NSURL *url = [NSURL URLWithString:@"http://mimamori.azurewebsites.net/dataupdateR.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"post"];
    NSString *content = [NSString stringWithFormat:@"userid=%@&updatedate=%@",userid,updatedate];
    [request setHTTPBody:[content dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
         NSLog(@"dict=%@",dic);
        _userDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
        [self backdic];
        [self addtoDBL_SensorData:dic];
        [self addtoDBL_ShiKiChiContacts:dic];
        [self addtoDBL_EmergencyContacts:dic];
        [self addtoDBL_UserInfo:dic];
        [self addtoDBL_SensorMaster:dic];
        
    }];
    [task resume];
    
}
#pragma mark - 检验是否取回数据
-(NSDictionary*)backdic
{
    NSDictionary *backDic = _userDic;
    return backDic;
}



#pragma mark - L_SensorData更新
-(void)addtoDBL_SensorData:(NSDictionary*)dic
{
    
    NSArray *itemArr = [dic valueForKey:@"sensordata"];
    for (int i = 0; i <itemArr.count; i++) {
        sqlite3_stmt *statement;
        char *sql = "insert into L_SensorData(userid0,date,time,sensorid,value) values(?,?,?,?,?)";
        NSInteger sqlReturn = sqlite3_prepare_v2(database, sql, -1, &statement, nil);
        if (sqlReturn !=SQLITE_OK) {
        }
        NSDictionary *itemDict = [itemArr objectAtIndex:i];
        NSString *userid = [itemDict valueForKey:@"userid0"];
        NSString *date = [itemDict valueForKey:@"date"];
        NSString *time = [itemDict valueForKey:@"time"];
        NSString *sensorid = [itemDict valueForKey:@"sensorid"];
        NSString *value = [NSString stringWithFormat:@"%@",[itemDict valueForKey:@"value"]];
        
        sqlite3_bind_text(statement, 1, [userid UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [date UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [time UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 4, [sensorid UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 5, [value UTF8String], -1, SQLITE_TRANSIENT);
        
        int success = sqlite3_step(statement);
        sqlite3_finalize(statement);
        if (success == SQLITE_ERROR) {
            
        }
    }
}
#pragma mark - L_ShiKiChiContacts更新
-(void)addtoDBL_ShiKiChiContacts:(NSDictionary*)dic
{
    NSArray *itemArr = [dic valueForKey:@"shikichicontacts"];
    for (int i = 0; i <itemArr.count; i++) {
        sqlite3_stmt *statement;
        char *sql = "insert into L_ShiKiChiContacts(userid0,sensorid,abnname,abnemail) values(?,?,?,?)";
        NSInteger sqlReturn = sqlite3_prepare_v2(database, sql, -1, &statement, nil);
        if (sqlReturn !=SQLITE_OK) {
            NSLog(@"sql error!");
        }
        NSDictionary *itemDict = [itemArr objectAtIndex:i];
        NSString *userid = [itemDict valueForKey:@"userid0"];
        NSString *sensorid = [itemDict valueForKey:@"sensorid"];
        NSString *abnname = [itemDict valueForKey:@"abnname"];
        NSString *abnemail = [itemDict valueForKey:@"abnemail"];
        sqlite3_bind_text(statement, 1, [userid UTF8String], -1, SQLITE_TRANSIENT);
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
#pragma mark - L_EmergencyContacts更新
-(void)addtoDBL_EmergencyContacts:(NSDictionary*)dic
{
    NSArray *itemArr = [dic valueForKey:@"emergencycontacts"];
    for (int i = 0; i <itemArr.count; i++) {
        sqlite3_stmt *statement;
        char *sql = "insert into L_EmergencyContacts(userid0,contact,nickname) values(?,?,?)";
        NSInteger sqlReturn = sqlite3_prepare_v2(database, sql, -1, &statement, nil);
        if (sqlReturn !=SQLITE_OK) {
            
        }
        NSDictionary *itemDict = [itemArr objectAtIndex:i];
        NSString *userid = [itemDict valueForKey:@"userid0"];
        NSString *contact = [itemDict valueForKey:@"contact"];
        NSString *nickname = [itemDict valueForKey:@"nickname"];
        sqlite3_bind_text(statement, 1, [userid UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [contact UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [nickname UTF8String], -1, SQLITE_TRANSIENT);
        
        int success = sqlite3_step(statement);
        sqlite3_finalize(statement);
        if (success == SQLITE_ERROR) {
            
        }
    }

}
#pragma mark - L_UserInfo更新
-(void)addtoDBL_UserInfo:(NSDictionary*)dic
{
    sqlite3_stmt *statement;
    char *sql = "insert into L_UserInfo(userid0,username,sex,birthday,address,kakaritsuke,drug,health,other,updatetime,updatename) values(?,?,?,?,?,?,?,?,?,?,?)";
    NSInteger sqlReturn = sqlite3_prepare_v2(database, sql, -1, &statement, nil);
    if (sqlReturn !=SQLITE_OK) {
    }
    NSArray *arr = [dic valueForKey:@"userinfo"];
    if (arr.count != 0) {
        
        NSDictionary *itemDict = [arr objectAtIndex:0];
        NSString *userid = [itemDict valueForKey:@"userid0"];
        NSString *username = [itemDict valueForKey:@"username"];
        NSString *sex = [itemDict valueForKey:@"sex"];
        NSString *birthday = [itemDict valueForKey:@"birthday"];
        NSString *address = [itemDict valueForKey:@"address"];
        NSString *kakaritsuke = [itemDict valueForKey:@"kakaritsuke"];
        NSString *drug = [itemDict valueForKey:@"drug"];
        NSString *health = [itemDict valueForKey:@"health"];
        NSString *other = [itemDict valueForKey:@"other"];
        NSString *updatetime = [itemDict valueForKey:@"updatetime"];
        NSString *updatename = [itemDict valueForKey:@"updatename"];
        
        sqlite3_bind_text(statement, 1, [userid UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [username UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [sex UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 4, [birthday UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 5, [address UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 6, [kakaritsuke UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 7, [drug UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 8, [health UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 9, [other UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 10, [[updatetime valueForKey:@"date"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 11, [updatename UTF8String], -1, SQLITE_TRANSIENT);
        
        int success = sqlite3_step(statement);
        sqlite3_finalize(statement);
        if (success == SQLITE_ERROR) {
        }
        
    }
    
    
}
#pragma mark - L_SensorMaster更新
-(void)addtoDBL_SensorMaster:(NSDictionary*)dic
{
    NSArray *itemArr = [dic valueForKey:@"sensormaster"];
    for (int i = 0; i <itemArr.count; i++) {
        sqlite3_stmt *statement;
        char *sql = "insert into L_SensorMaster(userid0,sensorid,sensorname) values(?,?,?)";
        NSInteger sqlReturn = sqlite3_prepare_v2(database, sql, -1, &statement, nil);
        if (sqlReturn !=SQLITE_OK) {
            
        }
        NSDictionary *itemDict = [itemArr objectAtIndex:i];
        NSString *userid = [itemDict valueForKey:@"userid0"];
        NSString *sensorid = [itemDict valueForKey:@"sensorid"];
        NSString *sensorname = [itemDict valueForKey:@"sensorname"];
        sqlite3_bind_text(statement, 1, [userid UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [sensorid UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [sensorname UTF8String], -1, SQLITE_TRANSIENT);
        
        int success = sqlite3_step(statement);
        sqlite3_finalize(statement);
        if (success == SQLITE_ERROR) {
            
        }
    }

}


#pragma mark - L_UserInfoTable 更新和查询
// ---------------------更新------------------
-(void)updateL_UserInfoTable:(NSDictionary*)itemDict userid:(NSString*)userid
{
    sqlite3_stmt *statement;
    char *sql = "UPDATE L_UserInfo SET username=?,sex=?,birthday=?,address=?,kakaritsuke=?,drug=?,health=?,other=?,updatetime=?,updatename=? where userid0=?";
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
        
        sqlite3_bind_text(statement, 1, [username UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [sex UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [birthday UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 4, [address UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 5, [kakaritsuke UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 6, [drug UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 7, [health UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 8, [other UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 9, [updatetime UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 10, [updatename UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 11, [userid UTF8String], -1, SQLITE_TRANSIENT);
        
        int success = sqlite3_step(statement);
        sqlite3_finalize(statement);
        if (success == SQLITE_ERROR) {
            NSLog(@"update NG");
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

#pragma mark - SensorData 图表数据查询
//72小时数据
-(NSMutableArray*)selectL_SensorDayData:(NSString *)userid Sensorid:(NSString*)sensorid
{
    NSMutableArray* rootArr= [[NSMutableArray alloc]init];
    
    NSDate * senddate=[NSDate date];
    NSMutableArray *count = [[NSMutableArray alloc]init];
    //获取3天的日期
    for (int i = 0; i<3; i++) {
        NSDate *day = [[NSDate alloc]initWithTimeIntervalSinceReferenceDate:([senddate timeIntervalSinceReferenceDate] - i*24*3600)];
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"yyyy/MM/dd"];
        NSString *dateStr = [dateformatter stringFromDate:day];
        [count addObject:dateStr];
    }
    //测试代码
   // NSArray * countTest =[[NSArray alloc]init];
    //countTest = @[@"2016-02-16",@"2016-02-15",@"2016-02-14"];
    for (int i=0; i<3; i++) {
        sqlite3_stmt *statement;
        char *sql = "select value,time from L_SensorData where userid0=? and date=? and sensorid=? order by time";
        NSInteger sqlReturn = sqlite3_prepare_v2(database, sql, -1, &statement, nil);
        if (sqlReturn !=SQLITE_OK) {
            NSLog(@"sql error!");
        }
        sqlite3_bind_text(statement, 1, [userid UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [[count objectAtIndex:i] UTF8String], -1, SQLITE_TRANSIENT);
        //sqlite3_bind_text(statement, 2, [[countTest objectAtIndex:i] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [sensorid UTF8String], -1, SQLITE_TRANSIENT);
        //保存一天的数据字典
        NSMutableDictionary *contactDic = [[NSMutableDictionary alloc]init];
        NSMutableArray *contactArr = [[NSMutableArray alloc]init];
        while (sqlite3_step(statement)==SQLITE_ROW) {
            
            
            //时间为key 数值为value 放入一个字典中
            char *value = (char*) sqlite3_column_text(statement, 0);
            char *time = (char*) sqlite3_column_text(statement, 1);
            NSString* valueStr = [NSString stringWithUTF8String:value];
            NSString* timeStr = [NSString stringWithUTF8String:time];
            [contactDic setValue:valueStr forKey:timeStr];
            
            
            [contactArr addObject:valueStr];
         //   [contactArr addObject:contactDic];
        }
        
        int success = sqlite3_step(statement);
        sqlite3_finalize(statement);
        if (success == SQLITE_ERROR) {
            NSLog(@"select NG");
        }
      //  [rootArr addObject:contactDic];
        [rootArr addObject:contactArr];
    }
    return rootArr;
    
}
//21天数据
-(NSMutableArray*)selectL_SensorWeekData:(NSString *)userid Sensorid:(NSString *)sensorid
{
    NSMutableArray* rootArr= [[NSMutableArray alloc]init];
    
    NSDate * senddate=[NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps;
    comps = [calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit) fromDate:senddate];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"EEEE"];
    NSString *yobi=[formatter stringFromDate:senddate];
    int now = 0;
    if ([yobi isEqualToString:@"Sunday"]) {
        now = 0;
    }
    if ([yobi isEqualToString:@"Saturday"]) {
        now = 1;
    }
    if ([yobi isEqualToString:@"Friday"]) {
        now = 2;
    }
    if ([yobi isEqualToString:@"Thursday"]) {
        now = 3;
    }
    if ([yobi isEqualToString:@"Wednesday"]) {
        now = 4;
    }
    if ([yobi isEqualToString:@"Tuesday"]) {
        now = 5;
    }
    if ([yobi isEqualToString:@"Monday"]) {
        now = 6;
    }
    //测试数据
    //now = 6;
    NSString *nowStr = [NSString stringWithFormat:@"%d",now];
    [rootArr addObject:nowStr];
    NSMutableArray *count = [[NSMutableArray alloc]init];
    for (int i = 0; i<(21-now); i++) {
        NSDate *day = [[NSDate alloc]initWithTimeIntervalSinceReferenceDate:([senddate timeIntervalSinceReferenceDate] - i*24*3600)];
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"yyyy/MM/dd"];
        NSString *dateStr = [dateformatter stringFromDate:day];
        [count addObject:dateStr];
    }
    for (int i=0; i<(21-now); i++) {
        sqlite3_stmt *statement;
        char *sql = "select value from L_SensorData where userid0=? and date=? and sensorid=?";
        NSInteger sqlReturn = sqlite3_prepare_v2(database, sql, -1, &statement, nil);
        if (sqlReturn !=SQLITE_OK) {
            NSLog(@"sql error!");
        }
        sqlite3_bind_text(statement, 1, [userid UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [[count objectAtIndex:i] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [sensorid UTF8String], -1, SQLITE_TRANSIENT);
        NSMutableArray *contactArr = [[NSMutableArray alloc]init];
        while (sqlite3_step(statement)==SQLITE_ROW) {
            
            char *value = (char*) sqlite3_column_text(statement, 0);
            
            NSString* valueStr = [NSString stringWithUTF8String:value];
            [contactArr addObject:valueStr];
            
        }
        NSNumber *sum = [contactArr valueForKeyPath:@"@sum.floatValue"];
        int success = sqlite3_step(statement);
        sqlite3_finalize(statement);
        if (success == SQLITE_ERROR) {
            NSLog(@"select NG");
        }
        [rootArr addObject:sum];
    }
    //NSLog(@"rootArr=%@",rootArr);
    return rootArr;
    
}
//3月数据
-(NSMutableArray*)selectL_SensorMounthData:(NSString *)userid Sensorid:(NSString *)sensorid
{
    NSMutableArray* rootArr= [[NSMutableArray alloc]init];
    
    NSDate * senddate=[NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:senddate];
    long month = [dateComponent month];
    long year = [dateComponent year];
    long day = [dateComponent day];
    NSLog(@"当月月份%ld",month);
    int monthday = 0;
    
    if (month==1) {
        monthday =31;
    }
    //只粗略判断了能被4整除的年份为闰年
    if (month==2) {
        if (year%4==0) {
            monthday = 29;
        }else{
            monthday =28;
        }
    }
    if (month==3) {
        monthday =31;
    }
    if (month==4) {
        monthday =30;
    }
    if (month==5) {
        monthday =31;
    }
    if (month==6) {
        monthday =30;
    }
    if (month==7) {
        monthday =31;
    }
    if (month==8) {
        monthday =31;
    }
    if (month==9) {
        monthday =30;
    }
    if (month==10) {
        monthday =31;
    }
    if (month==11) {
        monthday =30;
    }
    if (month==12) {
        monthday =31;
    }
    NSString *monthStr = [NSString stringWithFormat:@"%ld",month];
    NSString *todayStr = [NSString stringWithFormat:@"%ld",day];
    NSString *yearStr = [NSString stringWithFormat:@"%ld",year];
    [rootArr addObject:monthStr];
    [rootArr addObject:todayStr];
    [rootArr addObject:yearStr];
    NSMutableArray *count = [[NSMutableArray alloc]init];
    for (int i = 0; i<92; i++) {
        NSDate *day = [[NSDate alloc]initWithTimeIntervalSinceReferenceDate:([senddate timeIntervalSinceReferenceDate] - i*24*3600)];
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"yyyy/MM/dd"];
        NSString *dateStr = [dateformatter stringFromDate:day];
        [count addObject:dateStr];
    }
    for (int i=0; i<92; i++) {
        sqlite3_stmt *statement;
        char *sql = "select value from L_SensorData where userid0=? and date=? and sensorid=?";
        NSInteger sqlReturn = sqlite3_prepare_v2(database, sql, -1, &statement, nil);
        if (sqlReturn !=SQLITE_OK) {
            NSLog(@"sql error!");
        }
        sqlite3_bind_text(statement, 1, [userid UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [[count objectAtIndex:i] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [sensorid UTF8String], -1, SQLITE_TRANSIENT);
        NSMutableArray *contactArr = [[NSMutableArray alloc]init];
        while (sqlite3_step(statement)==SQLITE_ROW) {
            
            char *value = (char*) sqlite3_column_text(statement, 0);
            NSString* valueStr = [NSString stringWithUTF8String:value];
            [contactArr addObject:valueStr];
            
        }
        NSNumber *sum = [contactArr valueForKeyPath:@"@sum.floatValue"];
        int success = sqlite3_step(statement);
        sqlite3_finalize(statement);
        if (success == SQLITE_ERROR) {
            NSLog(@"select NG");
        }
        [rootArr addObject:sum];
    }
    return rootArr;
    
}

#pragma mark - 查询当天数据 显示在B-3页面

-(NSMutableArray*)selectL_SensorTodayData:(NSString *)userid Sensorid:(NSString *)sensorid
{
    NSMutableArray* rootArr= [[NSMutableArray alloc]init];
    
    NSDate * senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy/MM/dd"];
    NSString *dateStr = [dateformatter stringFromDate:senddate];
    sqlite3_stmt *statement;
    char *sql = "select value from L_SensorData where userid0=? and date=? and sensorid=? order by time";
    NSInteger sqlReturn = sqlite3_prepare_v2(database, sql, -1, &statement, nil);
    if (sqlReturn !=SQLITE_OK) {
        NSLog(@"sql error!");
    }
    sqlite3_bind_text(statement, 1, [userid UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(statement, 2, [dateStr UTF8String], -1, SQLITE_TRANSIENT);
    //测试代码
    //sqlite3_bind_text(statement, 2, [@"2016-02-16" UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 3, [sensorid UTF8String], -1, SQLITE_TRANSIENT);
    while (sqlite3_step(statement)==SQLITE_ROW) {
        
        char *value = (char*) sqlite3_column_text(statement, 0);
        NSString* valueStr = [NSString stringWithUTF8String:value];
        [rootArr addObject:valueStr];
    }
    int success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    if (success == SQLITE_ERROR) {
        NSLog(@"select NG");
    }
    return rootArr;
    
}


#pragma mark - ShiKiChiContacts 数据查询

-(NSMutableArray*)selectL_ShiKiChiContacts:(NSString *)userid
{
    sqlite3_stmt *statement;
    char *sql = "select sensorid,abnname,abnemail from L_ShiKiChiContacts where userid0=?";
    NSInteger sqlReturn = sqlite3_prepare_v2(database, sql, -1, &statement, nil);
    if (sqlReturn !=SQLITE_OK) {
        NSLog(@"sql error!");
    }
    sqlite3_bind_text(statement, 1, [userid UTF8String], -1, SQLITE_TRANSIENT);
    NSMutableArray *contactArr = [[NSMutableArray alloc]init];
    while (sqlite3_step(statement)==SQLITE_ROW) {
        char *sensorid = (char*) sqlite3_column_text(statement, 0);
        char *abnname = (char*) sqlite3_column_text(statement, 1);
        char *abnemail = (char*) sqlite3_column_text(statement, 2);
        NSMutableDictionary *value = [[NSMutableDictionary alloc]init];
        [value setValue:[NSString stringWithUTF8String:sensorid] forKey:@"sensorid"];
        [value setValue:[NSString stringWithUTF8String:abnname] forKey:@"abnname"];
        [value setValue:[NSString stringWithUTF8String:abnemail] forKey:@"abnemail"];
        [contactArr addObject:value];
    }
    int success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    if (success == SQLITE_ERROR) {
        NSLog(@"select NG");
    }
    return contactArr;
}

#pragma mark - SensorMaster 数据查询
-(NSMutableArray*)selectL_SensorMaster:(NSString *)userid
{
    sqlite3_stmt *statement;
    char *sql = "select sensorid,sensorname from L_SensorMaster where userid0=?";
    NSInteger sqlReturn = sqlite3_prepare_v2(database, sql, -1, &statement, nil);
    if (sqlReturn !=SQLITE_OK) {
        NSLog(@"sql error!");
    }
    sqlite3_bind_text(statement, 1, [userid UTF8String], -1, SQLITE_TRANSIENT);
    NSMutableArray *contactArr = [[NSMutableArray alloc]init];
    while (sqlite3_step(statement)==SQLITE_ROW) {
        char *sensorid = (char*) sqlite3_column_text(statement, 0);
        char *sensorname = (char*) sqlite3_column_text(statement, 1);
        NSMutableDictionary *value = [[NSMutableDictionary alloc]init];
        [value setValue:[NSString stringWithUTF8String:sensorid] forKey:@"sensorid"];
        [value setValue:[NSString stringWithUTF8String:sensorname] forKey:@"sensorname"];
        [contactArr addObject:value];
    }
    int success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    if (success == SQLITE_ERROR) {
        NSLog(@"select NG");
    }
    return contactArr;
}

@end
