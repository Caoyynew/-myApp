//
//  ViewController.m
//  MimamoruApp
//
//  Created by totyu3 on 16/1/7.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "ViewController.h"
#import "LeafNotification.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "DataBaseTool.h"

@interface ViewController ()<UITextFieldDelegate>
{
    NSString *usertype;
}
@property (weak, nonatomic) IBOutlet UITextField *userID;
@property (weak, nonatomic) IBOutlet UITextField *passWord;

@end

@implementation ViewController

#pragma mark - 验证登陆

-(void)startRequest:(NSString*)userid password:(NSString*)pwd
{
    //post 提交修改
    usertype = @"0";
    NSURL *url = [NSURL URLWithString:@"http://mimamori.azurewebsites.net/login.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //
    [request setHTTPMethod:@"post"];
    NSString * content = [NSString stringWithFormat:@"userid=%@&password=%@&usertype=%@",userid,pwd,usertype];
    [request setHTTPBody:[content dataUsingEncoding:NSUTF8StringEncoding]];
    //构建session
    NSURLSession *session = [NSURLSession sharedSession];
    //任务
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",dict);
        //异步回调方法
        [self checkdate:dict];
    }];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [task resume];
    
}
//判断是否跳转

-(void)gotoMain{
    
    NSDictionary *dict = [[DataBaseTool sharedDB]backdic];
    
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[dict valueForKey:@"code"]isEqualToString:@""]) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self performSegueWithIdentifier:@"gotomain" sender:self];
            }
        });
    
}
//判断是否成功

#pragma mark - 异步回调方法，判断是否成功
-(void)checkdate:(NSDictionary*)date{
    
    NSString *value = [date valueForKey:@"code"];
    
    if ([value isEqualToString:@""]) {
        [[NSUserDefaults standardUserDefaults]setValue:_userID.text forKey:@"userid0"];
        //打开db  创建本地表
        [[DataBaseTool sharedDB]openDB];
        //下载数据
        [[DataBaseTool sharedDB]startRequest:_userID.text];

        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self performSegueWithIdentifier:@"gotomain" sender:self];
          //  [self gotoMain];
        });
        
    }else if ([value isEqualToString:@"connectNG"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [LeafNotification showInController:self withText:@"ネットワークエラー、接続失敗"];
        });
    }else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [LeafNotification showInController:self withText:@"ユーザーID or パスワードエラー"];
            });
        }

}

-(void)viewWillAppear:(BOOL)animated
{
    NSString *type= [[NSUserDefaults standardUserDefaults]valueForKey:@"types"];
    
    if ([type isEqualToString:@"logout"]) {
        
        _passWord.text = @"";
        
    }else{
        [self performSegueWithIdentifier:@"gotomain" sender:self];
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (IBAction)loginAction:(id)sender {
    if ([_userID.text isEqual:@""]) {
        [LeafNotification showInController:self withText:@"ユーザーIDを入力してください"];
        return;
    }
    if ([_passWord.text isEqual:@""]) {
        [LeafNotification showInController:self withText:@"パスワードを入力してください"];
        return;
    }
    //进行服务器请求，判断
    [self startRequest:_userID.text password:_passWord.text];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];

}


@end
