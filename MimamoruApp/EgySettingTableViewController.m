//
//  EgySettingTableViewController.m
//  MimamoruApp
//
//  Created by totyu3 on 16/1/7.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "EgySettingTableViewController.h"

@interface EgySettingTableViewController ()
{
    NSMutableArray *Arr;
}
@end

@implementation EgySettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *clear = [[UIView alloc]init];
    clear.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:clear];
    if (!Arr) {
        Arr = [[NSMutableArray alloc]init];
        NSString *t1 = @"緊急通報情報の設定";
        NSString *t2 = @"緊急通報先の設定";
        [Arr addObject:t1];
        [Arr addObject:t2];
    }

}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell1" forIndexPath:indexPath];
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width*0.1, 12.5, self.view.bounds.size.width*0.8, 55)];
    title.text = Arr[indexPath.row];
    title.backgroundColor = [UIColor colorWithRed:161/255.0 green:199/255.0 blue:166/255.0 alpha:1];
    title.textAlignment = NSTextAlignmentCenter;
    title.layer.cornerRadius = 5.0;
    [cell addSubview:title];
    //cell.textLabel.text = Arr[indexPath.row];
    //cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        [self performSegueWithIdentifier:@"gotocontent" sender:self];
        
    }
        else if (indexPath.row==1){
        [self performSegueWithIdentifier:@"gotomessage" sender:self];
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
