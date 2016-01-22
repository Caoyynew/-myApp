//
//  UserInfoInterface.m
//  MimamoruApp
//
//  Created by totyu3 on 16/1/22.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "UserInfoInterface.h"

enum ActionTypes{
    
    QUERY,      //查询
    ADD,        //
    MOD         //修改
};
@interface UserInfoInterface(){
    enum ActionTypes action;
    
}
@property (strong, nonatomic)NSMutableData *datas;

@end
@implementation UserInfoInterface


-(void)viewillappear{
    
    action = QUERY;
}

-(void)button{
    
    action = MOD;
}


#pragma mark - 从服务器获取信息

// 异步请求
-(void)startRequest:(NSString *)getid{
    //get 获取数据
    if (action == QUERY) {
        NSString *strUrl = [[NSString alloc]initWithFormat:@"http://mimamorihz.azurewebsites.net/userInfo.php?getid=%@&type=%@&action=%@",getid,@"JSON",@"query"];
        strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:strUrl];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
        NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        if (connection) {
            self.datas = [NSMutableData new];
        }
    //post 提交修改
    }else if (action == MOD){
        NSString *strUrl = [[NSString alloc]initWithFormat:@"http://mimamorihz.azurewebsites.net/userInfoEdit.php"];
        strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:strUrl];
        NSString *post = [NSString stringWithFormat:@"getid=%@&type=%@&action=%@",getid,@"JSON",@"modify"];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:postData];
        NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        if (connection) {
            self.datas = [NSMutableData new];
        }
    }
    
}

//异步回调方法

//successful
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.datas appendData:data];
}
//fail
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@",[error localizedDescription]);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"完成请求！");
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:self.datas options:NSJSONReadingAllowFragments error:nil];
    [self reloadView:dict];
}
-(void)reloadView:(NSDictionary*)dict
{
    
}
@end
