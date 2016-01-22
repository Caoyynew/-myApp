//
//  DataWebService.m
//  MimamoruApp
//
//  Created by totyu3 on 16/1/21.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "DataWebService.h"

@interface DataWebService()
{
    sqlite3 *db;
}
@property (strong, nonatomic) NSMutableData *datas;
@end

@implementation DataWebService

#pragma mark - 从服务器获取数据 userinfo 表


//get 异步请求
//-(void)startRequest:(NSString *)getid{
//    
//    NSString *strUrl = [[NSString alloc]initWithFormat:@"http://mimamorihz.azurewebsites.net/cyytest.php?getid=%@&type=%@&action=%@",getid,@"JSON",@"query"];
//    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *url = [NSURL URLWithString:strUrl];
//    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
//    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
//    if (connection) {
//        
//        self.datas = [NSMutableData new];
//    }
//    
//}
//
////异步回调方法
//
////successful
//-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
//    [self.datas appendData:data];
//}
////fail
//-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
//{
//    NSLog(@"%@",[error localizedDescription]);
//}
//
//-(void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//    NSLog(@"完成请求！");
//    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:self.datas options:NSJSONReadingAllowFragments error:nil];
//    [self reloadView:dict];
//}
//
//
////从服务器获取 userinfo 数据
//-(void)reloadView:(NSDictionary *)res
//{
//    NSDictionary *m = res;
//}
//







#pragma mark - OPEN oracle

-(NSString*)getDatafilepath{
    NSString *home = NSHomeDirectory();
    NSString *documentsDirector = [home stringByAppendingPathComponent:@"Documents"];
    return [documentsDirector stringByAppendingPathComponent:kFilename];
}

-(BOOL)openDB
{
    NSString* path =[self getDatafilepath];
    NSFileManager *filemanger = [NSFileManager defaultManager];
    //判断是否存在
    BOOL find = [filemanger fileExistsAtPath:path];
    
    if (find) {
        NSLog(@"数据库存在");
        if (sqlite3_open([path UTF8String], &db) !=  SQLITE_OK) {
            NSLog(@"数据库打开失败");
            return NO;
        }else{
            NSLog(@"数据打开成功");
            return YES;
        }
    }
    int result = sqlite3_open([path UTF8String], &db);
    if (result == SQLITE_OK) {
        
        //创建表1，2，3，。。。
        
        
        
        
        return YES;
    }else{
        NSLog(@"数据库创建失败");
        return NO;
    }
    return NO;
}
#pragma mark - 基本表（从服务器获取数据）

-(BOOL)createUserTable
{
    return NO;
}


-(void)createEditableCopyOfDatabaseIfNeeded
{
    NSString* DBpath = [self getDatafilepath];
    const char* cpath = [DBpath UTF8String];
    
    if (sqlite3_open(cpath, &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"数据库打开失败！");
        
    }else{
        char *err;
        NSString *sql = [NSString stringWithFormat:@"create table if not exits Note(cdate TEXT PRIMARY KEY,content TEXT);"];
        const char *csql = [sql UTF8String];
        
        if (sqlite3_exec(db, csql, NULL, NULL, &err) != SQLITE_OK ) {
            sqlite3_close(db);
            NSAssert(NO, @"建表失败");
        }
        sqlite3_close(db);
    }
    
}



@end
