//
//  ContentTableViewController.m
//  MimamoruApp
//
//  Created by totyu3 on 16/1/7.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "ContentTableViewController.h"
#import "DataBaseTool.h"
#import "MBProgressHUD.h"
#import "LeafNotification.h"
enum ActionTypes{
    
    QUERY,      //查询
    MOD         //修改
};
@interface ContentTableViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    enum ActionTypes action;
    NSMutableArray *emergencyArr;
    NSString *indexRowContact;
    NSString *userid0;

    IBOutlet UITableView *myTableView;
}
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *sex;
@property (weak, nonatomic) IBOutlet UITextField *birday;
@property (weak, nonatomic) IBOutlet UITextField *adress;
@property (weak, nonatomic) IBOutlet UITextField *doctor;
@property (weak, nonatomic) IBOutlet UITextView *kusili;
@property (weak, nonatomic) IBOutlet UITextView *health;
@property (weak, nonatomic) IBOutlet UITextView *otherthing;
@property (weak, nonatomic) IBOutlet UILabel *update;
@property (weak, nonatomic) IBOutlet UILabel *updateName;

@end

@implementation ContentTableViewController

#pragma mark - userinfo信息保存的请求
-(void)startRequest:(NSString *)getid{
    
    //post 提交修改
    NSDate *  senddate=[NSDate date];
    _updateName.text = _name.text;
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _update.text=[dateformatter stringFromDate:senddate];
    
    NSURL *url = [NSURL URLWithString:@"http://mimamori.azurewebsites.net/userInfoUpdate.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //post
    [request setHTTPMethod:@"post"];
    NSString * content = [NSString stringWithFormat:@"userid=%@&username=%@&sex=%@&birthday=%@&address=%@&kakaritsuke=%@&drug=%@&health=%@&other=%@&updatename=%@&updatedate=%@",getid,_name.text,_sex.text,_birday.text,_adress.text,_doctor.text,_kusili.text,_health.text,_otherthing.text,_updateName.text,_update.text];
    [request setHTTPBody:[content dataUsingEncoding:NSUTF8StringEncoding]];
    //构建session
    NSURLSession *session = [NSURLSession sharedSession];
    //任务
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"data=%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        //异步回调方法
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        [self reloadView:dict];
    }];
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    [task resume];
    
}
#pragma mark - userinfo更新成功，向本地数据库添加更新数据
-(void)reloadView:(NSDictionary *)res
{
    NSLog(@"%@",res);
    NSString *code = [res valueForKey:@"code"];
    if ([code isEqualToString:@"updateOK"]) {
        NSMutableDictionary *updateDic = [[NSMutableDictionary alloc]init];
        [updateDic setValue:_name.text forKey:@"username"];
        [updateDic setValue:_sex.text forKey:@"sex"];
        [updateDic setValue:_birday.text forKey:@"birthday"];
        [updateDic setValue:_adress.text forKey:@"address"];
        [updateDic setValue:_doctor.text forKey:@"kakaritsuke"];
        [updateDic setValue:_kusili.text forKey:@"drug"];
        [updateDic setValue:_health.text forKey:@"health"];
        [updateDic setValue:_otherthing.text forKey:@"other"];
        [updateDic setValue:_update.text forKey:@"updatetime"];
        [updateDic setValue:_updateName.text forKey:@"updatename"];
        
        [[DataBaseTool sharedDB]updateL_UserInfoTable:updateDic userid:userid0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.tableView animated:YES];
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
    if ([code isEqualToString:@"connectNG"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [LeafNotification showInController:self withText:@"ネットワークエラー、接続失敗"];
        });

    }
    
}


#pragma mark - 从本地数据库获取数据（L_UserInfo和 L_EmergencyContacts）

