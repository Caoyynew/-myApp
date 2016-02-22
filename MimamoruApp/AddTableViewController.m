//
//  AddTableViewController.m
//  MimamoruApp
//
//  Created by totyu3 on 16/1/18.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "AddTableViewController.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "LeafNotification.h"
#import "DataBaseTool.h"
#import "MBProgressHUD.h"
@interface AddTableViewController ()<CNContactPickerDelegate,UITextFieldDelegate>
{
    NSString *name;
    NSString *email;
    NSMutableArray *root;
    NSString * userid0;
    NSString * updatedate;
}
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *eamilText;

@end

@implementation AddTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    
    userid0 = [[NSUserDefaults standardUserDefaults]valueForKey:@"userid0"];
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    updatedate=[dateformatter stringFromDate:senddate];
}


#pragma mark - 紧急联络人的request请求

-(void)startRequest:(NSString *)getid{
    //post 提交修改
    NSURL *url = [NSURL URLWithString:@"http://mimamori.azurewebsites.net/emergencyInsert.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //
    [request setHTTPMethod:@"post"];
    NSString * content = [NSString stringWithFormat:@"userid0=%@&contact=%@&nickname=%@&updatedate=%@",getid,email,name,updatedate];
    [request setHTTPBody:[content dataUsingEncoding:NSUTF8StringEncoding]];
    //构建session
    NSURLSession *session = [NSURLSession sharedSession];
    //任务
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        //异步回调方法
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",dict);
        [self reloaddate:dict];
    }];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [task resume];
}

#pragma mark - L_EmergencyContacts 更新和新增
-(void)reloaddate:(NSDictionary*)dic
{
    NSString *OK = [dic valueForKey:@"code"];
    
    if ([OK isEqualToString:@"updateOK"]) {
        NSMutableDictionary *updateDic = [[NSMutableDictionary alloc]init];
        [updateDic setValue:name forKey:@"nickname"];
        [updateDic setValue:email forKey:@"contact"];
        [[DataBaseTool sharedDB]updateL_EmergencyContactsTable:updateDic userid:userid0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    }
    if ([OK isEqualToString:@"insertOK"]) {
        NSMutableDictionary *insertDic = [[NSMutableDictionary alloc]init];
        [insertDic setValue:name forKey:@"nickname"];
        [insertDic setValue:email forKey:@"contact"];
        [[DataBaseTool sharedDB]insertL_EmergencyContactsTable:insertDic userid:userid0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    }
}

//提交数据到服务器
- (IBAction)saveAction:(id)sender {
    
    name = self.nameText.text;
    email = self.eamilText.text;
    if (![self.nameText.text isEqualToString:@""] && ![self.eamilText.text isEqualToString:@""]) {
        //开始请求
        [self startRequest:userid0];
        
    }else{
        [LeafNotification showInController:self withText:@"add your name and email"];
        return;
    }
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addFromIphone:(id)sender {
    CNContactStore *cstore = [[CNContactStore alloc]init];
    [cstore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSLog(@"Granted Permission");
        }else{
            NSLog(@"Denied Permission");
        }
        if (error) {
            NSLog(@"Error");
        }
    }];
    
    CNContactPickerViewController *cvc = [[CNContactPickerViewController alloc]init];
    cvc.displayedPropertyKeys = @[CNContactPhoneNumbersKey,CNContactEmailAddressesKey];
    [cvc setDelegate:self];
    [self presentViewController:cvc animated:YES completion:nil];
}

#pragma mark - iphone add content
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact{
    self.nameText.text =[NSString stringWithFormat:@"%@ %@",contact.familyName,contact.givenName];
     self.eamilText.text = [NSString stringWithFormat:@"%@",[contact.emailAddresses firstObject].value];
    
}

@end
