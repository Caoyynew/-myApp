//
//  ContentTableViewController.m
//  MimamoruApp
//
//  Created by totyu3 on 16/1/7.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "ContentTableViewController.h"

@interface ContentTableViewController ()
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



@property (strong, nonatomic) NSMutableDictionary *myInfo;
@end

@implementation ContentTableViewController
@synthesize myInfo;

-(void)viewWillAppear:(BOOL)animated
{
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.kusili.layer.borderColor = [UIColor grayColor].CGColor;
//    
//    self.health.layer.borderColor = [UIColor grayColor].CGColor;
//    
//    self.otherthing.layer.borderColor = [UIColor grayColor].CGColor;
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    NSDictionary *myDict = [[NSUserDefaults standardUserDefaults]valueForKey:@"personal"];
    if (myDict==nil) {
        myInfo = [[NSMutableDictionary alloc]init];
    }else{
        myInfo = [[NSMutableDictionary alloc]initWithDictionary:myDict];
        _name.text = [myInfo valueForKey:@"name"];
        _sex.text = [myInfo valueForKey:@"sex"];
        _birday.text = [myInfo valueForKey:@"birthday"];
        _adress.text = [myInfo valueForKey:@"adress"];
        _doctor.text = [myInfo valueForKey:@"doctor"];
        _kusili.text = [myInfo valueForKey:@"kusili"];
        _health.text = [myInfo valueForKey:@"health"];
        _otherthing.text = [myInfo valueForKey:@"other"];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (IBAction)saveContent:(id)sender {
    [myInfo setValue:_name.text forKey:@"name"];
    [myInfo setValue:_sex.text forKey:@"sex"];
    [myInfo setValue:_birday.text forKey:@"birthday"];
    [myInfo setValue:_adress.text forKey:@"adress"];
    [myInfo setValue:_doctor.text forKey:@"doctor"];
    [myInfo setValue:_kusili.text forKey:@"kusili"];
    [myInfo setValue:_health.text forKey:@"health"];
    [myInfo setValue:_otherthing.text forKey:@"other"];
    
    NSLog(@"%@",myInfo);
    [[NSUserDefaults standardUserDefaults]setValue:myInfo forKey:@"personal"];
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
