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

}
@end

@implementation OtherTableViewController


-(void)viewWillAppear:(BOOL)animated
{
   // [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * login = @"login";
    [[NSUserDefaults standardUserDefaults]setObject:login forKey:@"types"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        [self performSegueWithIdentifier:@"gotocontent" sender:self];
    }else if (indexPath.row ==1){
        [self cancellation];
     //   [self.tableView reloadData];
    }
}

-(void)cancellation
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"ログアウトします。よろしいですか。" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *type = @"logout";
        [[NSUserDefaults standardUserDefaults]setObject:type forKey:@"types"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userid0"];
        //删除本地sqlite
        [self deleteMydb];
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tableView reloadData];
//        });
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

@end
