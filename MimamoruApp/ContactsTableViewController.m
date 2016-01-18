//
//  ContactsTableViewController.m
//  MimamoruApp
//
//  Created by totyu3 on 16/1/18.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "ContactsTableViewController.h"

@interface ContactsTableViewController ()
{
    NSMutableArray *root2;
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
-(void)viewWillAppear:(BOOL)animated
{
    NSArray *user = [[NSUserDefaults standardUserDefaults]valueForKey:@"content"];
    if (!user) {
        root2 = [[NSMutableArray alloc]init];
    }else{
        root2 = [[NSMutableArray alloc]initWithArray:user];
    }
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

    return root2.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycelladd" forIndexPath:indexPath];
    
    NSDictionary *value = root2[indexPath.row];
    cell.textLabel.text = [value valueForKey:@"name"];
    cell.detailTextLabel.text = [value valueForKey:@"email"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone; //不可点击
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [root2 removeObjectAtIndex:indexPath.row];
    [[NSUserDefaults standardUserDefaults]setObject:root2 forKey:@"content"];
    [self.tableView reloadData];
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
