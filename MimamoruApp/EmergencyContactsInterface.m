//
//  EmergencyContactsInterface.m
//  MimamoruApp
//
//  Created by totyu3 on 16/1/22.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "EmergencyContactsInterface.h"

@interface EmergencyContactsInterface()
@property (strong, nonatomic) NSMutableData *datas;
@end

@implementation EmergencyContactsInterface
#pragma mark - 从服务器获取信息

//get 异步请求
-(void)startRequest:(NSString *)getid{
    
    NSString *strUrl = [[NSString alloc]initWithFormat:@"http://mimamorihz.azurewebsites.net/emergencyContacts.php?getid=%@&type=%@&action=%@",getid,@"JSON",@"query"];
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strUrl];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if (connection) {
        
        self.datas = [NSMutableData new];
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
