//
//  ContactsTableViewController.m
//  MimamoruApp
//
//  Created by totyu3 on 16/1/18.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "ContactsTableViewController.h"
#include "DataBaseTool.h"
@interface ContactsTableViewController ()
{
    NSMutableArray *emergencyContacts;
    NSString *indexRowContact;
    NSString *userid0;
}


@end

@implementation ContactsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}
- (IBAction)addContact:(id)sender {
    
    [self performSegueWithIdentifier:@"addcontacts" sender:self];
}
#pragma mark - 从本地数据库获取数据
-(void)viewWillAppear:(BOOL)animated
{
    userid0 = [[NSUserDefaults standardUserDefaults]valueForKey:@"userid0"];
    emergencyContacts = [[DataBaseTool sharedDB]selectL_EmergencyContactsTableuserid:userid0];
    NSLog(@"emergencycount=%lu",(unsigned long)emergencyContacts.count);
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return emergencyContacts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycelladd" forIndexPath:indexPath];
    
    NSDictionary *value = emergencyContacts[indexPath.row];
    cell.textLabel.text = [value valueForKey:@"nickname"];
    cell.detailTextLabel.text = [value valueForKey:@"contact"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone; //不可点击
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *value = emergencyContacts[indexPath.row];
    indexRowContact = [value valueForKey:@"contact"];
    [self startRequest:userid0 Contact:indexRowContact];
    [emergencyContacts removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
}


#pragma mark -  删除的request事件

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
        NSLog(@"%@",dict);
        [self reloaddate:dict];
    }];
    [task resume];
}

#pragma mark - L_EmergencyContact 本地数据更新

-(void)reloaddate:(NSDictionary*)dic
{
    NSString *code = [dic valueForKey:@"code"];
    if ([code isEqualToString:@"deleteOK"]) {
        NSMutableDictionary *deleteDic = [[NSMutableDictionary alloc]init];
        [deleteDic setValue:indexRowContact forKey:@"contact"];
        [[DataBaseTool sharedDB]deleteL_EmergencyContactsTable:deleteDic userid:userid0];
    }
}


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