-(void)viewWillAppear:(BOOL)animated
{
    //获取紧急联系人
    userid0 = [[NSUserDefaults standardUserDefaults]valueForKey:@"userid0"];
    
    emergencyArr = [[DataBaseTool sharedDB]selectL_EmergencyContactsTableuserid:userid0];
    NSLog(@"emergencycount=%lu",(unsigned long)emergencyArr.count);
    [myTableView reloadData];
    
    //获取userinfo信息
    NSMutableDictionary *userinfoDic = [[DataBaseTool sharedDB]selectL_UserInfoTableuserid:userid0];
    if (userinfoDic) {
        _name.text = [userinfoDic valueForKey:@"username"];
        _sex.text = [userinfoDic valueForKey:@"sex"];
        _birday.text = [userinfoDic valueForKey:@"birthday"];
        _adress.text = [userinfoDic valueForKey:@"address"];
        _doctor.text = [userinfoDic valueForKey:@"kakaritsuke"];
        _kusili.text = [userinfoDic valueForKey:@"drug"];
        _health.text = [userinfoDic valueForKey:@"health"];
        _otherthing.text = [userinfoDic valueForKey:@"other"];
        _update.text = [userinfoDic valueForKey:@"updatetime"];
        _updateName.text = [userinfoDic valueForKey:@"updatename"];
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}

#pragma mark - 紧急联系人mytableview datasource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    
    UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
    
    label.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
    
    [view addSubview:label];
    
    
    
    if (section ==0){
        
        [label setText:@"   氏名"];
        
    }else if(section ==1){
        
        [label setText:@"   性别"];
        
    }else if(section ==2){
        
        [label setText:@"   誕生日"];
        
    }else if(section ==3){
        
        [label setText:@"   現住所"];
        
    }else if(section ==4){
        
        [label setText:@"   かかりつけ医"];
        
    }else if(section ==5){
        
        [label setText:@"   服薬情報"];
        
    }else if(section ==6){
        
        [label setText:@"   健康診断結果"];
        
    }else if(section ==7){
        
        [label setText:@"   その他お願い事項"];
        
    }else if(section ==8){
        
        [label setText:@"   緊急通報先"];
        
        UIButton *Button =[[UIButton alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width*0.9, 0, 20, 20)];
        
        [Button setTitle: @"＋" forState: UIControlStateNormal];
        
        Button.titleLabel.font = [UIFont systemFontOfSize: 20.0];
        
        Button.titleLabel.textColor = [UIColor blackColor];
        
        Button.backgroundColor = [UIColor lightGrayColor];
        
        [Button addTarget:self action:@selector(addContacts) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:Button];
        
    }else if(section ==9){
        
        [label setText:@"   最終更新日付"];
        
    }else if(section ==10){
        
        [label setText:@"   最終更新者名"];
        
    }
    return view;
    
}



-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = [NSString new];
    if (tableView == myTableView) {
        
        title = @"";
        return title;
    }
    return [super tableView:tableView titleForHeaderInSection:section];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView == myTableView) {
        return 1;
    }
    else{
        return 12;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == myTableView) {
        return emergencyArr.count;
    }else{
        return [super tableView:tableView numberOfRowsInSection:section];
    }
    return 0;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == myTableView) {
        static NSString *cellid = @"mycell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
        }
        NSDictionary *value = emergencyArr[indexPath.row];
        cell.textLabel.text = [value valueForKey:@"nickname"];
        cell.detailTextLabel.text = [value valueForKey:@"contact"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone; //不可点击
        return cell;
    }else{
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == myTableView) {
        return YES;
    }else {
        return NO;
    }
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == myTableView) {
        NSDictionary *value = emergencyArr[indexPath.row];
        indexRowContact = [value valueForKey:@"contact"];
        [self startRequest:userid0 Contact:indexRowContact];
        [emergencyArr removeObjectAtIndex:indexPath.row];
        

    }
}
#pragma mark -  紧急联系人删除的request事件

-(void)startRequest:(NSString *)getid Contact:(NSString*)contact{
    //post 提交修改
    NSURL *url = [NSURL URLWithString:@"http://mimamori.azurewebsites.net/emergencyDelete.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //
    [request setHTTPMethod:@"post"];
    NSString * content = [NSString stringWithFormat:@"userid0=%@&contact=%@",getid,contact];
    [request setHTTPBody:[content dataUsingEncoding:NSUTF8StringEncoding]];
    //构建session
    NSURLSession *session = [NSURLSession sharedSession];
    //任务
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        //异步回调方法
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
       // NSLog(@"%@",dict);
        [self reloaddate:dict];
    }];
    [MBProgressHUD showHUDAddedTo:myTableView animated:YES];
    [task resume];
}
#pragma mark - L_EmergencyContact 本地数据更新

-(void)reloaddate:(NSDictionary*)dic
{
    NSString *code = [dic valueForKey:@"code"];
    if ([code isEqualToString:@"deleteOK"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:myTableView animated:YES];
            [myTableView reloadData];
        });
        NSMutableDictionary *deleteDic = [[NSMutableDictionary alloc]init];
        [deleteDic setValue:indexRowContact forKey:@"contact"];
        [[DataBaseTool sharedDB]deleteL_EmergencyContactsTable:deleteDic userid:userid0];
            }
}
#pragma mark - 添加紧急联系人
- (void)addContacts{
    
    [self performSegueWithIdentifier:@"addcontact" sender:self];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}
#pragma mark - 保存提交
- (IBAction)saveContent:(id)sender {
    
    [self startRequest:userid0];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return  YES;
}

@end
