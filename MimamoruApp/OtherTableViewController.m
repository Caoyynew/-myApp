//
//  OtherTableViewController.m
//  MimamoruApp
//
//  Created by totyu3 on 16/1/7.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "OtherTableViewController.h"
#import "EgySettingTableViewController.h"
#import "AppDelegate.h"
#import "ViewController.h"
@interface OtherTableViewController ()
{
    NSMutableArray *Arr;
}
@end

@implementation OtherTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * login = @"login";
    [[NSUserDefaults standardUserDefaults]setObject:login forKey:@"types"];

    if (!Arr) {
        Arr = [[NSMutableArray alloc]init];
    }
    UIView *clear = [[UIView alloc]init];
    clear.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:clear];
    NSString *title1 = @"◆緊急通報の設定";
    NSString *title2 = @"◇ログアウト";
    [Arr addObject:title1];
    [Arr addObject:title2];
    
    
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

    return Arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellid = @"mycell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    cell.textLabel.text = Arr[indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        //[self performSegueWithIdentifier:@"gotoemergencysetting" sender:self];
        [self performSegueWithIdentifier:@"gotocontent" sender:self];
    }else if (indexPath.row ==1){
        [self cancellation];
    }
}

-(void)cancellation
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"ログアウトします。よろしいですか。" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *type = @"logout";
        [[NSUserDefaults standardUserDefaults]setObject:type forKey:@"types"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userid0"];
//        AppDelegate *app = [[AppDelegate alloc]init];
//        if (app.window.rootViewController ==[app.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"tablebar"]) {
//           // [self.navigationController popToViewController:[[UIViewController alloc]init] animated:YES];
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }
        //删除本地sqlite
        [self deleteMydb];
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:true completion:nil];
}

#pragma mark - 删除本地db
-(void)deleteMydb{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *MapLayerDataPath = [documentsDirectory stringByAppendingPathComponent:@"Mydb.db"];
    BOOL bRet = [fileMgr fileExistsAtPath:MapLayerDataPath];
    if (bRet) {
        //
        NSError *err;
        [fileMgr removeItemAtPath:MapLayerDataPath error:&err];
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
