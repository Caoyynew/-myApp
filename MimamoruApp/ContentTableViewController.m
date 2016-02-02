//
//  ContentTableViewController.m
//  MimamoruApp
//
//  Created by totyu3 on 16/1/7.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "ContentTableViewController.h"
#import "DataBaseTool.h"
enum ActionTypes{
    
    QUERY,      //查询
    MOD         //修改
};
@interface ContentTableViewController ()
{
    enum ActionTypes action;
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


@property (strong, nonatomic) NSMutableData *datas;
@end

@implementation ContentTableViewController

-(void)startRequest:(NSString *)getid{
    
    //post 提交修改
    _update.text = @"2016-1-31 10:00:00";
    NSURL *url = [NSURL URLWithString:@"http://mimamorihz.azurewebsites.net/userInfoUpdate.php"];
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
    [task resume];
    
    
}
#pragma mark - 更新成功，向本地数据库添加更新数据
-(void)reloadView:(NSDictionary *)res
{
    NSLog(@"%@",res);
    NSString *code = [res valueForKey:@"code"];
    if ([code isEqualToString:@"updateOK"]) {
        NSMutableDictionary *updateDic = [[NSMutableDictionary alloc]init];
        [updateDic setValue: _name.text forKey:@"username"];
        [updateDic setValue:_sex.text forKey:@"sex"];
        [updateDic setValue:_birday.text forKey:@"birthday"];
        [updateDic setValue:_adress.text forKey:@"address"];
        [updateDic setValue:_doctor.text forKey:@"kakaritsuke"];
        [updateDic setValue:_kusili.text forKey:@"drug"];
        [updateDic setValue:_health.text forKey:@"health"];
        [updateDic setValue:_otherthing.text forKey:@"other"];
        [updateDic setValue:_update.text forKey:@"updatetime"];
        [updateDic setValue:_updateName.text forKey:@"updatename"];
        
        [[DataBaseTool sharedDB]updateL_UserInfoTable:updateDic userid:@"00000001"];
    }
    
}


#pragma mark - 从本地数据库获取数据

-(void)viewWillAppear:(BOOL)animated
{
    NSMutableDictionary *userinfoDic = [[DataBaseTool sharedDB]selectL_UserInfoTableuserid:@"00000001"];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (IBAction)saveContent:(id)sender {
    
    [self startRequest:@"00000001"];

    [self.navigationController popViewControllerAnimated:YES];
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

/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
